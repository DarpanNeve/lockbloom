import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lockbloom/app/controllers/auth_controller.dart';
import 'package:lockbloom/app/controllers/password_controller.dart';
import 'package:lockbloom/app/core/theme/app_colors.dart';
import 'package:lockbloom/app/repositories/password_repository.dart';
import 'package:lockbloom/app/services/locale_service.dart';
import 'package:lockbloom/app/services/storage_service.dart';
import 'package:lockbloom/app/services/theme_service.dart';
import 'package:lockbloom/app/services/subscription_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsController extends GetxController {
  static const String _autoLockTimeoutKey = 'auto_lock_timeout';
  static const String _clipboardClearTimeKey = 'clipboard_clear_time';
  static const String _passwordHistoryKey = 'password_history_enabled';

  final ThemeService _themeService = Get.find();
  final LocaleService _localeService = Get.find();
  final AuthController _authController = Get.find();
  final StorageService _storageService = Get.find();
  final PasswordController _passwordController = Get.find();
  final PasswordRepository _passwordRepository = Get.find();
  final SubscriptionService _subscriptionService = Get.find();

  final autoLockTimeout = 300.obs;
  
  RxBool get isPremium => _subscriptionService.isPremium;
  final clipboardClearTime = 30.obs;
  final isPasswordHistoryEnabled = true.obs;
  final isLoading = false.obs;
  final appVersion = ''.obs;

  static const String _privacyPolicyUrl = 'https://lockbloom.app/privacy';
  static const String _termsOfServiceUrl = 'https://lockbloom.app/terms';

  final timeoutOptions = [
    {'label': 'immediately', 'value': 0},
    {'label': '30 seconds', 'value': 30},
    {'label': '1 minute', 'value': 60},
    {'label': '5 minutes', 'value': 300},
    {'label': '15 minutes', 'value': 900},
    {'label': '30 minutes', 'value': 1800},
    {'label': 'never', 'value': -1},
  ];

  final clipboardOptions = [
    {'label': '10 seconds', 'value': 10},
    {'label': '30 seconds', 'value': 30},
    {'label': '1 minute', 'value': 60},
    {'label': '2 minutes', 'value': 120},
    {'label': '5 minutes', 'value': 300},
    {'label': 'never', 'value': -1},
  ];

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
    _loadAppVersion();
    // Refresh subscription status immediately when controller initializes
    _subscriptionService.checkSubscriptionStatus();
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
    Fluttertoast.showToast(msg: 'timeout_updated'.tr);
  }

  Future<void> updateClipboardClearTime(int time) async {
    clipboardClearTime.value = time;
    await _storageService.write(_clipboardClearTimeKey, time);
    Fluttertoast.showToast(msg: 'clipboard_updated'.tr);
  }

  Future<void> togglePasswordHistory(bool enabled) async {
    isPasswordHistoryEnabled.value = enabled;
    await _storageService.write(_passwordHistoryKey, enabled);
    Fluttertoast.showToast(
      msg: enabled ? 'history_enabled'.tr : 'history_disabled'.tr,
    );
  }

  String get currentThemeText {
    switch (_themeService.theme) {
      case ThemeMode.light:
        return 'light'.tr;
      case ThemeMode.dark:
        return 'dark'.tr;
      case ThemeMode.system:
        return 'system'.tr;
    }
  }

  String get currentAccentColorName {
    final color = _themeService.accentColor;
    return color.getLocalizedName(_localeService.currentLocale.languageCode);
  }

  String get currentLanguageName => _localeService.currentLocaleName;

  void showThemeDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('choose_theme'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemeOption('light'.tr, ThemeMode.light),
            _buildThemeOption('dark'.tr, ThemeMode.dark),
            _buildThemeOption('system'.tr, ThemeMode.system),
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

  void showAccentColorDialog() {
    final categories = AppColors.categorizedColors;
    final categoryKeys = categories.keys.toList();

    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Get.theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: DefaultTabController(
          length: categoryKeys.length,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle Bar
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Title Row
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                child: Row(
                  children: [
                    Text(
                      'choose_accent_color'.tr,
                      style: Get.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close_rounded),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),

              // Tab Bar
              TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                dividerColor: Colors.transparent,
                labelColor: Get.theme.colorScheme.primary,
                unselectedLabelColor: Get.theme.colorScheme.onSurfaceVariant,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 3,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                tabs: categoryKeys.map((key) => Tab(text: key)).toList(),
              ),
              
              Divider(height: 1, color: Get.theme.dividerColor.withValues(alpha: 0.1)),

              // Content
              SizedBox(
                height: 350,
                child: TabBarView(
                  children: categoryKeys.map((key) {
                    final colors = categories[key]!;
                    return GridView.builder(
                      padding: const EdgeInsets.all(24),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: colors.length,
                      itemBuilder: (context, colorIndex) {
                        final color = colors[colorIndex];
                        
                        return Obx(() {
                           final isSelected = color.id == _themeService.accentColorId;
                           return GestureDetector(
                            onTap: () {
                              _themeService.changeAccentColor(color.id);
                              HapticFeedback.selectionClick();
                              Fluttertoast.showToast(msg: 'color_updated'.tr);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: color.primary,
                                shape: BoxShape.circle,
                                border: isSelected
                                    ? Border.all(
                                        color: Get.theme.colorScheme.onSurface,
                                        width: 2.5,
                                      )
                                    : Border.all(
                                        color: Get.theme.colorScheme.outline.withValues(alpha: 0.1),
                                        width: 1,
                                      ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: color.primary.withValues(alpha: 0.4),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        )
                                      ]
                                    : null,
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    )
                                  : null,
                            ),
                          );
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  void showLanguageDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('choose_language'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: LocaleService.supportedLocales.map((option) {
            return RadioListTile<String>(
              title: Row(
                children: [
                  Text(option.flag, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.nativeName,
                        style: Get.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        option.name,
                        style: Get.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
              value: option.locale.languageCode,
              groupValue: _localeService.currentLocale.languageCode,
              onChanged: (value) {
                if (value != null) {
                  _localeService.changeLocale(option.locale);
                  Get.back();
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void showAutoLockDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('auto_lock_timeout'.tr),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                timeoutOptions.map((option) {
                  return RadioListTile<int>(
                    title: Text(_getTimeoutLabel(option['value'] as int)),
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

  String _getTimeoutLabel(int value) {
    if (value == 0) return 'immediately'.tr;
    if (value == -1) return 'never'.tr;
    if (value < 60) return '$value ${'seconds'.tr}';
    if (value == 60) return '1 ${'minute'.tr}';
    return '${value ~/ 60} ${'minutes'.tr}';
  }

  void showClipboardDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('clipboard_clear_time'.tr),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                clipboardOptions.map((option) {
                  return RadioListTile<int>(
                    title: Text(_getClipboardLabel(option['value'] as int)),
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

  String _getClipboardLabel(int value) {
    if (value == -1) return 'never'.tr;
    if (value < 60) return '$value ${'seconds'.tr}';
    if (value == 60) return '1 ${'minute'.tr}';
    return '${value ~/ 60} ${'minutes'.tr}';
  }

  void showChangePinDialog() {
    final currentPinController = TextEditingController();
    final newPinController = TextEditingController();
    final confirmPinController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text('change_pin'.tr),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPinController,
                decoration: InputDecoration(
                  labelText: 'current_pin'.tr,
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 8,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: newPinController,
                decoration: InputDecoration(
                  labelText: 'new_pin'.tr,
                  prefixIcon: const Icon(Icons.lock_rounded),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 8,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmPinController,
                decoration: InputDecoration(
                  labelText: 'confirm_new_pin'.tr,
                  prefixIcon: const Icon(Icons.lock_rounded),
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
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              if (newPinController.text != confirmPinController.text) {
                Fluttertoast.showToast(msg: 'pin_not_match'.tr);
                return;
              }
              _authController.changePin(
                currentPinController.text,
                newPinController.text,
              );
              Get.back();
            },
            child: Text('confirm'.tr),
          ),
        ],
      ),
    );
  }

  String getTimeoutDisplayText(int timeout) {
    return _getTimeoutLabel(timeout);
  }

  String getClipboardDisplayText(int time) {
    return _getClipboardLabel(time);
  }

  void showExportDialog() {
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text('export_passwords'.tr),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('export_password_prompt'.tr),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'export_password'.tr,
                  prefixIcon: const Icon(Icons.key_rounded),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'confirm_password'.tr,
                  prefixIcon: const Icon(Icons.key_rounded),
                ),
                obscureText: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              final password = passwordController.text;
              final confirmPassword = confirmPasswordController.text;

              if (password.isEmpty) {
                Fluttertoast.showToast(msg: 'enter_password'.tr);
                return;
              }

              if (password.length < 6) {
                Fluttertoast.showToast(msg: 'password_min_length'.tr);
                return;
              }

              if (password != confirmPassword) {
                Fluttertoast.showToast(msg: 'passwords_not_match'.tr);
                return;
              }

              Get.back();
              _confirmAndExport(password);
            },
            child: Text('export_passwords'.tr),
          ),
        ],
      ),
    );
  }
  
  Future<void> _confirmAndExport(String password) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: Text('confirm_export'.tr),
        content: Text(
          '${'export_warning'.tr}\n\n${'remember_password'.tr}',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: Text('export_now'.tr),
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
        title: Text('import_passwords'.tr),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('import_password_prompt'.tr),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'password'.tr,
                  prefixIcon: const Icon(Icons.key_rounded),
                ),
                obscureText: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              final password = passwordController.text;

              if (password.isEmpty) {
                Fluttertoast.showToast(msg: 'enter_import_password'.tr);
                return;
              }

              Get.back();
              _importPasswords(password);
            },
            child: Text('select_file'.tr),
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
        dialogTitle: 'export_passwords'.tr,
        fileName: 'lockbloom_export_${DateTime.now().millisecondsSinceEpoch}.json',
        bytes: utf8.encode(exportData),
      );

      if (result != null) {
        Fluttertoast.showToast(msg: 'export_success'.tr);
      } else {
        Fluttertoast.showToast(msg: 'export_cancelled'.tr);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: '${'export_failed'.tr}: ${e.toString()}');
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
        Fluttertoast.showToast(msg: 'import_cancelled'.tr);
        return;
      }
      
      final filePath = result.files.single.path;
      if (filePath == null) {
        Fluttertoast.showToast(msg: 'file_not_found'.tr);
        return;
      }

      isLoading.value = true;
      final file = File(filePath);
      
      if (!await file.exists()) {
        Fluttertoast.showToast(msg: 'file_not_found'.tr);
        return;
      }
      
      final encryptedData = await file.readAsString();

      await _passwordRepository.importPasswords(encryptedData, password);
      await _passwordController.loadPasswords();
      
      HapticFeedback.lightImpact();
      Fluttertoast.showToast(msg: 'import_success'.tr);
    } on FileSystemException {
      Fluttertoast.showToast(msg: 'permission_denied'.tr);
    } on FormatException {
      Fluttertoast.showToast(msg: 'invalid_format'.tr);
    } catch (e) {
      final message = e.toString();
      if (message.contains('Invalid password') || message.contains('decrypt')) {
        Fluttertoast.showToast(msg: 'incorrect_password'.tr);
      } else {
        Fluttertoast.showToast(msg: 'import_failed'.tr);
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
      Fluttertoast.showToast(msg: '${'could_not_open'.tr} ${'privacy_policy'.tr}');
    }
  }

  Future<void> openTermsOfService() async {
    final uri = Uri.parse(_termsOfServiceUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Fluttertoast.showToast(msg: '${'could_not_open'.tr} ${'terms_of_service'.tr}');
    }
  }

  Future<void> openBMC() async { 
    const url = 'https://www.buymeacoffee.com/darpanneve';
    final uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
         // Fallback or retry with default mode if specific mode fails (though externalApplication is standard)
         if (!await launchUrl(uri)) {
            throw 'Could not launch $url';
         }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Could not open link: $e'); // Show actual error if possible or generic
    }
  }

  void manageSubscription() {
    _subscriptionService.manageSubscription();
  }

  void showResetAppDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('reset_app'.tr),
        content: Text('confirm_reset'.tr),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
          TextButton(
            onPressed: () {
              Get.back();
              _authController.resetApp();
            },
            child: Text('reset'.tr),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );
  }
}
