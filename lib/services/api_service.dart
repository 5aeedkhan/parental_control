import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../models/user_model.dart';
import '../models/device_model.dart';
import '../models/alert_model.dart';
import '../models/screen_time_model.dart';
import '../models/app_model.dart';
import '../models/location_model.dart';

class ApiService {
  static ApiService? _instance;
  static ApiService get instance => _instance ??= ApiService._();
  
  ApiService._();
  
  late Dio _dio;
  String? _authToken;
  
  Future<void> init() async {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    
    // Add interceptors
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_authToken != null) {
          options.headers['Authorization'] = 'Bearer $_authToken';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        // Handle common errors
        if (error.response?.statusCode == 401) {
          // Token expired, logout user
          _authToken = null;
        }
        handler.next(error);
      },
    ));
  }
  
  void setAuthToken(String token) {
    _authToken = token;
  }
  
  void clearAuthToken() {
    _authToken = null;
  }
  
  // Authentication
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // Mock authentication for development
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      
      // Simple validation for demo purposes
      if (email.isNotEmpty && password.isNotEmpty) {
        final mockUser = {
          'id': '1',
          'name': 'Demo Parent',
          'email': email,
          'userType': 'parent',
          'createdAt': DateTime.now().toIso8601String(),
        };
        
        final mockToken = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
        _authToken = mockToken;
        
        return {
          'user': mockUser,
          'token': mockToken,
          'message': 'Login successful',
        };
      } else {
        throw Exception('Email and password are required');
      }
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }
  
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      // Mock registration for development
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      
      // Simple validation for demo purposes
      if (userData['email'] != null && userData['password'] != null && userData['name'] != null) {
        final userType = userData['userType'] ?? 'parent';
        final mockUser = {
          'id': '${DateTime.now().millisecondsSinceEpoch}',
          'name': userData['name'],
          'email': userData['email'],
          'userType': userType,
          'parentId': userData['parentId'],
          'childIds': userData['childIds'] ?? [],
          'age': userData['age'],
          'deviceId': userData['deviceId'],
          'createdAt': DateTime.now().toIso8601String(),
        };
        
        final mockToken = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
        _authToken = mockToken;
        
        return {
          'user': mockUser,
          'token': mockToken,
          'message': 'Registration successful',
        };
      } else {
        throw Exception('Name, email, and password are required');
      }
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  // Register parent account
  Future<Map<String, dynamic>> registerParent({
    required String name,
    required String email,
    required String password,
  }) async {
    return await register({
      'name': name,
      'email': email,
      'password': password,
      'userType': 'parent',
    });
  }

  // Create child account (called by parent)
  Future<Map<String, dynamic>> createChildAccount({
    required String childName,
    required int age,
    required String parentId,
    required String deviceId,
  }) async {
    return await register({
      'name': childName,
      'email': '${childName.toLowerCase().replaceAll(' ', '')}@child.local',
      'password': 'child_${DateTime.now().millisecondsSinceEpoch}',
      'userType': 'child',
      'parentId': parentId,
      'age': age,
      'deviceId': deviceId,
    });
  }
  
  Future<void> logout() async {
    try {
      // Mock logout for development
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    } catch (e) {
      // Ignore logout errors
    } finally {
      _authToken = null;
    }
  }
  
  // User Management
  Future<UserModel> getCurrentUser() async {
    try {
      // Mock user data for development
      await Future.delayed(const Duration(milliseconds: 500));
      
      final mockUser = {
        'id': '1',
        'name': 'Demo Parent',
        'email': 'demo@example.com',
        'userType': 'parent',
        'createdAt': DateTime.now().toIso8601String(),
        'isActive': true,
        'preferences': {},
      };
      
      return UserModel.fromJson(mockUser);
    } catch (e) {
      throw Exception('Failed to get user profile: ${e.toString()}');
    }
  }
  
  Future<UserModel> updateUserProfile(Map<String, dynamic> userData) async {
    try {
      // Mock user profile update for development
      await Future.delayed(const Duration(milliseconds: 500));
      
      final mockUser = {
        'id': '1',
        'name': userData['name'] ?? 'Demo Parent',
        'email': userData['email'] ?? 'demo@example.com',
        'userType': 'parent',
        'createdAt': DateTime.now().toIso8601String(),
        'isActive': true,
        'preferences': userData['preferences'] ?? {},
      };
      
      return UserModel.fromJson(mockUser);
    } catch (e) {
      throw Exception('Failed to update user profile: ${e.toString()}');
    }
  }
  
  // Device Management
  Future<List<DeviceModel>> getDevices() async {
    try {
      // Mock device data for development
      await Future.delayed(const Duration(milliseconds: 500));
      
      final mockDevices = [
        {
          'id': 'device_1',
          'name': 'Emma\'s iPhone',
          'type': 'mobile',
          'platform': 'iOS',
          'model': 'iPhone 13',
          'isOnline': true,
          'lastSeen': DateTime.now().toIso8601String(),
          'batteryLevel': 78,
          'isMonitored': true,
          'userId': '1',
        },
        {
          'id': 'device_2',
          'name': 'Emma\'s iPad',
          'type': 'tablet',
          'platform': 'iOS',
          'model': 'iPad Air',
          'isOnline': false,
          'lastSeen': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
          'batteryLevel': 45,
          'isMonitored': true,
          'userId': '1',
        },
      ];
      
      return mockDevices.map((json) => DeviceModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get devices: ${e.toString()}');
    }
  }
  
  Future<DeviceModel> addDevice(DeviceModel device) async {
    try {
      // Mock device addition for development
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Return the device with a generated ID
      final deviceData = device.toJson();
      deviceData['id'] = 'device_${DateTime.now().millisecondsSinceEpoch}';
      deviceData['isOnline'] = true;
      deviceData['lastSeen'] = DateTime.now().toIso8601String();
      
      return DeviceModel.fromJson(deviceData);
    } catch (e) {
      throw Exception('Failed to add device: ${e.toString()}');
    }
  }
  
  Future<DeviceModel> updateDevice(String deviceId, Map<String, dynamic> updates) async {
    try {
      // Mock device update for development
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Return a mock updated device
      final mockDevice = {
        'id': deviceId,
        'name': updates['name'] ?? 'Updated Device',
        'type': 'mobile',
        'platform': 'iOS',
        'model': 'iPhone 13',
        'isOnline': true,
        'lastSeen': DateTime.now().toIso8601String(),
        'batteryLevel': 85,
        'isMonitored': true,
        'userId': '1',
        ...updates,
      };
      
      return DeviceModel.fromJson(mockDevice);
    } catch (e) {
      throw Exception('Failed to update device: ${e.toString()}');
    }
  }
  
  Future<void> removeDevice(String deviceId) async {
    try {
      // Mock device removal for development
      await Future.delayed(const Duration(milliseconds: 500));
      print('Device $deviceId removed successfully');
    } catch (e) {
      throw Exception('Failed to remove device: ${e.toString()}');
    }
  }
  
  // Alert Management
  Future<List<AlertModel>> getAlerts() async {
    try {
      final response = await _dio.get(AppConstants.alertsEndpoint);
      return (response.data as List)
          .map((json) => AlertModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get alerts: ${e.toString()}');
    }
  }
  
  Future<AlertModel> markAlertAsRead(String alertId) async {
    try {
      final response = await _dio.put(
        '${AppConstants.alertsEndpoint}/$alertId/read',
      );
      return AlertModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to mark alert as read: ${e.toString()}');
    }
  }
  
  Future<AlertModel> resolveAlert(String alertId, String actionTaken) async {
    try {
      final response = await _dio.put(
        '${AppConstants.alertsEndpoint}/$alertId/resolve',
        data: {'actionTaken': actionTaken},
      );
      return AlertModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to resolve alert: ${e.toString()}');
    }
  }
  
  // Screen Time Management
  Future<List<ScreenTimeModel>> getScreenTimeData(String deviceId, {DateTime? startDate, DateTime? endDate}) async {
    try {
      final queryParams = <String, dynamic>{
        'deviceId': deviceId,
      };
      
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }
      
      final response = await _dio.get(
        AppConstants.screenTimeEndpoint,
        queryParameters: queryParams,
      );
      
      return (response.data as List)
          .map((json) => ScreenTimeModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get screen time data: ${e.toString()}');
    }
  }
  
  Future<ScreenTimeModel> updateScreenTimeLimit(String deviceId, Duration limit) async {
    try {
      final response = await _dio.put(
        '${AppConstants.screenTimeEndpoint}/$deviceId/limit',
        data: {'limitSeconds': limit.inSeconds},
      );
      return ScreenTimeModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update screen time limit: ${e.toString()}');
    }
  }
  
  // App Management
  Future<List<AppModel>> getApps(String deviceId) async {
    try {
      final response = await _dio.get(
        '/apps',
        queryParameters: {'deviceId': deviceId},
      );
      return (response.data as List)
          .map((json) => AppModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get apps: ${e.toString()}');
    }
  }
  
  Future<AppModel> updateAppSettings(String appId, Map<String, dynamic> settings) async {
    try {
      final response = await _dio.put(
        '/apps/$appId',
        data: settings,
      );
      return AppModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update app settings: ${e.toString()}');
    }
  }
  
  // Location Management
  Future<List<LocationModel>> getLocationHistory(String deviceId, {DateTime? startDate, DateTime? endDate}) async {
    try {
      final queryParams = <String, dynamic>{
        'deviceId': deviceId,
      };
      
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }
      
      final response = await _dio.get(
        AppConstants.locationEndpoint,
        queryParameters: queryParams,
      );
      
      return (response.data as List)
          .map((json) => LocationModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get location history: ${e.toString()}');
    }
  }
  
  Future<List<SafeZoneModel>> getSafeZones() async {
    try {
      final response = await _dio.get('/safe-zones');
      return (response.data as List)
          .map((json) => SafeZoneModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get safe zones: ${e.toString()}');
    }
  }
  
  Future<SafeZoneModel> createSafeZone(SafeZoneModel safeZone) async {
    try {
      final response = await _dio.post(
        '/safe-zones',
        data: safeZone.toJson(),
      );
      return SafeZoneModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create safe zone: ${e.toString()}');
    }
  }
  
  Future<SafeZoneModel> updateSafeZone(String safeZoneId, Map<String, dynamic> updates) async {
    try {
      final response = await _dio.put(
        '/safe-zones/$safeZoneId',
        data: updates,
      );
      return SafeZoneModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update safe zone: ${e.toString()}');
    }
  }
  
  Future<void> deleteSafeZone(String safeZoneId) async {
    try {
      await _dio.delete('/safe-zones/$safeZoneId');
    } catch (e) {
      throw Exception('Failed to delete safe zone: ${e.toString()}');
    }
  }
  
  // Utility Methods
  Future<bool> checkConnection() async {
    try {
      final response = await _dio.get('/health');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
  
  Future<Map<String, dynamic>> uploadFile(String filePath, String fieldName) async {
    try {
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath),
      });
      
      final response = await _dio.post('/upload', data: formData);
      return response.data;
    } catch (e) {
      throw Exception('Failed to upload file: ${e.toString()}');
    }
  }
}
