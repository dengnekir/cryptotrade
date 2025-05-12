import 'package:flutter/material.dart';
import '../../core/models/user_model.dart';
import '../../core/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  UserModel? _userModel;

  bool get isLoading => _isLoading;
  UserModel? get userModel => _userModel;

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
            profileImage: data['profileImage'] ?? currentUser.photoURL,
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

  Future<void> updateUserProfile({
    String? name,
    String? surname,
    String? email,
    String? profileImage,
  }) async {
    setLoading(true);
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null && _userModel != null) {
        final updates = <String, dynamic>{};

        if (name != null) updates['name'] = name;
        if (surname != null) updates['surname'] = surname;
        if (email != null) updates['email'] = email;
        if (profileImage != null) updates['profileImage'] = profileImage;

        await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .update(updates);

        _userModel = UserModel(
          uid: _userModel!.uid,
          name: name ?? _userModel!.name,
          surname: surname ?? _userModel!.surname,
          email: email ?? _userModel!.email,
          profileImage: profileImage ?? _userModel!.profileImage,
        );

        notifyListeners();
      }
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
}
