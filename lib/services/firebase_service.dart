import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseService {
  static FirebaseService? _instance;
  static FirebaseService get instance => _instance ??= FirebaseService._();
  
  FirebaseService._();
  
  late FirebaseAuth _auth;
  late FirebaseFirestore _firestore;
  late FirebaseMessaging _messaging;
  late FirebaseAnalytics _analytics;
  
  // Getters
  FirebaseAuth get auth => _auth;
  FirebaseFirestore get firestore => _firestore;
  FirebaseMessaging get messaging => _messaging;
  FirebaseAnalytics get analytics => _analytics;
  
  // Initialize Firebase
  Future<void> init() async {
    try {
      // Initialize Firebase
      await Firebase.initializeApp();
      
      // Initialize services
      _auth = FirebaseAuth.instance;
      _firestore = FirebaseFirestore.instance;
      _messaging = FirebaseMessaging.instance;
      _analytics = FirebaseAnalytics.instance;
      
      // Configure Firestore settings
      _firestore.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
      
      // Request notification permissions
      await _requestNotificationPermissions();
      
      print('Firebase initialized successfully');
    } catch (e) {
      print('Firebase initialization failed: $e');
      rethrow;
    }
  }
  
  // Request notification permissions
  Future<void> _requestNotificationPermissions() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      
      print('Notification permission status: ${settings.authorizationStatus}');
    } catch (e) {
      print('Failed to request notification permissions: $e');
    }
  }
  
  // Get FCM token
  Future<String?> getFCMToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      print('Failed to get FCM token: $e');
      return null;
    }
  }
  
  // Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      print('Subscribed to topic: $topic');
    } catch (e) {
      print('Failed to subscribe to topic $topic: $e');
    }
  }
  
  // Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      print('Unsubscribed from topic: $topic');
    } catch (e) {
      print('Failed to unsubscribe from topic $topic: $e');
    }
  }
  
  // Log analytics event
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    try {
      await _analytics.logEvent(name: name, parameters: parameters);
    } catch (e) {
      print('Failed to log analytics event: $e');
    }
  }
  
  // Set user properties
  Future<void> setUserProperties({
    required String userId,
    required String userType,
    String? parentId,
  }) async {
    try {
      await _analytics.setUserId(id: userId);
      await _analytics.setUserProperty(name: 'user_type', value: userType);
      if (parentId != null) {
        await _analytics.setUserProperty(name: 'parent_id', value: parentId);
      }
    } catch (e) {
      print('Failed to set user properties: $e');
    }
  }
}
