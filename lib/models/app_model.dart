import 'package:hive/hive.dart';

part 'app_model.g.dart';

@HiveType(typeId: 6)
enum AppCategory {
  @HiveField(0)
  games,
  @HiveField(1)
  social,
  @HiveField(2)
  education,
  @HiveField(3)
  entertainment,
  @HiveField(4)
  productivity,
  @HiveField(5)
  communication,
  @HiveField(6)
  utilities,
  @HiveField(7)
  other,
}

@HiveType(typeId: 7)
enum AppStatus {
  @HiveField(0)
  allowed,
  @HiveField(1)
  blocked,
  @HiveField(2)
  restricted,
  @HiveField(3)
  pending,
}

@HiveType(typeId: 8)
class AppModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String packageName;

  @HiveField(3)
  final String? iconUrl;

  @HiveField(4)
  final AppCategory category;

  @HiveField(5)
  final AppStatus status;

  @HiveField(6)
  final Duration? timeLimit;

  @HiveField(7)
  final Duration? dailyUsage;

  @HiveField(8)
  final List<String> allowedTimes; // e.g., ["09:00-17:00", "19:00-21:00"]

  @HiveField(9)
  final bool isSystemApp;

  @HiveField(10)
  final String version;

  @HiveField(11)
  final DateTime installedDate;

  @HiveField(12)
  final DateTime? lastUsed;

  @HiveField(13)
  final Map<String, dynamic> metadata;

  AppModel({
    required this.id,
    required this.name,
    required this.packageName,
    this.iconUrl,
    required this.category,
    this.status = AppStatus.allowed,
    this.timeLimit,
    this.dailyUsage,
    this.allowedTimes = const [],
    this.isSystemApp = false,
    required this.version,
    required this.installedDate,
    this.lastUsed,
    this.metadata = const {},
  });

  factory AppModel.fromJson(Map<String, dynamic> json) {
    return AppModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      packageName: json['packageName'] ?? '',
      iconUrl: json['iconUrl'],
      category: AppCategory.values.firstWhere(
        (e) => e.toString() == 'AppCategory.${json['category']}',
        orElse: () => AppCategory.other,
      ),
      status: AppStatus.values.firstWhere(
        (e) => e.toString() == 'AppStatus.${json['status']}',
        orElse: () => AppStatus.allowed,
      ),
      timeLimit: json['timeLimitSeconds'] != null 
          ? Duration(seconds: json['timeLimitSeconds']) 
          : null,
      dailyUsage: json['dailyUsageSeconds'] != null 
          ? Duration(seconds: json['dailyUsageSeconds']) 
          : null,
      allowedTimes: List<String>.from(json['allowedTimes'] ?? []),
      isSystemApp: json['isSystemApp'] ?? false,
      version: json['version'] ?? '',
      installedDate: DateTime.parse(json['installedDate'] ?? DateTime.now().toIso8601String()),
      lastUsed: json['lastUsed'] != null ? DateTime.parse(json['lastUsed']) : null,
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'packageName': packageName,
      'iconUrl': iconUrl,
      'category': category.toString().split('.').last,
      'status': status.toString().split('.').last,
      'timeLimitSeconds': timeLimit?.inSeconds,
      'dailyUsageSeconds': dailyUsage?.inSeconds,
      'allowedTimes': allowedTimes,
      'isSystemApp': isSystemApp,
      'version': version,
      'installedDate': installedDate.toIso8601String(),
      'lastUsed': lastUsed?.toIso8601String(),
      'metadata': metadata,
    };
  }

  AppModel copyWith({
    String? id,
    String? name,
    String? packageName,
    String? iconUrl,
    AppCategory? category,
    AppStatus? status,
    Duration? timeLimit,
    Duration? dailyUsage,
    List<String>? allowedTimes,
    bool? isSystemApp,
    String? version,
    DateTime? installedDate,
    DateTime? lastUsed,
    Map<String, dynamic>? metadata,
  }) {
    return AppModel(
      id: id ?? this.id,
      name: name ?? this.name,
      packageName: packageName ?? this.packageName,
      iconUrl: iconUrl ?? this.iconUrl,
      category: category ?? this.category,
      status: status ?? this.status,
      timeLimit: timeLimit ?? this.timeLimit,
      dailyUsage: dailyUsage ?? this.dailyUsage,
      allowedTimes: allowedTimes ?? this.allowedTimes,
      isSystemApp: isSystemApp ?? this.isSystemApp,
      version: version ?? this.version,
      installedDate: installedDate ?? this.installedDate,
      lastUsed: lastUsed ?? this.lastUsed,
      metadata: metadata ?? this.metadata,
    );
  }

  bool get isBlocked => status == AppStatus.blocked;
  bool get isRestricted => status == AppStatus.restricted;
  bool get isAllowed => status == AppStatus.allowed;

  bool get hasTimeLimit => timeLimit != null;
  bool get hasDailyUsage => dailyUsage != null;
  bool get hasAllowedTimes => allowedTimes.isNotEmpty;
}
