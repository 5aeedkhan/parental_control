import 'package:hive/hive.dart';

part 'screen_time_model.g.dart';

@HiveType(typeId: 5)
class ScreenTimeModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String deviceId;

  @HiveField(2)
  final String userId;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final Duration totalTime;

  @HiveField(5)
  final Duration limit;

  @HiveField(6)
  final Map<String, Duration> appUsage;

  @HiveField(7)
  final Map<String, Duration> categoryUsage;

  @HiveField(8)
  final int unlockCount;

  @HiveField(9)
  final int notificationCount;

  @HiveField(10)
  final DateTime? lastActivity;

  @HiveField(11)
  final bool isLimitExceeded;

  ScreenTimeModel({
    required this.id,
    required this.deviceId,
    required this.userId,
    required this.date,
    required this.totalTime,
    required this.limit,
    this.appUsage = const {},
    this.categoryUsage = const {},
    this.unlockCount = 0,
    this.notificationCount = 0,
    this.lastActivity,
    this.isLimitExceeded = false,
  });

  factory ScreenTimeModel.fromJson(Map<String, dynamic> json) {
    return ScreenTimeModel(
      id: json['id'] ?? '',
      deviceId: json['deviceId'] ?? '',
      userId: json['userId'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      totalTime: Duration(seconds: json['totalTimeSeconds'] ?? 0),
      limit: Duration(seconds: json['limitSeconds'] ?? 0),
      appUsage: Map<String, Duration>.from(
        (json['appUsage'] ?? {}).map(
          (key, value) => MapEntry(key, Duration(seconds: value)),
        ),
      ),
      categoryUsage: Map<String, Duration>.from(
        (json['categoryUsage'] ?? {}).map(
          (key, value) => MapEntry(key, Duration(seconds: value)),
        ),
      ),
      unlockCount: json['unlockCount'] ?? 0,
      notificationCount: json['notificationCount'] ?? 0,
      lastActivity: json['lastActivity'] != null 
          ? DateTime.parse(json['lastActivity']) 
          : null,
      isLimitExceeded: json['isLimitExceeded'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deviceId': deviceId,
      'userId': userId,
      'date': date.toIso8601String(),
      'totalTimeSeconds': totalTime.inSeconds,
      'limitSeconds': limit.inSeconds,
      'appUsage': appUsage.map(
        (key, value) => MapEntry(key, value.inSeconds),
      ),
      'categoryUsage': categoryUsage.map(
        (key, value) => MapEntry(key, value.inSeconds),
      ),
      'unlockCount': unlockCount,
      'notificationCount': notificationCount,
      'lastActivity': lastActivity?.toIso8601String(),
      'isLimitExceeded': isLimitExceeded,
    };
  }

  ScreenTimeModel copyWith({
    String? id,
    String? deviceId,
    String? userId,
    DateTime? date,
    Duration? totalTime,
    Duration? limit,
    Map<String, Duration>? appUsage,
    Map<String, Duration>? categoryUsage,
    int? unlockCount,
    int? notificationCount,
    DateTime? lastActivity,
    bool? isLimitExceeded,
  }) {
    return ScreenTimeModel(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      totalTime: totalTime ?? this.totalTime,
      limit: limit ?? this.limit,
      appUsage: appUsage ?? this.appUsage,
      categoryUsage: categoryUsage ?? this.categoryUsage,
      unlockCount: unlockCount ?? this.unlockCount,
      notificationCount: notificationCount ?? this.notificationCount,
      lastActivity: lastActivity ?? this.lastActivity,
      isLimitExceeded: isLimitExceeded ?? this.isLimitExceeded,
    );
  }

  double get usagePercentage {
    if (limit.inSeconds == 0) return 0.0;
    return (totalTime.inSeconds / limit.inSeconds * 100).clamp(0.0, 100.0);
  }

  Duration get remainingTime {
    return Duration(seconds: (limit.inSeconds - totalTime.inSeconds).clamp(0, limit.inSeconds));
  }
}
