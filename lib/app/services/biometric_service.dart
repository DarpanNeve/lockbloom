import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lockbloom/app/services/storage_service.dart';

class BiometricService extends GetxService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<bool> isAvailable() async {
    try {
      final bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final bool isDeviceSupported = await _localAuth.isDeviceSupported();
      return canCheckBiometrics && isDeviceSupported;
    } catch (e) {
      return false;
    }
  }

  /// Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  Future<bool> authenticate({
    String localizedReason = 'Please authenticate to access your passwords',
    bool biometricOnly = false,
  }) async {
    try {
      final bool isAvailable = await this.isAvailable();
      if (!isAvailable) {
        return false;
      }

      final bool authenticated = await _localAuth.authenticate(
        localizedReason: localizedReason,
        options: AuthenticationOptions(
          biometricOnly: biometricOnly,
          stickyAuth: true,
          sensitiveTransaction: true,
        ),
      );
      return authenticated;
    } on PlatformException catch (e) {
      switch (e.code) {
        case 'NotAvailable':
        case 'NotEnrolled':
        case 'LockedOut':
        case 'PermanentlyLockedOut':
          return false;
        default:
          return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// Stop authentication
  Future<void> stopAuthentication() async {
    try {
      await _localAuth.stopAuthentication();
    } catch (e) {
      // Ignore errors when stopping authentication
    }
  }

  /// Get biometric type display name
  String getBiometricTypeDisplayName(BiometricType type) {
    switch (type) {
      case BiometricType.face:
        return 'Face ID';
      case BiometricType.fingerprint:
        return 'Fingerprint';
      case BiometricType.iris:
        return 'Iris';
      case BiometricType.strong:
        return 'Strong Biometrics';
      case BiometricType.weak:
        return 'Weak Biometrics';
      default:
        return 'Biometric';
    }
  }

  final StorageService _storageService = Get.find();
  static const String _biometricEnabledKey = 'biometric_enabled';

  Future<bool> isBiometricEnabledInApp() async {
    final bool isEnabledInSettings = _storageService.read<bool>(_biometricEnabledKey) ?? false;
    final bool deviceIsAvailable = await isAvailable();
    return isEnabledInSettings && deviceIsAvailable;
  }
}