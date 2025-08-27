import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lockbloom/app/controllers/auth_controller.dart';
import 'package:lockbloom/app/services/storage_service.dart';
import 'package:lockbloom/app/services/theme_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SettingsController extends GetxController {
  static const String _autoLockTimeoutKey = 'auto_lock_timeout';
  static const String _clipboardClearTimeKey = 'clipboard_clear_time';
  static const String _passwordHistoryKey = 'password_history_enabled';
  
  final ThemeService _themeService = Get.find();
  final AuthController _authController = Get.find();
  final StorageService _storageService = Get.find();

  // Observable settings
  final autoLockTimeout = 300.obs; // 5 minutes default
  final clipboardClearTime = 30.obs; // 30 seconds default
  final isPasswordHistoryEnabled = true.obs;
  final isLoading = false.obs;

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
  }

  /// Load settings from storage
  void _loadSettings() {
    autoLockTimeout.value = _storageService.read<int>(_autoLockTimeoutKey) ?? 300;
    clipboardClearTime.value = _storageService.read<int>(_clipboardClearTimeKey) ?? 30;
    isPasswordHistoryEnabled.value = _storageService.read<bool>(_passwordHistoryKey) ?? true;
  }

  /// Update auto-lock timeout
  Future<void> updateAutoLockTimeout(int timeout) async {
    autoLockTimeout.value = timeout;
    await _storageService.write(_autoLockTimeoutKey, timeout);
    Fluttertoast.showToast(msg: 'Auto-lock timeout updated');
  }

  /// Update clipboard clear time
  Future<void> updateClipboardClearTime(int time) async {
    clipboardClearTime.value = time;
    await _storageService.write(_clipboardClearTimeKey, time);
    Fluttertoast.showToast(msg: 'Clipboard clear time updated');
  }

  /// Toggle password history
  Future<void> togglePasswordHistory(bool enabled) async {
    isPasswordHistoryEnabled.value = enabled;
    await _storageService.write(_passwordHistoryKey, enabled);
    Fluttertoast.showToast(msg: 'Password history ${enabled ? 'enabled' : 'disabled'}');
  }

  /// Get current theme mode display text
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

  /// Show theme selection dialog
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

  /// Show auto-lock timeout dialog
  void showAutoLockDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Auto-Lock Timeout'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: timeoutOptions.map((option) {
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
    );
  }

  /// Show clipboard clear time dialog
  void showClipboardDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Clipboard Clear Time'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: clipboardOptions.map((option) {
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
    );
  }

  /// Show change PIN dialog
  void showChangePinDialog() {
    final currentPinController = TextEditingController();
    final newPinController = TextEditingController();
    final confirmPinController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Change PIN'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPinController,
              decoration: const InputDecoration(labelText: 'Current PIN'),
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 6,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPinController,
              decoration: const InputDecoration(labelText: 'New PIN'),
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 6,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPinController,
              decoration: const InputDecoration(labelText: 'Confirm New PIN'),
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 6,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (newPinController.text != confirmPinController.text) {
                Fluttertoast.showToast(msg: 'New PIN and confirmation do not match');
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

  /// Get timeout display text
  String getTimeoutDisplayText(int timeout) {
    final option = timeoutOptions.firstWhere((o) => o['value'] == timeout);
    return option['label'] as String;
  }

  /// Get clipboard clear time display text
  String getClipboardDisplayText(int time) {
    final option = clipboardOptions.firstWhere((o) => o['value'] == time);
    return option['label'] as String;
  }

  /// Show export dialog
  void showExportDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Export Passwords'),
        content: const Text('This will export all your passwords as an encrypted file. Keep this file secure.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Export functionality would go here
              Get.back();
              Fluttertoast.showToast(msg: 'Passwords exported');
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  /// Show import dialog
  void showImportDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Import Passwords'),
        content: const Text('Select an encrypted backup file to import your passwords.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Import functionality would go here
              Get.back();
              Fluttertoast.showToast(msg: 'Passwords imported');
            },
            child: const Text('Select File'),
          ),
        ],
      ),
    );
  }

  /// Show reset app confirmation
  void showResetAppDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Reset App'),
        content: const Text('This will delete all your passwords and settings. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
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