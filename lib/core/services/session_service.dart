import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SessionService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Kullanıcı oturumunu kontrol et
  Future<bool> checkSession() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        print('Aktif kullanıcı bulunamadı');
        return false;
      }

      try {
        // Token'ı yenile
        await currentUser.getIdToken(true);
      } catch (e) {
        print('Token yenileme hatası: $e');
        return false;
      }

      try {
        // Firestore'da kullanıcı kontrolü
        final userDoc =
            await _firestore.collection('users').doc(currentUser.uid).get();

        if (!userDoc.exists) {
          print('Kullanıcı Firestore\'da bulunamadı');
          return false;
        }

        return true;
      } catch (e) {
        print('Firestore kontrolü hatası: $e');
        return false;
      }
    } catch (e) {
      print('Genel oturum kontrolü hatası: $e');
      return false;
    }
  }

  // Kullanıcı oturumunu yenile
  Future<bool> refreshSession() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      // Önce token'ı yenile
      await currentUser.getIdToken(true);

      // Sonra kullanıcı bilgilerini yenile
      await currentUser.reload();

      return true;
    } catch (e) {
      print('Oturum yenileme hatası: $e');
      return false;
    }
  }

  // Oturum süresini kontrol et
  Future<bool> isSessionValid() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      // Token'ı zorla yenile
      final idTokenResult = await currentUser.getIdTokenResult(true);
      final expirationTime = idTokenResult.expirationTime;

      if (expirationTime == null) return false;

      return expirationTime.isAfter(DateTime.now());
    } catch (e) {
      print('Token kontrolü hatası: $e');
      return false;
    }
  }

  // Oturumu sonlandır
  Future<void> signOut() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        // Önce Firestore'daki aktif oturumları kapat
        try {
          await _firestore
              .collection('sessions')
              .where('userId', isEqualTo: currentUser.uid)
              .where('isActive', isEqualTo: true)
              .get()
              .then((snapshot) {
            for (var doc in snapshot.docs) {
              doc.reference.update({
                'isActive': false,
                'logoutTime': FieldValue.serverTimestamp(),
              });
            }
          });
        } catch (e) {
          print('Oturum kayıtları güncellenirken hata: $e');
        }
      }

      await _auth.signOut();
    } catch (e) {
      print('Oturum kapatma hatası: $e');
      rethrow;
    }
  }
}
