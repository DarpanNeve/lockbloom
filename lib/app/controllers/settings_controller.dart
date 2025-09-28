import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lockbloom/app/controllers/auth_controller.dart';
import 'package:lockbloom/app/controllers/password_controller.dart';
import 'package:lockbloom/app/repositories/password_repository.dart';
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
  final PasswordController _passwordController = Get.find();
  final PasswordRepository _passwordRepository = Get.find();

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
    autoLockTimeout.value =
        _storageService.read<int>(_autoLockTimeoutKey) ?? 300;
    clipboardClearTime.value =
        _storageService.read<int>(_clipboardClearTimeKey) ?? 30;
    isPasswordHistoryEnabled.value =
        _storageService.read<bool>(_passwordHistoryKey) ?? true;
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
    Fluttertoast.showToast(
      msg: 'Password history ${enabled ? 'enabled' : 'disabled'}',
    );
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
    );
  }

  /// Show clipboard clear time dialog
  void showClipboardDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Clipboard Clear Time'),
        content: Column(
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
    );
  }

  /// Show change PIN dialog
  void showChangePinDialog() {
    final currentPinController = TextEditingController();
    final newPinController = TextEditingController();
    final confirmPinController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text(
          'Change PIN',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        content: Container(
          constraints: BoxConstraints(maxHeight: 250.h),
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPinController,
                decoration: InputDecoration(
                  labelText: 'Current PIN',
                  labelStyle: TextStyle(fontSize: 14.sp),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 16.h,
                  ),
                ),
                style: TextStyle(fontSize: 16.sp),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 8,
              ),
              Spacer(),
              TextField(
                controller: newPinController,
                decoration: InputDecoration(
                  labelText: 'New PIN',
                  labelStyle: TextStyle(fontSize: 14.sp),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 16.h,
                  ),
                ),
                style: TextStyle(fontSize: 16.sp),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 8,
              ),
              Spacer(),
              TextField(
                controller: confirmPinController,
                decoration: InputDecoration(
                  labelText: 'Confirm New PIN',
                  labelStyle: TextStyle(fontSize: 14.sp),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 16.h,
                  ),
                ),
                style: TextStyle(fontSize: 16.sp),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 8,
              ),
            ],
          ),
        ),
        actionsPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              minimumSize: Size(60.w, 36.h),
            ),
            child: Text('Cancel', style: TextStyle(fontSize: 14.sp)),
          ),
          SizedBox(width: 8.w),
          TextButton(
            onPressed: () {
              if (newPinController.text != confirmPinController.text) {
                Fluttertoast.showToast(
                  msg: 'New PIN and confirmation do not match',
                  fontSize: 14.sp,
                );
                return;
              }
              _authController.changePin(
                currentPinController.text,
                newPinController.text,
              );
              Get.back();
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              minimumSize: Size(60.w, 36.h),
            ),
            child: Text('Change', style: TextStyle(fontSize: 14.sp)),
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
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text(
          'Export Passwords',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        content: Container(
          constraints: BoxConstraints(maxHeight: 200.h),
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Enter a password to encrypt your export file:',
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Export Password',
                  labelStyle: TextStyle(fontSize: 14.sp),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 16.h,
                  ),
                ),
                style: TextStyle(fontSize: 16.sp),
                obscureText: true,
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: TextStyle(fontSize: 14.sp),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 16.h,
                  ),
                ),
                style: TextStyle(fontSize: 16.sp),
                obscureText: true,
              ),
            ],
          ),
        ),
        actionsPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              minimumSize: Size(60.w, 36.h),
            ),
            child: Text('Cancel', style: TextStyle(fontSize: 14.sp)),
          ),
          SizedBox(width: 8.w),
          TextButton(
            onPressed: () {
              final password = passwordController.text;
              final confirmPassword = confirmPasswordController.text;

              if (password.isEmpty) {
                Fluttertoast.showToast(
                  msg: 'Please enter a password',
                  fontSize: 14.sp,
                );
                return;
              }

              if (password.length < 6) {
                Fluttertoast.showToast(
                  msg: 'Password must be at least 6 characters',
                  fontSize: 14.sp,
                );
                return;
              }

              if (password != confirmPassword) {
                Fluttertoast.showToast(
                  msg: 'Passwords do not match',
                  fontSize: 14.sp,
                );
                return;
              }

              Get.back();
              _exportPasswords(password);
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              minimumSize: Size(60.w, 36.h),
            ),
            child: Text('Export', style: TextStyle(fontSize: 14.sp)),
          ),
        ],
      ),
    );
  }

  /// Show import dialog
  void showImportDialog() {
    final passwordController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text(
          'Import Passwords',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        content: Container(
          constraints: BoxConstraints(maxHeight: 120.h),
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Enter the password used to encrypt the backup file:',
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Import Password',
                  labelStyle: TextStyle(fontSize: 14.sp),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 16.h,
                  ),
                ),
                style: TextStyle(fontSize: 16.sp),
                obscureText: true,
              ),
            ],
          ),
        ),
        actionsPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              minimumSize: Size(60.w, 36.h),
            ),
            child: Text('Cancel', style: TextStyle(fontSize: 14.sp)),
          ),
          SizedBox(width: 8.w),
          TextButton(
            onPressed: () {
              final password = passwordController.text;

              if (password.isEmpty) {
                Fluttertoast.showToast(
                  msg: 'Please enter the import password',
                  fontSize: 14.sp,
                );
                return;
              }

              Get.back();
              _importPasswords(password);
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              minimumSize: Size(60.w, 36.h),
            ),
            child: Text('Select File', style: TextStyle(fontSize: 14.sp)),
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

      if (result != null && result.files.single.path != null) {
        isLoading.value = true;
        final file = File(result.files.single.path!);
        final encryptedData = await file.readAsString();

        await _passwordRepository.importPasswords(encryptedData, password);
        await _passwordController.loadPasswords();

        Fluttertoast.showToast(msg: 'Passwords imported successfully');
      } else {
        Fluttertoast.showToast(msg: 'Import cancelled');
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to import passwords: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Show reset app confirmation
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
