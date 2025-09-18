import 'package:flutter/foundation.dart';
import '../models/device_control_model.dart';
import '../services/device_control_service.dart';

class DeviceControlProvider extends ChangeNotifier {
  List<DeviceControlModel> _deviceControls = [];
  bool _isLoading = false;
  String? _error;

  List<DeviceControlModel> get deviceControls => _deviceControls;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Get device control for a specific device
  DeviceControlModel? getDeviceControl(String deviceId) {
    try {
      return _deviceControls.firstWhere((control) => control.deviceId == deviceId);
    } catch (e) {
      return null;
    }
  }

  /// Check if device is locked
  bool isDeviceLocked(String deviceId) {
    final control = getDeviceControl(deviceId);
    return control?.isLocked ?? false;
  }

  /// Check if internet is paused for device
  bool isInternetPaused(String deviceId) {
    final control = getDeviceControl(deviceId);
    return control?.isInternetPaused ?? false;
  }

  /// Check if app blocking is enabled for device
  bool isAppBlockingEnabled(String deviceId) {
    final control = getDeviceControl(deviceId);
    return control?.isAppBlockingEnabled ?? false;
  }

  /// Load device controls for a parent
  Future<void> loadDeviceControls(String parentId) async {
    _setLoading(true);
    _clearError();

    try {
      _deviceControls = await DeviceControlService.getParentDeviceControls(parentId);
      notifyListeners();
    } catch (e) {
      _setError('Failed to load device controls: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Toggle device lock
  Future<bool> toggleDeviceLock(String deviceId, String parentId) async {
    _setLoading(true);
    _clearError();

    try {
      final currentControl = getDeviceControl(deviceId);
      final newLockState = !(currentControl?.isLocked ?? false);
      
      final success = await DeviceControlService.toggleDeviceLock(
        deviceId, 
        parentId, 
        newLockState
      );

      if (success) {
        // Update local state
        await loadDeviceControls(parentId);
      } else {
        _setError('Failed to toggle device lock');
      }

      return success;
    } catch (e) {
      _setError('Error toggling device lock: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Toggle internet pause
  Future<bool> toggleInternetPause(String deviceId, String parentId) async {
    _setLoading(true);
    _clearError();

    try {
      final currentControl = getDeviceControl(deviceId);
      final newPauseState = !(currentControl?.isInternetPaused ?? false);
      
      final success = await DeviceControlService.toggleInternetPause(
        deviceId, 
        parentId, 
        newPauseState
      );

      if (success) {
        // Update local state
        await loadDeviceControls(parentId);
      } else {
        _setError('Failed to toggle internet pause');
      }

      return success;
    } catch (e) {
      _setError('Error toggling internet pause: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Toggle app blocking
  Future<bool> toggleAppBlocking(String deviceId, String parentId) async {
    _setLoading(true);
    _clearError();

    try {
      final currentControl = getDeviceControl(deviceId);
      final newBlockingState = !(currentControl?.isAppBlockingEnabled ?? false);
      
      final success = await DeviceControlService.toggleAppBlocking(
        deviceId, 
        parentId, 
        newBlockingState
      );

      if (success) {
        // Update local state
        await loadDeviceControls(parentId);
      } else {
        _setError('Failed to toggle app blocking');
      }

      return success;
    } catch (e) {
      _setError('Error toggling app blocking: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Start listening to real-time updates
  void startListening(String parentId) {
    DeviceControlService.getDeviceControlsStream(parentId).listen(
      (controls) {
        _deviceControls = controls;
        notifyListeners();
      },
      onError: (error) {
        _setError('Real-time update error: $error');
      },
    );
  }

  /// Clear all device controls
  void clearDeviceControls() {
    _deviceControls.clear();
    notifyListeners();
  }

  /// Get overall status for all devices
  Map<String, dynamic> getOverallStatus() {
    if (_deviceControls.isEmpty) {
      return {
        'totalDevices': 0,
        'lockedDevices': 0,
        'pausedDevices': 0,
        'blockedDevices': 0,
      };
    }

    int lockedCount = 0;
    int pausedCount = 0;
    int blockedCount = 0;

    for (final control in _deviceControls) {
      if (control.isLocked) lockedCount++;
      if (control.isInternetPaused) pausedCount++;
      if (control.isAppBlockingEnabled) blockedCount++;
    }

    return {
      'totalDevices': _deviceControls.length,
      'lockedDevices': lockedCount,
      'pausedDevices': pausedCount,
      'blockedDevices': blockedCount,
    };
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
