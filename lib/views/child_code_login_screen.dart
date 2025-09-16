import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../services/short_code_service.dart';
import 'child_dashboard_screen.dart';

class ChildCodeLoginScreen extends StatefulWidget {
  const ChildCodeLoginScreen({super.key});

  @override
  State<ChildCodeLoginScreen> createState() => _ChildCodeLoginScreenState();
}

class _ChildCodeLoginScreenState extends State<ChildCodeLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  
  bool _isLoading = false;
  
  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _loginWithCode() async {
    if (!_formKey.currentState!.validate()) return;
    if (_codeController.text.length != 6) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      
      // TODO: Implement short code authentication
      // For now, we'll simulate a successful login
      // In a real implementation, this would:
      // 1. Look up the code in Firestore
      // 2. Check if it's valid and not expired
      // 3. Login as the associated child account
      
      // Simulate login delay
      await Future.delayed(const Duration(seconds: 1));
      
      // For demo purposes, we'll create a mock child login
      // In real implementation, this would use the code to find the child account
      final success = await _authenticateWithCode(_codeController.text.trim());
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Welcome! Setting up your device...'),
            backgroundColor: AppColors.success,
          ),
        );
        
        // Navigate to child dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ChildDashboardScreen(),
          ),
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid code. Please check with your parent.'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  // Authenticate with short code
  Future<bool> _authenticateWithCode(String code) async {
    try {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      
      // Use the new login method from AuthViewModel
      final success = await authViewModel.loginChildWithCode(code);
      
      if (success) {
        print('Child authenticated successfully with code');
        return true;
      } else {
        print('Authentication failed: ${authViewModel.error}');
        return false;
      }
    } catch (e) {
      print('Authentication error: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                
                // Logo and Title
                Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.child_care,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Child Login',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter the code your parent gave you',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                
                const SizedBox(height: 48),
                
                // Code Input Field
                TextFormField(
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                    fontFamily: 'monospace',
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Enter 6-digit code',
                    hintText: '123456',
                    hintStyle: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 8,
                      color: AppColors.textSecondary.withOpacity(0.5),
                      fontFamily: 'monospace',
                    ),
                    counterText: '', // Hide character counter
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.primary, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.primary, width: 2),
                    ),
                    prefixIcon: const Icon(Icons.vpn_key),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the code';
                    }
                    if (value.length != 6) {
                      return 'Code must be 6 digits';
                    }
                    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
                      return 'Code must contain only numbers';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    // Auto-submit when 6 digits are entered
                    if (value.length == 6) {
                      _loginWithCode();
                    }
                  },
                ),
                
                const SizedBox(height: 32),
                
                // Login Button
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _loginWithCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Help Text
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Need Help?',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ask your parent for the 6-digit code. They can find it in the parent app after setting up your account.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Back to Parent Login
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Parent Login',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
