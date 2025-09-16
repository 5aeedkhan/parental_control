import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../constants/app_colors.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../models/device_model.dart';
import '../services/firestore_service.dart';
import '../services/short_code_service.dart';

class DeviceSetupScreen extends StatefulWidget {
  const DeviceSetupScreen({super.key});

  @override
  State<DeviceSetupScreen> createState() => _DeviceSetupScreenState();
}

class _DeviceSetupScreenState extends State<DeviceSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _modelController = TextEditingController();
  
  bool _isLoading = false;
  String? _deviceId;
  String? _platform;
  String? _osVersion;
  
  @override
  void initState() {
    super.initState();
    _getDeviceInfo();
  }

  Future<void> _getDeviceInfo() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      
      if (Theme.of(context).platform == TargetPlatform.android) {
        final androidInfo = await deviceInfo.androidInfo;
        setState(() {
          _deviceId = androidInfo.id;
          _platform = 'Android';
          _osVersion = '${androidInfo.version.release} (API ${androidInfo.version.sdkInt})';
          _modelController.text = '${androidInfo.brand} ${androidInfo.model}';
        });
      } else if (Theme.of(context).platform == TargetPlatform.iOS) {
        final iosInfo = await deviceInfo.iosInfo;
        setState(() {
          _deviceId = iosInfo.identifierForVendor;
          _platform = 'iOS';
          _osVersion = '${iosInfo.systemName} ${iosInfo.systemVersion}';
          _modelController.text = '${iosInfo.name}';
        });
      } else {
        setState(() {
          _deviceId = 'device_${DateTime.now().millisecondsSinceEpoch}';
          _platform = 'Unknown';
          _osVersion = 'Unknown';
        });
      }
    } catch (e) {
      setState(() {
        _deviceId = 'device_${DateTime.now().millisecondsSinceEpoch}';
        _platform = 'Unknown';
        _osVersion = 'Unknown';
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _modelController.dispose();
    super.dispose();
  }

  Future<void> _addDevice() async {
    if (!_formKey.currentState!.validate()) return;
    if (_deviceId == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final currentUser = authViewModel.currentUser;
      
      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }

      // Create device model
      final device = DeviceModel(
        id: _deviceId!,
        name: _nameController.text.trim(),
        platform: _platform ?? 'unknown',
        model: _modelController.text.trim(),
        osVersion: _osVersion ?? 'unknown',
        ownerId: currentUser.id,
        isOnline: true,
        lastSeen: DateTime.now(),
        batteryLevel: 85, // Simulated
        isCharging: false,
        dataUsage: 0.0,
        settings: {
          'screenTimeLimit': 360, // 6 hours in minutes
          'bedtimeEnabled': true,
          'appRestrictions': {},
        },
        createdAt: DateTime.now(),
      );

      // Save to Firestore
      final firestoreService = FirestoreService.instance;
      await firestoreService.addDevice(device);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Device added successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        
        // Show code generation dialog - use current user ID as the device owner
        _showCodeGenerationDialog(currentUser.id);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add device: $e'),
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

  void _showCodeGenerationDialog(String deviceOwnerId) async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final currentUser = authViewModel.currentUser;
    
    if (currentUser == null) return;
    
    try {
      // For device setup, we need to generate a code for a child to use this device
      // Since this is a monitoring device, we'll use the first child ID if available
      final childId = authViewModel.childIds.isNotEmpty 
          ? authViewModel.childIds.first 
          : deviceOwnerId;
      
      // Generate and store short code in Firestore
      final shortCodeService = ShortCodeService();
      final shortCode = await shortCodeService.generateShortCode(
        childId: childId, // Use the child's ID
        parentId: currentUser.id, // Use the parent's ID
        childName: _nameController.text.trim(),
      );
      
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Device Setup Complete!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Share this code with your child to log in on this monitoring device:'),
                const SizedBox(height: 20),
                
                // Short Code
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Child Login Code',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        shortCode,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          letterSpacing: 4,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info, color: Colors.blue, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'The child should enter this code on their device to complete the setup. The code is valid for 24 hours.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Go back to dashboard
                },
                child: const Text('Done'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate login code: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Add Device'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'Add a new device to monitor',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This device will be monitored for screen time, location, and app usage.',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Device Information Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Device Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Device ID
                        _buildInfoRow('Device ID', _deviceId ?? 'Loading...'),
                        const SizedBox(height: 12),
                        
                        // Platform
                        _buildInfoRow('Platform', _platform ?? 'Loading...'),
                        const SizedBox(height: 12),
                        
                        // OS Version
                        _buildInfoRow('OS Version', _osVersion ?? 'Loading...'),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Device Name Input
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Device Name',
                    hintText: 'e.g., John\'s iPhone, Sarah\'s iPad',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.phone_android),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a device name';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Device Model Input
                TextFormField(
                  controller: _modelController,
                  decoration: InputDecoration(
                    labelText: 'Device Model',
                    hintText: 'e.g., iPhone 12, Samsung Galaxy S21',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.devices),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the device model';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 32),
                
                // Monitoring Information
                Card(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'What will be monitored?',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        
                        _buildMonitoringItem(
                          Icons.access_time,
                          'Screen Time',
                          'Daily usage patterns and limits',
                        ),
                        const SizedBox(height: 8),
                        
                        _buildMonitoringItem(
                          Icons.location_on,
                          'Location',
                          'Safe zones and location history',
                        ),
                        const SizedBox(height: 8),
                        
                        _buildMonitoringItem(
                          Icons.apps,
                          'App Usage',
                          'Which apps are being used and for how long',
                        ),
                        const SizedBox(height: 8),
                        
                        _buildMonitoringItem(
                          Icons.warning,
                          'Safety Alerts',
                          'Inappropriate content and cyberbullying detection',
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Add Device Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _addDevice,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
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
                            'Add Device',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Privacy Notice
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.warning.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.privacy_tip,
                        color: AppColors.warning,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Privacy Notice: This device will be monitored for child safety. All data is encrypted and stored securely.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.warning,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildMonitoringItem(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: AppColors.textSecondary,
          size: 16,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
