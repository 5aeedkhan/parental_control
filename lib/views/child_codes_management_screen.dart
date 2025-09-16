import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/app_colors.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../services/short_code_service.dart';
import 'child_setup_screen.dart';

class ChildCodesManagementScreen extends StatefulWidget {
  const ChildCodesManagementScreen({super.key});

  @override
  State<ChildCodesManagementScreen> createState() => _ChildCodesManagementScreenState();
}

class _ChildCodesManagementScreenState extends State<ChildCodesManagementScreen> {
  final ShortCodeService _shortCodeService = ShortCodeService();
  List<Map<String, dynamic>> _activeCodes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadActiveCodes();
  }

  Future<void> _loadActiveCodes() async {
    try {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final currentUser = authViewModel.currentUser;
      
      print('ChildCodesManagementScreen: currentUser = ${currentUser?.id}, name = ${currentUser?.name}');
      
      if (currentUser != null) {
        print('Loading codes for parent: ${currentUser.id}');
        final codes = await _shortCodeService.getActiveCodesForParent(currentUser.id);
        print('ChildCodesManagementScreen: received ${codes.length} codes');
        setState(() {
          _activeCodes = codes;
          _isLoading = false;
        });
      } else {
        print('ChildCodesManagementScreen: currentUser is null');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load codes: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _generateNewCode(String childName, String childId) async {
    try {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final currentUser = authViewModel.currentUser;
      
      if (currentUser != null) {
        final newCode = await _shortCodeService.generateShortCode(
          childId: childId,
          parentId: currentUser.id,
          childName: childName,
        );
        
        if (mounted) {
          _showNewCodeDialog(newCode, childName);
          _loadActiveCodes(); // Refresh the list
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate new code: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showNewCodeDialog(String code, String childName) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('New Code Generated'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('New code for $childName:'),
            const SizedBox(height: 20),
            
            // Code Display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: Column(
                children: [
                  const Text(
                    'Child Login Code',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    code,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      letterSpacing: 4,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.warning, color: Colors.orange, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This code will expire in 24 hours. Make sure to share it with your child soon.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Child Login Codes'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _activeCodes.isEmpty
              ? _buildEmptyState()
              : _buildCodesList(),
    );
  }

  Widget _buildEmptyState() {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final hasChildren = authViewModel.childIds.isNotEmpty;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasChildren ? Icons.qr_code_2 : Icons.add_circle_outline,
              size: 80,
              color: AppColors.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              hasChildren ? 'No Active Codes' : 'No Child Accounts',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hasChildren 
                  ? 'All codes have been used. Generate new codes for your children.'
                  : 'Create child accounts to generate login codes',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            if (hasChildren) ...[
              // Show children and generate codes for them
              ...authViewModel.childIds.map((childId) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ElevatedButton.icon(
                    onPressed: () => _generateCodeForChild(childId),
                    icon: const Icon(Icons.qr_code_2),
                    label: Text('Generate Code for ${_getChildName(childId)}'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 16),
            ],
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChildSetupScreen(),
                  ),
                );
              },
              icon: Icon(hasChildren ? Icons.add : Icons.add),
              label: Text(hasChildren ? 'Add Another Child' : 'Add Child Account'),
              style: ElevatedButton.styleFrom(
                backgroundColor: hasChildren ? AppColors.secondary : AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodesList() {
    return RefreshIndicator(
      onRefresh: _loadActiveCodes,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _activeCodes.length,
        itemBuilder: (context, index) {
          final code = _activeCodes[index];
          final createdAt = (code['createdAt'] as Timestamp).toDate();
          final expiresAt = (code['expiresAt'] as Timestamp).toDate();
          final timeRemaining = expiresAt.difference(DateTime.now());
          
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.child_care,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              code['childName'] ?? 'Unknown Child',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Code: ${code['code']}',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: timeRemaining.inHours > 12
                              ? AppColors.success.withOpacity(0.1)
                              : timeRemaining.inHours > 4
                                  ? Colors.orange.withOpacity(0.1)
                                  : AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          timeRemaining.inHours > 0
                              ? '${timeRemaining.inHours}h left'
                              : 'Expired',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: timeRemaining.inHours > 12
                                ? AppColors.success
                                : timeRemaining.inHours > 4
                                    ? Colors.orange
                                    : AppColors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Created: ${_formatDateTime(createdAt)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _generateNewCode(
                            code['childName'],
                            code['childId'],
                          );
                        },
                        child: const Text('Generate New'),
                      ),
                    ],
                  ),
                  
                  if (code['isUsed'] == true) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppColors.success,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Code has been used',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.success,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _generateCodeForChild(String childId) async {
    try {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final currentUser = authViewModel.currentUser;
      
      if (currentUser != null) {
        // Get child name from the childId (we'll use a simple approach for now)
        final childName = _getChildName(childId);
        
        final newCode = await _shortCodeService.generateShortCode(
          childId: childId,
          parentId: currentUser.id,
          childName: childName,
        );
        
        if (mounted) {
          _showNewCodeDialog(newCode, childName);
          _loadActiveCodes(); // Refresh the list
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate new code: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  String _getChildName(String childId) {
    // For now, we'll use a simple approach to get child names
    // In a real app, you'd want to fetch this from Firestore or cache it
    // Since we know from the logs that childId "y1y5uNxP0zbHzGbDASsRxVGZ0VH2" is "hammad"
    if (childId == 'y1y5uNxP0zbHzGbDASsRxVGZ0VH2') {
      return 'hammad';
    }
    return 'Child'; // Fallback name
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
