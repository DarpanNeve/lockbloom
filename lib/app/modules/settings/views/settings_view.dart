import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lockbloom/app/controllers/auth_controller.dart';
import 'package:lockbloom/app/controllers/settings_controller.dart';
import 'package:lockbloom/app/routes/app_pages.dart';
import 'package:lockbloom/app/services/locale_service.dart';
import 'package:lockbloom/app/services/theme_service.dart';
import 'package:lockbloom/app/themes/app_theme.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            title: Text(
              'settings'.tr, 
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20.sp,
                fontFamily: 'Inter',
              ),
            ),
            centerTitle: true,
            pinned: true,
            floating: true,
            snap: true,
            surfaceTintColor: Colors.transparent,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: AppTheme.spacingMd.w),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                 _buildSupportSection(context),
                 SizedBox(height: 24.h),
                 _buildPremiumSection(context),
                 SizedBox(height: 24.h),
                 _buildSectionHeader(context, 'security'.tr),
                 _buildSecuritySection(context),
                 SizedBox(height: 24.h),
                 _buildSectionHeader(context, 'privacy'.tr),
                 _buildPrivacySection(context),
                 SizedBox(height: 24.h),
                 _buildSectionHeader(context, 'appearance'.tr),
                 _buildAppearanceSection(context),
                 SizedBox(height: 24.h),
                 _buildSectionHeader(context, 'data'.tr),
                 _buildDataSection(context),
                 SizedBox(height: 24.h),
                 _buildSectionHeader(context, 'about'.tr),
                 _buildAboutSection(context),
                 SizedBox(height: 48.h),
                 _buildDangerSection(context),
                 SizedBox(height: 24.h),
                 OutlinedButton.icon(
                    onPressed: () => Get.find<AuthController>().logout(),
                    icon: const Icon(Icons.logout_rounded),
                    label: Text('logout'.tr),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                      side: BorderSide(color: Theme.of(context).colorScheme.error.withValues(alpha: 0.5)),
                    ),
                 ),
                 SizedBox(height: 100.h),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, left: 4.w),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return _buildCard(context, [
      _buildSettingsTile(
        context,
        icon: Icons.coffee_rounded,
        title: "buy_coffee".tr,
        subtitle: "support_developer".tr,
        onTap: controller.openBMC,
        iconColor: const Color(0xFFFFDD00),
        iconBgColor: const Color(0xFFFFDD00).withOpacity(0.1),
        trailing: const Text("☕️", style: TextStyle(fontSize: 20)),
      ),
    ]);
  }

  Widget _buildPremiumSection(BuildContext context) {
    return Obx(() {
      final isPremium = controller.isPremium.value;
      return _buildCard(context, [
         _buildSettingsTile(
          context,
          icon: isPremium ? Icons.star_rounded : Icons.diamond_rounded,
          title: isPremium ? "manage_subscription".tr : "unlock_premium".tr,
          subtitle: isPremium ? "premium_active".tr : "get_premium_access".tr,
          onTap: isPremium ? controller.manageSubscription : () => Get.toNamed(Routes.PREMIUM),
          iconColor: Colors.amber, // Premium Gold
          iconBgColor: Colors.amber.withOpacity(0.1),
        ),
      ]);
    });
  }

  Widget _buildSecuritySection(BuildContext context) {
    return _buildCard(context, [
      Obx(() => _buildSettingsTile(
        context,
        icon: Icons.fingerprint_rounded,
        title: 'biometric_auth'.tr,
        subtitle: 'biometric_subtitle'.tr,
        isSwitch: true,
        switchValue: Get.find<AuthController>().isBiometricEnabled.value,
        onSwitchChanged: Get.find<AuthController>().isBiometricAvailable.value
            ? (val) => val ? Get.find<AuthController>().enableBiometric() : Get.find<AuthController>().disableBiometric()
            : null,
      )),
      _buildDivider(context),
      Obx(() => _buildSettingsTile(
        context,
        icon: Icons.timer_rounded,
        title: 'auto_lock_timeout'.tr,
        subtitle: controller.getTimeoutDisplayText(controller.autoLockTimeout.value),
        onTap: controller.showAutoLockDialog,
      )),
       _buildDivider(context),
      _buildSettingsTile(
        context,
        icon: Icons.vpn_key_rounded,
        title: 'change_pin'.tr,
        subtitle: 'update_pin'.tr,
        onTap: controller.showChangePinDialog,
      ),
    ]);
  }

  Widget _buildPrivacySection(BuildContext context) {
    return _buildCard(context, [
      Obx(() => _buildSettingsTile(
        context,
        icon: Icons.content_copy_rounded,
        title: 'clipboard_clear_time'.tr,
        subtitle: controller.getClipboardDisplayText(controller.clipboardClearTime.value),
        onTap: controller.showClipboardDialog,
      )),
      _buildDivider(context),
      Obx(() => _buildSettingsTile(
        context,
        icon: Icons.history_rounded,
        title: 'password_history'.tr,
        subtitle: 'remember_changes'.tr,
        isSwitch: true,
        switchValue: controller.isPasswordHistoryEnabled.value,
        onSwitchChanged: controller.togglePasswordHistory,
      )),
    ]);
  }

  Widget _buildAppearanceSection(BuildContext context) {
    return _buildCard(context, [
      Obx(() => _buildSettingsTile(
        context,
        icon: Icons.palette_rounded,
        title: 'theme'.tr,
        subtitle: controller.currentThemeText,
        onTap: controller.showThemeDialog,
      )),
      _buildDivider(context),
      Obx(() {
        final themeService = Get.find<ThemeService>();
        return _buildSettingsTile(
          context,
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
            ),
          ),
        );
      }),
      _buildDivider(context),
      Obx(() {
         final localeService = Get.find<LocaleService>();
         return _buildSettingsTile(
          context,
          icon: Icons.language_rounded,
          title: 'language'.tr,
          subtitle: controller.currentLanguageName,
          onTap: controller.showLanguageDialog,
          trailing: Text(localeService.currentLocaleFlag, style: TextStyle(fontSize: 20.sp)),
        );
      }),
    ]);
  }

  Widget _buildDataSection(BuildContext context) {
    return _buildCard(context, [
      _buildSettingsTile(
        context,
        icon: Icons.download_rounded,
        title: 'export_passwords'.tr,
        subtitle: 'create_backup'.tr,
        onTap: controller.showExportDialog,
      ),
      _buildDivider(context),
      _buildSettingsTile(
        context,
        icon: Icons.upload_rounded,
        title: 'import_passwords'.tr,
        subtitle: 'restore_backup'.tr,
        onTap: controller.showImportDialog,
      ),
    ]);
  }

  Widget _buildAboutSection(BuildContext context) {
    return _buildCard(context, [
       Obx(() => _buildSettingsTile(
        context,
        icon: Icons.info_outline_rounded,
        title: 'version'.tr,
        subtitle: controller.appVersion.value,
        onTap: null, // Just display
      )),
      _buildDivider(context),
      _buildSettingsTile(
        context,
        icon: Icons.security_rounded,
        title: 'privacy_policy'.tr,
        subtitle: 'privacy_policy_subtitle'.tr,
        onTap: controller.openPrivacyPolicy,
      ),
      _buildDivider(context),
      _buildSettingsTile(
        context,
        icon: Icons.description_rounded,
        title: 'terms_of_service'.tr,
        subtitle: 'terms_subtitle'.tr,
        onTap: controller.openTermsOfService,
      ),
    ]);
  }

  Widget _buildDangerSection(BuildContext context) {
    return _buildCard(context, [
      _buildSettingsTile(
        context,
        icon: Icons.delete_forever_rounded,
        title: 'reset_app'.tr,
        subtitle: 'reset_subtitle'.tr,
        iconColor: Theme.of(context).colorScheme.error,
        iconBgColor: Theme.of(context).colorScheme.error.withOpacity(0.1),
        onTap: controller.showResetAppDialog,
      ),
    ]);
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      height: 1,
      indent: 56.w, 
      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Color? iconColor,
    Color? iconBgColor,
    bool isSwitch = false,
    bool switchValue = false,
    ValueChanged<bool>? onSwitchChanged,
    Widget? trailing,
  }) {
    final effectiveIconColor = iconColor ?? Theme.of(context).colorScheme.primary;
    final effectiveIconBg = iconBgColor ?? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1);

    return InkWell(
      onTap: isSwitch ? () => onSwitchChanged?.call(!switchValue) : onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: effectiveIconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: effectiveIconColor, size: 22.w),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            if (isSwitch)
              Switch(
                value: switchValue,
                onChanged: onSwitchChanged,
              )
            else if (trailing != null)
              trailing
            else if (onTap != null)
              Icon(Icons.chevron_right_rounded, color: Theme.of(context).colorScheme.outline, size: 20.sp),
          ],
        ),
      ),
    );
  }
}
