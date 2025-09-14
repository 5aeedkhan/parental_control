import 'package:uuid/uuid.dart';
import '../models/user_model.dart';
import '../models/device_model.dart';
import '../models/alert_model.dart';
import '../models/screen_time_model.dart';
import '../models/app_model.dart';
import '../models/location_model.dart';
import '../services/storage_service.dart';

class DemoDataService {
  static DemoDataService? _instance;
  static DemoDataService get instance => _instance ??= DemoDataService._();
  
  DemoDataService._();
  
  final _uuid = const Uuid();
  
  Future<void> populateDemoData() async {
    final storageService = StorageService.instance;
    
    // Create demo user
    final demoUser = UserModel(
      id: _uuid.v4(),
      name: 'Sarah Johnson',
      email: 'sarah.johnson@example.com',
      role: 'parent',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      lastLogin: DateTime.now(),
      preferences: {
        'notifications': true,
        'darkMode': false,
        'language': 'en',
      },
    );
    
    await storageService.saveUser(demoUser);
    
    // Create demo device
    final demoDevice = DeviceModel(
      id: _uuid.v4(),
      name: 'Emma\'s iPhone',
      platform: 'ios',
      model: 'iPhone 13',
      osVersion: 'iOS 16.0',
      ownerId: demoUser.id,
      isOnline: true,
      lastSeen: DateTime.now(),
      batteryLevel: 78,
      isCharging: false,
      dataUsage: 2.3,
      settings: {
        'screenTimeLimit': 6 * 60 * 60, // 6 hours in seconds
        'bedtimeMode': true,
        'locationTracking': true,
      },
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    );
    
    await storageService.saveDevice(demoDevice);
    
    // Create demo alerts
    final demoAlerts = [
      AlertModel(
        id: _uuid.v4(),
        type: AlertType.cyberbullying,
        severity: AlertSeverity.high,
        title: 'Potential Cyberbullying Detected',
        description: 'Inappropriate language detected in Instagram messages',
        deviceId: demoDevice.id,
        userId: demoUser.id,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        metadata: {
          'app': 'Instagram',
          'messageCount': 3,
          'confidence': 0.85,
        },
      ),
      AlertModel(
        id: _uuid.v4(),
        type: AlertType.screenTimeExceeded,
        severity: AlertSeverity.medium,
        title: 'Screen Time Limit Exceeded',
        description: 'Daily screen time limit has been exceeded by 1 hour',
        deviceId: demoDevice.id,
        userId: demoUser.id,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        metadata: {
          'limit': 6 * 60 * 60,
          'actual': 7 * 60 * 60,
          'excess': 1 * 60 * 60,
        },
      ),
    ];
    
    for (final alert in demoAlerts) {
      await storageService.saveAlert(alert);
    }
    
    // Create demo screen time data
    final now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      final date = now.subtract(Duration(days: i));
      final screenTime = ScreenTimeModel(
        id: '${demoDevice.id}_${date.year}_${date.month}_${date.day}',
        deviceId: demoDevice.id,
        userId: demoUser.id,
        date: date,
        totalTime: Duration(
          hours: 4 + (i % 3),
          minutes: 20 + (i * 10),
        ),
        limit: const Duration(hours: 6),
        appUsage: {
          'Instagram': Duration(minutes: 45 + (i * 5)),
          'TikTok': Duration(minutes: 30 + (i * 3)),
          'YouTube': Duration(minutes: 25 + (i * 2)),
          'Games': Duration(minutes: 60 + (i * 8)),
          'Education': Duration(minutes: 20 + (i * 2)),
        },
        categoryUsage: {
          'Social': Duration(minutes: 75 + (i * 8)),
          'Entertainment': Duration(minutes: 85 + (i * 10)),
          'Games': Duration(minutes: 60 + (i * 8)),
          'Education': Duration(minutes: 20 + (i * 2)),
        },
        unlockCount: 25 + (i * 3),
        notificationCount: 15 + (i * 2),
        lastActivity: date.add(const Duration(hours: 20)),
        isLimitExceeded: i > 3,
      );
      
      await storageService.saveScreenTime(screenTime);
    }
    
    // Create demo apps
    final demoApps = [
      AppModel(
        id: _uuid.v4(),
        name: 'Instagram',
        packageName: 'com.instagram.android',
        category: AppCategory.social,
        status: AppStatus.allowed,
        timeLimit: const Duration(hours: 1),
        dailyUsage: const Duration(minutes: 45),
        allowedTimes: ['09:00-21:00'],
        version: '1.0.0',
        installedDate: DateTime.now().subtract(const Duration(days: 30)),
        lastUsed: DateTime.now().subtract(const Duration(minutes: 30)),
        metadata: {'deviceId': demoDevice.id},
      ),
      AppModel(
        id: _uuid.v4(),
        name: 'TikTok',
        packageName: 'com.zhiliaoapp.musically',
        category: AppCategory.entertainment,
        status: AppStatus.restricted,
        timeLimit: const Duration(minutes: 30),
        dailyUsage: const Duration(minutes: 30),
        allowedTimes: ['15:00-18:00'],
        version: '1.0.0',
        installedDate: DateTime.now().subtract(const Duration(days: 20)),
        lastUsed: DateTime.now().subtract(const Duration(hours: 2)),
        metadata: {'deviceId': demoDevice.id},
      ),
      AppModel(
        id: _uuid.v4(),
        name: 'YouTube',
        packageName: 'com.google.android.youtube',
        category: AppCategory.entertainment,
        status: AppStatus.allowed,
        timeLimit: const Duration(hours: 2),
        dailyUsage: const Duration(minutes: 25),
        allowedTimes: ['09:00-21:00'],
        version: '1.0.0',
        installedDate: DateTime.now().subtract(const Duration(days: 45)),
        lastUsed: DateTime.now().subtract(const Duration(hours: 1)),
        metadata: {'deviceId': demoDevice.id},
      ),
      AppModel(
        id: _uuid.v4(),
        name: 'Roblox',
        packageName: 'com.roblox.client',
        category: AppCategory.games,
        status: AppStatus.allowed,
        timeLimit: const Duration(hours: 1),
        dailyUsage: const Duration(minutes: 60),
        allowedTimes: ['16:00-20:00'],
        version: '1.0.0',
        installedDate: DateTime.now().subtract(const Duration(days: 10)),
        lastUsed: DateTime.now().subtract(const Duration(minutes: 15)),
        metadata: {'deviceId': demoDevice.id},
      ),
    ];
    
    for (final app in demoApps) {
      await storageService.saveApp(app);
    }
    
    // Create demo location data
    final demoLocations = [
      LocationModel(
        id: _uuid.v4(),
        deviceId: demoDevice.id,
        userId: demoUser.id,
        latitude: 37.7749,
        longitude: -122.4194,
        address: '123 Main St, San Francisco, CA',
        placeName: 'Emma\'s School',
        accuracy: 10.0,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isSafeZone: true,
        safeZoneId: 'school_zone',
        metadata: {'confidence': 0.95},
      ),
      LocationModel(
        id: _uuid.v4(),
        deviceId: demoDevice.id,
        userId: demoUser.id,
        latitude: 37.7849,
        longitude: -122.4094,
        address: '456 Oak Ave, San Francisco, CA',
        placeName: 'Home',
        accuracy: 5.0,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isSafeZone: true,
        safeZoneId: 'home_zone',
        metadata: {'confidence': 0.98},
      ),
    ];
    
    for (final location in demoLocations) {
      await storageService.saveLocation(location);
    }
    
    // Create demo safe zones
    final demoSafeZones = [
      SafeZoneModel(
        id: 'school_zone',
        name: 'Emma\'s School',
        description: 'School campus and surrounding area',
        latitude: 37.7749,
        longitude: -122.4194,
        radius: 100.0,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        deviceIds: [demoDevice.id],
        settings: {
          'notifications': true,
          'autoCheckIn': true,
        },
      ),
      SafeZoneModel(
        id: 'home_zone',
        name: 'Home',
        description: 'Family home and neighborhood',
        latitude: 37.7849,
        longitude: -122.4094,
        radius: 50.0,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        deviceIds: [demoDevice.id],
        settings: {
          'notifications': true,
          'autoCheckIn': false,
        },
      ),
    ];
    
    for (final safeZone in demoSafeZones) {
      await storageService.saveSafeZone(safeZone);
    }
  }
  
  Future<void> clearDemoData() async {
    final storageService = StorageService.instance;
    await storageService.clearAllData();
  }
}
