import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lockbloom/app/modules/splash/controllers/splash_controller.dart';
import 'package:lockbloom/app/services/theme_service.dart';
import 'package:lockbloom/app/themes/app_theme.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          // Background subtle pattern or gradient could go here
          Container(
            decoration: BoxDecoration(
               gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                      Theme.of(context).colorScheme.surface,
                    ],
               ),
            ),
          ),
          
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 140.w,
                  height: 140.w,
                  padding: EdgeInsets.all(AppTheme.spacingMd.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                        blurRadius: 40,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/icon.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
                Text(
                  'app_name'.tr,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'secure_vault'.tr, 
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        letterSpacing: 0.5,
                      ),
                ),
              ],
            ),
          ),
          
          Positioned(
            bottom: 60.h,
            left: 0,
            right: 0,
            child: Obx(() {
               if (!controller.isLoading.value) return const SizedBox.shrink();
               return Column(
                 children: [
                   SizedBox(
                     width: 24.w,
                     height: 24.w,
                     child: CircularProgressIndicator(
                       strokeWidth: 2.5,
                       color: Theme.of(context).colorScheme.primary,
                     ),
                   ),
                 ],
               );
            }),
          ),
        ],
      ),
    );
  }
}
