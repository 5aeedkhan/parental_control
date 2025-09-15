import 'package:hive/hive.dart';

part 'user_model.g.dart';

enum UserType { parent, child }

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String? profileImage;

  @HiveField(4)
  final UserType userType; // parent or child

  @HiveField(5)
  final String? parentId; // for child accounts

  @HiveField(6)
  final List<String> childIds; // for parent accounts

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final DateTime? lastLogin;

  @HiveField(9)
  final bool isActive;

  @HiveField(10)
  final Map<String, dynamic> preferences;

  @HiveField(11)
  final int? age; // for child accounts

  @HiveField(12)
  final String? deviceId; // for child accounts

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    required this.userType,
    this.parentId,
    this.childIds = const [],
    required this.createdAt,
    this.lastLogin,
    this.isActive = true,
    this.preferences = const {},
    this.age,
    this.deviceId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'],
      userType: _parseUserType(json['userType'] ?? json['role'] ?? 'parent'),
      parentId: json['parentId'],
      childIds: List<String>.from(json['childIds'] ?? []),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      lastLogin: json['lastLogin'] != null ? DateTime.parse(json['lastLogin']) : null,
      isActive: json['isActive'] ?? true,
      preferences: Map<String, dynamic>.from(json['preferences'] ?? {}),
      age: json['age'],
      deviceId: json['deviceId'],
    );
  }

  static UserType _parseUserType(String type) {
    switch (type.toLowerCase()) {
      case 'child':
        return UserType.child;
      case 'parent':
      default:
        return UserType.parent;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'userType': userType.name,
      'parentId': parentId,
      'childIds': childIds,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
      'isActive': isActive,
      'preferences': preferences,
      'age': age,
      'deviceId': deviceId,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImage,
    UserType? userType,
    String? parentId,
    List<String>? childIds,
    DateTime? createdAt,
    DateTime? lastLogin,
    bool? isActive,
    Map<String, dynamic>? preferences,
    int? age,
    String? deviceId,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      userType: userType ?? this.userType,
      parentId: parentId ?? this.parentId,
      childIds: childIds ?? this.childIds,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      isActive: isActive ?? this.isActive,
      preferences: preferences ?? this.preferences,
      age: age ?? this.age,
      deviceId: deviceId ?? this.deviceId,
    );
  }

  // Helper methods
  bool get isParent => userType == UserType.parent;
  bool get isChild => userType == UserType.child;
  
  // For backward compatibility
  String get role => userType.name;
}
