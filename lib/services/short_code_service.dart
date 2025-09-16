import 'package:cloud_firestore/cloud_firestore.dart';

class ShortCodeService {
  static final ShortCodeService _instance = ShortCodeService._internal();
  factory ShortCodeService() => _instance;
  ShortCodeService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  /// Generate and store a short code for child login
  Future<String> generateShortCode({
    required String childId,
    required String parentId,
    required String childName,
  }) async {
    try {
      // Generate a 6-digit code
      final code = _generateRandomCode();
      
      // Store in Firestore with expiration (24 hours)
      final expiresAt = DateTime.now().add(const Duration(hours: 24));
      
      await _firestore
          .collection('shortCodes')
          .doc(code)
          .set({
        'code': code,
        'childId': childId,
        'parentId': parentId,
        'childName': childName,
        'createdAt': FieldValue.serverTimestamp(),
        'expiresAt': Timestamp.fromDate(expiresAt),
        'isUsed': false,
        'usedAt': null,
      });
      
      print('Short code generated: $code for child: $childName (childId: $childId)');
      return code;
    } catch (e) {
      print('Failed to generate short code: $e');
      rethrow;
    }
  }
  
  /// Validate and consume a short code
  Future<Map<String, dynamic>?> validateShortCode(String code) async {
    try {
      final doc = await _firestore
          .collection('shortCodes')
          .doc(code)
          .get();
      
      if (!doc.exists) {
        print('Short code not found: $code');
        return null;
      }
      
      final data = doc.data()!;
      final expiresAt = (data['expiresAt'] as Timestamp).toDate();
      final isUsed = data['isUsed'] as bool? ?? false;
      
      // Check if code is expired
      if (DateTime.now().isAfter(expiresAt)) {
        print('Short code expired: $code');
        await _deleteExpiredCode(code);
        return null;
      }
      
      // Check if code is already used
      if (isUsed) {
        print('Short code already used: $code');
        return null;
      }
      
      // Mark code as used
      await _firestore
          .collection('shortCodes')
          .doc(code)
          .update({
        'isUsed': true,
        'usedAt': FieldValue.serverTimestamp(),
      });
      
      print('Short code validated successfully: $code');
      return data;
    } catch (e) {
      print('Failed to validate short code: $e');
      return null;
    }
  }
  
  /// Clean up expired codes
  Future<void> cleanupExpiredCodes() async {
    try {
      final now = Timestamp.fromDate(DateTime.now());
      
      final expiredCodes = await _firestore
          .collection('shortCodes')
          .where('expiresAt', isLessThan: now)
          .get();
      
      final batch = _firestore.batch();
      for (final doc in expiredCodes.docs) {
        batch.delete(doc.reference);
      }
      
      if (expiredCodes.docs.isNotEmpty) {
        await batch.commit();
        print('Cleaned up ${expiredCodes.docs.length} expired codes');
      }
    } catch (e) {
      print('Failed to cleanup expired codes: $e');
    }
  }
  
  /// Delete a specific expired code
  Future<void> _deleteExpiredCode(String code) async {
    try {
      await _firestore
          .collection('shortCodes')
          .doc(code)
          .delete();
      print('Deleted expired code: $code');
    } catch (e) {
      print('Failed to delete expired code: $e');
    }
  }
  
  /// Generate a random 6-digit code
  String _generateRandomCode() {
    // Generate a 6-digit code (100000 to 999999)
    final random = DateTime.now().millisecondsSinceEpoch;
    final code = (random % 900000 + 100000).toString();
    
    // Ensure code is exactly 6 digits
    return code.padLeft(6, '0');
  }
  
  /// Get active codes for a parent
  Future<List<Map<String, dynamic>>> getActiveCodesForParent(String parentId) async {
    try {
      print('Looking for codes for parentId: $parentId');
      
      // Simplified query to avoid complex index requirements
      final query = await _firestore
          .collection('shortCodes')
          .where('parentId', isEqualTo: parentId)
          .get();
      
      print('Found ${query.docs.length} codes in Firestore for parentId: $parentId');
      
      final now = DateTime.now();
      final codes = <Map<String, dynamic>>[];
      
      for (final doc in query.docs) {
        final data = doc.data();
        final expiresAt = (data['expiresAt'] as Timestamp).toDate();
        final isUsed = data['isUsed'] as bool? ?? false;
        final docParentId = data['parentId'] as String;
        
        print('Code ${doc.id}: parentId=$docParentId, expiresAt=$expiresAt, isUsed=$isUsed, now=$now');
        
        // Filter in memory to avoid complex Firestore queries
        if (!isUsed && now.isBefore(expiresAt)) {
          codes.add({
            'id': doc.id,
            ...data,
          });
          print('Added code ${doc.id} to active codes list');
        } else {
          print('Code ${doc.id} filtered out: isUsed=$isUsed, expired=${now.isAfter(expiresAt)}');
        }
      }
      
      // Sort by creation time (newest first)
      codes.sort((a, b) {
        final aTime = (a['createdAt'] as Timestamp).toDate();
        final bTime = (b['createdAt'] as Timestamp).toDate();
        return bTime.compareTo(aTime);
      });
      
      print('Returning ${codes.length} active codes');
      return codes;
    } catch (e) {
      print('Failed to get active codes for parent: $e');
      return [];
    }
  }
}
