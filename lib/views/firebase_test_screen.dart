import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../services/firebase_service.dart';

class FirebaseTestScreen extends StatefulWidget {
  const FirebaseTestScreen({super.key});

  @override
  State<FirebaseTestScreen> createState() => _FirebaseTestScreenState();
}

class _FirebaseTestScreenState extends State<FirebaseTestScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  
  bool _isLogin = true;
  String _status = 'Ready to test Firebase';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _testFirebaseConnection() async {
    setState(() {
      _status = 'Testing Firebase connection...';
    });

    try {
      // Test Firebase initialization
      final firebaseService = FirebaseService.instance;
      final fcmToken = await firebaseService.getFCMToken();
      
      setState(() {
        _status = 'Firebase connected successfully!\nFCM Token: ${fcmToken?.substring(0, 20)}...';
      });
    } catch (e) {
      setState(() {
        _status = 'Firebase connection failed: $e';
      });
    }
  }

  Future<void> _testAuthentication() async {
    if (_isLogin) {
      await _testLogin();
    } else {
      await _testRegistration();
    }
  }

  Future<void> _testLogin() async {
    setState(() {
      _status = 'Testing login...';
    });

    try {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final success = await authViewModel.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      setState(() {
        _status = success 
            ? 'Login successful! User: ${authViewModel.userName}'
            : 'Login failed: ${authViewModel.error}';
      });
    } catch (e) {
      setState(() {
        _status = 'Login error: $e';
      });
    }
  }

  Future<void> _testRegistration() async {
    setState(() {
      _status = 'Testing registration...';
    });

    try {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final success = await authViewModel.registerParent(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      setState(() {
        _status = success 
            ? 'Registration successful! User: ${authViewModel.userName}'
            : 'Registration failed: ${authViewModel.error}';
      });
    } catch (e) {
      setState(() {
        _status = 'Registration error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Firebase Test'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  _status,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Firebase Connection Test
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _testFirebaseConnection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Test Firebase Connection',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Toggle Login/Register
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => setState(() => _isLogin = true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isLogin ? AppColors.primary : Colors.grey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Login'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => setState(() => _isLogin = false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: !_isLogin ? AppColors.primary : Colors.grey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Register'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Name field (for registration)
              if (!_isLogin) ...[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Email field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),

              // Password field
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 24),

              // Test Authentication Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _testAuthentication,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _isLogin ? 'Test Login' : 'Test Registration',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Clear Fields Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    _emailController.clear();
                    _passwordController.clear();
                    _nameController.clear();
                    setState(() {
                      _status = 'Fields cleared';
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Clear Fields',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
