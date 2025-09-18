import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../viewmodels/dashboard_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../models/user_model.dart';
import 'dashboard_screen.dart';
import 'screen_time_monitoring_screen.dart';
import 'apps_control_screen.dart';
import 'location_monitoring_screen.dart';
import 'ai_alerts_screen.dart';
import 'location_screen.dart';
import 'alerts_screen.dart';
import 'settings_screen.dart';
import 'content_filtering_screen.dart';
import 'activity_monitoring_screen.dart';
import 'remote_controls_screen.dart';
import 'firebase_test_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  bool _showMoreMenu = false;

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      id: 'dashboard',
      label: 'Home',
      icon: Icons.home,
      screen: const DashboardScreen(),
    ),
    NavigationItem(
      id: 'screentime',
      label: 'Screen Time',
      icon: Icons.access_time,
      screen: const ScreenTimeMonitoringScreen(),
    ),
    NavigationItem(
      id: 'apps',
      label: 'Apps',
      icon: Icons.apps,
      screen: const AppsControlScreen(),
    ),
    NavigationItem(
      id: 'location',
      label: 'Location',
      icon: Icons.location_on,
      screen: const LocationMonitoringScreen(),
    ),
    NavigationItem(
      id: 'alerts',
      label: 'Alerts',
      icon: Icons.notifications,
      screen: const AIAlertsScreen(),
    ),
  ];

  final List<NavigationItem> _moreItems = [
    NavigationItem(
      id: 'content_filtering',
      label: 'Content Filtering',
      icon: Icons.block,
      screen: const ContentFilteringScreen(),
    ),
    NavigationItem(
      id: 'activity_monitoring',
      label: 'Activity Monitoring',
      icon: Icons.analytics,
      screen: const ActivityMonitoringScreen(),
    ),
    NavigationItem(
      id: 'remote_controls',
      label: 'Remote Controls',
      icon: Icons.control_camera,
      screen: const RemoteControlsScreen(),
    ),
    NavigationItem(
      id: 'settings',
      label: 'Settings',
      icon: Icons.settings,
      screen: const SettingsScreen(),
    ),
    NavigationItem(
      id: 'firebase_test',
      label: 'Firebase Test',
      icon: Icons.bug_report,
      screen: const FirebaseTestScreen(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize dashboard data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DashboardViewModel>(context, listen: false).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final userType = authViewModel.userType;
    
    // Show different interfaces based on user type
    if (userType == UserType.parent) {
      return _buildParentInterface();
    } else if (userType == UserType.child) {
      return _buildChildInterface();
    } else {
      // Fallback to parent interface
      return _buildParentInterface();
    }
  }

  Widget _buildParentInterface() {
    return Scaffold(
      body: Stack(
        children: [
          // Main Content
          _navigationItems[_currentIndex].screen,
          
          // More Menu Overlay
          if (_showMoreMenu)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildMoreMenu(),
            ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildChildInterface() {
    return Scaffold(
      body: _navigationItems[_currentIndex].screen,
      bottomNavigationBar: _buildChildBottomNavigation(),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              // Main Navigation Items
              ..._navigationItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isActive = _currentIndex == index;
                
                return Expanded(
                  child: _buildNavItem(
                    item: item,
                    isActive: isActive,
                    onTap: () {
                      setState(() {
                        _currentIndex = index;
                        _showMoreMenu = false;
                      });
                    },
                  ),
                );
              }),
              
              // More Button
              Expanded(
                child: _buildNavItem(
                  item: NavigationItem(
                    id: 'more',
                    label: 'More',
                    icon: Icons.more_horiz,
                    screen: const SizedBox.shrink(),
                  ),
                  isActive: _showMoreMenu,
                  onTap: () {
                    setState(() {
                      _showMoreMenu = !_showMoreMenu;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required NavigationItem item,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Icon(
                  item.icon,
                  color: isActive ? Colors.white : AppColors.textSecondary,
                  size: 24,
                ),
                // Alert Badge for Alerts tab
                if (item.id == 'alerts' && _hasUnreadAlerts())
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? Colors.white : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreMenu() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // More Items
          Padding(
            padding: const EdgeInsets.all(20),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemCount: _moreItems.length,
              itemBuilder: (context, index) {
                final item = _moreItems[index];
                return _buildMoreItem(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreItem(NavigationItem item) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showMoreMenu = false;
        });
        // Navigate to the selected screen
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => item.screen),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.border,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                item.icon,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              // Limited navigation for children
              Expanded(
                child: _buildNavItem(
                  item: NavigationItem(
                    id: 'dashboard',
                    label: 'Home',
                    icon: Icons.home,
                    screen: const SizedBox.shrink(),
                  ),
                  isActive: _currentIndex == 0,
                  onTap: () {
                    setState(() {
                      _currentIndex = 0;
                    });
                  },
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  item: NavigationItem(
                    id: 'screen_time',
                    label: 'Usage',
                    icon: Icons.access_time,
                    screen: const SizedBox.shrink(),
                  ),
                  isActive: _currentIndex == 1,
                  onTap: () {
                    setState(() {
                      _currentIndex = 1;
                    });
                  },
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  item: NavigationItem(
                    id: 'alerts',
                    label: 'Alerts',
                    icon: Icons.notifications,
                    screen: const SizedBox.shrink(),
                  ),
                  isActive: _currentIndex == 4,
                  onTap: () {
                    setState(() {
                      _currentIndex = 4;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _hasUnreadAlerts() {
    final dashboardViewModel = Provider.of<DashboardViewModel>(context, listen: false);
    return dashboardViewModel.unreadAlertsCount > 0;
  }
}

class NavigationItem {
  final String id;
  final String label;
  final IconData icon;
  final Widget screen;

  NavigationItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.screen,
  });
}
