import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../viewmodels/auth_viewmodel.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  
  bool _isLogin = true;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    
    bool success = false;
    if (_isLogin) {
      success = await authViewModel.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
    } else {
      success = await authViewModel.registerParent(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }

    if (success && mounted) {
      context.go('/main');
    }
  }

  Future<void> _handleGoogleSignIn() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    
    final success = await authViewModel.signInWithGoogle();
    
    if (success && mounted) {
      context.go('/main');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.secondary,
              Color(0xFFEC4899),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 
                          MediaQuery.of(context).padding.top - 
                          MediaQuery.of(context).padding.bottom - 48,
              ),
              child: Column(
                children: [
                const SizedBox(height: 40),
                
                // Logo and Title
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.shield,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        AppConstants.appName,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isLogin ? 'Welcome back!' : 'Create your account',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Auth Form
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Name Field (Register only)
                            if (!_isLogin) ...[
                              TextFormField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: 'Full Name',
                                  prefixIcon: Icon(Icons.person),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                            ],
                            
                            // Email Field
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            
                            // Password Field
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            
                            // Submit Button
                            Consumer<AuthViewModel>(
                              builder: (context, authViewModel, child) {
                                return ElevatedButton(
                                  onPressed: authViewModel.isLoading
                                      ? null
                                      : _handleSubmit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: authViewModel.isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                          ),
                                        )
                                      : Text(
                                          _isLogin ? 'Sign In' : 'Create Account',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                );
                              },
                            ),
                            
                             const SizedBox(height: 16),
                             
                             // Divider
                             Row(
                               children: [
                                 Expanded(
                                   child: Divider(
                                     color: Colors.grey.withOpacity(0.3),
                                     thickness: 1,
                                   ),
                                 ),
                                 Padding(
                                   padding: const EdgeInsets.symmetric(horizontal: 16),
                                   child: Text(
                                     'or',
                                     style: TextStyle(
                                       color: Colors.grey.withOpacity(0.7),
                                       fontSize: 14,
                                       fontWeight: FontWeight.w500,
                                     ),
                                   ),
                                 ),
                                 Expanded(
                                   child: Divider(
                                     color: Colors.grey.withOpacity(0.3),
                                     thickness: 1,
                                   ),
                                 ),
                               ],
                             ),
                             
                             // Forgot Password Link (Login only)
                             if (_isLogin) ...[
                               const SizedBox(height: 12),
                               Align(
                                 alignment: Alignment.centerRight,
                                 child: TextButton(
                                   onPressed: () {
                                     // TODO: Implement forgot password
                                     ScaffoldMessenger.of(context).showSnackBar(
                                       const SnackBar(
                                         content: Text('Forgot password feature coming soon!'),
                                         duration: Duration(seconds: 2),
                                       ),
                                     );
                                   },
                                   child: Text(
                                     'Forgot password?',
                                     style: TextStyle(
                                       color: AppColors.primary,
                                       fontSize: 14,
                                       fontWeight: FontWeight.w500,
                                     ),
                                   ),
                                 ),
                               ),
                             ],
                             
                             const SizedBox(height: 16),
                             
                             // Google Sign-In Button
                             Consumer<AuthViewModel>(
                               builder: (context, authViewModel, child) {
                                 return Container(
                                   width: double.infinity,
                                   height: 56,
                                   decoration: BoxDecoration(
                                     color: Colors.white,
                                     borderRadius: BorderRadius.circular(12),
                                     border: Border.all(
                                       color: Colors.grey.withOpacity(0.2),
                                       width: 1,
                                     ),
                                     boxShadow: [
                                       BoxShadow(
                                         color: Colors.black.withOpacity(0.05),
                                         blurRadius: 4,
                                         offset: const Offset(0, 2),
                                       ),
                                     ],
                                   ),
                                   child: Material(
                                     color: Colors.transparent,
                                     child: InkWell(
                                       borderRadius: BorderRadius.circular(12),
                                       onTap: authViewModel.isLoading
                                           ? null
                                           : _handleGoogleSignIn,
                                       child: Padding(
                                         padding: const EdgeInsets.symmetric(horizontal: 16),
                                         child: Row(
                                           mainAxisAlignment: MainAxisAlignment.center,
                                           children: [
                                             // Google Logo
                                             Container(
                                               width: 20,
                                               height: 20,
                                               decoration: const BoxDecoration(
                                                 image: DecorationImage(
                                                   image: NetworkImage(
                                                     'https://developers.google.com/identity/images/g-logo.png',
                                                   ),
                                                   fit: BoxFit.contain,
                                                 ),
                                               ),
                                             ),
                                             const SizedBox(width: 12),
                                             Text(
                                               'Continue with Google',
                                               style: TextStyle(
                                                 fontSize: 16,
                                                 fontWeight: FontWeight.w500,
                                                 color: Colors.grey[800],
                                               ),
                                             ),
                                           ],
                                         ),
                                       ),
                                     ),
                                   ),
                                 );
                               },
                             ),
                             
                             const SizedBox(height: 12),
                             
                             // Facebook Sign-In Button
                             Consumer<AuthViewModel>(
                               builder: (context, authViewModel, child) {
                                 return Container(
                                   width: double.infinity,
                                   height: 56,
                                   decoration: BoxDecoration(
                                     color: Colors.white,
                                     borderRadius: BorderRadius.circular(12),
                                     border: Border.all(
                                       color: Colors.grey.withOpacity(0.2),
                                       width: 1,
                                     ),
                                     boxShadow: [
                                       BoxShadow(
                                         color: Colors.black.withOpacity(0.05),
                                         blurRadius: 4,
                                         offset: const Offset(0, 2),
                                       ),
                                     ],
                                   ),
                                   child: Material(
                                     color: Colors.transparent,
                                     child: InkWell(
                                       borderRadius: BorderRadius.circular(12),
                                       onTap: authViewModel.isLoading
                                           ? null
                                           : () {
                                               // TODO: Implement Facebook Sign-In later
                                               ScaffoldMessenger.of(context).showSnackBar(
                                                 const SnackBar(
                                                   content: Text('Facebook Sign-In coming soon!'),
                                                   duration: Duration(seconds: 2),
                                                 ),
                                               );
                                             },
                                       child: Padding(
                                         padding: const EdgeInsets.symmetric(horizontal: 16),
                                         child: Row(
                                           mainAxisAlignment: MainAxisAlignment.center,
                                           children: [
                                             // Facebook Logo
                                             Container(
                                               width: 20,
                                               height: 20,
                                               decoration: const BoxDecoration(
                                                 color: Color(0xFF1877F2),
                                                 shape: BoxShape.circle,
                                               ),
                                               child: const Icon(
                                                 Icons.facebook,
                                                 color: Colors.white,
                                                 size: 12,
                                               ),
                                             ),
                                             const SizedBox(width: 12),
                                             Text(
                                               'Continue with Facebook',
                                               style: TextStyle(
                                                 fontSize: 16,
                                                 fontWeight: FontWeight.w500,
                                                 color: Colors.grey[800],
                                               ),
                                             ),
                                           ],
                                         ),
                                       ),
                                     ),
                                   ),
                                 );
                               },
                             ),
                            
                            // Error Message
                            Consumer<AuthViewModel>(
                              builder: (context, authViewModel, child) {
                                if (authViewModel.error != null) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: AppColors.error.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: AppColors.error.withOpacity(0.3),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.error_outline,
                                            color: AppColors.error,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              authViewModel.error!,
                                              style: TextStyle(
                                                color: AppColors.error,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Toggle Auth Mode
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isLogin
                            ? 'Don\'t have an account? '
                            : 'Already have an account? ',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: _toggleAuthMode,
                        child: Text(
                          _isLogin ? 'Sign Up' : 'Sign In',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
