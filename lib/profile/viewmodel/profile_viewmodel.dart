import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/models/user_model.dart';
import '../../core/models/session_model.dart';
import '../../core/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../../core/services/session_service.dart';

class ProfileViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  final SessionService _sessionService = SessionService();
  bool _isLoading = false;
  UserModel? _userModel;
  List<SessionModel> _activeSessions = [];
  List<SessionModel> _sessionHistory = [];

  bool get isLoading => _isLoading;
  UserModel? get userModel => _userModel;
  List<SessionModel> get activeSessions => _activeSessions;
  List<SessionModel> get sessionHistory => _sessionHistory;

  Future<void> loadUserData() async {
    setLoading(true);

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // Önce Firestore'dan kullanıcı verilerini al
        final docSnapshot =
            await _firestore.collection('users').doc(currentUser.uid).get();

        if (docSnapshot.exists) {
          final data = docSnapshot.data() as Map<String, dynamic>;
          _userModel = UserModel(
            uid: currentUser.uid,
            name: data['name'] ?? '',
            surname: data['surname'] ?? '',
            email: data['email'] ?? currentUser.email ?? '',
            profileImage: data['profileImage'],
            phone: data['phone'],
          );
        } else {
          // Firestore'da veri yoksa, yeni kullanıcı oluştur
          _userModel = UserModel(
            uid: currentUser.uid,
            name: currentUser.displayName?.split(' ').first ?? '',
            surname: currentUser.displayName?.split(' ').last ?? '',
            email: currentUser.email ?? '',
            profileImage: currentUser.photoURL,
          );

          // Firestore'a kaydet
          await _firestore.collection('users').doc(currentUser.uid).set({
            'name': _userModel!.name,
            'surname': _userModel!.surname,
            'email': _userModel!.email,
            'profileImage': _userModel!.profileImage,
            'phone': _userModel!.phone,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }
    } catch (e) {
      print('Kullanıcı bilgileri yüklenirken hata: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<String?> _uploadProfileImage(String imagePath) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return null;

      final file = File(imagePath);
      final ref = _storage.ref().child('profile_images/${currentUser.uid}');
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Profil resmi yüklenirken hata: $e');
      return null;
    }
  }

  Future<void> updateUserProfile({
    String? name,
    String? surname,
    String? phone,
    String? profileImagePath,
  }) async {
    setLoading(true);
    try {
      print('UpdateUserProfile başladı');

      // Firebase App Check token'ını yenile
      try {
        await FirebaseAuth.instance.currentUser?.getIdToken(true);
      } catch (e) {
        print('Token yenileme hatası (önemli değil): $e');
      }

      // Oturum kontrolü
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('Kullanıcı oturumu bulunamadı');
      }

      // Kullanıcı verilerini kontrol et
      if (_userModel == null) {
        await loadUserData();
        if (_userModel == null) {
          throw Exception('Kullanıcı bilgileri yüklenemedi');
        }
      }

      final updates = <String, dynamic>{};

      // Sadece değişiklik yapılan alanları güncelle
      if (name != null) {
        updates['name'] = name.trim();
        print('İsim güncelleniyor: $name');
      }
      if (surname != null) {
        updates['surname'] = surname.trim();
        print('Soyisim güncelleniyor: $surname');
      }
      if (phone != null) {
        updates['phone'] = phone.trim();
        print('Telefon güncelleniyor: $phone');
      }

      // Profil resmi varsa yükle
      if (profileImagePath != null) {
        print('Profil resmi yükleniyor');
        final imageUrl = await _uploadProfileImage(profileImagePath);
        if (imageUrl != null) {
          updates['profileImage'] = imageUrl;
          print('Profil resmi yüklendi: $imageUrl');
        }
      }

      // Eğer güncellenecek alan yoksa çık
      if (updates.isEmpty) {
        print('Güncellenecek alan yok');
        return;
      }

      // Timestamp ekle
      updates['updatedAt'] = FieldValue.serverTimestamp();

      print('Firestore güncelleniyor: $updates');

      // Firestore'u güncelle
      await _firestore.collection('users').doc(currentUser.uid).update(updates);

      print('Firestore güncellendi');

      // Local model'i güncelle
      _userModel = UserModel(
        uid: _userModel!.uid,
        name: updates['name'] ?? _userModel!.name,
        surname: updates['surname'] ?? _userModel!.surname,
        email: _userModel!.email,
        profileImage: updates['profileImage'] ?? _userModel!.profileImage,
        phone: updates['phone'] ?? _userModel!.phone,
      );

      // DisplayName'i Firebase Auth'da güncelle
      if (updates.containsKey('name') || updates.containsKey('surname')) {
        try {
          final displayName = '${_userModel!.name} ${_userModel!.surname}';
          await currentUser.updateDisplayName(displayName);
          print('DisplayName güncellendi: $displayName');
        } catch (e) {
          print('DisplayName güncelleme hatası (önemli değil): $e');
        }
      }

      print('Profil güncelleme tamamlandı');
      notifyListeners();
    } catch (e) {
      print('Profil güncellenirken hata: $e');
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> signOut() async {
    setLoading(true);
    try {
      await _authService.signOut();
      _userModel = null;
    } catch (e) {
      print('Çıkış yaparken hata: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> loadDeviceHistory() async {
    setLoading(true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Kullanıcı oturumu bulunamadı');

      final sessionsSnapshot = await _firestore
          .collection('sessions')
          .where('userId', isEqualTo: user.uid)
          .get();

      _activeSessions = [];
      _sessionHistory = [];

      for (var doc in sessionsSnapshot.docs) {
        final session = SessionModel.fromMap(doc.data(), doc.id);
        if (session.isActive) {
          _activeSessions.add(session);
        } else {
          _sessionHistory.add(session);
        }
      }

      // Tarihe göre sırala
      _activeSessions.sort((a, b) => b.lastAccess.compareTo(a.lastAccess));
      _sessionHistory.sort((a, b) => b.loginTime.compareTo(a.loginTime));

      notifyListeners();
    } catch (e) {
      print('Cihaz geçmişi yüklenirken hata: $e');
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  Future<void> terminateSession(String sessionId) async {
    setLoading(true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Kullanıcı oturumu bulunamadı');

      await _firestore.collection('sessions').doc(sessionId).update({
        'isActive': false,
        'logoutTime': FieldValue.serverTimestamp(),
      });

      await loadDeviceHistory();
    } catch (e) {
      print('Oturum kapatılırken hata: $e');
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  Future<void> createSession() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      String deviceName = 'Bilinmeyen Cihaz';
      String deviceType = 'unknown';

      try {
        if (Platform.isAndroid) {
          final androidInfo = await _deviceInfo.androidInfo;
          deviceName = '${androidInfo.brand} ${androidInfo.model}';
          deviceType = 'mobile';
        } else if (Platform.isIOS) {
          final iosInfo = await _deviceInfo.iosInfo;
          deviceName = '${iosInfo.name} ${iosInfo.model}';
          deviceType = 'mobile';
        } else if (Platform.isWindows) {
          final windowsInfo = await _deviceInfo.windowsInfo;
          deviceName = windowsInfo.computerName;
          deviceType = 'desktop';
        } else if (Platform.isMacOS) {
          final macOsInfo = await _deviceInfo.macOsInfo;
          deviceName = macOsInfo.computerName;
          deviceType = 'desktop';
        }
      } catch (e) {
        print('Cihaz bilgisi alınırken hata: $e');
      }

      final session = SessionModel(
        id: '', // Firestore tarafından otomatik oluşturulacak
        userId: user.uid,
        deviceName: deviceName,
        deviceType: deviceType,
        loginTime: DateTime.now(),
        lastAccess: DateTime.now(),
      );

      await _firestore.collection('sessions').add(session.toMap());
    } catch (e) {
      print('Oturum oluşturulurken hata: $e');
    }
  }

  Future<void> updateLastAccess() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final sessionsSnapshot = await _firestore
          .collection('sessions')
          .where('userId', isEqualTo: user.uid)
          .where('isActive', isEqualTo: true)
          .get();

      for (var doc in sessionsSnapshot.docs) {
        await doc.reference.update({
          'lastAccess': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Son erişim güncellenirken hata: $e');
    }
  }

  Future<void> deleteAccount({required String password}) async {
    setLoading(true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Kullanıcı oturumu bulunamadı');

      // Firestore'dan kullanıcı bilgilerini al
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) throw Exception('Kullanıcı bilgileri bulunamadı');

      final userData = userDoc.data();
      if (userData == null || userData['password'] != password) {
        throw Exception('Şifre yanlış');
      }

      // Kullanıcının tüm verilerini sil
      await _firestore.collection('users').doc(user.uid).delete();
      await _firestore
          .collection('sessions')
          .where('userId', isEqualTo: user.uid)
          .get()
          .then((snapshot) {
        for (var doc in snapshot.docs) {
          doc.reference.delete();
        }
      });

      // Profil resmini sil
      if (_userModel?.profileImage != null) {
        try {
          await _storage.refFromURL(_userModel!.profileImage!).delete();
        } catch (e) {
          print('Profil resmi silinirken hata: $e');
        }
      }

      // Firebase Auth hesabını sil
      await user.delete();
      _userModel = null;
      notifyListeners();
    } catch (e) {
      print('Hesap silme hatası: $e');
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'requires-recent-login':
            throw 'Güvenlik nedeniyle yeniden giriş yapmanız gerekiyor';
          default:
            throw 'Hesap silinirken bir hata oluştu: ${e.message}';
        }
      }
      String errorMessage = e.toString();
      if (errorMessage.contains('Şifre yanlış')) {
        throw 'Şifre yanlış';
      }
      rethrow;
    } finally {
      setLoading(false);
    }
  }
}
