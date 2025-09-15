import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'content_filtering_screen.dart';
import 'remote_controls_screen.dart';
import 'activity_monitoring_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _locationTrackingEnabled = true;
  bool _appMonitoringEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'English';
  String _selectedTimeZone = 'UTC-5 (EST)';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _saveSettings(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Section
          _buildProfileSection(),
          const SizedBox(height: 16),
          
          // Account Settings
          _buildAccountSettings(),
          const SizedBox(height: 16),
          
          // Monitoring Settings
          _buildMonitoringSettings(),
          const SizedBox(height: 16),
          
          // App Settings
          _buildAppSettings(),
          const SizedBox(height: 16),
          
          // Advanced Settings
          _buildAdvancedSettings(),
          const SizedBox(height: 16),
          
          // Support & Help
          _buildSupportSection(),
          const SizedBox(height: 16),
          
          // Logout Button
          _buildLogoutSection(),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 16),
          Consumer<AuthViewModel>(
            builder: (context, authViewModel, child) {
              return Text(
                authViewModel.userName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: AppColors.textPrimary,
                ),
              );
            },
          ),
          const SizedBox(height: 4),
          Consumer<AuthViewModel>(
            builder: (context, authViewModel, child) {
              return Text(
                authViewModel.userEmail,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _editProfile(),
            icon: const Icon(Icons.edit, size: 18),
            label: const Text('Edit Profile'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSettings() {
    return _buildSettingsCard(
      'Account Settings',
      [
        _buildSettingsItem(
          'Change Password',
          Icons.lock,
          () => _changePassword(),
        ),
        _buildSettingsItem(
          'Two-Factor Authentication',
          Icons.security,
          () => _setupTwoFactor(),
        ),
        _buildSettingsItem(
          'Account Privacy',
          Icons.privacy_tip,
          () => _accountPrivacy(),
        ),
        _buildSettingsItem(
          'Data Export',
          Icons.download,
          () => _exportData(),
        ),
      ],
    );
  }

  Widget _buildMonitoringSettings() {
    return _buildSettingsCard(
      'Monitoring Settings',
      [
        _buildSwitchItem(
          'Notifications',
          'Receive alerts and updates',
          Icons.notifications,
          _notificationsEnabled,
          (value) => setState(() => _notificationsEnabled = value),
        ),
        _buildSwitchItem(
          'Location Tracking',
          'Track device location',
          Icons.location_on,
          _locationTrackingEnabled,
          (value) => setState(() => _locationTrackingEnabled = value),
        ),
        _buildSwitchItem(
          'App Monitoring',
          'Monitor app usage and activity',
          Icons.apps,
          _appMonitoringEnabled,
          (value) => setState(() => _appMonitoringEnabled = value),
        ),
      ],
    );
  }

  Widget _buildAppSettings() {
    return _buildSettingsCard(
      'App Settings',
      [
        _buildSwitchItem(
          'Dark Mode',
          'Use dark theme',
          Icons.dark_mode,
          _darkModeEnabled,
          (value) => setState(() => _darkModeEnabled = value),
        ),
        _buildDropdownItem(
          'Language',
          _selectedLanguage,
          Icons.language,
          ['English', 'Spanish', 'French', 'German'],
          (value) => setState(() => _selectedLanguage = value!),
        ),
        _buildDropdownItem(
          'Time Zone',
          _selectedTimeZone,
          Icons.access_time,
          ['UTC-5 (EST)', 'UTC-8 (PST)', 'UTC+0 (GMT)', 'UTC+1 (CET)'],
          (value) => setState(() => _selectedTimeZone = value!),
        ),
      ],
    );
  }

  Widget _buildAdvancedSettings() {
    return _buildSettingsCard(
      'Advanced Settings',
      [
        _buildSettingsItem(
          'Content Filtering',
          Icons.block,
          () => _openContentFiltering(),
        ),
        _buildSettingsItem(
          'Remote Controls',
          Icons.control_camera,
          () => _openRemoteControls(),
        ),
        _buildSettingsItem(
          'Activity Monitoring',
          Icons.analytics,
          () => _openActivityMonitoring(),
        ),
        _buildSettingsItem(
          'Backup & Sync',
          Icons.backup,
          () => _backupSettings(),
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return _buildSettingsCard(
      'Support & Help',
      [
        _buildSettingsItem(
          'Help Center',
          Icons.help,
          () => _openHelpCenter(),
        ),
        _buildSettingsItem(
          'Contact Support',
          Icons.support_agent,
          () => _contactSupport(),
        ),
        _buildSettingsItem(
          'Report Bug',
          Icons.bug_report,
          () => _reportBug(),
        ),
        _buildSettingsItem(
          'About',
          Icons.info,
          () => _showAbout(),
        ),
      ],
    );
  }

  Widget _buildLogoutSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: const Icon(Icons.logout, color: AppColors.error),
        title: const Text(
          'Logout',
          style: TextStyle(
            color: AppColors.error,
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: () => _showLogoutDialog(),
      ),
    );
  }

  Widget _buildSettingsCard(String title, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          ...children.map((child) => Column(
            children: [
              child,
              if (child != children.last) const Divider(height: 1),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: AppColors.textPrimary,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }

  Widget _buildSwitchItem(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }

  Widget _buildDropdownItem(
    String title,
    String value,
    IconData icon,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
      ),
      trailing: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        underline: Container(),
        items: options.map((option) => DropdownMenuItem(
          value: option,
          child: Text(option),
        )).toList(),
      ),
    );
  }

  // Action methods
  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings saved successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _editProfile() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: const Text('Profile editing feature coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _changePassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: const Text('Password change feature coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _setupTwoFactor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Two-Factor Authentication'),
        content: const Text('2FA setup feature coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _accountPrivacy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Account Privacy'),
        content: const Text('Privacy settings feature coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _exportData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text('Data export feature coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _openContentFiltering() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ContentFilteringScreen(),
      ),
    );
  }

  void _openRemoteControls() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RemoteControlsScreen(),
      ),
    );
  }

  void _openActivityMonitoring() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ActivityMonitoringScreen(),
      ),
    );
  }

  void _backupSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Backup & Sync'),
        content: const Text('Backup settings feature coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _openHelpCenter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help Center'),
        content: const Text('Help center feature coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _contactSupport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Support'),
        content: const Text('Contact support feature coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _reportBug() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Bug'),
        content: const Text('Bug reporting feature coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'FamilyGuard',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.security,
        size: 48,
        color: AppColors.primary,
      ),
      children: [
        const Text('A comprehensive parental control application designed to help parents monitor and manage their children\'s digital activities.'),
      ],
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
              await authViewModel.logout();
              if (context.mounted) {
                context.go('/auth');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
