import 'package:hive/hive.dart';

part 'alert_model.g.dart';

@HiveType(typeId: 2)
enum AlertType {
  @HiveField(0)
  cyberbullying,
  @HiveField(1)
  inappropriateContent,
  @HiveField(2)
  locationAlert,
  @HiveField(3)
  screenTimeExceeded,
  @HiveField(4)
  appUsageAlert,
  @HiveField(5)
  unknownContact,
  @HiveField(6)
  systemAlert,
}

@HiveType(typeId: 3)
enum AlertSeverity {
  @HiveField(0)
  low,
  @HiveField(1)
  medium,
  @HiveField(2)
  high,
  @HiveField(3)
  critical,
}

@HiveType(typeId: 4)
class AlertModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final AlertType type;

  @HiveField(2)
  final AlertSeverity severity;

  @HiveField(3)
  final String title;

  @HiveField(4)
  final String description;

  @HiveField(5)
  final String? deviceId;

  @HiveField(6)
  final String? userId;

  @HiveField(7)
  final DateTime timestamp;

  @HiveField(8)
  final bool isRead;

  @HiveField(9)
  final bool isResolved;

  @HiveField(10)
  final Map<String, dynamic> metadata;

  @HiveField(11)
  final String? actionTaken;

  AlertModel({
    required this.id,
    required this.type,
    required this.severity,
    required this.title,
    required this.description,
    this.deviceId,
    this.userId,
    required this.timestamp,
    this.isRead = false,
    this.isResolved = false,
    this.metadata = const {},
    this.actionTaken,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'] ?? '',
      type: AlertType.values.firstWhere(
        (e) => e.toString() == 'AlertType.${json['type']}',
        orElse: () => AlertType.systemAlert,
      ),
      severity: AlertSeverity.values.firstWhere(
        (e) => e.toString() == 'AlertSeverity.${json['severity']}',
        orElse: () => AlertSeverity.medium,
      ),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      deviceId: json['deviceId'],
      userId: json['userId'],
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      isRead: json['isRead'] ?? false,
      isResolved: json['isResolved'] ?? false,
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      actionTaken: json['actionTaken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'severity': severity.toString().split('.').last,
      'title': title,
      'description': description,
      'deviceId': deviceId,
      'userId': userId,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'isResolved': isResolved,
      'metadata': metadata,
      'actionTaken': actionTaken,
    };
  }

  AlertModel copyWith({
    String? id,
    AlertType? type,
    AlertSeverity? severity,
    String? title,
    String? description,
    String? deviceId,
    String? userId,
    DateTime? timestamp,
    bool? isRead,
    bool? isResolved,
    Map<String, dynamic>? metadata,
    String? actionTaken,
  }) {
    return AlertModel(
      id: id ?? this.id,
      type: type ?? this.type,
      severity: severity ?? this.severity,
      title: title ?? this.title,
      description: description ?? this.description,
      deviceId: deviceId ?? this.deviceId,
      userId: userId ?? this.userId,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      isResolved: isResolved ?? this.isResolved,
      metadata: metadata ?? this.metadata,
      actionTaken: actionTaken ?? this.actionTaken,
    );
  }
}
