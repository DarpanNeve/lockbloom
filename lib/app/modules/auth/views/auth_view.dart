import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lockbloom/app/controllers/auth_controller.dart';
import 'package:lockbloom/app/services/locale_service.dart';
import 'package:lockbloom/app/themes/app_theme.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:upgrader/upgrader.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      barrierDismissible: false,
      showIgnore: false,
      showLater: false,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                Theme.of(context).colorScheme.surface,
              ],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Obx(() => SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: IntrinsicHeight(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppTheme.spacingLg),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const Spacer(),
                                    _buildHeader(context),
                                    const SizedBox(height: 48),
                                    if (!controller.isSetupComplete.value)
                                      _buildSetupForm(context)
                                    else
                                      _buildLoginForm(context),
                                    const Spacer(),
                                    if (!controller.isSetupComplete.value)
                                      _buildVaultInfo(context),
                                    const SizedBox(height: 24),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ));
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingMd),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: _buildLanguageSelector(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context) {
    final localeService = Get.find<LocaleService>();
    return Obx(() => Container(
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest
                .withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(context)
                  .colorScheme
                  .outlineVariant
                  .withValues(alpha: 0.5),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showLanguageBottomSheet(context),
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      localeService.currentLocaleFlag,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      localeService.currentLocaleName,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void _showLanguageBottomSheet(BuildContext context) {
    final localeService = Get.find<LocaleService>();
    Get.bottomSheet(
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingLg,
          vertical: AppTheme.spacingLg,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'choose_language'.tr,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppTheme.spacingLg),
            ...LocaleService.supportedLocales.map((option) {
              return Obx(() {
                final isSelected = localeService.currentLocale.languageCode ==
                    option.locale.languageCode;
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
                  child: _buildLanguageOption(context, option, isSelected),
                );
              });
            }),
            const SizedBox(height: AppTheme.spacingMd),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    LocaleOption option,
    bool isSelected,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Get.back();
          Get.find<LocaleService>().changeLocale(option.locale);
        },
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primaryContainer
                : Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Text(
                option.flag,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: AppTheme.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.nativeName,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                    Text(
                      option.name,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isSelected
                                ? Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer
                                    .withValues(alpha: 0.7)
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color:
                    Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(AppTheme.spacingSm),
          child: ClipOval(
            child: Image.asset('assets/images/icon.png', fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: AppTheme.spacingLg),
        Text(
          'app_name'.tr,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
        ),
        const SizedBox(height: AppTheme.spacingSm),
        Text(
          controller.isSetupComplete.value
              ? 'welcome_back'.tr
              : 'secure_vault'.tr,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }

  Widget _buildSetupForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildPinInput(
          context,
          controller: controller.pinController,
          label: 'create_pin'.tr,
          icon: Icons.lock_outline_rounded,
        ),
        const SizedBox(height: AppTheme.spacingMd),
        _buildPinInput(
          context,
          controller: controller.confirmPinController,
          label: 'confirm_pin'.tr,
          icon: Icons.lock_rounded,
        ),
        const SizedBox(height: AppTheme.spacingXl),
        SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: controller.isLoading.value
                ? null
                : () {
                    final pin = controller.pinController.text;
                    final confirmPin = controller.confirmPinController.text;
                    if (pin.length < 4) {
                      Fluttertoast.showToast(
                          msg: 'PIN must be at least 4 digits');
                      return;
                    }
                    if (pin != confirmPin) {
                      Fluttertoast.showToast(msg: 'pin_not_match'.tr);
                      return;
                    }
                    controller.setupPin(pin);
                  },
            child: controller.isLoading.value
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2.5),
                  )
                : Text('create_pin'.tr),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildPinInput(
          context,
          controller: controller.pinController,
          label: 'enter_pin'.tr,
          icon: Icons.lock_open_rounded,
          onSubmitted: (_) =>
              controller.authenticateWithPin(controller.pinController.text),
        ),
        const SizedBox(height: AppTheme.spacingXl),
        SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: controller.isLoading.value
                ? null
                : () => controller
                    .authenticateWithPin(controller.pinController.text),
            child: controller.isLoading.value
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2.5),
                  )
                : Text('confirm'.tr),
          ),
        ),
        if (controller.isBiometricAvailable.value &&
            controller.isBiometricEnabled.value) ...[
          const SizedBox(height: AppTheme.spacingMd),
          SizedBox(
            height: 56,
            child: OutlinedButton.icon(
              onPressed: controller.authenticateWithBiometric,
              icon: const Icon(Icons.fingerprint_rounded),
              label: Text('use_biometric'.tr),
            ),
          ),
        ],
        const SizedBox(height: AppTheme.spacingXl),
        TextButton(
          onPressed: controller.resetApp,
          child: Text(
            'forgot_pin'.tr,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      ],
    );
  }

  Widget _buildPinInput(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required IconData icon,
    Function(String)? onSubmitted,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        counterText: '',
      ),
      keyboardType: TextInputType.number,
      obscureText: true,
      maxLength: 8,
      textAlign: TextAlign.start,
      style: Theme.of(context)
          .textTheme
          .headlineSmall
          ?.copyWith(letterSpacing: 4),
      onSubmitted: onSubmitted,
    );
  }

  Widget _buildVaultInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      ),
      child: Row(
        children: [
          Icon(Icons.security_rounded,
              color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: AppTheme.spacingMd),
          Expanded(
            child: Text(
              'vault_description'.tr,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
