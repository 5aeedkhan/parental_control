import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_card.dart';

class AIAlertsScreen extends StatefulWidget {
  const AIAlertsScreen({super.key});

  @override
  State<AIAlertsScreen> createState() => _AIAlertsScreenState();
}

class _AIAlertsScreenState extends State<AIAlertsScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _aiAlerts = [
    {
      'id': 1,
      'type': 'cyberbullying',
      'severity': 'high',
      'source': 'Instagram DM',
      'title': 'Potential cyberbullying detected',
      'description': 'Harsh language and threats detected in messages from @unknown_user123',
      'context': '"You\'re so stupid, nobody likes you..."',
      'time': '2 hours ago',
      'recommendations': ['Block the user', 'Report to platform', 'Talk to Emma about the incident'],
      'status': 'new'
    },
    {
      'id': 2,
      'type': 'sensitive_content',
      'severity': 'medium',
      'source': 'YouTube',
      'title': 'Inappropriate content viewed',
      'description': 'Video containing mature themes was watched',
      'context': 'Video: "Teen Drama Series - Episode 15"',
      'time': '4 hours ago',
      'recommendations': ['Review content filters', 'Discuss media consumption', 'Update age restrictions'],
      'status': 'new'
    },
    {
      'id': 3,
      'type': 'risky_contact',
      'severity': 'high',
      'source': 'WhatsApp',
      'title': 'Unknown contact attempting communication',
      'description': 'New contact with limited profile information trying to connect',
      'context': 'Contact: +1 (555) 123-4567 - No profile picture, limited info',
      'time': '6 hours ago',
      'recommendations': ['Block contact', 'Review privacy settings', 'Educate about stranger danger'],
      'status': 'acknowledged'
    },
    {
      'id': 4,
      'type': 'screen_time',
      'severity': 'low',
      'source': 'System',
      'title': 'Unusual late-night activity',
      'description': 'Device usage detected between 11 PM and 1 AM',
      'context': 'Apps used: TikTok (45m), YouTube (30m)',
      'time': 'Yesterday',
      'recommendations': ['Adjust bedtime schedule', 'Enable night mode restrictions'],
      'status': 'resolved'
    }
  ];

  final List<Map<String, dynamic>> _insights = [
    {
      'title': 'Communication Patterns',
      'description': 'Emma\'s messaging activity has increased 40% this week',
      'trend': 'up',
      'severity': 'low'
    },
    {
      'title': 'Content Consumption',
      'description': 'More mature content being accessed recently',
      'trend': 'up',
      'severity': 'medium'
    },
    {
      'title': 'Social Interactions',
      'description': 'New contacts added to social media accounts',
      'trend': 'stable',
      'severity': 'low'
    }
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

  List<Map<String, dynamic>> get _newAlerts => 
      _aiAlerts.where((alert) => alert['status'] == 'new').toList();
  
  List<Map<String, dynamic>> get _acknowledgedAlerts => 
      _aiAlerts.where((alert) => alert['status'] == 'acknowledged').toList();
  
  List<Map<String, dynamic>> get _resolvedAlerts => 
      _aiAlerts.where((alert) => alert['status'] == 'resolved').toList();

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'high': return Colors.red;
      case 'medium': return Colors.orange;
      case 'low': return Colors.blue;
      default: return AppColors.gray400;
    }
  }

  IconData _getSeverityIcon(String type) {
    switch (type) {
      case 'cyberbullying': return Icons.message;
      case 'sensitive_content': return Icons.visibility;
      case 'risky_contact': return Icons.person;
      case 'screen_time': return Icons.access_time;
      default: return Icons.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'AI Alerts',
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
            onPressed: () => _showSettingsDialog(),
            child: const Text('Settings'),
          ),
          const SizedBox(width: 16),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('New'),
                    if (_newAlerts.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${_newAlerts.length}',
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
              const Tab(text: 'Acknowledged'),
              const Tab(text: 'Resolved'),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Summary Alert
          if (_newAlerts.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              child: _buildSummaryAlert(),
            ),
          ],
          
          // AI Insights
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildAIInsights(),
          ),
          
          const SizedBox(height: 16),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildNewAlertsTab(),
                _buildAcknowledgedAlertsTab(),
                _buildResolvedAlertsTab(),
              ],
            ),
          ),
          
          // AI Settings
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: _buildAISettings(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryAlert() {
    final highPriorityCount = _newAlerts.where((alert) => alert['severity'] == 'high').length;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning,
            color: Colors.red,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                ),
                children: [
                  const TextSpan(
                    text: 'New alerts require your attention.',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  if (highPriorityCount > 0)
                    TextSpan(
                      text: ' $highPriorityCount are high priority.',
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIInsights() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shield, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              const Text(
                'AI Insights',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          Column(
            children: _insights.map((insight) => _buildInsightItem(insight)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem(Map<String, dynamic> insight) {
    final severityColor = _getSeverityColor(insight['severity']);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.gray400.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight['title'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  insight['description'],
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: severityColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              insight['severity'],
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: severityColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewAlertsTab() {
    if (_newAlerts.isEmpty) {
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
                  'No new alerts',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'All alerts have been reviewed',
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
      itemCount: _newAlerts.length,
      itemBuilder: (context, index) {
        final alert = _newAlerts[index];
        return _buildNewAlertCard(alert);
      },
    );
  }

  Widget _buildNewAlertCard(Map<String, dynamic> alert) {
    final severityColor = _getSeverityColor(alert['severity']);
    final alertIcon = _getSeverityIcon(alert['type']);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Alert Header
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    alertIcon,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alert['title'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${alert['source']} • ${alert['time']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: severityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    alert['severity'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: severityColor,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Description
            Text(
              alert['description'],
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Context
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.gray400.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Context:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '"${alert['context']}"',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Recommendations
            const Text(
              'Recommended Actions:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            ...alert['recommendations'].map<Widget>((rec) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.textSecondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      rec,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            )).toList(),
            
            const SizedBox(height: 16),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _acknowledgeAlert(alert),
                    child: const Text('Acknowledge'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _takeAction(alert),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Take Action'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAcknowledgedAlertsTab() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _acknowledgedAlerts.length,
      itemBuilder: (context, index) {
        final alert = _acknowledgedAlerts[index];
        return _buildAcknowledgedAlertCard(alert);
      },
    );
  }

  Widget _buildAcknowledgedAlertCard(Map<String, dynamic> alert) {
    final alertIcon = _getSeverityIcon(alert['type']);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: CustomCard(
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                alertIcon,
                color: Colors.orange,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alert['title'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${alert['source']} • ${alert['time']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    alert['description'],
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => _markResolved(alert),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              child: const Text('Mark Resolved'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResolvedAlertsTab() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _resolvedAlerts.length,
      itemBuilder: (context, index) {
        final alert = _resolvedAlerts[index];
        return _buildResolvedAlertCard(alert);
      },
    );
  }

  Widget _buildResolvedAlertCard(Map<String, dynamic> alert) {
    final alertIcon = _getSeverityIcon(alert['type']);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: CustomCard(
        child: Opacity(
          opacity: 0.75,
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  alertIcon,
                  color: Colors.green,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${alert['source']} • ${alert['time']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      alert['description'],
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Resolved',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAISettings() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AI Detection Settings',
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
                  onPressed: () => _showCyberbullyingSettings(),
                  icon: const Icon(Icons.message, size: 18),
                  label: const Text('Cyberbullying'),
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
                  onPressed: () => _showContentFilterSettings(),
                  icon: const Icon(Icons.visibility, size: 18),
                  label: const Text('Content Filter'),
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
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showContactSafetySettings(),
                  icon: const Icon(Icons.person, size: 18),
                  label: const Text('Contact Safety'),
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
                  onPressed: () => _showUsagePatternsSettings(),
                  icon: const Icon(Icons.access_time, size: 18),
                  label: const Text('Usage Patterns'),
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

  void _acknowledgeAlert(Map<String, dynamic> alert) {
    setState(() {
      alert['status'] = 'acknowledged';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Alert acknowledged: ${alert['title']}'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _takeAction(Map<String, dynamic> alert) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Take Action - ${alert['title']}'),
        content: const Text('Action implementation will be added here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _acknowledgeAlert(alert);
            },
            child: const Text('Complete'),
          ),
        ],
      ),
    );
  }

  void _markResolved(Map<String, dynamic> alert) {
    setState(() {
      alert['status'] = 'resolved';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Alert resolved: ${alert['title']}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AI Alert Settings'),
        content: const Text('AI alert settings will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showCyberbullyingSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cyberbullying Detection'),
        content: const Text('Cyberbullying detection settings will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showContentFilterSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Content Filter'),
        content: const Text('Content filter settings will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showContactSafetySettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Safety'),
        content: const Text('Contact safety settings will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showUsagePatternsSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Usage Patterns'),
        content: const Text('Usage patterns settings will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
