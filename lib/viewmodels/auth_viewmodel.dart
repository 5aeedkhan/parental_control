import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';
import '../services/api_service.dart';
import '../services/firebase_auth_service.dart';
import '../services/firestore_service.dart';

class AuthViewModel extends ChangeNotifier {
  final StorageService _storageService = StorageService.instance;
  final ApiService _apiService = ApiService.instance;
  final FirebaseAuthService _firebaseAuth = FirebaseAuthService.instance;
  final FirestoreService _firestore = FirestoreService.instance;
  
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;
  bool _isLoggedIn = false;
  
  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _isLoggedIn;
  
  // Initialize auth state
  Future<void> init() async {
    _setLoading(true);
    try {
      // Check Firebase Auth state first
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser != null) {
        // User is authenticated with Firebase, get their data
        final user = await _firebaseAuth.getUserById(firebaseUser.uid);
        if (user != null) {
          _currentUser = user;
          _isLoggedIn = true;
          // Save to local storage
          await _storageService.saveUser(user);
        }
      } else {
        // No Firebase user, clear local data
        _currentUser = null;
        _isLoggedIn = false;
        // Clear any cached user data
        await _storageService.clearAllData();
      }
    } catch (e) {
      _setError('Failed to initialize auth: ${e.toString()}');
      // On error, clear everything
      _currentUser = null;
      _isLoggedIn = false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Login
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();
    
    try {
      // Use Firebase authentication
      final user = await _firebaseAuth.login(email, password);
      
      if (user != null) {
        _currentUser = user;
        _isLoggedIn = true;
        
        // Save user to local storage
        await _storageService.saveUser(user);
        
        notifyListeners();
        return true;
      } else {
        _setError('Login failed: Invalid credentials');
        return false;
      }
    } catch (e) {
      _setError('Login failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Register parent
  Future<bool> registerParent({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      // Use Firebase authentication
      final user = await _firebaseAuth.registerParent(
        name: name,
        email: email,
        password: password,
      );
      
      if (user != null) {
        // Don't set user as logged in - they need to sign in manually
        _currentUser = null;
        _isLoggedIn = false;
        
        // Don't save user to local storage yet - they need to sign in first
        // await _storageService.saveUser(user);
        
        notifyListeners();
        return true;
      } else {
        _setError('Parent registration failed: Unable to create account');
        return false;
      }
    } catch (e) {
      _setError('Parent registration failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Create child account (called by parent)
  Future<bool> createChildAccount({
    required String childName,
    required int age,
    required String deviceId,
  }) async {
    if (_currentUser == null || !_currentUser!.isParent) {
      _setError('Only parents can create child accounts');
      return false;
    }
    
    _setLoading(true);
    _clearError();
    
    try {
      // Use Firebase authentication
      final childUser = await _firebaseAuth.createChildAccount(
        childName: childName,
        age: age,
        parentId: _currentUser!.id,
        deviceId: deviceId,
      );
      
      if (childUser != null) {
        // Update parent's child list
        final updatedParent = _currentUser!.copyWith(
          childIds: [..._currentUser!.childIds, childUser.id],
        );
        _currentUser = updatedParent;
        await _storageService.saveUser(updatedParent);
        
        notifyListeners();
        return true;
      } else {
        _setError('Child account creation failed: Unable to create account');
        return false;
      }
    } catch (e) {
      _setError('Child account creation failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Legacy register method for backward compatibility
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    if (role.toLowerCase() == 'parent') {
      return await registerParent(
        name: name,
        email: email,
        password: password,
      );
    } else {
      _setError('Child accounts must be created by parents');
      return false;
    }
  }
  
  // Google Sign-In
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _clearError();
    
    try {
      final user = await _firebaseAuth.signInWithGoogle();
      
      if (user != null) {
        _currentUser = user;
        _isLoggedIn = true;
        
        // Save user to local storage
        await _storageService.saveUser(user);
        
        notifyListeners();
        return true;
      } else {
        _setError('Google Sign-In was cancelled');
        return false;
      }
    } catch (e) {
      _setError('Google Sign-In failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Logout
  Future<void> logout() async {
    _setLoading(true);
    
    try {
      // Sign out from Google if signed in with Google
      await _firebaseAuth.signOutGoogle();
      
      // Use Firebase logout
      await _firebaseAuth.logout();
      
      // Clear local data
      if (_currentUser != null) {
        await _storageService.removeUser(_currentUser!.id);
      }
      
      _currentUser = null;
      _isLoggedIn = false;
      
      notifyListeners();
    } catch (e) {
      _setError('Logout failed: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
  
  // Update profile
  Future<bool> updateProfile({
    String? name,
    String? email,
    String? profileImage,
  }) async {
    if (_currentUser == null) return false;
    
    _setLoading(true);
    _clearError();
    
    try {
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (email != null) updates['email'] = email;
      if (profileImage != null) updates['profileImage'] = profileImage;
      
      final updatedUser = await _apiService.updateUserProfile(updates);
      
      _currentUser = updatedUser;
      await _storageService.saveUser(updatedUser);
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Profile update failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Verify token
  Future<void> _verifyToken() async {
    try {
      final user = await _apiService.getCurrentUser();
      _currentUser = user;
      await _storageService.saveUser(user);
    } catch (e) {
      // Token is invalid, logout user
      await logout();
    }
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
  
  // Check if user is parent
  bool get isParent => _currentUser?.isParent ?? false;
  
  // Check if user is child
  bool get isChild => _currentUser?.isChild ?? false;
  
  // Get user type
  UserType? get userType => _currentUser?.userType;
  
  // Get child IDs (for parents)
  List<String> get childIds => _currentUser?.childIds ?? [];
  
  // Get parent ID (for children)
  String? get parentId => _currentUser?.parentId;
  
  // Get user name
  String get userName => _currentUser?.name ?? 'User';
  
  // Get user email
  String get userEmail => _currentUser?.email ?? '';
  
  // Get user profile image
  String? get userProfileImage => _currentUser?.profileImage;
}
