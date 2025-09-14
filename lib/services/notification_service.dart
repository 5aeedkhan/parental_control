import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/alert_model.dart';
import '../constants/app_constants.dart';

class NotificationService {
  static NotificationService? _instance;
  static NotificationService get instance => _instance ??= NotificationService._();
  
  NotificationService._();
  
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;
  
  Future<void> init() async {
    if (_isInitialized) return;
    
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
    
    _isInitialized = true;
  }
  
  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    final payload = response.payload;
    if (payload != null) {
      // Navigate to appropriate screen based on payload
      // This will be handled by the navigation service
    }
  }
  
  // Request notification permission
  Future<bool> requestPermission() async {
    final status = await Permission.notification.request();
    return status == PermissionStatus.granted;
  }
  
  // Check if notification permission is granted
  Future<bool> isPermissionGranted() async {
    final status = await Permission.notification.status;
    return status == PermissionStatus.granted;
  }
  
  // Show alert notification
  Future<void> showAlertNotification(AlertModel alert) async {
    if (!await isPermissionGranted()) return;
    
    final androidDetails = AndroidNotificationDetails(
      'alerts',
      'Alert Notifications',
      channelDescription: 'Notifications for important alerts and warnings',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: _getAlertColor(alert.severity),
      playSound: true,
      enableVibration: true,
    );
    
    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notifications.show(
      alert.id.hashCode,
      alert.title,
      alert.description,
      details,
      payload: 'alert:${alert.id}',
    );
  }
  
  // Show screen time notification
  Future<void> showScreenTimeNotification(String deviceName, Duration remainingTime) async {
    if (!await isPermissionGranted()) return;
    
    final androidDetails = AndroidNotificationDetails(
      'screen_time',
      'Screen Time Notifications',
      channelDescription: 'Notifications about screen time limits',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: const Color(AppConstants.warningColor),
    );
    
    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notifications.show(
      'screen_time_${deviceName.hashCode}'.hashCode,
      'Screen Time Alert',
      '$deviceName has ${_formatDuration(remainingTime)} remaining',
      details,
      payload: 'screen_time:$deviceName',
    );
  }
  
  // Show location notification
  Future<void> showLocationNotification(String deviceName, String location) async {
    if (!await isPermissionGranted()) return;
    
    final androidDetails = AndroidNotificationDetails(
      'location',
      'Location Notifications',
      channelDescription: 'Notifications about location updates',
      importance: Importance.low,
      priority: Priority.low,
      icon: '@mipmap/ic_launcher',
      color: const Color(AppConstants.infoColor),
    );
    
    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: false,
    );
    
    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notifications.show(
      'location_${deviceName.hashCode}'.hashCode,
      'Location Update',
      '$deviceName is at $location',
      details,
      payload: 'location:$deviceName',
    );
  }
  
  // Show app usage notification
  Future<void> showAppUsageNotification(String appName, Duration usageTime) async {
    if (!await isPermissionGranted()) return;
    
    final androidDetails = AndroidNotificationDetails(
      'app_usage',
      'App Usage Notifications',
      channelDescription: 'Notifications about app usage',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: const Color(AppConstants.warningColor),
    );
    
    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notifications.show(
      'app_usage_${appName.hashCode}'.hashCode,
      'App Usage Alert',
      '$appName has been used for ${_formatDuration(usageTime)}',
      details,
      payload: 'app_usage:$appName',
    );
  }
  
  // Show general notification
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
    int? id,
  }) async {
    if (!await isPermissionGranted()) return;
    
    final androidDetails = AndroidNotificationDetails(
      'general',
      'General Notifications',
      channelDescription: 'General app notifications',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      icon: '@mipmap/ic_launcher',
    );
    
    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notifications.show(
      id ?? title.hashCode,
      title,
      body,
      details,
      payload: payload,
    );
  }
  
  // Cancel notification
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }
  
  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
  
  // Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }
  
  // Schedule notification
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    if (!await isPermissionGranted()) return;
    
    final androidDetails = AndroidNotificationDetails(
      'scheduled',
      'Scheduled Notifications',
      channelDescription: 'Scheduled app notifications',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      icon: '@mipmap/ic_launcher',
    );
    
    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      payload: payload,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
  
  // Helper methods
  Color _getAlertColor(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.low:
        return const Color(AppConstants.successColor);
      case AlertSeverity.medium:
        return const Color(AppConstants.warningColor);
      case AlertSeverity.high:
        return const Color(AppConstants.errorColor);
      case AlertSeverity.critical:
        return const Color(0xFF7C2D12);
    }
  }
  
  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return '${duration.inSeconds}s';
    }
  }
}
