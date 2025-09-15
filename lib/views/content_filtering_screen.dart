import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ContentFilteringScreen extends StatefulWidget {
  const ContentFilteringScreen({super.key});

  @override
  State<ContentFilteringScreen> createState() => _ContentFilteringScreenState();
}

class _ContentFilteringScreenState extends State<ContentFilteringScreen> {
  bool _isContentFilteringEnabled = true;
  bool _isSafeSearchEnabled = true;
  bool _isAdultContentBlocked = true;
  bool _isSocialMediaBlocked = false;
  bool _isGamingBlocked = false;
  bool _isShoppingBlocked = false;

  final List<FilterCategory> _filterCategories = [
    FilterCategory(
      name: 'Adult Content',
      description: 'Block adult and inappropriate content',
      isEnabled: true,
      icon: Icons.block,
      color: Colors.red,
    ),
    FilterCategory(
      name: 'Social Media',
      description: 'Control access to social media platforms',
      isEnabled: false,
      icon: Icons.people,
      color: Colors.blue,
    ),
    FilterCategory(
      name: 'Gaming',
      description: 'Restrict gaming websites and apps',
      isEnabled: false,
      icon: Icons.games,
      color: Colors.orange,
    ),
    FilterCategory(
      name: 'Shopping',
      description: 'Block online shopping websites',
      isEnabled: false,
      icon: Icons.shopping_cart,
      color: Colors.green,
    ),
    FilterCategory(
      name: 'Entertainment',
      description: 'Control entertainment and streaming sites',
      isEnabled: false,
      icon: Icons.movie,
      color: Colors.purple,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Content Filtering'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showHelpDialog(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Toggle
            _buildMainToggle(),
            const SizedBox(height: 24),
            
            // Safe Search
            _buildSafeSearchToggle(),
            const SizedBox(height: 24),
            
            // Filter Categories
            _buildFilterCategories(),
            const SizedBox(height: 24),
            
            // Blocked Sites
            _buildBlockedSites(),
            const SizedBox(height: 24),
            
            // Allowed Sites
            _buildAllowedSites(),
            const SizedBox(height: 24),
            
            // Statistics
            _buildStatistics(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainToggle() {
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
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _isContentFilteringEnabled 
                  ? AppColors.primary.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.security,
              color: _isContentFilteringEnabled 
                  ? AppColors.primary
                  : Colors.grey,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Content Filtering',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _isContentFilteringEnabled 
                      ? 'Protecting your child from inappropriate content'
                      : 'Content filtering is disabled',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _isContentFilteringEnabled,
            onChanged: (value) {
              setState(() {
                _isContentFilteringEnabled = value;
              });
            },
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildSafeSearchToggle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            color: AppColors.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Safe Search',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Switch(
            value: _isSafeSearchEnabled,
            onChanged: _isContentFilteringEnabled ? (value) {
              setState(() {
                _isSafeSearchEnabled = value;
              });
            } : null,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Filter Categories',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ..._filterCategories.map((category) => _buildFilterCategory(category)),
      ],
    );
  }

  Widget _buildFilterCategory(FilterCategory category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: category.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              category.icon,
              color: category.color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  category.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: category.isEnabled,
            onChanged: _isContentFilteringEnabled ? (value) {
              setState(() {
                category.isEnabled = value;
              });
            } : null,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildBlockedSites() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Blocked Sites',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton.icon(
              onPressed: () => _showAddSiteDialog(true),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Site'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              _buildSiteItem('facebook.com', true),
              _buildSiteItem('instagram.com', true),
              _buildSiteItem('tiktok.com', true),
              _buildSiteItem('youtube.com', true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAllowedSites() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Allowed Sites',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton.icon(
              onPressed: () => _showAddSiteDialog(false),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Site'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              _buildSiteItem('google.com', false),
              _buildSiteItem('wikipedia.org', false),
              _buildSiteItem('khanacademy.org', false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSiteItem(String site, bool isBlocked) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isBlocked 
            ? Colors.red.withOpacity(0.1)
            : Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            isBlocked ? Icons.block : Icons.check_circle,
            color: isBlocked ? Colors.red : Colors.green,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              site,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 16),
            onPressed: () => _removeSite(site, isBlocked),
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics() {
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
            'Filtering Statistics',
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
                child: _buildStatItem(
                  'Sites Blocked',
                  '47',
                  Icons.block,
                  Colors.red,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Requests Today',
                  '156',
                  Icons.trending_up,
                  Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Time Saved',
                  '2.5h',
                  Icons.access_time,
                  Colors.green,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Alerts Sent',
                  '3',
                  Icons.notifications,
                  Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
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
              fontSize: 18,
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

  void _showAddSiteDialog(bool isBlocked) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add ${isBlocked ? 'Blocked' : 'Allowed'} Site'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter website URL',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                // Add site logic here
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _removeSite(String site, bool isBlocked) {
    // Remove site logic here
    setState(() {});
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Content Filtering Help'),
        content: const Text(
          'Content filtering helps protect your child by blocking inappropriate websites and content. You can customize which categories to block and add specific websites to block or allow.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

class FilterCategory {
  final String name;
  final String description;
  bool isEnabled;
  final IconData icon;
  final Color color;

  FilterCategory({
    required this.name,
    required this.description,
    required this.isEnabled,
    required this.icon,
    required this.color,
  });
}
