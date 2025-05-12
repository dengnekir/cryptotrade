import 'package:flutter/material.dart';

@immutable
class UserModel {
  final String uid;
  final String name;
  final String surname;
  final String email;
  late final String? profileImage;
  final String? phone;

  UserModel({
    required this.uid,
    required this.name,
    required this.surname,
    required this.email,
    this.profileImage,
    this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Null safety ve tip kontrolü uygulayarak güvenli dönüşüm
    String getStringValue(
        Map<String, dynamic> map, String key, String defaultValue) {
      final value = map[key];
      if (value == null) return defaultValue;
      if (value is String) return value;
      return value.toString();
    }

    return UserModel(
      uid: getStringValue(json, 'uid', ''),
      name: getStringValue(json, 'name', ''),
      surname: getStringValue(json, 'surname', ''),
      email: getStringValue(json, 'email', ''),
      profileImage: json['profileImage'] is String
          ? json['profileImage'] as String?
          : null,
      phone: json['phone'] is String ? json['phone'] as String? : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'surname': surname,
      'email': email,
      'profileImage': profileImage,
      'phone': phone,
    };
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? surname,
    String? email,
    String? profileImage,
    String? phone,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      phone: phone ?? this.phone,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, surname: $surname, email: $email, profileImage: $profileImage, phone: $phone)';
  }
}
