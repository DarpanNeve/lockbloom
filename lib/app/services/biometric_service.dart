import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService extends GetxService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  /// Check if biometric authentication is available
  Future<bool> isAvailable() async {
    try {
      final bool isAvailable = await _localAuth.canCheckBiometrics;
      final bool isDeviceSupported = await _localAuth.isDeviceSupported();
      return isAvailable && isDeviceSupported;
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

  /// Authenticate using biometrics
  Future<bool> authenticate({
    String localizedReason = 'Please authenticate to access your passwords',
    bool biometricOnly = false,
  }) async {
    try {
      final bool isAvailable = await this.isAvailable();
      if (!isAvailable) return false;

      return await _localAuth.authenticate(
        localizedReason: localizedReason,
        options: AuthenticationOptions(
          biometricOnly: biometricOnly,
          stickyAuth: true,
          sensitiveTransaction: true,
        ),
      );
    } on PlatformException catch (e) {
      // Handle specific error cases
      switch (e.code) {
        case 'NotAvailable':
          return false;
        case 'NotEnrolled':
          return false;
        case 'LockedOut':
          return false;
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

  /// Check if biometric authentication is enabled in app settings
  Future<bool> isBiometricEnabledInApp() async {
    // This would typically check app-specific settings
    // For now, return true if biometrics are available
    return await isAvailable();
  }
}