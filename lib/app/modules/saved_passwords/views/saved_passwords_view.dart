import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lockbloom/app/controllers/password_controller.dart';
import 'package:lockbloom/app/data/models/password_entry.dart';
import 'package:lockbloom/app/routes/app_pages.dart';
import 'package:lockbloom/app/widgets/password_entry_card.dart';
import 'package:lockbloom/app/widgets/skeleton_password_card.dart';
import 'package:lockbloom/app/themes/app_theme.dart';
import 'package:lockbloom/app/modules/saved_passwords/views/widgets/add_password_sheet.dart';
import 'package:lockbloom/app/modules/saved_passwords/views/widgets/password_filter_sheet.dart';

class SavedPasswordsView extends GetView<PasswordController> {
  const SavedPasswordsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('vault'.tr),
        actions: [
          IconButton(
            onPressed: () => Get.bottomSheet(
              const AddPasswordSheet(),
              isScrollControlled: true,
              isDismissible: false,
              enableDrag: false,
            ),
            icon: const Icon(Icons.add_rounded),
            tooltip: 'add_password'.tr,
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(AppTheme.spacingMd.w),
              child: TextField(
                onChanged: controller.searchPasswords,
                decoration: InputDecoration(
                  hintText: '${'search'.tr}...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: Obx(() {
                    if (controller.searchQuery.value.isNotEmpty) {
                      return Semantics(
                        button: true,
                        label: 'close'.tr,
                        child: IconButton(
                          onPressed: () {
                            controller.searchPasswords('');
                          },
                          icon: const Icon(Icons.clear_rounded),
                        ),
                      );
                    }
                    return Semantics(
                      button: true,
                      label: 'Filter',
                      child: IconButton(
                        onPressed: () => Get.bottomSheet(
                          const PasswordFilterSheet(),
                          isScrollControlled: true,
                        ),
                        icon: const Icon(Icons.filter_list_rounded),
                        tooltip: 'Filter',
                      ),
                    );
                  }),
                ),
              ),
            ),

            Obx(() {
              if (controller.selectedTags.isNotEmpty) {
                return Container(
                  height: 40.h,
                  margin: EdgeInsets.only(
                    left: AppTheme.spacingMd.w,
                    right: AppTheme.spacingMd.w,
                    bottom: AppTheme.spacingSm.h,
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.selectedTags.length,
                    itemBuilder: (context, index) {
                      final tag = controller.selectedTags[index];
                      return Padding(
                        padding: EdgeInsets.only(right: AppTheme.spacingSm.w),
                        child: Chip(
                          label: Text(tag),
                          onDeleted: () {
                            final tags = List<String>.from(controller.selectedTags);
                            tags.remove(tag);
                            controller.filterByTags(tags);
                          },
                          deleteIcon: const Icon(Icons.close_rounded, size: 16),
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      );
                    },
                  ),
                );
              }
              return const SizedBox.shrink();
            }),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: AppTheme.spacingMd.w),
                    itemCount: 6,
                    itemBuilder: (context, index) => const SkeletonPasswordCard(),
                  );
                }

                if (controller.filteredPasswords.isEmpty) {
                  return _buildEmptyState(context);
                }

                return RefreshIndicator(
                  onRefresh: controller.loadPasswords,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: AppTheme.spacingMd.w),
                    physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    itemCount: controller.filteredPasswords.length,
                    itemBuilder: (context, index) {
                      final password = controller.filteredPasswords[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: AppTheme.spacingMd.h),
                        child: PasswordEntryCard(
                          entry: password,
                          onTap: () => Get.toNamed(
                            Routes.PASSWORD_DETAIL,
                            arguments: password,
                          ),
                          onCopyPassword: () => controller.copyPassword(password),
                          onCopyUsername: () => controller.copyUsername(password),
                          onToggleFavorite: () => controller.toggleFavorite(password),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100.w,
              height: 100.w,
              padding: EdgeInsets.all(AppTheme.spacingLg.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_outline_rounded,
                size: 48.w,
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
              ),
            ),
            SizedBox(height: AppTheme.spacingLg.h),
            Text(
              'empty_vault'.tr,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: AppTheme.spacingSm.h),
            Text(
              'add_first_password'.tr,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppTheme.spacingLg.h),
            ElevatedButton.icon(
              onPressed: () => Get.bottomSheet(
                const AddPasswordSheet(),
                isScrollControlled: true,
                isDismissible: false,
                enableDrag: false,
              ),
              icon: const Icon(Icons.add_rounded),
              label: Text('add_password'.tr),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingXl.w,
                  vertical: AppTheme.spacingMd.h,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
