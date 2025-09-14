import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import '../constants/app_constants.dart';

class PermissionService {
  static PermissionService? _instance;
  static PermissionService get instance => _instance ??= PermissionService._();
  
  PermissionService._();
  
  // Check if permission is granted
  Future<bool> isPermissionGranted(Permission permission) async {
    final status = await permission.status;
    return status == PermissionStatus.granted;
  }
  
  // Request permission
  Future<bool> requestPermission(Permission permission) async {
    final status = await permission.request();
    return status == PermissionStatus.granted;
  }
  
  // Check location permission
  Future<bool> isLocationPermissionGranted() async {
    final status = await Geolocator.checkPermission();
    return status == LocationPermission.always || status == LocationPermission.whileInUse;
  }
  
  // Request location permission
  Future<bool> requestLocationPermission() async {
    final status = await Geolocator.requestPermission();
    return status == LocationPermission.always || status == LocationPermission.whileInUse;
  }
  
  // Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }
  
  // Request all required permissions
  Future<Map<String, bool>> requestRequiredPermissions() async {
    final results = <String, bool>{};
    
    // Location permission
    results['location'] = await requestLocationPermission();
    
    // Notification permission
    results['notifications'] = await requestPermission(Permission.notification);
    
    // Storage permission (for Android)
    results['storage'] = await requestPermission(Permission.storage);
    
    // Camera permission
    results['camera'] = await requestPermission(Permission.camera);
    
    // Microphone permission
    results['microphone'] = await requestPermission(Permission.microphone);
    
    // Contacts permission
    results['contacts'] = await requestPermission(Permission.contacts);
    
    // Calendar permission
    results['calendar'] = await requestPermission(Permission.calendar);
    
    return results;
  }
  
  // Check all required permissions
  Future<Map<String, bool>> checkAllPermissions() async {
    final results = <String, bool>{};
    
    // Location permission
    results['location'] = await isLocationPermissionGranted();
    
    // Notification permission
    results['notifications'] = await isPermissionGranted(Permission.notification);
    
    // Storage permission
    results['storage'] = await isPermissionGranted(Permission.storage);
    
    // Camera permission
    results['camera'] = await isPermissionGranted(Permission.camera);
    
    // Microphone permission
    results['microphone'] = await isPermissionGranted(Permission.microphone);
    
    // Contacts permission
    results['contacts'] = await isPermissionGranted(Permission.contacts);
    
    // Calendar permission
    results['calendar'] = await isPermissionGranted(Permission.calendar);
    
    return results;
  }
  
  // Get permission status with description
  Future<Map<String, dynamic>> getPermissionStatus(Permission permission) async {
    final status = await permission.status;
    final isGranted = status == PermissionStatus.granted;
    final isDenied = status == PermissionStatus.denied;
    final isPermanentlyDenied = status == PermissionStatus.permanentlyDenied;
    final isRestricted = status == PermissionStatus.restricted;
    
    return {
      'permission': permission.toString(),
      'status': status.toString(),
      'isGranted': isGranted,
      'isDenied': isDenied,
      'isPermanentlyDenied': isPermanentlyDenied,
      'isRestricted': isRestricted,
      'canRequest': !isPermanentlyDenied && !isRestricted,
    };
  }
  
  // Open app settings
  Future<void> openAppSettings() async {
    await openAppSettings();
  }
  
  // Check if we can request permission (not permanently denied)
  Future<bool> canRequestPermission(Permission permission) async {
    final status = await permission.status;
    return status != PermissionStatus.permanentlyDenied && 
           status != PermissionStatus.restricted;
  }
  
  // Get permission description
  String getPermissionDescription(String permission) {
    switch (permission) {
      case 'location':
        return 'Track your child\'s location and set up safe zones';
      case 'notifications':
        return 'Receive alerts about important activities';
      case 'camera':
        return 'Monitor camera usage and detect inappropriate content';
      case 'microphone':
        return 'Monitor voice calls and voice messages';
      case 'contacts':
        return 'Monitor communication with unknown contacts';
      case 'calendar':
        return 'Integrate with family schedules and school hours';
      case 'storage':
        return 'Access device storage for app data';
      default:
        return 'Required for app functionality';
    }
  }
  
  // Check if permission is required
  bool isPermissionRequired(String permission) {
    return AppConstants.requiredPermissions.contains(permission);
  }
  
  // Check if permission is optional
  bool isPermissionOptional(String permission) {
    return AppConstants.optionalPermissions.contains(permission);
  }
}
