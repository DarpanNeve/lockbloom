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
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppTheme.spacingMd.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Security Section
            _buildSectionHeader(context, 'Security'),
            _buildSettingsCard(context, [
              _buildSettingsTile(
                icon: Icons.fingerprint,
                title: 'Biometric Authentication',
                subtitle: 'Use fingerprint or face to unlock',
                trailing: Obx(() {
                  print(
                    "biometric value: ${Get.find<AuthController>().isBiometricEnabled.value}",
                  );
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
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
              Obx(
                () => _buildSettingsTile(
                  icon: Icons.timer,
                  title: 'Auto-Lock Timeout',
                  subtitle: controller.getTimeoutDisplayText(
                    controller.autoLockTimeout.value,
                  ),
                  onTap: controller.showAutoLockDialog,
                ),
              ),
              Divider(
                height: 1,
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
              _buildSettingsTile(
                icon: Icons.vpn_key,
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
                  icon: Icons.content_copy,
                  title: 'Clipboard Clear Time',
                  subtitle: controller.getClipboardDisplayText(
                    controller.clipboardClearTime.value,
                  ),
                  onTap: controller.showClipboardDialog,
                ),
              ),
              Divider(
                height: 1,
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
              _buildSettingsTile(
                icon: Icons.history,
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

            // Appearance Section
            _buildSectionHeader(context, 'Appearance'),
            _buildSettingsCard(context, [
              _buildSettingsTile(
                icon: Icons.palette,
                title: 'Theme',
                subtitle: controller.currentThemeText,
                onTap: controller.showThemeDialog,
              ),
            ]),

            SizedBox(height: AppTheme.spacingLg.h),

            // Data Section
            _buildSectionHeader(context, 'Data'),
            _buildSettingsCard(context, [
              _buildSettingsTile(
                icon: Icons.download,
                title: 'Export Passwords',
                subtitle: 'Create encrypted backup',
                onTap: controller.showExportDialog,
              ),
              Divider(
                height: 1,
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
              _buildSettingsTile(
                icon: Icons.upload,
                title: 'Import Passwords',
                subtitle: 'Restore from backup',
                onTap: controller.showImportDialog,
              ),
            ]),

            SizedBox(height: AppTheme.spacingLg.h),

            // About Section
            _buildSectionHeader(context, 'About'),
            _buildSettingsCard(context, [
              _buildSettingsTile(
                icon: Icons.info,
                title: 'Version',
                subtitle: '1.0.0',
              ),
              Divider(
                height: 1,
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
              _buildSettingsTile(
                icon: Icons.security,
                title: 'Privacy Policy',
                subtitle: 'How we protect your data',
                onTap: () {
                  // Show privacy policy
                },
              ),
              Divider(
                height: 1,
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
              _buildSettingsTile(
                icon: Icons.description,
                title: 'Terms of Service',
                subtitle: 'Usage terms and conditions',
                onTap: () {
                  // Show terms of service
                },
              ),
            ]),

            SizedBox(height: AppTheme.spacingXl.h),

            // Danger Zone
            _buildSectionHeader(context, 'Danger Zone', isError: true),
            _buildSettingsCard(context, [
              _buildSettingsTile(
                icon: Icons.warning,
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
                icon: const Icon(Icons.logout),
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
      padding: EdgeInsets.only(bottom: AppTheme.spacingMd.h),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: isError ? Theme.of(context).colorScheme.error : null,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context, List<Widget> children) {
    return Card(
      margin: EdgeInsets.zero,
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
      leading: Container(
        padding: EdgeInsets.all(AppTheme.spacingSm.w),
        decoration: BoxDecoration(
          color:
              isDestructive
                  ? Get.theme.colorScheme.errorContainer.withOpacity(0.8)
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
        style: Get.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w500,
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
          trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
      onTap: onTap,
    );
  }
}
