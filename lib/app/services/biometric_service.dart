import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lockbloom/app/services/storage_service.dart';

class BiometricService extends GetxService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  /// Check if biometric authentication is available
  Future<bool> isAvailable() async {
    try {
      final bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final bool isDeviceSupported = await _localAuth.isDeviceSupported();
      print('BiometricService: isAvailable - canCheckBiometrics: $canCheckBiometrics, isDeviceSupported: $isDeviceSupported');
      return canCheckBiometrics && isDeviceSupported;
    } catch (e) {
      print('BiometricService: isAvailable error: $e');
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
      if (!isAvailable) {
        print('BiometricService: authenticate - Biometrics not available on device.');
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
      print('BiometricService: authenticate - Authenticated: $authenticated');
      return authenticated;
    } on PlatformException catch (e) {
      print('BiometricService: authenticate PlatformException: ${e.code} - ${e.message}');
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
      print('BiometricService: authenticate general error: $e');
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

  /// Check if biometric authentication is enabled in app settings
  Future<bool> isBiometricEnabledInApp() async {
    // This checks app-specific settings stored in StorageService
    final bool isEnabledInSettings = _storageService.read<bool>(_biometricEnabledKey) ?? false;
    final bool deviceIsAvailable = await isAvailable();
    print('BiometricService: isBiometricEnabledInApp - isEnabledInSettings: $isEnabledInSettings, deviceIsAvailable: $deviceIsAvailable');
    return isEnabledInSettings && deviceIsAvailable;
  }
}