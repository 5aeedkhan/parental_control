import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../viewmodels/auth_viewmodel.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Section
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Consumer<AuthViewModel>(
                builder: (context, authViewModel, child) {
                  return Text(
                    authViewModel.userName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  );
                },
              ),
              subtitle: Consumer<AuthViewModel>(
                builder: (context, authViewModel, child) {
                  return Text(authViewModel.userEmail);
                },
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to profile settings
              },
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Settings Options
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.notifications, color: AppColors.primary),
                  title: const Text('Notifications'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigate to notification settings
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.security, color: AppColors.primary),
                  title: const Text('Privacy & Security'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigate to privacy settings
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.devices, color: AppColors.primary),
                  title: const Text('Device Management'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigate to device management
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.help, color: AppColors.primary),
                  title: const Text('Help & Support'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigate to help
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Logout Button
          Card(
            child: ListTile(
              leading: const Icon(Icons.logout, color: AppColors.error),
              title: const Text(
                'Logout',
                style: TextStyle(color: AppColors.error),
              ),
              onTap: () async {
                final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
                await authViewModel.logout();
                if (context.mounted) {
                  context.go('/auth');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
