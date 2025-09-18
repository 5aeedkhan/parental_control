import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_card.dart';

class LocationMonitoringScreen extends StatefulWidget {
  const LocationMonitoringScreen({super.key});

  @override
  State<LocationMonitoringScreen> createState() => _LocationMonitoringScreenState();
}

class _LocationMonitoringScreenState extends State<LocationMonitoringScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _locationTracking = true;
  bool _safeZoneAlerts = true;
  bool _keepLocationHistory = true;

  final Map<String, dynamic> _currentLocation = {
    'name': 'Emma\'s School',
    'address': '123 Education St, City Center',
    'coordinates': {'lat': 40.7128, 'lng': -74.0060},
    'lastUpdated': '2 minutes ago',
    'zone': 'safe'
  };

  final List<Map<String, dynamic>> _safeZones = [
    { 'name': 'Home', 'address': '456 Family Ave', 'radius': '100m', 'status': 'active', 'icon': Icons.home },
    { 'name': 'School', 'address': '123 Education St', 'radius': '200m', 'status': 'active', 'icon': Icons.school },
    { 'name': 'Grandma\'s House', 'address': '789 Elder Rd', 'radius': '150m', 'status': 'active', 'icon': Icons.home },
    { 'name': 'Library', 'address': '321 Book St', 'radius': '50m', 'status': 'inactive', 'icon': Icons.local_library },
  ];

  final List<Map<String, dynamic>> _locationHistory = [
    { 'time': '14:30', 'location': 'Emma\'s School', 'duration': '6h 15m', 'status': 'safe' },
    { 'time': '08:15', 'location': 'Home', 'duration': '12h 30m', 'status': 'safe' },
    { 'time': '19:45', 'location': 'Unknown Location', 'duration': '15m', 'status': 'alert' },
    { 'time': '17:30', 'location': 'Soccer Field', 'duration': '2h', 'status': 'safe' },
    { 'time': '15:00', 'location': 'Emma\'s School', 'duration': '7h', 'status': 'safe' },
  ];

  final List<Map<String, dynamic>> _alerts = [
    { 'time': 'Yesterday 19:45', 'message': 'Left safe zone without notification', 'severity': 'medium' },
    { 'time': '2 days ago', 'message': 'Device turned off during school hours', 'severity': 'high' },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Location',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          ElevatedButton.icon(
            onPressed: () => _showAddZoneDialog(),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Zone'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          const SizedBox(width: 16),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: TabBar(
            controller: _tabController,
            tabs: [
              const Tab(text: 'Safe Zones'),
              const Tab(text: 'History'),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Alerts'),
                    if (_alerts.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${_alerts.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Current Location
            Container(
              padding: const EdgeInsets.all(12),
              child: _buildCurrentLocation(),
            ),
            
            // Tab Content
            SizedBox(
              height: 300,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildSafeZonesTab(),
                  _buildHistoryTab(),
                  _buildAlertsTab(),
                ],
              ),
            ),
            
            // Location Settings
            Container(
              padding: const EdgeInsets.all(12),
              child: _buildLocationSettings(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentLocation() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.green, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Current Location',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentLocation['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _currentLocation['address'],
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Last updated: ${_currentLocation['lastUpdated']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Safe Zone',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Mock Map
          Container(
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFE3F2FD), Color(0xFFE8F5E8)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                // Grid pattern
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.2,
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 8,
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 1,
                      ),
                      itemCount: 48,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.gray300, width: 0.5),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                
                // Location marker
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 10,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Emma\'s Location',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Street view label
                const Positioned(
                  top: 8,
                  left: 8,
                  child: Text(
                    'Street View',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafeZonesTab() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _safeZones.length,
      itemBuilder: (context, index) {
        final zone = _safeZones[index];
        return _buildSafeZoneCard(zone);
      },
    );
  }

  Widget _buildSafeZoneCard(Map<String, dynamic> zone) {
    final isActive = zone['status'] == 'active';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: CustomCard(
        child: Row(
          children: [
            // Zone Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                zone['icon'],
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            
            // Zone Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    zone['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    zone['address'],
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Radius: ${zone['radius']}',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            // Status and Switch
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isActive 
                        ? AppColors.primary.withOpacity(0.1)
                        : AppColors.gray400.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    zone['status'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isActive ? AppColors.primary : AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Switch(
                  value: isActive,
                  onChanged: (value) {
                    setState(() {
                      zone['status'] = value ? 'active' : 'inactive';
                    });
                  },
                  activeColor: AppColors.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTab() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _locationHistory.length,
      itemBuilder: (context, index) {
        final entry = _locationHistory[index];
        return _buildHistoryCard(entry);
      },
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> entry) {
    final isSafe = entry['status'] == 'safe';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: CustomCard(
        child: Row(
          children: [
            // Time Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.gray400.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.access_time,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            
            // History Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry['location'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${entry['time']} • Duration: ${entry['duration']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isSafe 
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isSafe ? 'Safe' : 'Alert',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isSafe ? Colors.green : Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertsTab() {
    if (_alerts.isEmpty) {
      return Center(
        child: CustomCard(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                const Icon(
                  Icons.shield,
                  size: 48,
                  color: Colors.green,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No location alerts',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Emma is staying within safe zones',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _alerts.length,
      itemBuilder: (context, index) {
        final alert = _alerts[index];
        return _buildAlertCard(alert);
      },
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> alert) {
    final isHighSeverity = alert['severity'] == 'high';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: CustomCard(
        child: Row(
          children: [
            // Alert Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isHighSeverity 
                    ? Colors.red.withOpacity(0.1)
                    : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.warning,
                color: isHighSeverity ? Colors.red : Colors.orange,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            
            // Alert Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alert['message'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    alert['time'],
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            // Severity Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isHighSeverity 
                    ? Colors.red.withOpacity(0.1)
                    : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                alert['severity'],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isHighSeverity ? Colors.red : Colors.orange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSettings() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Location Settings',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          
          // Location Tracking
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Location Tracking',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Track device location in real-time',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _locationTracking,
                onChanged: (value) {
                  setState(() {
                    _locationTracking = value;
                  });
                },
                activeColor: AppColors.primary,
              ),
            ],
          ),
          
          Divider(color: AppColors.gray400, height: 8),
          
          // Safe Zone Alerts
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Safe Zone Alerts',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Get notified when leaving safe zones',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _safeZoneAlerts,
                onChanged: (value) {
                  setState(() {
                    _safeZoneAlerts = value;
                  });
                },
                activeColor: AppColors.primary,
              ),
            ],
          ),
          
          Divider(color: AppColors.gray400, height: 8),
          
          // Location History
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Location History',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Keep 30 days of location data',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _keepLocationHistory,
                onChanged: (value) {
                  setState(() {
                    _keepLocationHistory = value;
                  });
                },
                activeColor: AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddZoneDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Safe Zone'),
        content: const Text('Add safe zone functionality will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
