class AppConstants {
  // App Information
  static const String appName = 'FamilyGuard';
  static const String appVersion = '2.1.0';
  static const String appDescription = 'Protecting what matters most';

  // Storage Keys
  static const String userKey = 'familyguard_user';
  static const String onboardingKey = 'familyguard_onboarding';
  static const String deviceKey = 'familyguard_device';
  static const String settingsKey = 'familyguard_settings';
  static const String alertsKey = 'familyguard_alerts';

  // API Endpoints
  static const String baseUrl = 'https://api.familyguard.com';
  static const String authEndpoint = '/auth';
  static const String devicesEndpoint = '/devices';
  static const String alertsEndpoint = '/alerts';
  static const String screenTimeEndpoint = '/screen-time';
  static const String locationEndpoint = '/location';

  // Default Values
  static const Duration defaultScreenTimeLimit = Duration(hours: 6);
  static const Duration defaultAppTimeLimit = Duration(hours: 2);
  static const double defaultSafeZoneRadius = 100.0; // meters

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Colors
  static const int primaryColor = 0xFF4F46E5;
  static const int secondaryColor = 0xFF7C3AED;
  static const int successColor = 0xFF10B981;
  static const int warningColor = 0xFFF59E0B;
  static const int errorColor = 0xFFEF4444;
  static const int infoColor = 0xFF3B82F6;

  // Screen Time Categories
  static const Map<String, String> appCategories = {
    'games': 'Games',
    'social': 'Social Media',
    'education': 'Education',
    'entertainment': 'Entertainment',
    'productivity': 'Productivity',
    'communication': 'Communication',
    'utilities': 'Utilities',
    'other': 'Other',
  };

  // Alert Types
  static const Map<String, String> alertTypes = {
    'cyberbullying': 'Cyberbullying',
    'inappropriateContent': 'Inappropriate Content',
    'locationAlert': 'Location Alert',
    'screenTimeExceeded': 'Screen Time Exceeded',
    'appUsageAlert': 'App Usage Alert',
    'unknownContact': 'Unknown Contact',
    'systemAlert': 'System Alert',
  };

  // Permissions
  static const List<String> requiredPermissions = [
    'location',
    'notifications',
    'messages',
  ];

  static const List<String> optionalPermissions = [
    'camera',
    'microphone',
    'contacts',
    'calendar',
  ];
}
