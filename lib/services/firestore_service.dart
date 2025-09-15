import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/device_model.dart';
import '../models/screen_time_model.dart';
import '../models/app_model.dart';
import '../models/location_model.dart';
import '../models/alert_model.dart';

class FirestoreService {
  static FirestoreService? _instance;
  static FirestoreService get instance => _instance ??= FirestoreService._();
  
  FirestoreService._();
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Collections
  static const String _usersCollection = 'users';
  static const String _devicesCollection = 'devices';
  static const String _screenTimeCollection = 'screenTime';
  static const String _appUsageCollection = 'appUsage';
  static const String _locationCollection = 'location';
  static const String _alertsCollection = 'alerts';
  static const String _monitoringCollection = 'monitoring';
  
  // User Management
  Future<void> createUser(UserModel user) async {
    try {
      await _firestore
          .collection(_usersCollection)
          .doc(user.id)
          .set(user.toJson());
    } catch (e) {
      print('Failed to create user: $e');
      rethrow;
    }
  }
  
  Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .get();
      
      if (!doc.exists) return null;
      
      return UserModel.fromJson(doc.data()!);
    } catch (e) {
      print('Failed to get user: $e');
      return null;
    }
  }
  
  Future<List<UserModel>> getChildrenForParent(String parentId) async {
    try {
      final query = await _firestore
          .collection(_usersCollection)
          .where('parentId', isEqualTo: parentId)
          .where('userType', isEqualTo: 'child')
          .get();
      
      return query.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Failed to get children: $e');
      return [];
    }
  }
  
  // Device Management
  Future<void> addDevice(DeviceModel device) async {
    try {
      await _firestore
          .collection(_devicesCollection)
          .doc(device.id)
          .set(device.toJson());
    } catch (e) {
      print('Failed to add device: $e');
      rethrow;
    }
  }
  
  Future<List<DeviceModel>> getDevicesForUser(String userId) async {
    try {
      final query = await _firestore
          .collection(_devicesCollection)
          .where('userId', isEqualTo: userId)
          .get();
      
      return query.docs
          .map((doc) => DeviceModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Failed to get devices: $e');
      return [];
    }
  }
  
  // Screen Time Monitoring
  Future<void> recordScreenTime(String childId, ScreenTimeModel screenTime) async {
    try {
      await _firestore
          .collection(_monitoringCollection)
          .doc(childId)
          .collection(_screenTimeCollection)
          .doc(screenTime.id)
          .set(screenTime.toJson());
    } catch (e) {
      print('Failed to record screen time: $e');
      rethrow;
    }
  }
  
  Stream<List<ScreenTimeModel>> getScreenTimeStream(String childId, {int days = 7}) {
    final startDate = DateTime.now().subtract(Duration(days: days));
    
    return _firestore
        .collection(_monitoringCollection)
        .doc(childId)
        .collection(_screenTimeCollection)
        .where('date', isGreaterThanOrEqualTo: startDate)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ScreenTimeModel.fromJson(doc.data()))
            .toList());
  }
  
  // App Usage Monitoring
  Future<void> recordAppUsage(String childId, AppModel app) async {
    try {
      await _firestore
          .collection(_monitoringCollection)
          .doc(childId)
          .collection(_appUsageCollection)
          .doc(app.id)
          .set(app.toJson());
    } catch (e) {
      print('Failed to record app usage: $e');
      rethrow;
    }
  }
  
  Stream<List<AppModel>> getAppUsageStream(String childId) {
    return _firestore
        .collection(_monitoringCollection)
        .doc(childId)
        .collection(_appUsageCollection)
        .orderBy('lastUsed', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AppModel.fromJson(doc.data()))
            .toList());
  }
  
  // Location Tracking
  Future<void> recordLocation(String childId, LocationModel location) async {
    try {
      await _firestore
          .collection(_monitoringCollection)
          .doc(childId)
          .collection(_locationCollection)
          .add(location.toJson());
    } catch (e) {
      print('Failed to record location: $e');
      rethrow;
    }
  }
  
  Stream<List<LocationModel>> getLocationStream(String childId, {int hours = 24}) {
    final startTime = DateTime.now().subtract(Duration(hours: hours));
    
    return _firestore
        .collection(_monitoringCollection)
        .doc(childId)
        .collection(_locationCollection)
        .where('timestamp', isGreaterThanOrEqualTo: startTime)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => LocationModel.fromJson(doc.data()))
            .toList());
  }
  
  // Alerts Management
  Future<void> createAlert(AlertModel alert) async {
    try {
      await _firestore
          .collection(_alertsCollection)
          .doc(alert.id)
          .set(alert.toJson());
    } catch (e) {
      print('Failed to create alert: $e');
      rethrow;
    }
  }
  
  Stream<List<AlertModel>> getAlertsForParent(String parentId) {
    return _firestore
        .collection(_alertsCollection)
        .where('parentId', isEqualTo: parentId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AlertModel.fromJson(doc.data()))
            .toList());
  }
  
  Stream<List<AlertModel>> getAlertsForChild(String childId) {
    return _firestore
        .collection(_alertsCollection)
        .where('childId', isEqualTo: childId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AlertModel.fromJson(doc.data()))
            .toList());
  }
  
  Future<void> markAlertAsRead(String alertId) async {
    try {
      await _firestore
          .collection(_alertsCollection)
          .doc(alertId)
          .update({'isRead': true});
    } catch (e) {
      print('Failed to mark alert as read: $e');
      rethrow;
    }
  }
  
  // Real-time Monitoring Data
  Future<void> updateRealTimeData(String childId, Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection(_monitoringCollection)
          .doc(childId)
          .set({
        'lastUpdated': FieldValue.serverTimestamp(),
        ...data,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Failed to update real-time data: $e');
      rethrow;
    }
  }
  
  Stream<Map<String, dynamic>?> getRealTimeDataStream(String childId) {
    return _firestore
        .collection(_monitoringCollection)
        .doc(childId)
        .snapshots()
        .map((snapshot) => snapshot.data());
  }
  
  // Batch Operations
  Future<void> batchUpdate(List<Map<String, dynamic>> operations) async {
    try {
      final batch = _firestore.batch();
      
      for (final operation in operations) {
        final docRef = _firestore
            .collection(operation['collection'])
            .doc(operation['docId']);
        
        switch (operation['type']) {
          case 'set':
            batch.set(docRef, operation['data']);
            break;
          case 'update':
            batch.update(docRef, operation['data']);
            break;
          case 'delete':
            batch.delete(docRef);
            break;
        }
      }
      
      await batch.commit();
    } catch (e) {
      print('Failed to execute batch operation: $e');
      rethrow;
    }
  }
}
