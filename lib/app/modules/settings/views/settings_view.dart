import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lockbloom/app/controllers/auth_controller.dart';
import 'package:lockbloom/app/controllers/settings_controller.dart';
import 'package:lockbloom/app/themes/app_theme.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppTheme.spacingMd.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Security Section
            _buildSectionHeader(context, 'Security'),
            _buildSettingsCard(context, [
              _buildSettingsTile(
                icon: Icons.fingerprint_rounded,
                title: 'Biometric Authentication',
                subtitle: 'Use fingerprint or face to unlock',
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
                  title: 'Auto-Lock Timeout',
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
                title: 'Change PIN',
                subtitle: 'Update your security PIN',
                onTap: controller.showChangePinDialog,
              ),
            ]),

            SizedBox(height: AppTheme.spacingLg.h),

            // Privacy Section
            _buildSectionHeader(context, 'Privacy'),
            _buildSettingsCard(context, [
              Obx(
                () => _buildSettingsTile(
                  icon: Icons.content_copy_rounded,
                  title: 'Clipboard Clear Time',
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
                title: 'Password History',
                subtitle: 'Remember password changes',
                trailing: Obx(
                  () => Switch(
                    value: controller.isPasswordHistoryEnabled.value,
                    onChanged: controller.togglePasswordHistory,
                  ),
                ),
              ),
            ]),

            SizedBox(height: AppTheme.spacingLg.h),

            _buildSectionHeader(context, 'Appearance'),
            _buildSettingsCard(context, [
              Obx(() => _buildSettingsTile(
                icon: Icons.palette_rounded,
                title: 'Theme',
                subtitle: controller.currentThemeText,
                onTap: controller.showThemeDialog,
              )),
            ]),

            SizedBox(height: AppTheme.spacingLg.h),

            // Data Section
            _buildSectionHeader(context, 'Data'),
            _buildSettingsCard(context, [
              _buildSettingsTile(
                icon: Icons.download_rounded,
                title: 'Export Passwords',
                subtitle: 'Create encrypted backup',
                onTap: controller.showExportDialog,
              ),
              Divider(
                height: 1,
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              ),
              _buildSettingsTile(
                icon: Icons.upload_rounded,
                title: 'Import Passwords',
                subtitle: 'Restore from backup',
                onTap: controller.showImportDialog,
              ),
            ]),

            SizedBox(height: AppTheme.spacingLg.h),

            _buildSectionHeader(context, 'About'),
            _buildSettingsCard(context, [
              Obx(() => _buildSettingsTile(
                icon: Icons.info_outline_rounded,
                title: 'Version',
                subtitle: controller.appVersion.value,
              )),
              Divider(
                height: 1,
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              ),
              _buildSettingsTile(
                icon: Icons.security_rounded,
                title: 'Privacy Policy',
                subtitle: 'How we protect your data',
                onTap: controller.openPrivacyPolicy,
              ),
              Divider(
                height: 1,
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              ),
              _buildSettingsTile(
                icon: Icons.description_rounded,
                title: 'Terms of Service',
                subtitle: 'Usage terms and conditions',
                onTap: controller.openTermsOfService,
              ),
            ]),

            SizedBox(height: AppTheme.spacingXl.h),

            // Danger Zone
            _buildSectionHeader(context, 'Danger Zone', isError: true),
            _buildSettingsCard(context, [
              _buildSettingsTile(
                icon: Icons.warning_rounded,
                title: 'Reset App',
                subtitle: 'Delete all data and settings',
                onTap: controller.showResetAppDialog,
                isDestructive: true,
              ),
            ]),

            SizedBox(height: AppTheme.spacingXl.h),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Get.find<AuthController>().logout(),
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Logout'),
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
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd.w,
        vertical: 4.h,
      ),
      leading: Container(
        padding: EdgeInsets.all(AppTheme.spacingSm.w),
        decoration: BoxDecoration(
          color:
              isDestructive
                  ? Get.theme.colorScheme.errorContainer.withValues(alpha: 0.8)
                  : Get.theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        ),
        child: Icon(
          icon,
          color:
              isDestructive
                  ? Get.theme.colorScheme.error
                  : Get.theme.colorScheme.primary,
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
