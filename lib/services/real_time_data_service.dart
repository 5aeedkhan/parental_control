import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/screen_time_model.dart';
import '../models/location_model.dart';
import '../models/alert_model.dart';
import 'firestore_service.dart';

class RealTimeDataService {
  static final RealTimeDataService _instance = RealTimeDataService._internal();
  factory RealTimeDataService() => _instance;
  RealTimeDataService._internal();

  final FirestoreService _firestoreService = FirestoreService.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Timer? _screenTimeTimer;
  Timer? _locationTimer;
  Timer? _dataSyncTimer;
  
  String? _currentUserId;
  String? _currentDeviceId;
  
  // Real-time data collection settings
  static const Duration _screenTimeInterval = Duration(minutes: 5);
  static const Duration _locationInterval = Duration(minutes: 2);
  static const Duration _dataSyncInterval = Duration(minutes: 1);
  
  // Current session data
  DateTime _sessionStartTime = DateTime.now();
  Map<String, Duration> _currentAppUsage = {};
  String? _currentApp;
  
  /// Initialize real-time data collection for a user/device
  Future<void> startRealTimeCollection({
    required String userId,
    required String deviceId,
  }) async {
    _currentUserId = userId;
    _currentDeviceId = deviceId;
    _sessionStartTime = DateTime.now();
    
    print('Starting real-time data collection for user: $userId, device: $deviceId');
    
    // Start periodic data collection
    _startScreenTimeCollection();
    _startLocationCollection();
    _startDataSync();
    
    // Record session start
    await _recordSessionStart();
  }
  
  /// Stop real-time data collection
  Future<void> stopRealTimeCollection() async {
    print('Stopping real-time data collection');
    
    // Save final session data
    if (_currentUserId != null && _currentDeviceId != null) {
      await _recordSessionEnd();
    }
    
    // Cancel all timers
    _screenTimeTimer?.cancel();
    _locationTimer?.cancel();
    _dataSyncTimer?.cancel();
    
    // Clear data
    _currentUserId = null;
    _currentDeviceId = null;
    _currentAppUsage.clear();
    _currentApp = null;
  }
  
  /// Start screen time data collection
  void _startScreenTimeCollection() {
    _screenTimeTimer = Timer.periodic(_screenTimeInterval, (timer) async {
      if (_currentUserId != null && _currentDeviceId != null) {
        await _collectScreenTimeData();
      }
    });
  }
  
  /// Start location data collection
  void _startLocationCollection() {
    _locationTimer = Timer.periodic(_locationInterval, (timer) async {
      if (_currentUserId != null && _currentDeviceId != null) {
        await _collectLocationData();
      }
    });
  }
  
  /// Start data synchronization
  void _startDataSync() {
    _dataSyncTimer = Timer.periodic(_dataSyncInterval, (timer) async {
      if (_currentUserId != null && _currentDeviceId != null) {
        await _syncRealTimeData();
      }
    });
  }
  
  /// Collect current screen time data
  Future<void> _collectScreenTimeData() async {
    try {
      // Only collect screen time data if we have valid device and user info
      if (_currentUserId == null || _currentDeviceId == null) {
        print('Skipping screen time data collection - no valid device/user');
        return;
      }
      
      // In a real implementation, this would use actual app usage tracking
      // For now, we'll skip fake data generation to avoid confusion
      print('Screen time data collection would happen here in a real implementation');
      
      // TODO: Implement actual screen time tracking
      // final now = DateTime.now();
      // final sessionDuration = now.difference(_sessionStartTime);
      // 
      // final screenTimeData = ScreenTimeModel(
      //   id: '${_currentUserId}_${now.millisecondsSinceEpoch}',
      //   deviceId: _currentDeviceId!,
      //   userId: _currentUserId!,
      //   date: DateTime(now.year, now.month, now.day),
      //   totalTime: actualScreenTime,
      //   limit: const Duration(hours: 6),
      //   appUsage: actualAppUsage,
      // );
      
    } catch (e) {
      print('Failed to collect screen time data: $e');
    }
  }
  
  /// Collect current location data
  Future<void> _collectLocationData() async {
    try {
      // Only collect location data if we have valid device and user info
      if (_currentUserId == null || _currentDeviceId == null) {
        print('Skipping location data collection - no valid device/user');
        return;
      }
      
      // In a real implementation, this would use GPS
      // For now, we'll skip fake data generation to avoid confusion
      print('Location data collection would happen here in a real implementation');
      
      // TODO: Implement actual GPS location collection
      // final now = DateTime.now();
      // final locationData = LocationModel(
      //   id: '${_currentUserId}_${now.millisecondsSinceEpoch}',
      //   deviceId: _currentDeviceId!,
      //   userId: _currentUserId!,
      //   latitude: actualGPSLatitude,
      //   longitude: actualGPSLongitude,
      //   address: reverseGeocodedAddress,
      //   timestamp: now,
      //   accuracy: actualAccuracy,
      // );
      
    } catch (e) {
      print('Failed to collect location data: $e');
    }
  }
  
  /// Sync real-time data to Firestore
  Future<void> _syncRealTimeData() async {
    try {
      if (_currentUserId == null || _currentDeviceId == null) return;
      
      // Create real-time data document
      final realTimeData = {
        'userId': _currentUserId,
        'deviceId': _currentDeviceId,
        'lastSeen': DateTime.now().toIso8601String(),
        'sessionDuration': DateTime.now().difference(_sessionStartTime).inSeconds,
        'currentApp': _currentApp ?? 'unknown',
        'appUsage': _currentAppUsage.map((key, value) => MapEntry(key, value.inSeconds)),
        'isOnline': true,
        'batteryLevel': await _getBatteryLevel(),
        'dataUsage': await _getDataUsage(),
      };
      
      // Update real-time data document
      await _firestore
          .collection('realTimeData')
          .doc(_currentUserId)
          .set(realTimeData, SetOptions(merge: true));
      
    } catch (e) {
      print('Failed to sync real-time data: $e');
    }
  }
  
  /// Record app usage
  Future<void> recordAppUsage(String appName) async {
    if (_currentApp == appName) return;
    
    final now = DateTime.now();
    
    // Record previous app usage
    if (_currentApp != null && _sessionStartTime != null) {
      final usageDuration = now.difference(_sessionStartTime);
      _currentAppUsage[_currentApp!] = 
          (_currentAppUsage[_currentApp!] ?? Duration.zero) + usageDuration;
    }
    
    // Update current app
    _currentApp = appName;
    _sessionStartTime = now;
    
    print('App usage recorded: $appName');
  }
  
  /// Record session start
  Future<void> _recordSessionStart() async {
    try {
      final sessionData = {
        'userId': _currentUserId,
        'deviceId': _currentDeviceId,
        'sessionStart': DateTime.now().toIso8601String(),
        'isActive': true,
      };
      
      await _firestore
          .collection('sessions')
          .doc('${_currentUserId}_${_currentDeviceId}')
          .set(sessionData, SetOptions(merge: true));
          
    } catch (e) {
      print('Failed to record session start: $e');
    }
  }
  
  /// Record session end
  Future<void> _recordSessionEnd() async {
    try {
      final sessionData = {
        'userId': _currentUserId,
        'deviceId': _currentDeviceId,
        'sessionEnd': DateTime.now().toIso8601String(),
        'isActive': false,
        'totalDuration': DateTime.now().difference(_sessionStartTime).inSeconds,
      };
      
      await _firestore
          .collection('sessions')
          .doc('${_currentUserId}_${_currentDeviceId}')
          .update(sessionData);
          
    } catch (e) {
      print('Failed to record session end: $e');
    }
  }
  
  /// Create alert for suspicious activity
  Future<void> createAlert({
    required String parentId,
    required AlertType type,
    required AlertSeverity severity,
    required String title,
    required String description,
    String? deviceId,
  }) async {
    try {
      final alert = AlertModel(
        id: 'alert_${DateTime.now().millisecondsSinceEpoch}',
        type: type,
        severity: severity,
        title: title,
        description: description,
        deviceId: deviceId ?? _currentDeviceId,
        userId: _currentUserId,
        timestamp: DateTime.now(),
        isRead: false,
        isResolved: false,
        metadata: {
          'createdBy': 'system',
          'autoGenerated': true,
        },
      );
      
      await _firestore
          .collection('alerts')
          .doc(alert.id)
          .set(alert.toJson());
      
      print('Alert created: $title');
    } catch (e) {
      print('Failed to create alert: $e');
    }
  }
  
  /// Get battery level (simulated)
  Future<int> _getBatteryLevel() async {
    // In a real implementation, this would use device APIs
    return 75 + (DateTime.now().millisecond % 25);
  }
  
  /// Get data usage (simulated)
  Future<double> _getDataUsage() async {
    // In a real implementation, this would use network APIs
    return (DateTime.now().millisecond % 1000) / 100.0;
  }
  
  /// Check for screen time limits and create alerts
  Future<void> checkScreenTimeLimits() async {
    try {
      if (_currentUserId == null) return;
      
      // Get today's screen time
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      
      final query = await _firestore
          .collection('screenTime')
          .where('userId', isEqualTo: _currentUserId)
          .where('date', isGreaterThanOrEqualTo: startOfDay)
          .get();
      
      final totalMinutes = query.docs.fold<int>(0, (total, doc) {
        final data = doc.data();
        final duration = Duration(seconds: data['totalTime'] ?? 0);
        return total + duration.inMinutes;
      });
      
      // Check limits and create alerts
      if (totalMinutes > 360) { // 6 hours
        await createAlert(
          parentId: '', // This would be retrieved from user data
          type: AlertType.screenTimeExceeded,
          severity: AlertSeverity.high,
          title: 'Screen Time Limit Exceeded',
          description: 'Child has exceeded 6 hours of screen time today.',
        );
      } else if (totalMinutes > 240) { // 4 hours
        await createAlert(
          parentId: '', // This would be retrieved from user data
          type: AlertType.screenTimeExceeded,
          severity: AlertSeverity.medium,
          title: 'Screen Time Warning',
          description: 'Child has used ${(totalMinutes / 60).toStringAsFixed(1)} hours of screen time today.',
        );
      }
    } catch (e) {
      print('Failed to check screen time limits: $e');
    }
  }
  
  /// Dispose resources
  void dispose() {
    stopRealTimeCollection();
  }
}
