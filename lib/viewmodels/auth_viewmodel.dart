import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';
import '../services/api_service.dart';

class AuthViewModel extends ChangeNotifier {
  final StorageService _storageService = StorageService.instance;
  final ApiService _apiService = ApiService.instance;
  
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
      final user = _storageService.getCurrentUser();
      if (user != null) {
        _currentUser = user;
        _isLoggedIn = true;
        // Verify token with server
        await _verifyToken();
      }
    } catch (e) {
      _setError('Failed to initialize auth: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
  
  // Login
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();
    
    try {
      final response = await _apiService.login(email, password);
      final user = UserModel.fromJson(response['user']);
      
      _currentUser = user;
      _isLoggedIn = true;
      
      // Save user to local storage
      await _storageService.saveUser(user);
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Login failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Register
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final userData = {
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      };
      
      final response = await _apiService.register(userData);
      final user = UserModel.fromJson(response['user']);
      
      _currentUser = user;
      _isLoggedIn = true;
      
      // Save user to local storage
      await _storageService.saveUser(user);
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Registration failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Logout
  Future<void> logout() async {
    _setLoading(true);
    
    try {
      await _apiService.logout();
      
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
  bool get isParent => _currentUser?.role == 'parent';
  
  // Check if user is child
  bool get isChild => _currentUser?.role == 'child';
  
  // Get user name
  String get userName => _currentUser?.name ?? 'User';
  
  // Get user email
  String get userEmail => _currentUser?.email ?? '';
  
  // Get user profile image
  String? get userProfileImage => _currentUser?.profileImage;
}
