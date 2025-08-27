import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lockbloom/app/controllers/auth_controller.dart';
import 'package:lockbloom/app/widgets/password_strength_indicator.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24.w),
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
    );
  }

  Widget _buildSetupView(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 40.h),

          // Welcome Section
          Column(
            children: [
              Icon(
                Icons.lock_outline_rounded,
                size: 80.w,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(height: 24.h),
              Text(
                'Welcome to LockBloom',
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                'Create a secure PIN to protect your passwords',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),

          SizedBox(height: 32.h), // Replaced Spacer with SizedBox
          // PIN Setup Form
          Column(
            children: [
              TextField(
                controller: controller.pinController,
                decoration: const InputDecoration(
                  labelText: 'Create PIN',
                  hintText: 'Enter at least 4 digits',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 8,
                onChanged: (value) {
                  // You could add real-time PIN strength validation here
                },
              ),

              SizedBox(height: 16.h),

              TextField(
                controller: controller.confirmPinController,
                decoration: const InputDecoration(
                  labelText: 'Confirm PIN',
                  hintText: 'Re-enter your PIN',
                  prefixIcon: Icon(Icons.lock),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 8,
              ),

              SizedBox(height: 32.h),

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
                              ),
                            )
                            : const Text('Setup PIN'),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 32.h), // Replaced Spacer with SizedBox
          // Security Note
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.security_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 32.w,
                ),
                SizedBox(height: 8.h),
                Text(
                  'Your PIN is encrypted and stored securely on your device. We cannot recover it if you forget it.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 40.h), // Added some bottom padding
        ],
      ),
    );
  }

  Widget _buildLoginView(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // App Logo and Name
          Column(
            children: [
              Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Icon(
                  Icons.lock_rounded,
                  size: 50.w,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'LockBloom',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              SizedBox(height: 8.h),
              Text(
                'Enter your PIN to continue',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          SizedBox(height: 32.h), // Replaced Spacer with SizedBox
          // PIN Input
          Column(
            children: [
              TextField(
                controller: controller.pinController,
                decoration: const InputDecoration(
                  labelText: 'Enter PIN',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 8,
                onSubmitted: (value) => controller.authenticateWithPin(value),
              ),

              SizedBox(height: 250.h),

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
                      SizedBox(height: 16.h),
                      OutlinedButton.icon(
                        onPressed: controller.authenticateWithBiometric,
                        icon: const Icon(Icons.fingerprint),
                        label: const Text('Use Biometric'),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
          SizedBox(height: 32.h), // Replaced Spacer with SizedBox
        ],
      ),
    );
  }
}
