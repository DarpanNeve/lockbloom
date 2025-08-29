import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lockbloom/app/modules/splash/controllers/splash_controller.dart';
import 'package:lockbloom/app/themes/app_theme.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primaryContainer,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Logo
                    Container(
                      width: 120.w,
                      height: 120.w,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(AppTheme.radiusXxl),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.lock_rounded,
                        size: 60.w,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    
                    SizedBox(height: AppTheme.spacingXl.h),
                    
                    // App Name
                    Text(
                      'LockBloom',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    
                    SizedBox(height: AppTheme.spacingSm.h),
                    
                    // Tagline
                    Text(
                      'Secure Password Manager',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Loading indicator
              Obx(() => controller.isLoading.value
                  ? Column(
                      children: [
                        SizedBox(
                          width: 32.w,
                          height: 32.w,
                          child: const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.onPrimary,
                            ),
                            strokeWidth: 3,
                          ),
                        ),
                        SizedBox(height: AppTheme.spacingMd.h),
                        Text(
                          'Initializing...',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink()),
              
              SizedBox(height: AppTheme.spacingXxl.h),
            ],
          ),
        ),
      ),
    );
  }
}