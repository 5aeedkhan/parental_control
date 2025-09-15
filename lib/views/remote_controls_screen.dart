import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class RemoteControlsScreen extends StatefulWidget {
  const RemoteControlsScreen({super.key});

  @override
  State<RemoteControlsScreen> createState() => _RemoteControlsScreenState();
}

class _RemoteControlsScreenState extends State<RemoteControlsScreen> {
  String _selectedDevice = 'Emma\'s iPhone';
  bool _isDeviceLocked = false;
  bool _isInternetPaused = false;
  bool _isAppBlockingEnabled = false;

  final List<String> _devices = ['Emma\'s iPhone', 'Emma\'s iPad'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Remote Controls'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refreshDeviceStatus(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Device Selector
          _buildDeviceSelector(),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Device Status
                  _buildDeviceStatus(),
                  const SizedBox(height: 24),
                  
                  // Quick Actions
                  _buildQuickActions(),
                  const SizedBox(height: 24),
                  
                  // App Controls
                  _buildAppControls(),
                  const SizedBox(height: 24),
                  
                  // Internet Controls
                  _buildInternetControls(),
                  const SizedBox(height: 24),
                  
                  // Emergency Controls
                  _buildEmergencyControls(),
                  const SizedBox(height: 24),
                  
                  // Scheduled Controls
                  _buildScheduledControls(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.phone_android,
            color: AppColors.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          const Text(
            'Select Device:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedDevice,
              onChanged: (value) => setState(() => _selectedDevice = value!),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: _devices.map((device) => DropdownMenuItem(
                value: device,
                child: Text(device),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceStatus() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Device Status',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatusItem(
                  'Battery',
                  '78%',
                  Icons.battery_charging_full,
                  Colors.green,
                ),
              ),
              Expanded(
                child: _buildStatusItem(
                  'Last Seen',
                  '2 min ago',
                  Icons.access_time,
                  Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatusItem(
                  'Location',
                  'Home',
                  Icons.location_on,
                  Colors.orange,
                ),
              ),
              Expanded(
                child: _buildStatusItem(
                  'WiFi',
                  'Connected',
                  Icons.wifi,
                  Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionButton(
                  'Lock Device',
                  Icons.lock,
                  Colors.red,
                  _isDeviceLocked,
                  () => _toggleDeviceLock(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionButton(
                  'Pause Internet',
                  Icons.wifi_off,
                  Colors.orange,
                  _isInternetPaused,
                  () => _toggleInternetPause(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionButton(
                  'Block Apps',
                  Icons.block,
                  Colors.purple,
                  _isAppBlockingEnabled,
                  () => _toggleAppBlocking(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionButton(
                  'Send Message',
                  Icons.message,
                  Colors.blue,
                  false,
                  () => _sendMessage(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    String label,
    IconData icon,
    Color color,
    bool isActive,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isActive ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? color : color.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : color,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppControls() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'App Controls',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildAppControlItem('YouTube', true, Colors.red),
          _buildAppControlItem('Instagram', false, Colors.purple),
          _buildAppControlItem('TikTok', true, Colors.black),
          _buildAppControlItem('Games', false, Colors.orange),
          _buildAppControlItem('Social Media', true, Colors.blue),
        ],
      ),
    );
  }

  Widget _buildAppControlItem(String appName, bool isBlocked, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isBlocked ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isBlocked ? color.withOpacity(0.3) : Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isBlocked ? Icons.block : Icons.check_circle,
            color: isBlocked ? color : Colors.green,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              appName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Switch(
            value: isBlocked,
            onChanged: (value) => _toggleAppBlock(appName, value),
            activeColor: color,
          ),
        ],
      ),
    );
  }

  Widget _buildInternetControls() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Internet Controls',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildInternetControlItem('WiFi', true, Icons.wifi),
          _buildInternetControlItem('Mobile Data', false, Icons.signal_cellular_alt),
          _buildInternetControlItem('Bluetooth', true, Icons.bluetooth),
          _buildInternetControlItem('Hotspot', false, Icons.wifi_tethering),
        ],
      ),
    );
  }

  Widget _buildInternetControlItem(String name, bool isEnabled, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isEnabled ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isEnabled ? Colors.green.withOpacity(0.3) : Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isEnabled ? Colors.green : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: (value) => _toggleInternetControl(name, value),
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyControls() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning,
                color: Colors.red,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Emergency Controls',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Use these controls only in emergency situations',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _emergencyLock(),
                  icon: const Icon(Icons.lock, size: 18),
                  label: const Text('Emergency Lock'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _emergencyShutdown(),
                  icon: const Icon(Icons.power_settings_new, size: 18),
                  label: const Text('Shutdown'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScheduledControls() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Scheduled Controls',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton.icon(
                onPressed: () => _addScheduledControl(),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Schedule'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildScheduledItem('Bedtime Lock', '9:00 PM - 7:00 AM', true),
          _buildScheduledItem('Study Time', '3:00 PM - 5:00 PM', false),
          _buildScheduledItem('Meal Time', '12:00 PM - 1:00 PM', true),
        ],
      ),
    );
  }

  Widget _buildScheduledItem(String name, String time, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive ? Colors.blue.withOpacity(0.1) : Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive ? Colors.blue.withOpacity(0.3) : Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.schedule,
            color: isActive ? Colors.blue : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isActive,
            onChanged: (value) => _toggleScheduledControl(name, value),
            activeColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  // Action methods
  void _refreshDeviceStatus() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Device status refreshed'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _toggleDeviceLock() {
    setState(() {
      _isDeviceLocked = !_isDeviceLocked;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isDeviceLocked ? 'Device locked' : 'Device unlocked'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _toggleInternetPause() {
    setState(() {
      _isInternetPaused = !_isInternetPaused;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isInternetPaused ? 'Internet paused' : 'Internet resumed'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _toggleAppBlocking() {
    setState(() {
      _isAppBlockingEnabled = !_isAppBlockingEnabled;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isAppBlockingEnabled ? 'App blocking enabled' : 'App blocking disabled'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _sendMessage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Message'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'Enter your message',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Message sent')),
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _toggleAppBlock(String appName, bool isBlocked) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$appName ${isBlocked ? 'blocked' : 'unblocked'}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _toggleInternetControl(String name, bool isEnabled) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name ${isEnabled ? 'enabled' : 'disabled'}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _emergencyLock() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Lock'),
        content: const Text('Are you sure you want to emergency lock the device?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Emergency lock activated')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Lock'),
          ),
        ],
      ),
    );
  }

  void _emergencyShutdown() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Shutdown'),
        content: const Text('Are you sure you want to shutdown the device?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Device shutdown initiated')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Shutdown'),
          ),
        ],
      ),
    );
  }

  void _addScheduledControl() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add scheduled control feature coming soon')),
    );
  }

  void _toggleScheduledControl(String name, bool isActive) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name schedule ${isActive ? 'enabled' : 'disabled'}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
