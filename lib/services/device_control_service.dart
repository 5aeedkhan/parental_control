import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/device_control_model.dart';

class DeviceControlService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'deviceControls';

  /// Get device control settings for a specific device
  static Future<DeviceControlModel?> getDeviceControl(String deviceId) async {
    try {
      final doc = await _firestore
          .collection(_collection)
          .where('deviceId', isEqualTo: deviceId)
          .limit(1)
          .get();

      if (doc.docs.isEmpty) {
        return null;
      }

      return DeviceControlModel.fromFirestore(doc.docs.first);
    } catch (e) {
      print('Error getting device control: $e');
      return null;
    }
  }

  /// Get all device controls for a parent
  static Future<List<DeviceControlModel>> getParentDeviceControls(String parentId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('parentId', isEqualTo: parentId)
          .get();

      return querySnapshot.docs
          .map((doc) => DeviceControlModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error getting parent device controls: $e');
      return [];
    }
  }

  /// Create or update device control settings
  static Future<String?> saveDeviceControl(DeviceControlModel deviceControl) async {
    try {
      final docRef = await _firestore
          .collection(_collection)
          .add(deviceControl.toFirestore());

      return docRef.id;
    } catch (e) {
      print('Error saving device control: $e');
      return null;
    }
  }

  /// Update device control settings
  static Future<bool> updateDeviceControl(String controlId, DeviceControlModel deviceControl) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(controlId)
          .update(deviceControl.toFirestore());

      return true;
    } catch (e) {
      print('Error updating device control: $e');
      return false;
    }
  }

  /// Toggle device lock status
  static Future<bool> toggleDeviceLock(String deviceId, String parentId, bool isLocked) async {
    try {
      // Get existing control or create new one
      DeviceControlModel? existingControl = await getDeviceControl(deviceId);
      
      if (existingControl != null) {
        // Update existing
        final updatedControl = existingControl.copyWith(
          isLocked: isLocked,
          lockedAt: isLocked ? DateTime.now() : null,
          updatedAt: DateTime.now(),
        );
        return await updateDeviceControl(existingControl.id, updatedControl);
      } else {
        // Create new
        final newControl = DeviceControlModel(
          id: '',
          deviceId: deviceId,
          parentId: parentId,
          isLocked: isLocked,
          isInternetPaused: false,
          isAppBlockingEnabled: false,
          lockedAt: isLocked ? DateTime.now() : null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        return await saveDeviceControl(newControl) != null;
      }
    } catch (e) {
      print('Error toggling device lock: $e');
      return false;
    }
  }

  /// Toggle internet pause status
  static Future<bool> toggleInternetPause(String deviceId, String parentId, bool isPaused) async {
    try {
      // Get existing control or create new one
      DeviceControlModel? existingControl = await getDeviceControl(deviceId);
      
      if (existingControl != null) {
        // Update existing
        final updatedControl = existingControl.copyWith(
          isInternetPaused: isPaused,
          internetPausedAt: isPaused ? DateTime.now() : null,
          updatedAt: DateTime.now(),
        );
        return await updateDeviceControl(existingControl.id, updatedControl);
      } else {
        // Create new
        final newControl = DeviceControlModel(
          id: '',
          deviceId: deviceId,
          parentId: parentId,
          isLocked: false,
          isInternetPaused: isPaused,
          isAppBlockingEnabled: false,
          internetPausedAt: isPaused ? DateTime.now() : null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        return await saveDeviceControl(newControl) != null;
      }
    } catch (e) {
      print('Error toggling internet pause: $e');
      return false;
    }
  }

  /// Toggle app blocking status
  static Future<bool> toggleAppBlocking(String deviceId, String parentId, bool isEnabled) async {
    try {
      // Get existing control or create new one
      DeviceControlModel? existingControl = await getDeviceControl(deviceId);
      
      if (existingControl != null) {
        // Update existing
        final updatedControl = existingControl.copyWith(
          isAppBlockingEnabled: isEnabled,
          appBlockingEnabledAt: isEnabled ? DateTime.now() : null,
          updatedAt: DateTime.now(),
        );
        return await updateDeviceControl(existingControl.id, updatedControl);
      } else {
        // Create new
        final newControl = DeviceControlModel(
          id: '',
          deviceId: deviceId,
          parentId: parentId,
          isLocked: false,
          isInternetPaused: false,
          isAppBlockingEnabled: isEnabled,
          appBlockingEnabledAt: isEnabled ? DateTime.now() : null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        return await saveDeviceControl(newControl) != null;
      }
    } catch (e) {
      print('Error toggling app blocking: $e');
      return false;
    }
  }

  /// Get real-time updates for device controls
  static Stream<List<DeviceControlModel>> getDeviceControlsStream(String parentId) {
    return _firestore
        .collection(_collection)
        .where('parentId', isEqualTo: parentId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => DeviceControlModel.fromFirestore(doc))
          .toList();
    });
  }

  /// Delete device control settings
  static Future<bool> deleteDeviceControl(String controlId) async {
    try {
      await _firestore.collection(_collection).doc(controlId).delete();
      return true;
    } catch (e) {
      print('Error deleting device control: $e');
      return false;
    }
  }
}
