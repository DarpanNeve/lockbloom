import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lockbloom/app/controllers/password_controller.dart';
import 'package:lockbloom/app/routes/app_pages.dart';
import 'package:lockbloom/app/widgets/password_entry_card.dart';
import 'package:lockbloom/app/widgets/skeleton_password_card.dart';
import 'package:lockbloom/app/themes/app_theme.dart';

class RecentPasswordsList extends GetView<PasswordController> {
  const RecentPasswordsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Column(
          children: List.generate(
            3,
            (index) => const SkeletonPasswordCard(),
          ),
        );
      }

      final recentPasswords = controller.passwords.take(3).toList();

      if (recentPasswords.isEmpty) {
        return Container(
          height: 120.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline_rounded,
                size: 40.w,
                color: Theme.of(context).colorScheme.outline,
              ),
              SizedBox(height: AppTheme.spacingSm.h),
              Text(
                'No passwords saved yet',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );
      }

      return Column(
        children:
            recentPasswords.map((password) {
              return Padding(
                padding: EdgeInsets.only(bottom: AppTheme.spacingMd.h),
                child: PasswordEntryCard(
                  entry: password,
                  onTap:
                      () => Get.toNamed(
                        Routes.PASSWORD_DETAIL,
                        arguments: password,
                      ),
                  onCopyPassword: () => controller.copyPassword(password),
                  onCopyUsername: () => controller.copyUsername(password),
                  onToggleFavorite: () => controller.toggleFavorite(password),
                ),
              );
            }).toList(),
      );
    });
  }
}
