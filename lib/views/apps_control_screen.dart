import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_card.dart';

class AppsControlScreen extends StatefulWidget {
  const AppsControlScreen({super.key});

  @override
  State<AppsControlScreen> createState() => _AppsControlScreenState();
}

class _AppsControlScreenState extends State<AppsControlScreen> with TickerProviderStateMixin {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  late TabController _tabController;

  final List<Map<String, dynamic>> _installedApps = [
    { 'name': 'Instagram', 'category': 'Social', 'status': 'blocked', 'timeLimit': '1h 30m', 'usage': '2h 15m', 'icon': '📷' },
    { 'name': 'YouTube', 'category': 'Entertainment', 'status': 'limited', 'timeLimit': '2h', 'usage': '1h 45m', 'icon': '📺' },
    { 'name': 'TikTok', 'category': 'Social', 'status': 'limited', 'timeLimit': '1h', 'usage': '45m', 'icon': '🎵' },
    { 'name': 'Minecraft', 'category': 'Games', 'status': 'allowed', 'timeLimit': '1h', 'usage': '30m', 'icon': '🎮' },
    { 'name': 'Khan Academy', 'category': 'Education', 'status': 'allowed', 'timeLimit': 'Unlimited', 'usage': '25m', 'icon': '📚' },
    { 'name': 'Duolingo', 'category': 'Education', 'status': 'allowed', 'timeLimit': 'Unlimited', 'usage': '15m', 'icon': '🦉' },
    { 'name': 'Snapchat', 'category': 'Social', 'status': 'blocked', 'timeLimit': '30m', 'usage': '0m', 'icon': '👻' },
    { 'name': 'Discord', 'category': 'Communication', 'status': 'limited', 'timeLimit': '1h', 'usage': '20m', 'icon': '💬' },
  ];

  final List<Map<String, dynamic>> _pendingRequests = [
    { 'name': 'WhatsApp', 'category': 'Communication', 'reason': 'For group project communication', 'time': '2h ago', 'icon': '💬' },
    { 'name': 'Spotify', 'category': 'Music', 'reason': 'For studying playlist', 'time': '4h ago', 'icon': '🎵' },
    { 'name': 'Netflix', 'category': 'Entertainment', 'reason': 'Educational documentary', 'time': '1d ago', 'icon': '📺' },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredApps {
    return _installedApps.where((app) {
      final matchesSearch = app['name'].toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' || app['category'] == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  List<String> get _categories {
    return ['All', ...Set.from(_installedApps.map((app) => app['category']))];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'App Control',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => _showBulkEditDialog(),
            child: const Text('Bulk Edit'),
          ),
          const SizedBox(width: 16),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: TabBar(
            controller: _tabController,
            tabs: [
              const Tab(text: 'Installed Apps'),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Requests'),
                    if (_pendingRequests.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${_pendingRequests.length}',
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
      body: Column(
        children: [
          // Search and Filter
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search apps...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.gray400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                
                // Category Filters
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((category) {
                      final isSelected = _selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          backgroundColor: Colors.white,
                          selectedColor: AppColors.primary.withOpacity(0.2),
                          checkmarkColor: AppColors.primary,
                          side: BorderSide(
                            color: isSelected ? AppColors.primary : AppColors.gray400,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildInstalledAppsTab(),
                _buildRequestsTab(),
              ],
            ),
          ),
          
          // Quick Actions
          Container(
            padding: const EdgeInsets.all(16),
            child: _buildQuickActions(),
          ),
        ],
      ),
    );
  }

  Widget _buildInstalledAppsTab() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredApps.length,
      itemBuilder: (context, index) {
        final app = _filteredApps[index];
        return _buildAppCard(app);
      },
    );
  }

  Widget _buildAppCard(Map<String, dynamic> app) {
    final isAllowed = app['status'] == 'allowed';
    final isLimited = app['status'] == 'limited';
    final isBlocked = app['status'] == 'blocked';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: CustomCard(
        child: Column(
          children: [
            Row(
              children: [
                // App Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.gray400,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      app['icon'],
                      style: const TextStyle(fontSize: 20),
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
                        app['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                       Row(
                         children: [
                           Flexible(
                             child: Text(
                               app['category'],
                               style: TextStyle(
                                 fontSize: 12,
                                 color: AppColors.textSecondary,
                               ),
                               overflow: TextOverflow.ellipsis,
                             ),
                           ),
                           const SizedBox(width: 4),
                           const Text('•', style: TextStyle(color: AppColors.textSecondary)),
                           const SizedBox(width: 4),
                           Flexible(
                             child: Text(
                               'Today: ${app['usage']}',
                               style: TextStyle(
                                 fontSize: 12,
                                 color: AppColors.textSecondary,
                               ),
                               overflow: TextOverflow.ellipsis,
                             ),
                           ),
                         ],
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
                        color: isAllowed 
                            ? Colors.green.withOpacity(0.1)
                            : isLimited 
                                ? AppColors.primary.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isAllowed ? 'Allowed' : isLimited ? 'Limited' : 'Blocked',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isAllowed 
                              ? Colors.green
                              : isLimited 
                                  ? AppColors.primary
                                  : Colors.red,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Limit: ${app['timeLimit']}',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Switch(
                      value: !isBlocked,
                      onChanged: (value) {
                        setState(() {
                          app['status'] = value ? (isLimited ? 'limited' : 'allowed') : 'blocked';
                        });
                      },
                      activeColor: AppColors.primary,
                    ),
                  ],
                ),
              ],
            ),
            
            // Time Limit Progress (for limited apps)
            if (isLimited) ...[
              const Divider(height: 24),
              Row(
                children: [
                  Text(
                    'Time limit: ${app['timeLimit']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => _editTimeLimit(app),
                    icon: const Icon(Icons.access_time, size: 16),
                    label: const Text('Edit'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.gray400,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _calculateUsageProgress(app),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRequestsTab() {
    if (_pendingRequests.isEmpty) {
      return Center(
        child: CustomCard(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 48,
                  color: Colors.green,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No pending requests',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'All app requests have been reviewed',
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
      itemCount: _pendingRequests.length,
      itemBuilder: (context, index) {
        final request = _pendingRequests[index];
        return _buildRequestCard(request);
      },
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: CustomCard(
        child: Row(
          children: [
            // App Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.gray400,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  request['icon'],
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // Request Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    request['category'],
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    request['reason'],
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    request['time'],
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
             // Action Buttons
             Column(
               children: [
                 TextButton.icon(
                   onPressed: () => _denyRequest(request),
                   icon: const Icon(Icons.cancel, size: 16, color: Colors.red),
                   label: const Text('Deny'),
                   style: TextButton.styleFrom(
                     foregroundColor: Colors.red,
                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                     minimumSize: Size.zero,
                     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                   ),
                 ),
                 const SizedBox(height: 4),
                 ElevatedButton.icon(
                   onPressed: () => _approveRequest(request),
                   icon: const Icon(Icons.check_circle, size: 16),
                   label: const Text('Approve'),
                   style: ElevatedButton.styleFrom(
                     backgroundColor: AppColors.primary,
                     foregroundColor: Colors.white,
                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                     minimumSize: Size.zero,
                     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                   ),
                 ),
               ],
             ),
          ],
        ),
      ),
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
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showBlockCategoryDialog(),
                  icon: const Icon(Icons.shield, size: 18),
                  label: const Text('Block Category'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.gray400),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showSetTimeLimitsDialog(),
                  icon: const Icon(Icons.access_time, size: 18),
                  label: const Text('Set Time Limits'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.gray400),
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

  double _calculateUsageProgress(Map<String, dynamic> app) {
    // Simple calculation for demo purposes
    final usage = app['usage'];
    final limit = app['timeLimit'];
    
    if (usage == '0m' || limit == 'Unlimited') return 0.0;
    
    // Parse time strings (simplified)
    final usageMinutes = _parseTimeToMinutes(usage);
    final limitMinutes = _parseTimeToMinutes(limit);
    
    if (limitMinutes == 0) return 0.0;
    
    return (usageMinutes / limitMinutes).clamp(0.0, 1.0);
  }

  int _parseTimeToMinutes(String timeStr) {
    // Simple parser for "1h 45m" or "45m" format
    final parts = timeStr.split(' ');
    int totalMinutes = 0;
    
    for (final part in parts) {
      if (part.endsWith('h')) {
        totalMinutes += int.parse(part.substring(0, part.length - 1)) * 60;
      } else if (part.endsWith('m')) {
        totalMinutes += int.parse(part.substring(0, part.length - 1));
      }
    }
    
    return totalMinutes;
  }

  void _showBulkEditDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bulk Edit'),
        content: const Text('Bulk edit functionality will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _editTimeLimit(Map<String, dynamic> app) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Time Limit - ${app['name']}'),
        content: const Text('Time limit editing functionality will be implemented here.'),
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

  void _denyRequest(Map<String, dynamic> request) {
    setState(() {
      _pendingRequests.remove(request);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Denied request for ${request['name']}'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _approveRequest(Map<String, dynamic> request) {
    setState(() {
      _pendingRequests.remove(request);
      // Add to installed apps
      _installedApps.add({
        'name': request['name'],
        'category': request['category'],
        'status': 'allowed',
        'timeLimit': '1h',
        'usage': '0m',
        'icon': request['icon'],
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Approved request for ${request['name']}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showBlockCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Block Category'),
        content: const Text('Block category functionality will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Block'),
          ),
        ],
      ),
    );
  }

  void _showSetTimeLimitsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Time Limits'),
        content: const Text('Set time limits functionality will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}
