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
              // Use a slightly darker shade for the gradient end to ensure text contrast
              // In light mode, primary is Teal 600. We want something compatible.
              // We can use primaryDarkColor from AppTheme if we could access it directly,
              // or just derive it.
              // Since we can't easily access static members if not imported or exposed via theme,
              // we'll use primary with opacity or a fixed color if needed.
              // However, let's try to use the theme's primary container if it's dark enough,
              // or just primary with a different shade.
              // Actually, let's use the primary color and a slightly transparent version of it over black,
              // or just hardcode a nice gradient based on the primary.
              // Better yet, let's use the primary color and the tertiary color for a subtle shift,
              // or just primary to primaryDark.
              // Since we don't have primaryDark in ColorScheme (it's primaryContainer in dark mode),
              // we'll stick to a safe bet: Primary to Primary (slightly modified).
              Theme.of(context).colorScheme.primary.withOpacity(0.8),
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
                        color: Colors.white, // Force white for contrast on gradient
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(height: AppTheme.spacingSm.h),

                    // Tagline
                    Text(
                      'Secure Password Manager',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),

              // Loading indicator
              Obx(
                () => controller.isLoading.value
                    ? Column(
                        children: [
                          SizedBox(
                            width: 32.w,
                            height: 32.w,
                            child: const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 3,
                            ),
                          ),
                          SizedBox(height: AppTheme.spacingMd.h),
                          Text(
                            'Initializing...',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),

              SizedBox(height: AppTheme.spacingXxl.h),
            ],
          ),
        ),
      ),
    );
  }
}
