import 'package:cloud_firestore/cloud_firestore.dart';

class SessionModel {
  final String id;
  final String userId;
  final String deviceName;
  final String deviceType;
  final DateTime loginTime;
  final DateTime lastAccess;
  final DateTime? logoutTime;
  final bool isActive;

  SessionModel({
    required this.id,
    required this.userId,
    required this.deviceName,
    required this.deviceType,
    required this.loginTime,
    required this.lastAccess,
    this.logoutTime,
    this.isActive = true,
  });

  factory SessionModel.fromMap(Map<String, dynamic> map, String id) {
    return SessionModel(
      id: id,
      userId: map['userId'] as String,
      deviceName: map['deviceName'] as String,
      deviceType: map['deviceType'] as String,
      loginTime: (map['loginTime'] as Timestamp).toDate(),
      lastAccess: (map['lastAccess'] as Timestamp).toDate(),
      logoutTime: map['logoutTime'] != null
          ? (map['logoutTime'] as Timestamp).toDate()
          : null,
      isActive: map['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'deviceName': deviceName,
      'deviceType': deviceType,
      'loginTime': loginTime,
      'lastAccess': lastAccess,
      'logoutTime': logoutTime,
      'isActive': isActive,
    };
  }

  SessionModel copyWith({
    String? id,
    String? userId,
    String? deviceName,
    String? deviceType,
    DateTime? loginTime,
    DateTime? lastAccess,
    DateTime? logoutTime,
    bool? isActive,
  }) {
    return SessionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      deviceName: deviceName ?? this.deviceName,
      deviceType: deviceType ?? this.deviceType,
      loginTime: loginTime ?? this.loginTime,
      lastAccess: lastAccess ?? this.lastAccess,
      logoutTime: logoutTime ?? this.logoutTime,
      isActive: isActive ?? this.isActive,
    );
  }
}
