# FamilyGuard - Parental Control App

A comprehensive Flutter-based parental control application designed to help parents monitor and manage their children's digital activities while ensuring their safety and promoting healthy device habits.

## 🚀 Features

### Core Functionality
- **Screen Time Monitoring**: Track and limit daily device usage with detailed analytics
- **App Control**: Manage and restrict access to specific applications
- **Location Tracking**: Monitor child's location with safe zone alerts
- **AI-Powered Alerts**: Detect potential cyberbullying and inappropriate content
- **Content Filtering**: Block inappropriate websites and content
- **Activity Monitoring**: Track device usage patterns and behaviors
- **Remote Controls**: Lock device or pause internet access remotely

### User Experience
- **Beautiful UI**: Modern, intuitive interface with smooth animations
- **MVVM Architecture**: Clean, maintainable code structure
- **Real-time Updates**: Live data synchronization across devices
- **Offline Support**: Local data storage with sync capabilities
- **Multi-platform**: Support for Android and iOS

## 🏗️ Architecture

The app follows the **MVVM (Model-View-ViewModel)** pattern for clean separation of concerns:

```
lib/
├── models/           # Data models and entities
├── views/            # UI screens and widgets
├── viewmodels/       # Business logic and state management
├── services/         # API calls, storage, and external services
├── widgets/          # Reusable UI components
├── constants/        # App constants and configurations
└── utils/            # Utility functions and helpers
```

### Key Components

#### Models
- `UserModel`: User account information
- `DeviceModel`: Device details and status
- `AlertModel`: Security alerts and notifications
- `ScreenTimeModel`: Screen time tracking data
- `AppModel`: Installed applications and restrictions
- `LocationModel`: Location tracking and safe zones

#### Services
- `StorageService`: Local data persistence with Hive
- `ApiService`: HTTP API communication
- `PermissionService`: Device permission management
- `NotificationService`: Push notifications

#### ViewModels
- `AuthViewModel`: Authentication and user management
- `DashboardViewModel`: Main dashboard data and analytics

## 🛠️ Technology Stack

### Core Framework
- **Flutter**: Cross-platform mobile development
- **Dart**: Programming language

### State Management
- **Provider**: State management and dependency injection

### Navigation
- **GoRouter**: Declarative routing and navigation

### Data Storage
- **Hive**: Local NoSQL database
- **SharedPreferences**: Simple key-value storage

### Charts & Visualization
- **FL Chart**: Beautiful charts and graphs

### HTTP & API
- **Dio**: HTTP client for API calls
- **HTTP**: Additional HTTP utilities

### Permissions & Device Access
- **Permission Handler**: Runtime permission management
- **Geolocator**: Location services
- **Device Info Plus**: Device information

### Notifications
- **Flutter Local Notifications**: Local push notifications

### UI & Animations
- **Lottie**: Vector animations
- **Flutter Staggered Animations**: Staggered animations
- **Shimmer**: Loading placeholders

## 📱 Screenshots

### Splash Screen
- Animated logo with progress indicator
- Beautiful gradient background
- Smooth transitions

### Onboarding
- Multi-step introduction to app features
- Permission request flow
- Interactive permission management

### Authentication
- Login and registration forms
- Form validation and error handling
- Secure authentication flow

### Dashboard
- Real-time device status
- Screen time analytics with charts
- Quick action buttons
- Alert notifications

### Navigation
- Bottom navigation bar
- Tab-based navigation
- More menu with additional features

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.7.2 or higher)
- Dart SDK
- Android Studio / VS Code
- Android device or emulator / iOS simulator

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd parental_control
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Configuration

1. **API Configuration**
   - Update `AppConstants.baseUrl` with your API endpoint
   - Configure authentication tokens and API keys

2. **Permissions**
   - The app will request necessary permissions during onboarding
   - Required permissions: Location, Notifications, Messages
   - Optional permissions: Camera, Microphone, Contacts, Calendar

3. **Local Storage**
   - Hive boxes are automatically initialized
   - Data is stored locally and synced with server

## 🔧 Development

### Project Structure
```
lib/
├── constants/
│   ├── app_constants.dart    # App-wide constants
│   └── app_colors.dart       # Color definitions
├── models/
│   ├── user_model.dart       # User data model
│   ├── device_model.dart     # Device data model
│   ├── alert_model.dart      # Alert data model
│   ├── screen_time_model.dart # Screen time data model
│   ├── app_model.dart        # App data model
│   └── location_model.dart   # Location data model
├── services/
│   ├── storage_service.dart  # Local storage management
│   ├── api_service.dart      # API communication
│   ├── permission_service.dart # Permission handling
│   └── notification_service.dart # Notification management
├── viewmodels/
│   ├── auth_viewmodel.dart   # Authentication logic
│   └── dashboard_viewmodel.dart # Dashboard logic
├── views/
│   ├── splash_screen.dart    # App launch screen
│   ├── onboarding_screen.dart # User onboarding
│   ├── auth_screen.dart      # Login/Register
│   ├── main_navigation.dart  # Main app navigation
│   ├── dashboard_screen.dart # Main dashboard
│   └── [other screens]       # Additional screens
└── widgets/
    ├── custom_card.dart      # Reusable card widget
    └── quick_action_button.dart # Action button widget
```

### Code Generation
The app uses code generation for Hive adapters. Run the following command after making changes to models:

```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### State Management
The app uses Provider for state management. ViewModels extend `ChangeNotifier` and are provided at the app level:

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthViewModel()),
    ChangeNotifierProvider(create: (_) => DashboardViewModel()),
  ],
  child: MyApp(),
)
```

## 🎨 UI/UX Design

### Design System
- **Colors**: Consistent color palette with primary, secondary, and semantic colors
- **Typography**: Clear hierarchy with appropriate font weights and sizes
- **Spacing**: Consistent padding and margins throughout the app
- **Components**: Reusable UI components for consistency

### Animations
- **Splash Screen**: Smooth logo animation with progress indicator
- **Onboarding**: Page transitions and fade animations
- **Navigation**: Smooth tab transitions
- **Charts**: Animated data visualization

### Responsive Design
- **Adaptive Layout**: Works on different screen sizes
- **Safe Areas**: Proper handling of device notches and status bars
- **Accessibility**: Support for screen readers and accessibility features

## 🔒 Security & Privacy

### Data Protection
- **Encryption**: All sensitive data is encrypted
- **Local Storage**: Secure local data storage
- **API Security**: Secure API communication with tokens

### Privacy Features
- **Permission Management**: Granular permission controls
- **Data Control**: Users control what data is monitored
- **Transparency**: Clear information about data usage

## 🧪 Testing

### Unit Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter test integration_test/
```

### Widget Tests
```bash
flutter test test/
```

## 📦 Building for Production

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation

## 🔮 Future Enhancements

- **Web Dashboard**: Browser-based management interface
- **Advanced Analytics**: Machine learning insights
- **Multi-language Support**: Internationalization
- **Wearable Integration**: Smartwatch companion app
- **Advanced AI**: Enhanced content detection
- **Family Sharing**: Multiple child management
- **Time-based Rules**: Schedule-based restrictions
- **Emergency Features**: Panic button and emergency contacts

---

**FamilyGuard** - Protecting what matters most 🛡️