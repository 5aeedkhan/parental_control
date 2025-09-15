import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';
import '../models/device_model.dart';
import '../models/alert_model.dart';
import '../models/screen_time_model.dart';
import '../models/app_model.dart';
import '../models/location_model.dart';
import '../adapters/duration_adapter.dart';
import '../adapters/user_type_adapter.dart';

class StorageService {
  static StorageService? _instance;
  static StorageService get instance => _instance ??= StorageService._();
  
  StorageService._();
  
  late Box<UserModel> _userBox;
  late Box<DeviceModel> _deviceBox;
  late Box<AlertModel> _alertBox;
  late Box<ScreenTimeModel> _screenTimeBox;
  late Box<AppModel> _appBox;
  late Box<LocationModel> _locationBox;
  late Box<SafeZoneModel> _safeZoneBox;
  
  SharedPreferences? _prefs;
  
  Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(DurationAdapter());
    Hive.registerAdapter(UserTypeAdapter());
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(DeviceModelAdapter());
    Hive.registerAdapter(AlertModelAdapter());
    Hive.registerAdapter(AlertTypeAdapter());
    Hive.registerAdapter(AlertSeverityAdapter());
    Hive.registerAdapter(ScreenTimeModelAdapter());
    Hive.registerAdapter(AppModelAdapter());
    Hive.registerAdapter(AppCategoryAdapter());
    Hive.registerAdapter(AppStatusAdapter());
    Hive.registerAdapter(LocationModelAdapter());
    Hive.registerAdapter(SafeZoneModelAdapter());
    
    // Open boxes
    _userBox = await Hive.openBox<UserModel>('users');
    _deviceBox = await Hive.openBox<DeviceModel>('devices');
    _alertBox = await Hive.openBox<AlertModel>('alerts');
    _screenTimeBox = await Hive.openBox<ScreenTimeModel>('screen_time');
    _appBox = await Hive.openBox<AppModel>('apps');
    _locationBox = await Hive.openBox<LocationModel>('locations');
    _safeZoneBox = await Hive.openBox<SafeZoneModel>('safe_zones');
    
    _prefs = await SharedPreferences.getInstance();
  }
  
  // User Management
  Future<void> saveUser(UserModel user) async {
    await _userBox.put(user.id, user);
    await _prefs?.setString('current_user_id', user.id);
  }
  
  UserModel? getCurrentUser() {
    final userId = _prefs?.getString('current_user_id');
    if (userId != null) {
      return _userBox.get(userId);
    }
    return null;
  }
  
  Future<void> removeUser(String userId) async {
    await _userBox.delete(userId);
    await _prefs?.remove('current_user_id');
  }
  
  // Device Management
  Future<void> saveDevice(DeviceModel device) async {
    await _deviceBox.put(device.id, device);
  }
  
  DeviceModel? getDevice(String deviceId) {
    return _deviceBox.get(deviceId);
  }
  
  List<DeviceModel> getAllDevices() {
    return _deviceBox.values.toList();
  }
  
  Future<void> removeDevice(String deviceId) async {
    await _deviceBox.delete(deviceId);
  }
  
  // Alert Management
  Future<void> saveAlert(AlertModel alert) async {
    await _alertBox.put(alert.id, alert);
  }
  
  AlertModel? getAlert(String alertId) {
    return _alertBox.get(alertId);
  }
  
  List<AlertModel> getAllAlerts() {
    return _alertBox.values.toList();
  }
  
  List<AlertModel> getUnreadAlerts() {
    return _alertBox.values.where((alert) => !alert.isRead).toList();
  }
  
  Future<void> markAlertAsRead(String alertId) async {
    final alert = _alertBox.get(alertId);
    if (alert != null) {
      await _alertBox.put(alertId, alert.copyWith(isRead: true));
    }
  }
  
  Future<void> removeAlert(String alertId) async {
    await _alertBox.delete(alertId);
  }
  
  // Screen Time Management
  Future<void> saveScreenTime(ScreenTimeModel screenTime) async {
    await _screenTimeBox.put(screenTime.id, screenTime);
  }
  
  ScreenTimeModel? getScreenTime(String screenTimeId) {
    return _screenTimeBox.get(screenTimeId);
  }
  
  List<ScreenTimeModel> getScreenTimeByDevice(String deviceId) {
    return _screenTimeBox.values
        .where((st) => st.deviceId == deviceId)
        .toList();
  }
  
  ScreenTimeModel? getTodayScreenTime(String deviceId) {
    final today = DateTime.now();
    final todayKey = '${deviceId}_${today.year}_${today.month}_${today.day}';
    return _screenTimeBox.get(todayKey);
  }
  
  // App Management
  Future<void> saveApp(AppModel app) async {
    await _appBox.put(app.id, app);
  }
  
  AppModel? getApp(String appId) {
    return _appBox.get(appId);
  }
  
  List<AppModel> getAllApps() {
    return _appBox.values.toList();
  }
  
  List<AppModel> getAppsByDevice(String deviceId) {
    return _appBox.values
        .where((app) => app.metadata['deviceId'] == deviceId)
        .toList();
  }
  
  Future<void> removeApp(String appId) async {
    await _appBox.delete(appId);
  }
  
  // Location Management
  Future<void> saveLocation(LocationModel location) async {
    await _locationBox.put(location.id, location);
  }
  
  LocationModel? getLocation(String locationId) {
    return _locationBox.get(locationId);
  }
  
  List<LocationModel> getLocationsByDevice(String deviceId) {
    return _locationBox.values
        .where((location) => location.deviceId == deviceId)
        .toList();
  }
  
  LocationModel? getLatestLocation(String deviceId) {
    final locations = getLocationsByDevice(deviceId);
    if (locations.isEmpty) return null;
    
    locations.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return locations.first;
  }
  
  // Safe Zone Management
  Future<void> saveSafeZone(SafeZoneModel safeZone) async {
    await _safeZoneBox.put(safeZone.id, safeZone);
  }
  
  SafeZoneModel? getSafeZone(String safeZoneId) {
    return _safeZoneBox.get(safeZoneId);
  }
  
  List<SafeZoneModel> getAllSafeZones() {
    return _safeZoneBox.values.toList();
  }
  
  Future<void> removeSafeZone(String safeZoneId) async {
    await _safeZoneBox.delete(safeZoneId);
  }
  
  // Settings Management
  Future<void> saveSetting(String key, dynamic value) async {
    if (value is String) {
      await _prefs?.setString(key, value);
    } else if (value is int) {
      await _prefs?.setInt(key, value);
    } else if (value is double) {
      await _prefs?.setDouble(key, value);
    } else if (value is bool) {
      await _prefs?.setBool(key, value);
    } else if (value is List<String>) {
      await _prefs?.setStringList(key, value);
    }
  }
  
  T? getSetting<T>(String key) {
    return _prefs?.get(key) as T?;
  }
  
  Future<void> removeSetting(String key) async {
    await _prefs?.remove(key);
  }
  
  // Clear all data
  Future<void> clearAllData() async {
    await _userBox.clear();
    await _deviceBox.clear();
    await _alertBox.clear();
    await _screenTimeBox.clear();
    await _appBox.clear();
    await _locationBox.clear();
    await _safeZoneBox.clear();
    await _prefs?.clear();
  }
  
  // Close all boxes
  Future<void> close() async {
    await _userBox.close();
    await _deviceBox.close();
    await _alertBox.close();
    await _screenTimeBox.close();
    await _appBox.close();
    await _locationBox.close();
    await _safeZoneBox.close();
  }
}
