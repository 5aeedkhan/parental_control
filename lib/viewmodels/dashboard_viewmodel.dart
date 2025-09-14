import 'package:flutter/foundation.dart';
import '../models/device_model.dart';
import '../models/alert_model.dart';
import '../models/screen_time_model.dart';
import '../models/location_model.dart';
import '../services/storage_service.dart';
import '../services/api_service.dart';

class DashboardViewModel extends ChangeNotifier {
  final StorageService _storageService = StorageService.instance;
  final ApiService _apiService = ApiService.instance;
  
  List<DeviceModel> _devices = [];
  List<AlertModel> _alerts = [];
  List<ScreenTimeModel> _screenTimeData = [];
  LocationModel? _currentLocation;
  bool _isLoading = false;
  String? _error;
  
  // Getters
  List<DeviceModel> get devices => _devices;
  List<AlertModel> get alerts => _alerts;
  List<ScreenTimeModel> get screenTimeData => _screenTimeData;
  LocationModel? get currentLocation => _currentLocation;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Get unread alerts count
  int get unreadAlertsCount => _alerts.where((alert) => !alert.isRead).length;
  
  // Get critical alerts count
  int get criticalAlertsCount => _alerts.where((alert) => alert.severity == AlertSeverity.critical).length;
  
  // Get online devices count
  int get onlineDevicesCount => _devices.where((device) => device.isOnline).length;
  
  // Get total screen time today
  Duration get totalScreenTimeToday {
    final today = DateTime.now();
    final todayData = _screenTimeData.where((data) => 
      data.date.year == today.year &&
      data.date.month == today.month &&
      data.date.day == today.day
    ).toList();
    
    return todayData.fold(Duration.zero, (total, data) => total + data.totalTime);
  }
  
  // Get average screen time this week
  Duration get averageScreenTimeThisWeek {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekData = _screenTimeData.where((data) => 
      data.date.isAfter(weekStart) && data.date.isBefore(now.add(const Duration(days: 1)))
    ).toList();
    
    if (weekData.isEmpty) return Duration.zero;
    
    final totalTime = weekData.fold(Duration.zero, (total, data) => total + data.totalTime);
    return Duration(seconds: totalTime.inSeconds ~/ weekData.length);
  }
  
  // Initialize dashboard data
  Future<void> init() async {
    _setLoading(true);
    _clearError();
    
    try {
      await Future.wait([
        _loadDevices(),
        _loadAlerts(),
        _loadScreenTimeData(),
        _loadCurrentLocation(),
      ]);
    } catch (e) {
      _setError('Failed to load dashboard data: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
  
  // Load devices
  Future<void> _loadDevices() async {
    try {
      _devices = _storageService.getAllDevices();
      if (_devices.isEmpty) {
        // Try to load from API
        _devices = await _apiService.getDevices();
        // Save to local storage
        for (final device in _devices) {
          await _storageService.saveDevice(device);
        }
      }
      notifyListeners();
    } catch (e) {
      _setError('Failed to load devices: ${e.toString()}');
    }
  }
  
  // Load alerts
  Future<void> _loadAlerts() async {
    try {
      _alerts = _storageService.getAllAlerts();
      if (_alerts.isEmpty) {
        // Try to load from API
        _alerts = await _apiService.getAlerts();
        // Save to local storage
        for (final alert in _alerts) {
          await _storageService.saveAlert(alert);
        }
      }
      notifyListeners();
    } catch (e) {
      _setError('Failed to load alerts: ${e.toString()}');
    }
  }
  
  // Load screen time data
  Future<void> _loadScreenTimeData() async {
    try {
      if (_devices.isNotEmpty) {
        final deviceId = _devices.first.id;
        final now = DateTime.now();
        final weekStart = now.subtract(const Duration(days: 7));
        
        _screenTimeData = await _apiService.getScreenTimeData(
          deviceId,
          startDate: weekStart,
          endDate: now,
        );
        
        // Save to local storage
        for (final data in _screenTimeData) {
          await _storageService.saveScreenTime(data);
        }
      }
      notifyListeners();
    } catch (e) {
      _setError('Failed to load screen time data: ${e.toString()}');
    }
  }
  
  // Load current location
  Future<void> _loadCurrentLocation() async {
    try {
      if (_devices.isNotEmpty) {
        final deviceId = _devices.first.id;
        _currentLocation = _storageService.getLatestLocation(deviceId);
      }
      notifyListeners();
    } catch (e) {
      _setError('Failed to load current location: ${e.toString()}');
    }
  }
  
  // Refresh all data
  Future<void> refresh() async {
    await init();
  }
  
  // Mark alert as read
  Future<void> markAlertAsRead(String alertId) async {
    try {
      await _apiService.markAlertAsRead(alertId);
      await _storageService.markAlertAsRead(alertId);
      
      // Update local alerts
      final index = _alerts.indexWhere((alert) => alert.id == alertId);
      if (index != -1) {
        _alerts[index] = _alerts[index].copyWith(isRead: true);
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to mark alert as read: ${e.toString()}');
    }
  }
  
  // Resolve alert
  Future<void> resolveAlert(String alertId, String actionTaken) async {
    try {
      await _apiService.resolveAlert(alertId, actionTaken);
      
      // Update local alerts
      final index = _alerts.indexWhere((alert) => alert.id == alertId);
      if (index != -1) {
        _alerts[index] = _alerts[index].copyWith(
          isResolved: true,
          actionTaken: actionTaken,
        );
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to resolve alert: ${e.toString()}');
    }
  }
  
  // Get device by ID
  DeviceModel? getDeviceById(String deviceId) {
    try {
      return _devices.firstWhere((device) => device.id == deviceId);
    } catch (e) {
      return null;
    }
  }
  
  // Get alerts by device
  List<AlertModel> getAlertsByDevice(String deviceId) {
    return _alerts.where((alert) => alert.deviceId == deviceId).toList();
  }
  
  // Get screen time data by device
  List<ScreenTimeModel> getScreenTimeDataByDevice(String deviceId) {
    return _screenTimeData.where((data) => data.deviceId == deviceId).toList();
  }
  
  // Get today's screen time for device
  ScreenTimeModel? getTodayScreenTime(String deviceId) {
    final today = DateTime.now();
    return _screenTimeData.firstWhere(
      (data) => 
        data.deviceId == deviceId &&
        data.date.year == today.year &&
        data.date.month == today.month &&
        data.date.day == today.day,
      orElse: () => ScreenTimeModel(
        id: '',
        deviceId: deviceId,
        userId: '',
        date: today,
        totalTime: Duration.zero,
        limit: const Duration(hours: 6),
      ),
    );
  }
  
  // Get weekly screen time data for charts
  List<Map<String, dynamic>> getWeeklyScreenTimeData(String deviceId) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekData = <Map<String, dynamic>>[];
    
    for (int i = 0; i < 7; i++) {
      final date = weekStart.add(Duration(days: i));
      final dayData = _screenTimeData.firstWhere(
        (data) => 
          data.deviceId == deviceId &&
          data.date.year == date.year &&
          data.date.month == date.month &&
          data.date.day == date.day,
        orElse: () => ScreenTimeModel(
          id: '',
          deviceId: deviceId,
          userId: '',
          date: date,
          totalTime: Duration.zero,
          limit: const Duration(hours: 6),
        ),
      );
      
      weekData.add({
        'day': _getDayName(date.weekday),
        'hours': dayData.totalTime.inMinutes / 60.0,
        'limit': dayData.limit.inMinutes / 60.0,
      });
    }
    
    return weekData;
  }
  
  // Get app usage data for charts
  List<Map<String, dynamic>> getAppUsageData(String deviceId) {
    final today = DateTime.now();
    final todayData = _screenTimeData.firstWhere(
      (data) => 
        data.deviceId == deviceId &&
        data.date.year == today.year &&
        data.date.month == today.month &&
        data.date.day == today.day,
      orElse: () => ScreenTimeModel(
        id: '',
        deviceId: deviceId,
        userId: '',
        date: today,
        totalTime: Duration.zero,
        limit: const Duration(hours: 6),
      ),
    );
    
    final appUsage = <String, Duration>{};
    for (final entry in todayData.appUsage.entries) {
      appUsage[entry.key] = entry.value;
    }
    
    // Convert to chart data
    final totalMinutes = appUsage.values.fold(0, (total, duration) => total + duration.inMinutes);
    if (totalMinutes == 0) return [];
    
    return appUsage.entries.map((entry) {
      final percentage = (entry.value.inMinutes / totalMinutes * 100).round();
      return {
        'name': entry.key,
        'value': percentage,
        'color': _getAppCategoryColor(entry.key),
      };
    }).toList();
  }
  
  // Helper methods
  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }
  
  int _getAppCategoryColor(String appName) {
    // Simple color assignment based on app name
    final colors = [0xFFFF6B6B, 0xFF4ECDC4, 0xFF45B7D1, 0xFF96CEB4, 0xFFFFEAA7];
    return colors[appName.hashCode % colors.length];
  }
  
  // Clear error
  void _clearError() {
    _error = null;
    notifyListeners();
  }
  
  // Set error
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }
  
  // Set loading
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
