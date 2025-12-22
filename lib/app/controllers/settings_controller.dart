import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lockbloom/app/controllers/auth_controller.dart';
import 'package:lockbloom/app/controllers/password_controller.dart';
import 'package:lockbloom/app/repositories/password_repository.dart';
import 'package:lockbloom/app/services/storage_service.dart';
import 'package:lockbloom/app/services/theme_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsController extends GetxController {
  static const String _autoLockTimeoutKey = 'auto_lock_timeout';
  static const String _clipboardClearTimeKey = 'clipboard_clear_time';
  static const String _passwordHistoryKey = 'password_history_enabled';

  final ThemeService _themeService = Get.find();
  final AuthController _authController = Get.find();
  final StorageService _storageService = Get.find();
  final PasswordController _passwordController = Get.find();
  final PasswordRepository _passwordRepository = Get.find();

  final autoLockTimeout = 300.obs;
  final clipboardClearTime = 30.obs;
  final isPasswordHistoryEnabled = true.obs;
  final isLoading = false.obs;
  final appVersion = ''.obs;

  static const String _privacyPolicyUrl = 'https://lockbloom.app/privacy';
  static const String _termsOfServiceUrl = 'https://lockbloom.app/terms';

  // Available timeout options (in seconds)
  final timeoutOptions = [
    {'label': 'Immediately', 'value': 0},
    {'label': '30 seconds', 'value': 30},
    {'label': '1 minute', 'value': 60},
    {'label': '5 minutes', 'value': 300},
    {'label': '15 minutes', 'value': 900},
    {'label': '30 minutes', 'value': 1800},
    {'label': 'Never', 'value': -1},
  ];

  // Available clipboard clear times (in seconds)
  final clipboardOptions = [
    {'label': '10 seconds', 'value': 10},
    {'label': '30 seconds', 'value': 30},
    {'label': '1 minute', 'value': 60},
    {'label': '2 minutes', 'value': 120},
    {'label': '5 minutes', 'value': 300},
    {'label': 'Never', 'value': -1},
  ];

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
    _loadAppVersion();
  }
  
  Future<void> _loadAppVersion() async {
    appVersion.value = '1.0.20 (21)';
  }

  void _loadSettings() {
    autoLockTimeout.value =
        _storageService.read<int>(_autoLockTimeoutKey) ?? 300;
    clipboardClearTime.value =
        _storageService.read<int>(_clipboardClearTimeKey) ?? 30;
    isPasswordHistoryEnabled.value =
        _storageService.read<bool>(_passwordHistoryKey) ?? true;
  }

  Future<void> updateAutoLockTimeout(int timeout) async {
    autoLockTimeout.value = timeout;
    await _storageService.write(_autoLockTimeoutKey, timeout);
    _authController.updateAutoLockTimeout(timeout);
    Fluttertoast.showToast(msg: 'Auto-lock timeout updated');
  }

  Future<void> updateClipboardClearTime(int time) async {
    clipboardClearTime.value = time;
    await _storageService.write(_clipboardClearTimeKey, time);
    Fluttertoast.showToast(msg: 'Clipboard clear time updated');
  }

  Future<void> togglePasswordHistory(bool enabled) async {
    isPasswordHistoryEnabled.value = enabled;
    await _storageService.write(_passwordHistoryKey, enabled);
    Fluttertoast.showToast(
      msg: 'Password history ${enabled ? 'enabled' : 'disabled'}',
    );
  }

  String get currentThemeText {
    switch (_themeService.theme) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  void showThemeDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemeOption('Light', ThemeMode.light),
            _buildThemeOption('Dark', ThemeMode.dark),
            _buildThemeOption('System', ThemeMode.system),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(String title, ThemeMode mode) {
    return RadioListTile<ThemeMode>(
      title: Text(title),
      value: mode,
      groupValue: _themeService.theme,
      onChanged: (value) {
        if (value != null) {
          _themeService.changeTheme(value);
          Get.back();
        }
      },
    );
  }

  void showAutoLockDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Auto-Lock Timeout'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                timeoutOptions.map((option) {
                  return RadioListTile<int>(
                    title: Text(option['label'] as String),
                    value: option['value'] as int,
                    groupValue: autoLockTimeout.value,
                    onChanged: (value) {
                      if (value != null) {
                        updateAutoLockTimeout(value);
                        Get.back();
                      }
                    },
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }

  void showClipboardDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Clipboard Clear Time'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                clipboardOptions.map((option) {
                  return RadioListTile<int>(
                    title: Text(option['label'] as String),
                    value: option['value'] as int,
                    groupValue: clipboardClearTime.value,
                    onChanged: (value) {
                      if (value != null) {
                        updateClipboardClearTime(value);
                        Get.back();
                      }
                    },
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }

  void showChangePinDialog() {
    final currentPinController = TextEditingController();
    final newPinController = TextEditingController();
    final confirmPinController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Change PIN'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPinController,
                decoration: const InputDecoration(
                  labelText: 'Current PIN',
                  prefixIcon: Icon(Icons.lock_outline_rounded),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 8,
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: newPinController,
                decoration: const InputDecoration(
                  labelText: 'New PIN',
                  prefixIcon: Icon(Icons.lock_rounded),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 8,
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: confirmPinController,
                decoration: const InputDecoration(
                  labelText: 'Confirm New PIN',
                  prefixIcon: Icon(Icons.lock_rounded),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 8,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (newPinController.text != confirmPinController.text) {
                Fluttertoast.showToast(
                  msg: 'New PIN and confirmation do not match',
                );
                return;
              }
              _authController.changePin(
                currentPinController.text,
                newPinController.text,
              );
              Get.back();
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  String getTimeoutDisplayText(int timeout) {
    final option = timeoutOptions.firstWhere((o) => o['value'] == timeout);
    return option['label'] as String;
  }

  String getClipboardDisplayText(int time) {
    final option = clipboardOptions.firstWhere((o) => o['value'] == time);
    return option['label'] as String;
  }

  void showExportDialog() {
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Export Passwords'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Enter a password to encrypt your export file:',
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Export Password',
                  prefixIcon: Icon(Icons.key_rounded),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: Icon(Icons.key_rounded),
                ),
                obscureText: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final password = passwordController.text;
              final confirmPassword = confirmPasswordController.text;

              if (password.isEmpty) {
                Fluttertoast.showToast(
                  msg: 'Please enter a password',
                );
                return;
              }

              if (password.length < 6) {
                Fluttertoast.showToast(
                  msg: 'Password must be at least 6 characters',
                );
                return;
              }

              if (password != confirmPassword) {
                Fluttertoast.showToast(
                  msg: 'Passwords do not match',
                );
                return;
              }

              Get.back();
              _confirmAndExport(password);
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }
  
  Future<void> _confirmAndExport(String password) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Confirm Export'),
        content: const Text(
          'This will create an encrypted backup file containing all your passwords. '
          'If a file with the same name exists, it will be overwritten.\n\n'
          'Make sure to remember the export password - you will need it to import the backup.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Export Now'),
          ),
        ],
      ),
    );
    
    if (confirm == true) {
      await _exportPasswords(password);
    }
  }

  void showImportDialog() {
    final passwordController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Import Passwords'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Enter the password used to encrypt the backup file:',
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Import Password',
                  prefixIcon: Icon(Icons.key_rounded),
                ),
                obscureText: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final password = passwordController.text;

              if (password.isEmpty) {
                Fluttertoast.showToast(
                  msg: 'Please enter the import password',
                );
                return;
              }

              Get.back();
              _importPasswords(password);
            },
            child: const Text('Select File'),
          ),
        ],
      ),
    );
  }

  Future<void> _exportPasswords(String password) async {
    try {
      isLoading.value = true;
      final exportData = await _passwordRepository.exportPasswords(password);

      final result = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Passwords',
        fileName: 'lockbloom_export_${DateTime.now().millisecondsSinceEpoch}.json',
        bytes: utf8.encode(exportData),
      );

      if (result != null) {
        Fluttertoast.showToast(
          msg: 'Passwords exported successfully',
        );
      } else {
        Fluttertoast.showToast(msg: 'Export cancelled');
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to export passwords: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _importPasswords(String password) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null || result.files.isEmpty) {
        Fluttertoast.showToast(msg: 'Import cancelled');
        return;
      }
      
      final filePath = result.files.single.path;
      if (filePath == null) {
        Fluttertoast.showToast(msg: 'Could not access file');
        return;
      }

      isLoading.value = true;
      final file = File(filePath);
      
      if (!await file.exists()) {
        Fluttertoast.showToast(msg: 'File not found');
        return;
      }
      
      final encryptedData = await file.readAsString();

      await _passwordRepository.importPasswords(encryptedData, password);
      await _passwordController.loadPasswords();
      
      HapticFeedback.lightImpact();
      Fluttertoast.showToast(msg: 'Passwords imported successfully');
    } on FileSystemException {
      Fluttertoast.showToast(msg: 'Could not read file - permission denied');
    } on FormatException {
      Fluttertoast.showToast(msg: 'Invalid file format');
    } catch (e) {
      final message = e.toString();
      if (message.contains('Invalid password') || message.contains('decrypt')) {
        Fluttertoast.showToast(msg: 'Incorrect password or corrupted file');
      } else {
        Fluttertoast.showToast(msg: 'Import failed - invalid backup file');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> openPrivacyPolicy() async {
    final uri = Uri.parse(_privacyPolicyUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Fluttertoast.showToast(msg: 'Could not open privacy policy');
    }
  }

  Future<void> openTermsOfService() async {
    final uri = Uri.parse(_termsOfServiceUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Fluttertoast.showToast(msg: 'Could not open terms of service');
    }
  }

  void showResetAppDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Reset App'),
        content: const Text(
          'This will delete all your passwords and settings. This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              _authController.resetApp();
            },
            child: const Text('Reset'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );
  }
}
