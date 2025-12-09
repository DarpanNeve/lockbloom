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
                Theme.of(context).colorScheme.primary.withOpacity(0.1),
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
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
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
          // Welcome Section
          _buildLogo(context),
          SizedBox(height: AppTheme.spacingLg.h),
          Text(
            'Welcome to LockBloom',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppTheme.spacingSm.h),
          Text(
            'Create a secure PIN to protect your passwords',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: AppTheme.spacingXl.h),
          
          // PIN Setup Form
          Column(
            children: [
              TextField(
                controller: controller.pinController,
                decoration: const InputDecoration(
                  labelText: 'Create PIN',
                  hintText: 'Enter at least 4 digits',
                  prefixIcon: Icon(Icons.lock_outline_rounded),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 8,
              ),

              SizedBox(height: AppTheme.spacingMd.h),

              TextField(
                controller: controller.confirmPinController,
                decoration: const InputDecoration(
                  labelText: 'Confirm PIN',
                  hintText: 'Re-enter your PIN',
                  prefixIcon: Icon(Icons.lock_rounded),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 8,
              ),

              SizedBox(height: AppTheme.spacingXl.h),

              // Setup Button
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        controller.isLoading.value
                            ? null
                            : () {
                                if (controller.pinController.text !=
                                    controller.confirmPinController.text) {
                                  Fluttertoast.showToast(
                                    msg: 'PINs do not match',
                                  );
                                  return;
                                }
                                controller.setupPin(
                                  controller.pinController.text,
                                );
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
                            : const Text('Setup PIN'),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: AppTheme.spacingXl.h),
          
          // Security Note
          Container(
            padding: EdgeInsets.all(AppTheme.spacingMd.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
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
                    'Your PIN is encrypted and stored securely on your device.',
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
          // App Logo and Name
          _buildLogo(context),
          SizedBox(height: AppTheme.spacingLg.h),
          Text(
            'LockBloom',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppTheme.spacingSm.h),
          Text(
            'Enter your PIN to continue',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),

          SizedBox(height: AppTheme.spacingXl.h),

          // PIN Input
          Column(
            children: [
              TextField(
                controller: controller.pinController,
                decoration: const InputDecoration(
                  labelText: 'Enter PIN',
                  prefixIcon: Icon(Icons.lock_outline_rounded),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 8,
                onSubmitted: (value) => controller.authenticateWithPin(value),
              ),

              SizedBox(height: AppTheme.spacingXl.h),

              // Login Button
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
                            : const Text('Unlock'),
                  ),
                ),
              ),

              // Biometric Button (if available and enabled)
              Obx(() {
                if (controller.isBiometricAvailable.value &&
                    controller.isBiometricEnabled.value) {
                  return Column(
                    children: [
                      SizedBox(height: AppTheme.spacingMd.h),
                      OutlinedButton.icon(
                        onPressed: controller.authenticateWithBiometric,
                        icon: const Icon(Icons.fingerprint_rounded),
                        label: const Text('Use Biometric'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(double.infinity, 48.h),
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
          
          // Forgot PIN / Reset Option (Hidden but accessible)
          TextButton(
            onPressed: controller.resetApp, // Assuming resetApp confirms with user
            child: Text(
              'Forgot PIN?',
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
