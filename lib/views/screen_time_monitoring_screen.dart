import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_card.dart';

class ScreenTimeMonitoringScreen extends StatefulWidget {
  const ScreenTimeMonitoringScreen({super.key});

  @override
  State<ScreenTimeMonitoringScreen> createState() => _ScreenTimeMonitoringScreenState();
}

class _ScreenTimeMonitoringScreenState extends State<ScreenTimeMonitoringScreen> {
  DateTime? _selectedDate;
  bool _emergencyOverride = false;
  bool _studyMode = false;

  final List<Map<String, dynamic>> _scheduleData = [
    { 'day': 'Monday', 'start': '07:00', 'end': '20:00', 'limit': '6h', 'status': 'active' },
    { 'day': 'Tuesday', 'start': '07:00', 'end': '20:00', 'limit': '6h', 'status': 'active' },
    { 'day': 'Wednesday', 'start': '07:00', 'end': '20:00', 'limit': '6h', 'status': 'active' },
    { 'day': 'Thursday', 'start': '07:00', 'end': '20:00', 'limit': '6h', 'status': 'active' },
    { 'day': 'Friday', 'start': '07:00', 'end': '21:00', 'limit': '7h', 'status': 'active' },
    { 'day': 'Saturday', 'start': '09:00', 'end': '22:00', 'limit': '8h', 'status': 'active' },
    { 'day': 'Sunday', 'start': '09:00', 'end': '21:00', 'limit': '7h', 'status': 'violated' },
  ];

  final List<Map<String, dynamic>> _todayUsage = [
    { 'app': 'Instagram', 'time': '2h 15m', 'limit': '1h 30m', 'status': 'exceeded' },
    { 'app': 'YouTube', 'time': '1h 45m', 'limit': '2h', 'status': 'normal' },
    { 'app': 'TikTok', 'time': '45m', 'limit': '1h', 'status': 'normal' },
    { 'app': 'Minecraft', 'time': '30m', 'limit': '1h', 'status': 'normal' },
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Screen Time',
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
            onPressed: () => _showAddRuleDialog(),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Rule'),
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Today's Summary
              _buildTodaysSummary(),
              const SizedBox(height: 24),
              
              // Weekly Schedule
              _buildWeeklySchedule(),
              const SizedBox(height: 24),
              
              // Override Options
              _buildOverrideOptions(),
              const SizedBox(height: 24),
              
              // Usage Calendar
              _buildUsageCalendar(),
              const SizedBox(height: 100), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodaysSummary() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.access_time, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              const Text(
                "Today's Usage",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Usage Summary
          Center(
            child: Column(
              children: [
                const Text(
                  '4h 23m',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'of 6h daily limit',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Progress Bar
                Container(
                  width: double.infinity,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.gray400,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.75, // 4h 23m / 6h = ~75%
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // App Usage List
          Column(
            children: _todayUsage.map((item) => _buildAppUsageItem(item)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAppUsageItem(Map<String, dynamic> item) {
    final isExceeded = item['status'] == 'exceeded';
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // App Icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.gray400,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                item['app'][0],
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // App Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['app'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  item['time'],
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          
          // Status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isExceeded ? Colors.red.withOpacity(0.1) : AppColors.gray400,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isExceeded ? 'Exceeded' : 'On Track',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isExceeded ? Colors.red : AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Limit: ${item['limit']}',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklySchedule() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly Schedule',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Set device usage hours and daily limits',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          
          Column(
            children: _scheduleData.asMap().entries.map((entry) {
              final index = entry.key;
              final day = entry.value;
              final isViolated = day['status'] == 'violated';
              
              return Column(
                children: [
                  Row(
                    children: [
                      // Day Indicator
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            day['day'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (isViolated) ...[
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.warning,
                              color: Colors.red,
                              size: 16,
                            ),
                          ],
                        ],
                      ),
                      
                      const Spacer(),
                      
                      // Schedule Info
                      Row(
                        children: [
                          Text(
                            '${day['start']} - ${day['end']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.gray400),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              day['limit'],
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () => _editSchedule(day),
                            icon: const Icon(Icons.edit, size: 16),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (index < _scheduleData.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Divider(
                        height: 1,
                        color: AppColors.gray400,
                      ),
                    ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildOverrideOptions() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Override Options',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          
          // Emergency Override
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Emergency Override',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Allow unlimited access for emergencies',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _emergencyOverride,
                onChanged: (value) {
                  setState(() {
                    _emergencyOverride = value;
                  });
                },
                activeColor: AppColors.primary,
              ),
            ],
          ),
          
          Divider(color: AppColors.gray400, height: 24),
          
          // Study Mode
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Study Mode',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Extended time for educational apps',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _studyMode,
                onChanged: (value) {
                  setState(() {
                    _studyMode = value;
                  });
                },
                activeColor: AppColors.primary,
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Extra Time Requests
          const Text(
            'Extra Time Requests',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.gray400.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Request for +30 minutes',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'For homework completion',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text('Deny'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          child: const Text('Approve'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageCalendar() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Usage Calendar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Calendar Placeholder
          Container(
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.gray400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text('Calendar Widget Here'),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Legend
          Row(
            children: [
              _buildLegendItem(Colors.green, 'Under limit'),
              const SizedBox(width: 16),
              _buildLegendItem(Colors.orange, 'Near limit'),
              const SizedBox(width: 16),
              _buildLegendItem(Colors.red, 'Exceeded'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
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
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  void _showAddRuleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Rule'),
        content: const Text('Add new screen time rule functionality will be implemented here.'),
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

  void _editSchedule(Map<String, dynamic> day) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${day['day']} Schedule'),
        content: const Text('Edit schedule functionality will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
