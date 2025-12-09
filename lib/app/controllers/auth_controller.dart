import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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

  static const int _maxFailedAttempts = 5;
  static const Duration _lockoutDuration = Duration(seconds: 30);
  static const String _failedAttemptsKey = 'auth_failed_attempts';
  static const String _lockoutUntilKey = 'auth_lockout_until';

  final failedAttempts = 0.obs;
  final lockoutUntil = Rxn<DateTime>();

  Future<void> _checkInitialState() async {
    isLoading.value = true;

    try {
      isBiometricAvailable.value = await _biometricService.isAvailable();

      isSetupComplete.value =
          _storageService.read<bool>(_isSetupCompleteKey) ?? false;

      isBiometricEnabled.value =
          _storageService.read<bool>(_biometricEnabledKey) ?? false;
      
      final storedAttempts = _storageService.read<int>(_failedAttemptsKey);
      if (storedAttempts != null) failedAttempts.value = storedAttempts;

      final storedLockout = _storageService.read<String>(_lockoutUntilKey);
      if (storedLockout != null) {
        lockoutUntil.value = DateTime.tryParse(storedLockout);
      }

      await _encryptionService.init();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack, reason: 'Auth checkInitialState failed');
      Fluttertoast.showToast(msg: 'Failed to initialize app: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setupPin(String pin) async {
    if (pin.length < 4) {
      Fluttertoast.showToast(msg: 'PIN must be at least 4 digits');
      return;
    }

    isLoading.value = true;

    try {
      final encryptedPin = _encryptionService.encrypt(pin);
      await _storageService.writeSecure(_pinKey, encryptedPin);

      await _storageService.write(_isSetupCompleteKey, true);
      isSetupComplete.value = true;

      FirebaseAnalytics.instance.logSignUp(signUpMethod: 'pin');

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

      Get.offAllNamed(Routes.HOME);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack, reason: 'setupPin failed');
      Fluttertoast.showToast(msg: 'Failed to setup PIN: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> verifyPin(String pin) async {
    if (lockoutUntil.value != null) {
      if (DateTime.now().isBefore(lockoutUntil.value!)) {
        final remaining = lockoutUntil.value!.difference(DateTime.now()).inSeconds;
        Fluttertoast.showToast(msg: 'Too many attempts. Try again in ${remaining}s');
        return false;
      } else {
        lockoutUntil.value = null;
        failedAttempts.value = 0;
        await _storageService.remove(_lockoutUntilKey);
        await _storageService.remove(_failedAttemptsKey);
      }
    }

    try {
      final encryptedStoredPin = await _storageService.readSecure(_pinKey);
      if (encryptedStoredPin == null) {
        return false;
      }

      final storedPin = _encryptionService.decrypt(encryptedStoredPin);

      if (pin == storedPin) {
        failedAttempts.value = 0;
        await _storageService.remove(_failedAttemptsKey);
        return true;
      } else {
        failedAttempts.value++;
        await _storageService.write(_failedAttemptsKey, failedAttempts.value);
        
        if (failedAttempts.value >= _maxFailedAttempts) {
            lockoutUntil.value = DateTime.now().add(_lockoutDuration);
            await _storageService.write(_lockoutUntilKey, lockoutUntil.value!.toIso8601String());
            Fluttertoast.showToast(msg: 'Too many failed attempts. Locked for 30s.');
        }
        return false;
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack, reason: 'verifyPin failed');
      return false;
    }
  }

  Future<void> authenticateWithPin(String pin) async {
    if (lockoutUntil.value != null) {
        if (DateTime.now().isBefore(lockoutUntil.value!)) {
            final remaining = lockoutUntil.value!.difference(DateTime.now()).inSeconds;
            Fluttertoast.showToast(msg: 'Too many attempts. Try again in ${remaining}s');
            return;
        } else {
            // Lockout expired
            lockoutUntil.value = null;
            failedAttempts.value = 0;
            await _storageService.remove(_lockoutUntilKey);
            await _storageService.remove(_failedAttemptsKey);
        }
    }

    isLoading.value = true;

    try {
      final encryptedStoredPin = await _storageService.readSecure(_pinKey);
      if (encryptedStoredPin == null) {
        Fluttertoast.showToast(
          msg: 'No PIN found. Please setup the app again.',
        );
        return;
      }

      final storedPin = _encryptionService.decrypt(encryptedStoredPin);

      if (pin == storedPin) {
        isAuthenticated.value = true;
        
        failedAttempts.value = 0;
        await _storageService.remove(_failedAttemptsKey);
        
        FirebaseAnalytics.instance.logLogin(loginMethod: 'pin');
        Get.offAllNamed(Routes.HOME);
      } else {
        failedAttempts.value++;
        await _storageService.write(_failedAttemptsKey, failedAttempts.value);
        
        if (failedAttempts.value >= _maxFailedAttempts) {
            lockoutUntil.value = DateTime.now().add(_lockoutDuration);
            await _storageService.write(_lockoutUntilKey, lockoutUntil.value!.toIso8601String());
            Fluttertoast.showToast(msg: 'Too many failed attempts. Locked for 30s.');
        } else {
            Fluttertoast.showToast(msg: 'Incorrect PIN. Attempts: ${failedAttempts.value}/$_maxFailedAttempts');
        }
        
        pinController.clear();
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack, reason: 'authenticateWithPin failed');
      Fluttertoast.showToast(msg: 'Authentication failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> authenticateWithBiometric() async {
    if (!isBiometricEnabled.value || !isBiometricAvailable.value) return;

    try {
      final success = await _biometricService.authenticate(
        localizedReason: 'Authenticate to access your passwords',
      );

      if (success) {
        isAuthenticated.value = true;
        FirebaseAnalytics.instance.logLogin(loginMethod: 'biometric');
        Get.offAllNamed(Routes.HOME);
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack, reason: 'authenticateWithBiometric failed');
      Fluttertoast.showToast(msg: 'Biometric authentication failed');
    }
  }

  Future<void> enableBiometric() async {
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
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack, reason: 'enableBiometric failed');
      Fluttertoast.showToast(msg: 'Failed to enable biometric authentication');
    }
  }

  Future<void> disableBiometric() async {
    await _storageService.write(_biometricEnabledKey, false);
    isBiometricEnabled.value = false;
    Fluttertoast.showToast(msg: 'Biometric authentication disabled');
  }

  Future<void> changePin(String currentPin, String newPin) async {
    if (newPin.length < 4) {
      Fluttertoast.showToast(msg: 'PIN must be at least 4 digits');
      return;
    }

    isLoading.value = true;

    try {
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

      final encryptedNewPin = _encryptionService.encrypt(newPin);
      await _storageService.writeSecure(_pinKey, encryptedNewPin);

      FirebaseAnalytics.instance.logEvent(name: 'change_pin');
      Fluttertoast.showToast(msg: 'PIN changed successfully');
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack, reason: 'changePin failed');
      Fluttertoast.showToast(msg: 'Failed to change PIN: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    isAuthenticated.value = false;
    pinController.clear();
    confirmPinController.clear();
    Get.offAllNamed(Routes.AUTH);
  }

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
      } catch (e, stack) {
        FirebaseCrashlytics.instance.recordError(e, stack, reason: 'resetApp failed');
        Fluttertoast.showToast(msg: 'Failed to reset app: ${e.toString()}');
      }
    }
  }
}
