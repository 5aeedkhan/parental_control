import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../constants/app_colors.dart';
import '../viewmodels/dashboard_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../providers/device_control_provider.dart';
import '../widgets/custom_card.dart';
import '../widgets/quick_action_button.dart';
import 'child_setup_screen.dart';
import 'device_setup_screen.dart';
import 'child_codes_management_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DashboardViewModel>(context, listen: false).init();
      
      // Initialize device control provider
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final deviceControlProvider = Provider.of<DeviceControlProvider>(context, listen: false);
      if (authViewModel.currentUser != null) {
        deviceControlProvider.loadDeviceControls(authViewModel.currentUser!.id);
        deviceControlProvider.startListening(authViewModel.currentUser!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Provider.of<DashboardViewModel>(context, listen: false).refresh();
          },
          child: Consumer<DashboardViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                );
              }
              
              return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(),
                const SizedBox(height: 24),
                
                // Quick Stats
                _buildQuickStats(),
                const SizedBox(height: 24),
                
                // AI Alerts
                _buildAlertsSection(),
                const SizedBox(height: 24),
                
                // Weekly Usage Chart
                _buildWeeklyUsageChart(),
                const SizedBox(height: 24),
                
                // App Usage Breakdown
                _buildAppUsageBreakdown(),
                const SizedBox(height: 24),
                
                // Device Status
                _buildDeviceStatus(),
                const SizedBox(height: 24),
                
                // Quick Actions
                _buildQuickActions(),
                const SizedBox(height: 24),
                
                // Device Control Status
                _buildDeviceControlStatus(),
                const SizedBox(height: 100), // Bottom padding for navigation
              ],
            ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer2<DashboardViewModel, AuthViewModel>(
      builder: (context, dashboardViewModel, authViewModel, child) {
        if (authViewModel.isParent) {
          return _buildParentHeader(authViewModel);
        } else {
          return _buildChildHeader(authViewModel);
        }
      },
    );
  }

  Widget _buildParentHeader(AuthViewModel authViewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good morning, ${authViewModel.userName}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Monitor and manage your children\'s devices',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.success.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Online',
                    style: TextStyle(
                      color: AppColors.success,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Add Child Button
        if (authViewModel.childIds.isEmpty)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChildSetupScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Child Device'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        
        // Manage Child Codes Button (when children exist)
        if (authViewModel.childIds.isNotEmpty) ...[
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChildCodesManagementScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.qr_code_2),
              label: const Text('Manage Child Login Codes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
        
        // Add Device Button (when child exists but no devices)
        if (authViewModel.childIds.isNotEmpty)
          Consumer<DashboardViewModel>(
            builder: (context, dashboardViewModel, child) {
              if (dashboardViewModel.devices.isEmpty) {
                return Column(
                  children: [
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DeviceSetupScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.phone_android),
                        label: const Text('Add Monitoring Device'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        
        // Real-time Data Status
        if (authViewModel.childIds.isNotEmpty)
          Consumer<DashboardViewModel>(
            builder: (context, dashboardViewModel, child) {
              final hasDevices = dashboardViewModel.devices.isNotEmpty;
              final isMonitoringActive = hasDevices && dashboardViewModel.devices.any((device) => device.isOnline);
              
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isMonitoringActive 
                      ? AppColors.success.withOpacity(0.1)
                      : AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isMonitoringActive 
                        ? AppColors.success.withOpacity(0.3)
                        : AppColors.warning.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isMonitoringActive ? Icons.sync : Icons.sync_problem,
                      color: isMonitoringActive ? AppColors.success : AppColors.warning,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isMonitoringActive 
                                ? 'Real-time Monitoring Active'
                                : hasDevices 
                                    ? 'Monitoring Setup Required'
                                    : 'No Devices Added',
                            style: TextStyle(
                              color: isMonitoringActive ? AppColors.success : AppColors.warning,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isMonitoringActive
                                ? 'Monitoring ${dashboardViewModel.devices.where((d) => d.isOnline).length} active device${dashboardViewModel.devices.where((d) => d.isOnline).length > 1 ? 's' : ''}'
                                : hasDevices
                                    ? 'Add devices to start monitoring'
                                    : 'Add monitoring devices to track child activity',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      isMonitoringActive ? Icons.check_circle : Icons.warning,
                      color: isMonitoringActive ? AppColors.success : AppColors.warning,
                      size: 20,
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildChildHeader(AuthViewModel authViewModel) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, ${authViewModel.userName}!',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Your device usage and activities',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'Monitored',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    return Consumer<DashboardViewModel>(
      builder: (context, viewModel, child) {
        return Row(
          children: [
            Expanded(
              child: CustomCard(
                gradient: AppColors.primaryGradient,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Today\'s Screen Time',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      viewModel.totalScreenTimeToday.inMinutes > 0 
                          ? _formatDuration(viewModel.totalScreenTimeToday)
                          : '0h 0m',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: 0.75, // This should be calculated from actual data
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      minHeight: 4,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '75% of daily limit (6h)',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomCard(
                gradient: AppColors.successGradient,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Current Location',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      viewModel.currentLocation != null 
                          ? viewModel.getLocationName()
                          : 'No location data',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.shield,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Safe Zone',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Updated ${_getTimeAgo(viewModel.currentLocation?.timestamp ?? DateTime.now())}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAlertsSection() {
    return Consumer<DashboardViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.criticalAlertsCount == 0) {
          return const SizedBox.shrink();
        }

        return CustomCard(
          gradient: AppColors.errorGradient,
          child: Row(
            children: [
              const Icon(
                Icons.warning,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${viewModel.criticalAlertsCount} new alerts:',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Potential cyberbullying detected in Instagram messages.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to alerts screen
                },
                child: const Text(
                  'View details',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWeeklyUsageChart() {
    return Consumer<DashboardViewModel>(
      builder: (context, viewModel, child) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly Screen Time',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
                child: RepaintBoundary(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 8,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        const style = TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        );
                        Widget text;
                        switch (value.toInt()) {
                          case 0:
                            text = const Text('Mon', style: style);
                            break;
                          case 1:
                            text = const Text('Tue', style: style);
                            break;
                          case 2:
                            text = const Text('Wed', style: style);
                            break;
                          case 3:
                            text = const Text('Thu', style: style);
                            break;
                          case 4:
                            text = const Text('Fri', style: style);
                            break;
                          case 5:
                            text = const Text('Sat', style: style);
                            break;
                          case 6:
                            text = const Text('Sun', style: style);
                            break;
                          default:
                            text = const Text('', style: style);
                            break;
                        }
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 16,
                          child: text,
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                      barGroups: _buildBarGroups(viewModel),
                    ),
              ),
            ),
          ),
        ],
      ),
        );
      },
    );
  }
  
  List<BarChartGroupData> _buildBarGroups(DashboardViewModel viewModel) {
    // Use real data if available
    if (viewModel.devices.isNotEmpty) {
      final deviceId = viewModel.devices.first.id;
      final weeklyData = viewModel.getWeeklyScreenTimeData(deviceId);
      
      if (weeklyData.isNotEmpty) {
        return weeklyData.asMap().entries.map((entry) {
          final index = entry.key;
          final data = entry.value;
          return BarChartGroupData(
            x: index,
            barRods: [BarChartRodData(
              toY: data['hours'] as double,
              color: AppColors.primary,
            )],
          );
        }).toList();
      }
    }
    
    // Show empty state for real data collection
    return List.generate(7, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [BarChartRodData(
          toY: 0.0,
          color: AppColors.textSecondary.withOpacity(0.3),
        )],
      );
    });
  }

  Widget _buildAppUsageBreakdown() {
    return Consumer<DashboardViewModel>(
      builder: (context, viewModel, child) {
        final breakdown = viewModel.getAppUsageBreakdown();
        
        return CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'App Categories Today',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              if (breakdown.values.every((value) => value == 0.0))
                const Center(
                  child: Text(
                    'No app usage data available',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                )
              else
                Row(
                  children: [
                    // Pie Chart
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: RepaintBoundary(
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 30,
                          sections: _buildPieChartSections(breakdown),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Legend
                    Expanded(
                      child: Column(
                        children: [
                          _buildLegendItem('Games', AppColors.gamesColor, breakdown['Games']?.round() ?? 0),
                          const SizedBox(height: 8),
                          _buildLegendItem('Social', AppColors.socialColor, breakdown['Social']?.round() ?? 0),
                          const SizedBox(height: 8),
                          _buildLegendItem('Education', AppColors.educationColor, breakdown['Education']?.round() ?? 0),
                          const SizedBox(height: 8),
                          _buildLegendItem('Other', AppColors.otherColor, breakdown['Other']?.round() ?? 0),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
  
  List<PieChartSectionData> _buildPieChartSections(Map<String, double> breakdown) {
    final sections = <PieChartSectionData>[];
    
    if (breakdown['Games'] != null && breakdown['Games']! > 0) {
      sections.add(PieChartSectionData(
        color: AppColors.gamesColor,
        value: breakdown['Games']!,
        title: '${breakdown['Games']!.round()}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ));
    }
    
    if (breakdown['Social'] != null && breakdown['Social']! > 0) {
      sections.add(PieChartSectionData(
        color: AppColors.socialColor,
        value: breakdown['Social']!,
        title: '${breakdown['Social']!.round()}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ));
    }
    
    if (breakdown['Education'] != null && breakdown['Education']! > 0) {
      sections.add(PieChartSectionData(
        color: AppColors.educationColor,
        value: breakdown['Education']!,
        title: '${breakdown['Education']!.round()}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ));
    }
    
    if (breakdown['Other'] != null && breakdown['Other']! > 0) {
      sections.add(PieChartSectionData(
        color: AppColors.otherColor,
        value: breakdown['Other']!,
        title: '${breakdown['Other']!.round()}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ));
    }
    
    return sections;
  }

  Widget _buildLegendItem(String label, Color color, int percentage) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Text(
          '$percentage%',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceStatus() {
    return Consumer<DashboardViewModel>(
      builder: (context, viewModel, child) {
        return CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Device Status',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(
                    Icons.phone_android,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    viewModel.devices.isNotEmpty ? viewModel.devices.first.name : 'No devices',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          viewModel.devices.isNotEmpty ? viewModel.getDeviceStatus(viewModel.devices.first.id) : 'Offline',
                          style: TextStyle(
                            color: viewModel.devices.isNotEmpty && viewModel.devices.first.isOnline 
                                ? AppColors.success 
                                : AppColors.error,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Battery',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          viewModel.devices.isNotEmpty 
                              ? '${viewModel.getDeviceBatteryLevel(viewModel.devices.first.id)}%'
                              : '--%',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Data Usage',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          viewModel.devices.isNotEmpty 
                              ? viewModel.getDataUsage()
                              : '-- GB',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActions() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: QuickActionButton(
                  icon: Icons.shield,
                  label: 'Lock Device',
                  color: AppColors.error,
                  onTap: () => _handleLockDevice(context),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: QuickActionButton(
                  icon: Icons.wifi_off,
                  label: 'Pause Internet',
                  color: AppColors.warning,
                  onTap: () => _handlePauseInternet(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceControlStatus() {
    return Consumer<DeviceControlProvider>(
      builder: (context, deviceControlProvider, child) {
        final dashboardViewModel = Provider.of<DashboardViewModel>(context, listen: false);
        
        if (dashboardViewModel.devices.isEmpty) {
          return const SizedBox.shrink();
        }

        final deviceId = dashboardViewModel.devices.first.id;
        final isLocked = deviceControlProvider.isDeviceLocked(deviceId);
        final isInternetPaused = deviceControlProvider.isInternetPaused(deviceId);
        final isAppBlockingEnabled = deviceControlProvider.isAppBlockingEnabled(deviceId);

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
                'Device Control Status',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatusIndicator(
                      'Device Lock',
                      isLocked,
                      isLocked ? Icons.lock : Icons.lock_open,
                      isLocked ? Colors.red : Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatusIndicator(
                      'Internet',
                      isInternetPaused,
                      isInternetPaused ? Icons.wifi_off : Icons.wifi,
                      isInternetPaused ? Colors.orange : Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatusIndicator(
                      'App Blocking',
                      isAppBlockingEnabled,
                      isAppBlockingEnabled ? Icons.block : Icons.apps,
                      isAppBlockingEnabled ? Colors.purple : Colors.grey,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusIndicator(String label, bool isActive, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive ? color : Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '${hours}h ${minutes}m';
  }
  
  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  /// Handle device lock action
  Future<void> _handleLockDevice(BuildContext context) async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final deviceControlProvider = Provider.of<DeviceControlProvider>(context, listen: false);
    final dashboardViewModel = Provider.of<DashboardViewModel>(context, listen: false);

    // Get the first device ID (you might want to show a device selection dialog)
    if (dashboardViewModel.devices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No devices available to control'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final deviceId = dashboardViewModel.devices.first.id;
    final parentId = authViewModel.currentUser?.id ?? '';

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final success = await deviceControlProvider.toggleDeviceLock(deviceId, parentId);
      
      Navigator.of(context).pop(); // Close loading dialog
      
      if (success) {
        final isLocked = deviceControlProvider.isDeviceLocked(deviceId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isLocked ? 'Device locked successfully' : 'Device unlocked successfully'),
            backgroundColor: isLocked ? Colors.red : Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to control device'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Handle internet pause action
  Future<void> _handlePauseInternet(BuildContext context) async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final deviceControlProvider = Provider.of<DeviceControlProvider>(context, listen: false);
    final dashboardViewModel = Provider.of<DashboardViewModel>(context, listen: false);

    // Get the first device ID (you might want to show a device selection dialog)
    if (dashboardViewModel.devices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No devices available to control'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final deviceId = dashboardViewModel.devices.first.id;
    final parentId = authViewModel.currentUser?.id ?? '';

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final success = await deviceControlProvider.toggleInternetPause(deviceId, parentId);
      
      Navigator.of(context).pop(); // Close loading dialog
      
      if (success) {
        final isPaused = deviceControlProvider.isInternetPaused(deviceId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isPaused ? 'Internet paused successfully' : 'Internet resumed successfully'),
            backgroundColor: isPaused ? Colors.orange : Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to control internet'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
