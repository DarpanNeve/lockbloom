import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lockbloom/app/controllers/auth_controller.dart';
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Obx(() => SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppTheme.spacingLg.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Spacer(),
                            _buildHeader(context),
                            SizedBox(height: 48.h),
                            if (!controller.isSetupComplete.value)
                              _buildSetupForm(context)
                            else
                              _buildLoginForm(context),
                            const Spacer(),
                            if (!controller.isSetupComplete.value)
                              _buildVaultInfo(context),
                            SizedBox(height: 24.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ));
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: EdgeInsets.all(AppTheme.spacingSm.w),
          child: ClipOval(
            child: Image.asset('assets/images/icon.png', fit: BoxFit.cover),
          ),
        ),
        SizedBox(height: AppTheme.spacingLg.h),
        Text(
          'app_name'.tr,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
        ),
        SizedBox(height: AppTheme.spacingSm.h),
        Text(
          controller.isSetupComplete.value ? 'welcome_back'.tr : 'secure_vault'.tr,
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
        SizedBox(height: AppTheme.spacingMd.h),
        _buildPinInput(
          context,
          controller: controller.confirmPinController,
          label: 'confirm_pin'.tr,
          icon: Icons.lock_rounded,
        ),
        SizedBox(height: AppTheme.spacingXl.h),
        SizedBox(
          height: 56.h,
          child: ElevatedButton(
            onPressed: controller.isLoading.value
                ? null
                : () {
                    final pin = controller.pinController.text;
                    final confirmPin = controller.confirmPinController.text;
                    if (pin.length < 4) {
                      Fluttertoast.showToast(msg: 'PIN must be at least 4 digits');
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
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
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
          onSubmitted: (_) => controller.authenticateWithPin(controller.pinController.text),
        ),
        SizedBox(height: AppTheme.spacingXl.h),
        SizedBox(
           height: 56.h,
           child: ElevatedButton(
            onPressed: controller.isLoading.value
                ? null
                : () => controller.authenticateWithPin(controller.pinController.text),
            child: controller.isLoading.value
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                  )
                : Text('confirm'.tr),
          ),
        ),
        if (controller.isBiometricAvailable.value && controller.isBiometricEnabled.value) ...[
          SizedBox(height: AppTheme.spacingMd.h),
          SizedBox(
             height: 56.h,
            child: OutlinedButton.icon(
              onPressed: controller.authenticateWithBiometric,
              icon: const Icon(Icons.fingerprint_rounded),
              label: Text('use_biometric'.tr),
            ),
          ),
        ],
        SizedBox(height: AppTheme.spacingXl.h),
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
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(letterSpacing: 4),
      onSubmitted: onSubmitted,
    );
  }
  
  Widget _buildVaultInfo(BuildContext context) {
     return Container(
      padding: EdgeInsets.all(AppTheme.spacingMd.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      ),
      child: Row(
        children: [
          Icon(Icons.security_rounded, color: Theme.of(context).colorScheme.primary),
             SizedBox(width: AppTheme.spacingMd.w),
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
