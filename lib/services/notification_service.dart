import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/alert_model.dart';
import '../constants/app_constants.dart';

class NotificationService {
  static NotificationService? _instance;
  static NotificationService get instance => _instance ??= NotificationService._();
  
  NotificationService._();
  
  bool _isInitialized = false;
  
  Future<void> init() async {
    if (_isInitialized) return;
    
    // Request notification permission
    await _requestNotificationPermission();
    
    _isInitialized = true;
    print('NotificationService initialized (simplified version)');
  }
  
  Future<void> _requestNotificationPermission() async {
    final status = await Permission.notification.request();
    if (status.isGranted) {
      print('Notification permission granted');
    } else {
      print('Notification permission denied');
    }
  }
  
  // Simplified notification methods that don't actually send notifications
  // but provide the same interface for the app to work
  
  Future<void> showScreenTimeAlert(String deviceName, int minutes) async {
    print('Screen time alert for $deviceName: $minutes minutes');
    // In a real implementation, this would show a notification
  }
  
  Future<void> showLocationAlert(String deviceName, String location) async {
    print('Location alert for $deviceName: $location');
    // In a real implementation, this would show a notification
  }
  
  Future<void> showAppUsageAlert(String deviceName, String appName) async {
    print('App usage alert for $deviceName: $appName');
    // In a real implementation, this would show a notification
  }
  
  Future<void> showScheduledAlert(AlertModel alert) async {
    print('Scheduled alert: ${alert.title}');
    // In a real implementation, this would show a notification
  }
  
  Future<void> cancelNotification(int id) async {
    print('Cancel notification: $id');
    // In a real implementation, this would cancel the notification
  }
  
  Future<void> cancelAllNotifications() async {
    print('Cancel all notifications');
    // In a real implementation, this would cancel all notifications
  }
  
  // Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }
  
  // Request notification permission
  Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }
}