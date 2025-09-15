import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/device_model.dart';
import '../models/alert_model.dart';
import '../models/screen_time_model.dart';
import '../models/location_model.dart';

class SampleDataService {
  static SampleDataService? _instance;
  static SampleDataService get instance => _instance ??= SampleDataService._();
  
  SampleDataService._();
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Generate sample data for testing
  Future<void> generateSampleData(String parentId, String childId) async {
    try {
      // Generate sample device
      await _generateSampleDevice(parentId, childId);
      
      // Generate sample alerts
      await _generateSampleAlerts(parentId, childId);
      
      // Generate sample screen time data
      await _generateSampleScreenTimeData(childId);
      
      // Generate sample location data
      await _generateSampleLocationData(childId);
      
      // Generate real-time monitoring data
      await _generateRealTimeData(childId);
      
      print('Sample data generated successfully!');
    } catch (e) {
      print('Failed to generate sample data: $e');
    }
  }
  
  Future<void> _generateSampleDevice(String parentId, String childId) async {
    final device = DeviceModel(
      id: 'device_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Child\'s iPhone',
      platform: 'ios',
      model: 'iPhone 13',
      osVersion: '16.0',
      ownerId: childId,
      isOnline: true,
      lastSeen: DateTime.now(),
      batteryLevel: 78,
      isCharging: false,
      dataUsage: 2.3,
      settings: {
        'bedtime': '22:00',
        'wakeup': '07:00',
        'maxScreenTime': 360, // 6 hours in minutes
      },
      createdAt: DateTime.now(),
    );
    
    await _firestore
        .collection('devices')
        .doc(device.id)
        .set(device.toJson());
  }
  
  Future<void> _generateSampleAlerts(String parentId, String childId) async {
    final alerts = [
      AlertModel(
        id: 'alert_1',
        type: AlertType.screenTimeExceeded,
        severity: AlertSeverity.medium,
        title: 'Screen Time Limit Exceeded',
        description: 'Your child has exceeded their daily screen time limit of 6 hours.',
        deviceId: 'device_${DateTime.now().millisecondsSinceEpoch}',
        userId: childId,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
        isResolved: false,
        metadata: {
          'screenTime': 420, // 7 hours in minutes
          'limit': 360, // 6 hours in minutes
        },
      ),
      AlertModel(
        id: 'alert_2',
        type: AlertType.locationAlert,
        severity: AlertSeverity.low,
        title: 'Left Safe Zone',
        description: 'Your child has left the designated safe zone (Home).',
        deviceId: 'device_${DateTime.now().millisecondsSinceEpoch}',
        userId: childId,
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isRead: false,
        isResolved: false,
        metadata: {
          'location': 'Downtown Mall',
          'safeZone': 'Home',
        },
      ),
    ];
    
    for (final alert in alerts) {
      await _firestore
          .collection('alerts')
          .doc(alert.id)
          .set(alert.toJson());
    }
  }
  
  Future<void> _generateSampleScreenTimeData(String childId) async {
    final now = DateTime.now();
    
    // Generate data for the past 7 days
    for (int i = 0; i < 7; i++) {
      final date = now.subtract(Duration(days: i));
      final screenTime = ScreenTimeModel(
        id: 'screentime_${date.millisecondsSinceEpoch}',
        deviceId: 'device_${DateTime.now().millisecondsSinceEpoch}',
        userId: childId,
        date: date,
        totalTime: Duration(minutes: 180 + (i * 30)), // Varying screen time
        limit: const Duration(hours: 6),
        appUsage: {
          'Instagram': Duration(minutes: 45 + (i * 5)),
          'TikTok': Duration(minutes: 60 + (i * 10)),
          'YouTube': Duration(minutes: 30 + (i * 3)),
          'Games': Duration(minutes: 25 + (i * 2)),
          'Education': Duration(minutes: 20 + (i * 1)),
        },
        categoryUsage: {
          'Social': Duration(minutes: 105 + (i * 15)),
          'Entertainment': Duration(minutes: 30 + (i * 3)),
          'Games': Duration(minutes: 25 + (i * 2)),
          'Education': Duration(minutes: 20 + (i * 1)),
        },
        unlockCount: 50 + (i * 5),
        notificationCount: 30 + (i * 3),
        lastActivity: date.copyWith(hour: 17, minute: 0),
        isLimitExceeded: i > 3,
      );
      
      await _firestore
          .collection('screenTime')
          .doc(screenTime.id)
          .set(screenTime.toJson());
    }
  }
  
  Future<void> _generateSampleLocationData(String childId) async {
    final locations = [
      LocationModel(
        id: 'loc_1',
        deviceId: 'device_${DateTime.now().millisecondsSinceEpoch}',
        userId: childId,
        latitude: 37.7749,
        longitude: -122.4194,
        address: 'Home - San Francisco, CA',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        accuracy: 10.0,
        isSafeZone: true,
      ),
      LocationModel(
        id: 'loc_2',
        deviceId: 'device_${DateTime.now().millisecondsSinceEpoch}',
        userId: childId,
        latitude: 37.7849,
        longitude: -122.4094,
        address: 'School - San Francisco, CA',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        accuracy: 15.0,
        isSafeZone: true,
      ),
    ];
    
    for (final location in locations) {
      await _firestore
          .collection('location')
          .doc(location.id)
          .set(location.toJson());
    }
  }
  
  Future<void> _generateRealTimeData(String childId) async {
    final realTimeData = {
      'batteryLevel': 78,
      'dataUsage': 2.3 * 1024 * 1024 * 1024, // 2.3 GB in bytes
      'currentApp': 'Instagram',
      'isCharging': false,
      'wifiConnected': true,
      'lastActivity': DateTime.now().toIso8601String(),
      'deviceStatus': 'active',
    };
    
    await _firestore
        .collection('monitoring')
        .doc(childId)
        .set({
      'lastUpdated': FieldValue.serverTimestamp(),
      ...realTimeData,
    });
  }
  
  // Clear all sample data
  Future<void> clearSampleData(String parentId) async {
    try {
      // Delete devices
      final devicesSnapshot = await _firestore
          .collection('devices')
          .where('parentId', isEqualTo: parentId)
          .get();
      
      for (final doc in devicesSnapshot.docs) {
        await doc.reference.delete();
      }
      
      // Delete alerts
      final alertsSnapshot = await _firestore
          .collection('alerts')
          .where('parentId', isEqualTo: parentId)
          .get();
      
      for (final doc in alertsSnapshot.docs) {
        await doc.reference.delete();
      }
      
      // Delete screen time data
      final screenTimeSnapshot = await _firestore
          .collection('screenTime')
          .get();
      
      for (final doc in screenTimeSnapshot.docs) {
        await doc.reference.delete();
      }
      
      // Delete location data
      final locationSnapshot = await _firestore
          .collection('location')
          .get();
      
      for (final doc in locationSnapshot.docs) {
        await doc.reference.delete();
      }
      
      // Delete monitoring data
      final monitoringSnapshot = await _firestore
          .collection('monitoring')
          .get();
      
      for (final doc in monitoringSnapshot.docs) {
        await doc.reference.delete();
      }
      
      print('Sample data cleared successfully!');
    } catch (e) {
      print('Failed to clear sample data: $e');
    }
  }
}
