import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../constants/app_colors.dart';
import '../viewmodels/dashboard_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../widgets/custom_card.dart';
import '../widgets/quick_action_button.dart';
import '../services/sample_data_service.dart';
import 'child_setup_screen.dart';

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
          child: SingleChildScrollView(
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
                const SizedBox(height: 100), // Bottom padding for navigation
              ],
            ),
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
        
        // Generate Sample Data Button (for testing)
        if (authViewModel.childIds.isNotEmpty)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                try {
                  await SampleDataService.instance.generateSampleData(
                    authViewModel.currentUser!.id,
                    authViewModel.childIds.first,
                  );
                  
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sample data generated! Pull to refresh to see real data.'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to generate sample data: $e'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                }
              },
              icon: const Icon(Icons.data_usage),
              label: const Text('Generate Sample Data'),
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
                      _formatDuration(viewModel.totalScreenTimeToday),
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
                      viewModel.getLocationName(),
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
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 4.2, color: AppColors.primary)]),
                  BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 3.8, color: AppColors.primary)]),
                  BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 5.1, color: AppColors.primary)]),
                  BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 3.5, color: AppColors.primary)]),
                  BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 6.2, color: AppColors.primary)]),
                  BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 7.8, color: AppColors.primary)]),
                  BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 6.5, color: AppColors.primary)]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 30,
                          sections: _buildPieChartSections(breakdown),
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
                          '${viewModel.devices.isNotEmpty ? viewModel.getDeviceBatteryLevel(viewModel.devices.first.id) : 0}%',
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
                          viewModel.getDataUsage(),
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
                  onTap: () {
                    // Implement lock device
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: QuickActionButton(
                  icon: Icons.wifi_off,
                  label: 'Pause Internet',
                  color: AppColors.warning,
                  onTap: () {
                    // Implement pause internet
                  },
                ),
              ),
            ],
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
}
