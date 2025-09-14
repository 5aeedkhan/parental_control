import 'package:hive/hive.dart';

part 'device_model.g.dart';

@HiveType(typeId: 1)
class DeviceModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String platform; // 'android' or 'ios'

  @HiveField(3)
  final String model;

  @HiveField(4)
  final String osVersion;

  @HiveField(5)
  final String? ownerId; // User ID of the child

  @HiveField(6)
  final bool isOnline;

  @HiveField(7)
  final DateTime? lastSeen;

  @HiveField(8)
  final int batteryLevel;

  @HiveField(9)
  final bool isCharging;

  @HiveField(10)
  final double dataUsage; // in GB

  @HiveField(11)
  final Map<String, dynamic> settings;

  @HiveField(12)
  final DateTime createdAt;

  DeviceModel({
    required this.id,
    required this.name,
    required this.platform,
    required this.model,
    required this.osVersion,
    this.ownerId,
    this.isOnline = false,
    this.lastSeen,
    this.batteryLevel = 0,
    this.isCharging = false,
    this.dataUsage = 0.0,
    this.settings = const {},
    required this.createdAt,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      platform: json['platform'] ?? '',
      model: json['model'] ?? '',
      osVersion: json['osVersion'] ?? '',
      ownerId: json['ownerId'],
      isOnline: json['isOnline'] ?? false,
      lastSeen: json['lastSeen'] != null ? DateTime.parse(json['lastSeen']) : null,
      batteryLevel: json['batteryLevel'] ?? 0,
      isCharging: json['isCharging'] ?? false,
      dataUsage: (json['dataUsage'] ?? 0.0).toDouble(),
      settings: Map<String, dynamic>.from(json['settings'] ?? {}),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'platform': platform,
      'model': model,
      'osVersion': osVersion,
      'ownerId': ownerId,
      'isOnline': isOnline,
      'lastSeen': lastSeen?.toIso8601String(),
      'batteryLevel': batteryLevel,
      'isCharging': isCharging,
      'dataUsage': dataUsage,
      'settings': settings,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  DeviceModel copyWith({
    String? id,
    String? name,
    String? platform,
    String? model,
    String? osVersion,
    String? ownerId,
    bool? isOnline,
    DateTime? lastSeen,
    int? batteryLevel,
    bool? isCharging,
    double? dataUsage,
    Map<String, dynamic>? settings,
    DateTime? createdAt,
  }) {
    return DeviceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      platform: platform ?? this.platform,
      model: model ?? this.model,
      osVersion: osVersion ?? this.osVersion,
      ownerId: ownerId ?? this.ownerId,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      isCharging: isCharging ?? this.isCharging,
      dataUsage: dataUsage ?? this.dataUsage,
      settings: settings ?? this.settings,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
