import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/device_model.dart';
import '../models/alert_model.dart';
import '../models/screen_time_model.dart';
import '../models/location_model.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';
import '../services/api_service.dart';
import '../services/firestore_service.dart';
import '../services/firebase_auth_service.dart';
import '../services/real_time_data_service.dart';

class DashboardViewModel extends ChangeNotifier {
  final StorageService _storageService = StorageService.instance;
  final ApiService _apiService = ApiService.instance;
  final FirestoreService _firestoreService = FirestoreService.instance;
  final FirebaseAuthService _firebaseAuth = FirebaseAuthService.instance;
  final RealTimeDataService _realTimeDataService = RealTimeDataService();
  
  List<DeviceModel> _devices = [];
  List<AlertModel> _alerts = [];
  List<ScreenTimeModel> _screenTimeData = [];
  LocationModel? _currentLocation;
  List<UserModel> _children = [];
  Map<String, dynamic> _realTimeData = {};
  bool _isLoading = false;
  String? _error;
  
  // Stream subscriptions for real-time updates
  StreamSubscription<QuerySnapshot>? _devicesSubscription;
  StreamSubscription<QuerySnapshot>? _alertsSubscription;
  StreamSubscription<QuerySnapshot>? _screenTimeSubscription;
  StreamSubscription<DocumentSnapshot>? _locationSubscription;
  StreamSubscription<Map<String, dynamic>?>? _realTimeSubscription;
  
  // Getters
  List<DeviceModel> get devices => _devices;
  List<AlertModel> get alerts => _alerts;
  List<ScreenTimeModel> get screenTimeData => _screenTimeData;
  LocationModel? get currentLocation => _currentLocation;
  List<UserModel> get children => _children;
  Map<String, dynamic> get realTimeData => _realTimeData;
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
  
  // Initialize dashboard data with real-time Firebase streams
  Future<void> init() async {
    _setLoading(true);
    _clearError();
    
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        _setError('No authenticated user found');
        return;
      }
      
      // Load children first
      await _loadChildren(currentUser.uid);
      
      // Set up real-time streams
      await _setupRealTimeStreams(currentUser.uid);
      
      // Start real-time data collection for child devices
      await _startRealTimeDataCollection();
      
      // Load initial data
      await Future.wait([
        _loadDevicesFromFirestore(),
        _loadAlertsFromFirestore(),
        _loadScreenTimeDataFromFirestore(),
        _loadCurrentLocationFromFirestore(),
      ]);
      
    } catch (e) {
      _setError('Failed to load dashboard data: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
  
  // Load children for the current parent
  Future<void> _loadChildren(String parentId) async {
    try {
      _children = await _firestoreService.getChildrenForParent(parentId);
      notifyListeners();
    } catch (e) {
      print('Failed to load children: $e');
    }
  }
  
  // Start real-time data collection for child devices
  Future<void> _startRealTimeDataCollection() async {
    try {
      // Only start real-time collection if we have children AND devices
      if (_children.isNotEmpty && _devices.isNotEmpty) {
        final child = _children.first;
        final device = _devices.firstWhere(
          (d) => d.ownerId == child.id,
          orElse: () => DeviceModel(
            id: '',
            name: 'Unknown',
            platform: 'unknown',
            model: 'Unknown',
            osVersion: 'Unknown',
            ownerId: null,
            isOnline: false,
            lastSeen: null,
            batteryLevel: 0,
            isCharging: false,
            dataUsage: 0.0,
            settings: {},
            createdAt: DateTime.now(),
          ),
        );
        
        if (device.id.isNotEmpty && device.isOnline) {
          await _realTimeDataService.startRealTimeCollection(
            userId: child.id,
            deviceId: device.id,
          );
          print('Real-time data collection started for child: ${child.name}');
        } else {
          print('No online devices found - skipping real-time data collection');
          await _realTimeDataService.stopRealTimeCollection();
        }
      } else {
        print('No children or devices found - stopping real-time data collection');
        await _realTimeDataService.stopRealTimeCollection();
      }
    } catch (e) {
      print('Failed to start real-time data collection: $e');
      await _realTimeDataService.stopRealTimeCollection();
    }
  }
  
  // Set up real-time data streams
  Future<void> _setupRealTimeStreams(String parentId) async {
    try {
      // Cancel existing subscriptions
      await _cancelSubscriptions();
      
      // Set up devices stream
      _devicesSubscription = FirebaseFirestore.instance
          .collection('devices')
          .where('parentId', isEqualTo: parentId)
          .snapshots()
          .listen((snapshot) {
        _devices = snapshot.docs
            .map((doc) => DeviceModel.fromJson(doc.data()))
            .toList();
        notifyListeners();
      });
      
      // Set up alerts stream with error handling
      _alertsSubscription = FirebaseFirestore.instance
          .collection('alerts')
          .where('parentId', isEqualTo: parentId)
          .orderBy('timestamp', descending: true)
          .limit(20) // Reduce limit for better performance
          .snapshots()
          .listen(
        (snapshot) {
        _alerts = snapshot.docs
            .map((doc) => AlertModel.fromJson(doc.data()))
            .toList();
        notifyListeners();
        },
        onError: (error) {
          print('Alerts stream error: $error');
          // Try fallback stream without ordering
          _setupAlertsFallbackStream(parentId);
        },
      );
      
      // Set up screen time stream for the first child only (to avoid multiple streams)
      if (_children.isNotEmpty) {
        final child = _children.first;
        _screenTimeSubscription = FirebaseFirestore.instance
            .collection('screenTime')
            .where('userId', isEqualTo: child.id)
            .orderBy('date', descending: true)
            .limit(7)
            .snapshots()
            .listen(
          (snapshot) {
          final newData = snapshot.docs
              .map((doc) => ScreenTimeModel.fromJson(doc.data()))
              .toList();
          
          // Merge with existing data
          _screenTimeData.removeWhere((data) => data.userId == child.id);
          _screenTimeData.addAll(newData);
          notifyListeners();
          },
          onError: (error) {
            print('Screen time stream error: $error');
            // Try fallback stream without ordering
            _setupScreenTimeFallbackStream(child.id);
          },
        );
      }
      
      // Set up real-time monitoring data stream
      if (_children.isNotEmpty) {
        final childId = _children.first.id;
        _realTimeSubscription = _firestoreService
            .getRealTimeDataStream(childId)
            .listen((data) {
          if (data != null) {
            _realTimeData = data;
            notifyListeners();
          }
        });
      }
      
    } catch (e) {
      print('Failed to setup real-time streams: $e');
    }
  }
  
  // Fallback alerts stream without ordering
  void _setupAlertsFallbackStream(String parentId) {
    _alertsSubscription?.cancel();
    _alertsSubscription = FirebaseFirestore.instance
        .collection('alerts')
        .where('parentId', isEqualTo: parentId)
        .limit(20)
        .snapshots()
        .listen((snapshot) {
      _alerts = snapshot.docs
          .map((doc) => AlertModel.fromJson(doc.data()))
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
      notifyListeners();
    });
  }
  
  // Fallback screen time stream without ordering
  void _setupScreenTimeFallbackStream(String childId) {
    _screenTimeSubscription?.cancel();
    _screenTimeSubscription = FirebaseFirestore.instance
        .collection('screenTime')
        .where('userId', isEqualTo: childId)
        .limit(10)
        .snapshots()
        .listen((snapshot) {
      final newData = snapshot.docs
          .map((doc) => ScreenTimeModel.fromJson(doc.data()))
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      
      _screenTimeData.removeWhere((data) => data.userId == childId);
      _screenTimeData.addAll(newData.take(7)); // Take only 7 most recent
      notifyListeners();
    });
  }
  
  // Cancel all subscriptions
  Future<void> _cancelSubscriptions() async {
    await _devicesSubscription?.cancel();
    await _alertsSubscription?.cancel();
    await _screenTimeSubscription?.cancel();
    await _locationSubscription?.cancel();
    await _realTimeSubscription?.cancel();
  }
  
  // Load devices from Firestore
  Future<void> _loadDevicesFromFirestore() async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) return;
      
      final snapshot = await FirebaseFirestore.instance
          .collection('devices')
          .where('parentId', isEqualTo: currentUser.uid)
          .get();
      
      _devices = snapshot.docs
          .map((doc) => DeviceModel.fromJson(doc.data()))
          .toList();
      
      // Save to local storage for offline access
        for (final device in _devices) {
          await _storageService.saveDevice(device);
      }
      
      notifyListeners();
    } catch (e) {
      print('Failed to load devices from Firestore: $e');
    }
  }
  
  // Load alerts from Firestore
  Future<void> _loadAlertsFromFirestore() async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) return;
      
      try {
        // Try composite index query first
      final snapshot = await FirebaseFirestore.instance
          .collection('alerts')
          .where('parentId', isEqualTo: currentUser.uid)
            .orderBy('timestamp', descending: true)
          .limit(50)
          .get();
      
      _alerts = snapshot.docs
          .map((doc) => AlertModel.fromJson(doc.data()))
          .toList();
      } catch (e) {
        print('Composite query failed for alerts, trying fallback: $e');
        
        // Fallback: Simple query without ordering if index is not ready
        try {
          final fallbackSnapshot = await FirebaseFirestore.instance
              .collection('alerts')
              .where('parentId', isEqualTo: currentUser.uid)
              .limit(50)
              .get();
          
          // Sort in memory
          _alerts = fallbackSnapshot.docs
              .map((doc) => AlertModel.fromJson(doc.data()))
              .toList()
            ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
        } catch (fallbackError) {
          print('Fallback query also failed for alerts: $fallbackError');
          _alerts = [];
        }
      }
      
      // Save to local storage for offline access (non-blocking)
        for (final alert in _alerts) {
        _storageService.saveAlert(alert); // Don't await to avoid blocking
      }
      
      notifyListeners();
    } catch (e) {
      print('Failed to load alerts from Firestore: $e');
    }
  }
  
  // Load screen time data from Firestore
  Future<void> _loadScreenTimeDataFromFirestore() async {
    try {
      if (_children.isEmpty) return;
      
        final now = DateTime.now();
        final weekStart = now.subtract(const Duration(days: 7));
      
      // Load data for all children in parallel
      final futures = _children.map((child) async {
        try {
          // First try with composite index query
        final snapshot = await FirebaseFirestore.instance
            .collection('screenTime')
            .where('userId', isEqualTo: child.id)
            .where('date', isGreaterThanOrEqualTo: weekStart)
            .orderBy('date', descending: true)
              .limit(7) // Limit results for better performance
            .get();
        
          return snapshot.docs
            .map((doc) => ScreenTimeModel.fromJson(doc.data()))
            .toList();
        } catch (e) {
          print('Composite query failed for child ${child.id}, trying fallback: $e');
          
          // Fallback: Simple query without date filter if index is not ready
          try {
            final fallbackSnapshot = await FirebaseFirestore.instance
                .collection('screenTime')
                .where('userId', isEqualTo: child.id)
                .orderBy('date', descending: true)
                .limit(7)
                .get();
            
            // Filter in memory
            return fallbackSnapshot.docs
                .map((doc) => ScreenTimeModel.fromJson(doc.data()))
                .where((data) => data.date.isAfter(weekStart))
                .toList();
          } catch (fallbackError) {
            print('Fallback query also failed for child ${child.id}: $fallbackError');
            return <ScreenTimeModel>[];
          }
        }
      });
      
      final results = await Future.wait(futures);
      
      // Flatten and add all results
      for (final childData in results) {
        _screenTimeData.addAll(childData);
        
        // Save to local storage in batch
        for (final data in childData) {
          _storageService.saveScreenTime(data); // Don't await to avoid blocking
        }
      }
      
      notifyListeners();
    } catch (e) {
      print('Failed to load screen time data from Firestore: $e');
    }
  }
  
  // Load current location from Firestore
  Future<void> _loadCurrentLocationFromFirestore() async {
    try {
      if (_children.isEmpty) return;
      
      final childId = _children.first.id;
      
      try {
        // Try composite index query first
      final snapshot = await FirebaseFirestore.instance
          .collection('location')
          .where('userId', isEqualTo: childId)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();
      
      if (snapshot.docs.isNotEmpty) {
        _currentLocation = LocationModel.fromJson(snapshot.docs.first.data());
        notifyListeners();
        }
      } catch (e) {
        print('Composite query failed for location, trying fallback: $e');
        
        // Fallback: Simple query without ordering if index is not ready
        try {
          final fallbackSnapshot = await FirebaseFirestore.instance
              .collection('location')
              .where('userId', isEqualTo: childId)
              .limit(10) // Get more results to sort in memory
              .get();
          
          if (fallbackSnapshot.docs.isNotEmpty) {
            // Sort by timestamp in memory and take the latest
            final sortedDocs = fallbackSnapshot.docs.toList()
              ..sort((a, b) {
                final timestampA = (a.data()['timestamp'] as Timestamp?)?.toDate() ?? DateTime.fromMillisecondsSinceEpoch(0);
                final timestampB = (b.data()['timestamp'] as Timestamp?)?.toDate() ?? DateTime.fromMillisecondsSinceEpoch(0);
                return timestampB.compareTo(timestampA);
              });
            
            _currentLocation = LocationModel.fromJson(sortedDocs.first.data());
            notifyListeners();
          }
        } catch (fallbackError) {
          print('Fallback query also failed for location: $fallbackError');
        }
      }
    } catch (e) {
      print('Failed to load current location from Firestore: $e');
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
  
  // Dispose method to clean up subscriptions
  @override
  void dispose() {
    _cancelSubscriptions();
    _realTimeDataService.dispose();
    super.dispose();
  }
  
  // Get real-time device status
  String getDeviceStatus(String deviceId) {
    final device = _devices.firstWhere(
      (d) => d.id == deviceId,
      orElse: () => DeviceModel(
        id: '',
        name: 'Unknown Device',
        platform: 'unknown',
        model: 'Unknown',
        osVersion: 'Unknown',
        ownerId: null,
        isOnline: false,
        lastSeen: null,
        batteryLevel: 0,
        isCharging: false,
        dataUsage: 0.0,
        settings: {},
        createdAt: DateTime.now(),
      ),
    );
    
    if (device.isOnline) {
      return 'Online';
    } else {
      if (device.lastSeen != null) {
        final timeSinceLastSeen = DateTime.now().difference(device.lastSeen!);
        if (timeSinceLastSeen.inMinutes < 5) {
          return 'Online';
        } else if (timeSinceLastSeen.inHours < 1) {
          return 'Away';
        } else {
          return 'Offline';
        }
      } else {
        return 'Offline';
      }
    }
  }
  
  // Get real battery level
  int getDeviceBatteryLevel(String deviceId) {
    final device = _devices.firstWhere(
      (d) => d.id == deviceId,
      orElse: () => DeviceModel(
        id: '',
        name: 'Unknown Device',
        platform: 'unknown',
        model: 'Unknown',
        osVersion: 'Unknown',
        ownerId: null,
        isOnline: false,
        lastSeen: null,
        batteryLevel: 0,
        isCharging: false,
        dataUsage: 0.0,
        settings: {},
        createdAt: DateTime.now(),
      ),
    );
    
    return device.batteryLevel;
  }
  
  // Get real location name
  String getLocationName() {
    if (_currentLocation != null) {
      return _currentLocation!.address ?? 'Unknown Location';
    }
    return 'Location not available';
  }
  
  // Get real data usage
  String getDataUsage() {
    // This would come from real-time monitoring data
    if (_realTimeData.containsKey('dataUsage')) {
      final usage = _realTimeData['dataUsage'] as double;
      return '${(usage / 1024 / 1024 / 1024).toStringAsFixed(1)} GB';
    }
    return '0.0 GB';
  }
  
  // Get real app usage breakdown
  Map<String, double> getAppUsageBreakdown() {
    final today = DateTime.now();
    final todayData = _screenTimeData.where((data) => 
      data.date.year == today.year &&
      data.date.month == today.month &&
      data.date.day == today.day
    ).toList();
    
    if (todayData.isEmpty) {
      return {
        'Games': 0.0,
        'Social': 0.0,
        'Education': 0.0,
        'Other': 0.0,
      };
    }
    
    final totalTime = todayData.fold(Duration.zero, (total, data) => total + data.totalTime);
    if (totalTime.inMinutes == 0) {
      return {
        'Games': 0.0,
        'Social': 0.0,
        'Education': 0.0,
        'Other': 0.0,
      };
    }
    
    final breakdown = <String, double>{};
    for (final data in todayData) {
      for (final entry in data.appUsage.entries) {
        final category = _getAppCategory(entry.key);
        final percentage = (entry.value.inMinutes / totalTime.inMinutes * 100);
        breakdown[category] = (breakdown[category] ?? 0.0) + percentage;
      }
    }
    
    return breakdown;
  }
  
  // Helper method to categorize apps
  String _getAppCategory(String appName) {
    final socialApps = ['instagram', 'facebook', 'twitter', 'tiktok', 'snapchat', 'whatsapp'];
    final gameApps = ['game', 'play', 'fortnite', 'minecraft', 'roblox', 'pubg'];
    final educationApps = ['school', 'learn', 'education', 'study', 'khan', 'duolingo'];
    
    final lowerAppName = appName.toLowerCase();
    
    if (socialApps.any((app) => lowerAppName.contains(app))) {
      return 'Social';
    } else if (gameApps.any((app) => lowerAppName.contains(app))) {
      return 'Games';
    } else if (educationApps.any((app) => lowerAppName.contains(app))) {
      return 'Education';
    } else {
      return 'Other';
    }
  }
}
