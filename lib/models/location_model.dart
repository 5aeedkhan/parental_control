import 'package:hive/hive.dart';

part 'location_model.g.dart';

@HiveType(typeId: 9)
class LocationModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String deviceId;

  @HiveField(2)
  final String userId;

  @HiveField(3)
  final double latitude;

  @HiveField(4)
  final double longitude;

  @HiveField(5)
  final String? address;

  @HiveField(6)
  final String? placeName;

  @HiveField(7)
  final double accuracy;

  @HiveField(8)
  final DateTime timestamp;

  @HiveField(9)
  final bool isSafeZone;

  @HiveField(10)
  final String? safeZoneId;

  @HiveField(11)
  final Map<String, dynamic> metadata;

  LocationModel({
    required this.id,
    required this.deviceId,
    required this.userId,
    required this.latitude,
    required this.longitude,
    this.address,
    this.placeName,
    required this.accuracy,
    required this.timestamp,
    this.isSafeZone = false,
    this.safeZoneId,
    this.metadata = const {},
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] ?? '',
      deviceId: json['deviceId'] ?? '',
      userId: json['userId'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      address: json['address'],
      placeName: json['placeName'],
      accuracy: (json['accuracy'] ?? 0.0).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      isSafeZone: json['isSafeZone'] ?? false,
      safeZoneId: json['safeZoneId'],
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deviceId': deviceId,
      'userId': userId,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'placeName': placeName,
      'accuracy': accuracy,
      'timestamp': timestamp.toIso8601String(),
      'isSafeZone': isSafeZone,
      'safeZoneId': safeZoneId,
      'metadata': metadata,
    };
  }

  LocationModel copyWith({
    String? id,
    String? deviceId,
    String? userId,
    double? latitude,
    double? longitude,
    String? address,
    String? placeName,
    double? accuracy,
    DateTime? timestamp,
    bool? isSafeZone,
    String? safeZoneId,
    Map<String, dynamic>? metadata,
  }) {
    return LocationModel(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      userId: userId ?? this.userId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      placeName: placeName ?? this.placeName,
      accuracy: accuracy ?? this.accuracy,
      timestamp: timestamp ?? this.timestamp,
      isSafeZone: isSafeZone ?? this.isSafeZone,
      safeZoneId: safeZoneId ?? this.safeZoneId,
      metadata: metadata ?? this.metadata,
    );
  }
}

@HiveType(typeId: 10)
class SafeZoneModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final double latitude;

  @HiveField(4)
  final double longitude;

  @HiveField(5)
  final double radius; // in meters

  @HiveField(6)
  final bool isActive;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final DateTime? lastModified;

  @HiveField(9)
  final List<String> deviceIds;

  @HiveField(10)
  final Map<String, dynamic> settings;

  SafeZoneModel({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.radius,
    this.isActive = true,
    required this.createdAt,
    this.lastModified,
    this.deviceIds = const [],
    this.settings = const {},
  });

  factory SafeZoneModel.fromJson(Map<String, dynamic> json) {
    return SafeZoneModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      radius: (json['radius'] ?? 100.0).toDouble(),
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      lastModified: json['lastModified'] != null 
          ? DateTime.parse(json['lastModified']) 
          : null,
      deviceIds: List<String>.from(json['deviceIds'] ?? []),
      settings: Map<String, dynamic>.from(json['settings'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'lastModified': lastModified?.toIso8601String(),
      'deviceIds': deviceIds,
      'settings': settings,
    };
  }

  SafeZoneModel copyWith({
    String? id,
    String? name,
    String? description,
    double? latitude,
    double? longitude,
    double? radius,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastModified,
    List<String>? deviceIds,
    Map<String, dynamic>? settings,
  }) {
    return SafeZoneModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radius: radius ?? this.radius,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
      deviceIds: deviceIds ?? this.deviceIds,
      settings: settings ?? this.settings,
    );
  }
}
