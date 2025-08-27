import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lockbloom/app/routes/app_pages.dart';
import 'package:lockbloom/app/services/biometric_service.dart';
import 'package:lockbloom/app/services/encryption_service.dart';
import 'package:lockbloom/app/services/storage_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthController extends GetxController {
  static const String _pinKey = 'user_pin';
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _isSetupCompleteKey = 'setup_complete';

  final BiometricService _biometricService = Get.find();
  final EncryptionService _encryptionService = Get.find();
  final StorageService _storageService = Get.find();

  final isAuthenticated = false.obs;
  final isBiometricEnabled = false.obs;
  final isBiometricAvailable = false.obs;
  final isSetupComplete = false.obs;
  final isLoading = false.obs;

  final pinController = TextEditingController();
  final confirmPinController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _checkInitialState();
  }

  @override
  void onClose() {
    pinController.dispose();
    confirmPinController.dispose();
    super.onClose();
  }

  /// Check initial authentication state
  Future<void> _checkInitialState() async {
    isLoading.value = true;

    try {
      // Check if biometric is available
      isBiometricAvailable.value = await _biometricService.isAvailable();

      // Check if setup is complete
      isSetupComplete.value =
          _storageService.read<bool>(_isSetupCompleteKey) ?? false;

      // Check if biometric is enabled
      isBiometricEnabled.value =
          _storageService.read<bool>(_biometricEnabledKey) ?? false;

      // Initialize encryption service
      await _encryptionService.init();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to initialize app: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Setup PIN for first time users
  Future<void> setupPin(String pin) async {
    if (pin.length < 4) {
      Fluttertoast.showToast(msg: 'PIN must be at least 4 digits');
      return;
    }

    isLoading.value = true;

    try {
      // Encrypt and store PIN
      final encryptedPin = _encryptionService.encrypt(pin);
      await _storageService.writeSecure(_pinKey, encryptedPin);

      // Mark setup as complete
      await _storageService.write(_isSetupCompleteKey, true);
      isSetupComplete.value = true;

      // If biometric is available, ask user if they want to enable it
      if (isBiometricAvailable.value) {
        final toEnableBiometric = await Get.dialog<bool>(
          AlertDialog(
            title: const Text('Enable Biometric Authentication?'),
            content: const Text(
              'You can use your fingerprint or face to unlock the app quickly.',
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('No Thanks'),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                child: const Text('Enable'),
              ),
            ],
          ),
        );
        if (toEnableBiometric == true) {
          await enableBiometric();
        }
      }

      // Navigate to home
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to setup PIN: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Authenticate with PIN
  Future<void> authenticateWithPin(String pin) async {
    isLoading.value = true;

    try {
      final encryptedStoredPin = await _storageService.readSecure(_pinKey);
      if (encryptedStoredPin == null) {
        Fluttertoast.showToast(msg: 'No PIN found. Please setup the app again.');
        return;
      }

      final storedPin = _encryptionService.decrypt(encryptedStoredPin);

      if (pin == storedPin) {
        isAuthenticated.value = true;
        Get.offAllNamed(Routes.HOME);
      } else {
        Fluttertoast.showToast(msg: 'Incorrect PIN');
        pinController.clear();
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Authentication failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Authenticate with biometric
  Future<void> authenticateWithBiometric() async {
    if (!isBiometricEnabled.value || !isBiometricAvailable.value) return;

    try {
      final success = await _biometricService.authenticate(
        localizedReason: 'Authenticate to access your passwords',
      );

      if (success) {
        isAuthenticated.value = true;
        Get.offAllNamed(Routes.HOME);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Biometric authentication failed');
    }
  }

  /// Enable biometric authentication
  Future<void> enableBiometric() async {
    print('enableBiometric called');
    if (!isBiometricAvailable.value) {
      Fluttertoast.showToast(msg: 'Biometric authentication not available');
      return;
    }

    try {
      final success = await _biometricService.authenticate(
        localizedReason: 'Authenticate to enable biometric login',
      );

      if (success) {
        await _storageService.write(_biometricEnabledKey, true);
        isBiometricEnabled.value = true;
        Fluttertoast.showToast(msg: 'Biometric authentication enabled');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to enable biometric authentication');
    }
  }

  /// Disable biometric authentication
  Future<void> disableBiometric() async {
    await _storageService.write(_biometricEnabledKey, false);
    isBiometricEnabled.value = false;
    Fluttertoast.showToast(msg: 'Biometric authentication disabled');
  }

  /// Change PIN
  Future<void> changePin(String currentPin, String newPin) async {
    if (newPin.length < 4) {
      Fluttertoast.showToast(msg: 'PIN must be at least 4 digits');
      return;
    }

    isLoading.value = true;

    try {
      // Verify current PIN
      final encryptedStoredPin = await _storageService.readSecure(_pinKey);
      if (encryptedStoredPin == null) {
        Fluttertoast.showToast(msg: 'No PIN found');
        return;
      }

      final storedPin = _encryptionService.decrypt(encryptedStoredPin);

      if (currentPin != storedPin) {
        Fluttertoast.showToast(msg: 'Current PIN is incorrect');
        return;
      }

      // Save new PIN
      final encryptedNewPin = _encryptionService.encrypt(newPin);
      await _storageService.writeSecure(_pinKey, encryptedNewPin);

      Fluttertoast.showToast(msg: 'PIN changed successfully');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to change PIN: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Logout user
  void logout() {
    isAuthenticated.value = false;
    pinController.clear();
    confirmPinController.clear();
    Get.offAllNamed(Routes.AUTH);
  }

  /// Reset app (clear all data)
  Future<void> resetApp() async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Reset App'),
        content: const Text(
          'This will delete all your passwords and settings. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Reset'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _storageService.clearSecure();
        await _storageService.clear();
        await _encryptionService.clearKeys();

        isAuthenticated.value = false;
        isSetupComplete.value = false;
        isBiometricEnabled.value = false;

        Get.offAllNamed(Routes.SPLASH);
        Fluttertoast.showToast(msg: 'App has been reset');
      } catch (e) {
        Fluttertoast.showToast(msg: 'Failed to reset app: ${e.toString()}');
      }
    }
  }
}
