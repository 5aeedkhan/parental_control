import 'package:cloud_firestore/cloud_firestore.dart';

class DeviceControlModel {
  final String id;
  final String deviceId;
  final String parentId;
  final bool isLocked;
  final bool isInternetPaused;
  final bool isAppBlockingEnabled;
  final DateTime? lockedAt;
  final DateTime? internetPausedAt;
  final DateTime? appBlockingEnabledAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  DeviceControlModel({
    required this.id,
    required this.deviceId,
    required this.parentId,
    required this.isLocked,
    required this.isInternetPaused,
    required this.isAppBlockingEnabled,
    this.lockedAt,
    this.internetPausedAt,
    this.appBlockingEnabledAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DeviceControlModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DeviceControlModel(
      id: doc.id,
      deviceId: data['deviceId'] ?? '',
      parentId: data['parentId'] ?? '',
      isLocked: data['isLocked'] ?? false,
      isInternetPaused: data['isInternetPaused'] ?? false,
      isAppBlockingEnabled: data['isAppBlockingEnabled'] ?? false,
      lockedAt: data['lockedAt']?.toDate(),
      internetPausedAt: data['internetPausedAt']?.toDate(),
      appBlockingEnabledAt: data['appBlockingEnabledAt']?.toDate(),
      createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
      updatedAt: data['updatedAt']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'deviceId': deviceId,
      'parentId': parentId,
      'isLocked': isLocked,
      'isInternetPaused': isInternetPaused,
      'isAppBlockingEnabled': isAppBlockingEnabled,
      'lockedAt': lockedAt != null ? Timestamp.fromDate(lockedAt!) : null,
      'internetPausedAt': internetPausedAt != null ? Timestamp.fromDate(internetPausedAt!) : null,
      'appBlockingEnabledAt': appBlockingEnabledAt != null ? Timestamp.fromDate(appBlockingEnabledAt!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  DeviceControlModel copyWith({
    String? id,
    String? deviceId,
    String? parentId,
    bool? isLocked,
    bool? isInternetPaused,
    bool? isAppBlockingEnabled,
    DateTime? lockedAt,
    DateTime? internetPausedAt,
    DateTime? appBlockingEnabledAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DeviceControlModel(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      parentId: parentId ?? this.parentId,
      isLocked: isLocked ?? this.isLocked,
      isInternetPaused: isInternetPaused ?? this.isInternetPaused,
      isAppBlockingEnabled: isAppBlockingEnabled ?? this.isAppBlockingEnabled,
      lockedAt: lockedAt ?? this.lockedAt,
      internetPausedAt: internetPausedAt ?? this.internetPausedAt,
      appBlockingEnabledAt: appBlockingEnabledAt ?? this.appBlockingEnabledAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
