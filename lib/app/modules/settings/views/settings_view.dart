import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lockbloom/app/controllers/auth_controller.dart';
import 'package:lockbloom/app/controllers/settings_controller.dart';
import 'package:lockbloom/app/services/locale_service.dart';
import 'package:lockbloom/app/services/theme_service.dart';
import 'package:lockbloom/app/themes/app_theme.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppTheme.spacingMd.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, "Support"),
            _buildSettingsCard(context, [
              _buildSettingsTile(
                icon: Icons.coffee_rounded,
                title: "Buy me a coffee",
                subtitle: "Support the developer",
                onTap: controller.openBMC,
                iconColor: const Color(0xFFFFDD00), // BMC Yellow
                iconBackgroundColor: const Color(0xFFFFDD00).withOpacity(0.2),
                trailing: const Text(
                  "☕",
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ]),
            SizedBox(height: AppTheme.spacingLg.h),

            _buildSectionHeader(context, "Premium"),
            _buildSettingsCard(context, [
              Obx(() {
                 if (controller.isPremium.value) {
                   return _buildSettingsTile(
                      icon: Icons.star_rounded,
                      title: "Manage Subscription",
                      subtitle: "Premium Active",
                      onTap: controller.manageSubscription,
                      iconColor: Colors.amber, 
                      iconBackgroundColor: Colors.amber.withOpacity(0.1),
                   );
                 }
                 return _buildSettingsTile(
                  icon: Icons.diamond_rounded,
                  title: "Unlock Premium",
                  subtitle: "Get access to all features",
                  onTap: () => Get.toNamed('/premium'),
                );
              }),
            ]),
            SizedBox(height: AppTheme.spacingLg.h),

            _buildSectionHeader(context, 'security'.tr),
            _buildSettingsCard(context, [
              _buildSettingsTile(
                icon: Icons.fingerprint_rounded,
                title: 'biometric_auth'.tr,
                subtitle: 'biometric_subtitle'.tr,
                trailing: Obx(() {
                  final authController = Get.find<AuthController>();
                  return Switch(
                    value: authController.isBiometricEnabled.value,
                    onChanged:
                        authController.isBiometricAvailable.value
                            ? (value) {
                              if (value) {
                                authController.enableBiometric();
                              } else {
                                authController.disableBiometric();
                              }
                            }
                            : null,
                  );
                }),
              ),
              Divider(
                height: 1,
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              ),
              Obx(
                () => _buildSettingsTile(
                  icon: Icons.timer_rounded,
                  title: 'auto_lock_timeout'.tr,
                  subtitle: controller.getTimeoutDisplayText(
                    controller.autoLockTimeout.value,
                  ),
                  onTap: controller.showAutoLockDialog,
                ),
              ),
              Divider(
                height: 1,
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              ),
              _buildSettingsTile(
                icon: Icons.vpn_key_rounded,
                title: 'change_pin'.tr,
                subtitle: 'update_pin'.tr,
                onTap: controller.showChangePinDialog,
              ),
            ]),

            SizedBox(height: AppTheme.spacingLg.h),

            _buildSectionHeader(context, 'privacy'.tr),
            _buildSettingsCard(context, [
              Obx(
                () => _buildSettingsTile(
                  icon: Icons.content_copy_rounded,
                  title: 'clipboard_clear_time'.tr,
                  subtitle: controller.getClipboardDisplayText(
                    controller.clipboardClearTime.value,
                  ),
                  onTap: controller.showClipboardDialog,
                ),
              ),
              Divider(
                height: 1,
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              ),
              _buildSettingsTile(
                icon: Icons.history_rounded,
                title: 'password_history'.tr,
                subtitle: 'remember_changes'.tr,
                trailing: Obx(
                  () => Switch(
                    value: controller.isPasswordHistoryEnabled.value,
                    onChanged: controller.togglePasswordHistory,
                  ),
                ),
              ),
            ]),

            SizedBox(height: AppTheme.spacingLg.h),

            _buildSectionHeader(context, 'appearance'.tr),
            _buildSettingsCard(context, [
              Obx(() => _buildSettingsTile(
                icon: Icons.palette_rounded,
                title: 'theme'.tr,
                subtitle: controller.currentThemeText,
                onTap: controller.showThemeDialog,
              )),
              Divider(
                height: 1,
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              ),
              Obx(() {
                final themeService = Get.find<ThemeService>();
                return _buildSettingsTile(
                  icon: Icons.color_lens_rounded,
                  title: 'accent_color'.tr,
                  subtitle: controller.currentAccentColorName,
                  onTap: controller.showAccentColorDialog,
                  trailing: Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      color: themeService.accentColor.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                        width: 2,
                      ),
                    ),
                  ),
                );
              }),
              Divider(
                height: 1,
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              ),
              Obx(() {
                final localeService = Get.find<LocaleService>();
                return _buildSettingsTile(
                  icon: Icons.language_rounded,
                  title: 'language'.tr,
                  subtitle: controller.currentLanguageName,
                  onTap: controller.showLanguageDialog,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        localeService.currentLocaleFlag,
                        style: TextStyle(fontSize: 20.sp),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ],
                  ),
                );
              }),
            ]),

            SizedBox(height: AppTheme.spacingLg.h),

            _buildSectionHeader(context, 'data'.tr),
            _buildSettingsCard(context, [
              _buildSettingsTile(
                icon: Icons.download_rounded,
                title: 'export_passwords'.tr,
                subtitle: 'create_backup'.tr,
                onTap: controller.showExportDialog,
              ),
              Divider(
                height: 1,
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              ),
              _buildSettingsTile(
                icon: Icons.upload_rounded,
                title: 'import_passwords'.tr,
                subtitle: 'restore_backup'.tr,
                onTap: controller.showImportDialog,
              ),
            ]),

            SizedBox(height: AppTheme.spacingLg.h),

            _buildSectionHeader(context, 'about'.tr),
            _buildSettingsCard(context, [
              Obx(() => _buildSettingsTile(
                icon: Icons.info_outline_rounded,
                title: 'version'.tr,
                subtitle: controller.appVersion.value,
              )),
              Divider(
                height: 1,
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              ),
              _buildSettingsTile(
                icon: Icons.security_rounded,
                title: 'privacy_policy'.tr,
                subtitle: 'privacy_policy_subtitle'.tr,
                onTap: controller.openPrivacyPolicy,
              ),
              Divider(
                height: 1,
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              ),
              _buildSettingsTile(
                icon: Icons.description_rounded,
                title: 'terms_of_service'.tr,
                subtitle: 'terms_subtitle'.tr,
                onTap: controller.openTermsOfService,
              ),
            ]),



            SizedBox(height: AppTheme.spacingXl.h),

            _buildSectionHeader(context, 'danger_zone'.tr, isError: true),
            _buildSettingsCard(context, [
              _buildSettingsTile(
                icon: Icons.warning_rounded,
                title: 'reset_app'.tr,
                subtitle: 'reset_subtitle'.tr,
                onTap: controller.showResetAppDialog,
                isDestructive: true,
              ),
            ]),

            SizedBox(height: AppTheme.spacingXl.h),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Get.find<AuthController>().logout(),
                icon: const Icon(Icons.logout_rounded),
                label: Text('logout'.tr),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: AppTheme.spacingMd.h),
                ),
              ),
            ),

            SizedBox(height: AppTheme.spacingXl.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title, {
    bool isError = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppTheme.spacingSm.h, left: AppTheme.spacingXs.w),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: isError ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context, List<Widget> children) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool isDestructive = false,
    Color? iconColor,
    Color? iconBackgroundColor,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd.w,
        vertical: 4.h,
      ),
      leading: Container(
        padding: EdgeInsets.all(AppTheme.spacingSm.w),
        decoration: BoxDecoration(
          color: iconBackgroundColor ?? (
              isDestructive
                  ? Get.theme.colorScheme.errorContainer.withValues(alpha: 0.8)
                  : Get.theme.colorScheme.primaryContainer),
          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        ),
        child: Icon(
          icon,
          color: iconColor ?? (
              isDestructive
                  ? Get.theme.colorScheme.error
                  : Get.theme.colorScheme.primary),
          size: 20.w,
        ),
      ),
      title: Text(
        title,
        style: Get.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: isDestructive ? Get.theme.colorScheme.error : null,
        ),
      ),
      subtitle: Text(
        subtitle, 
        style: Get.textTheme.bodySmall?.copyWith(
          color: Get.theme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing:
          trailing ?? (onTap != null ? Icon(Icons.chevron_right_rounded, color: Get.theme.colorScheme.outline) : null),
      onTap: onTap,
    );
  }
}
