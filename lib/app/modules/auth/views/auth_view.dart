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
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(AppTheme.spacingLg.w),
                child: Obx(() {
                  if (!controller.isSetupComplete.value) {
                    return _buildSetupView(context);
                  } else {
                    return _buildLoginView(context);
                  }
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Container(
      width: 120.w,
      height: 120.w,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: EdgeInsets.all(AppTheme.spacingMd.w),
      child: ClipOval(
        child: Image.asset(
          'assets/images/icon.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildSetupView(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLogo(context),
          SizedBox(height: AppTheme.spacingLg.h),
          Text(
            '${'welcome_back'.tr.split('!')[0]} ${'app_name'.tr}',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppTheme.spacingSm.h),
          Text(
            'secure_vault'.tr,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: AppTheme.spacingXl.h),
          
          Column(
            children: [
              TextField(
                controller: controller.pinController,
                decoration: InputDecoration(
                  labelText: 'create_pin'.tr,
                  hintText: '4-8 digits',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  counterText: '',
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 8,
              ),

              SizedBox(height: AppTheme.spacingMd.h),

              TextField(
                controller: controller.confirmPinController,
                decoration: InputDecoration(
                  labelText: 'confirm_pin'.tr,
                  hintText: 'confirm_pin'.tr,
                  prefixIcon: const Icon(Icons.lock_rounded),
                  counterText: '',
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 8,
              ),

              SizedBox(height: AppTheme.spacingXl.h),

              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        controller.isLoading.value
                            ? null
                            : () {
                                final pin = controller.pinController.text;
                                final confirmPin = controller.confirmPinController.text;
                                
                                if (pin.length < 4) {
                                  Fluttertoast.showToast(
                                    msg: 'PIN must be at least 4 digits',
                                  );
                                  return;
                                }
                                
                                if (pin != confirmPin) {
                                  Fluttertoast.showToast(
                                    msg: 'pin_not_match'.tr,
                                  );
                                  return;
                                }
                                controller.setupPin(pin);
                              },
                    child:
                        controller.isLoading.value
                            ? SizedBox(
                                height: 20.h,
                                width: 20.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text('create_pin'.tr),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: AppTheme.spacingXl.h),
          
          Container(
            padding: EdgeInsets.all(AppTheme.spacingMd.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.security_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24.w,
                ),
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
          ),
        ],
      ),
    );
  }

  Widget _buildLoginView(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLogo(context),
          SizedBox(height: AppTheme.spacingLg.h),
          Text(
            'app_name'.tr,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppTheme.spacingSm.h),
          Text(
            'enter_pin'.tr,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),

          SizedBox(height: AppTheme.spacingXl.h),

          Column(
            children: [
              TextField(
                controller: controller.pinController,
                decoration: InputDecoration(
                  labelText: 'enter_pin'.tr,
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  counterText: '',
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 8,
                onSubmitted: (value) => controller.authenticateWithPin(value),
              ),

              SizedBox(height: AppTheme.spacingXl.h),

              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        controller.isLoading.value
                            ? null
                            : () => controller.authenticateWithPin(
                                  controller.pinController.text,
                                ),
                    child:
                        controller.isLoading.value
                            ? SizedBox(
                                height: 20.h,
                                width: 20.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text('confirm'.tr),
                  ),
                ),
              ),

              Obx(() {
                if (controller.isBiometricAvailable.value &&
                    controller.isBiometricEnabled.value) {
                  return Column(
                    children: [
                      SizedBox(height: AppTheme.spacingMd.h),
                      Semantics(
                        button: true,
                        label: 'use_biometric'.tr,
                        child: OutlinedButton.icon(
                          onPressed: controller.authenticateWithBiometric,
                          icon: const Icon(Icons.fingerprint_rounded),
                          label: Text('use_biometric'.tr),
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(double.infinity, 48.h),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
          
          SizedBox(height: AppTheme.spacingXl.h),
          
          TextButton(
            onPressed: controller.resetApp,
            child: Text(
              'forgot_pin'.tr,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
