import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lockbloom/app/controllers/password_controller.dart';
import 'package:lockbloom/app/data/models/password_entry.dart';
import 'package:lockbloom/app/routes/app_pages.dart';
import 'package:lockbloom/app/widgets/password_entry_card.dart';
import 'package:lockbloom/app/themes/app_theme.dart';
import 'package:lockbloom/app/modules/saved_passwords/views/widgets/add_password_sheet.dart';
import 'package:lockbloom/app/modules/saved_passwords/views/widgets/password_filter_sheet.dart';

class SavedPasswordsView extends GetView<PasswordController> {
  const SavedPasswordsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Passwords'),
        actions: [
          IconButton(
            onPressed: () => Get.bottomSheet(
              const AddPasswordSheet(),
              isScrollControlled: true,
            ),
            icon: const Icon(Icons.add_circle_outline_rounded),
            tooltip: 'Add Password',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(AppTheme.spacingMd.w),
            child: TextField(
              onChanged: controller.searchPasswords,
              decoration: InputDecoration(
                hintText: 'Search passwords...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: Obx(() {
                  if (controller.searchQuery.value.isNotEmpty) {
                    return IconButton(
                      onPressed: () {
                        controller.searchQuery.value = '';
                        controller.searchPasswords('');
                      },
                      icon: const Icon(Icons.clear_rounded),
                    );
                  }
                  return IconButton(
                    onPressed: () => Get.bottomSheet(
                      const PasswordFilterSheet(),
                      isScrollControlled: true,
                    ),
                    icon: const Icon(Icons.filter_list_rounded),
                    tooltip: 'Filter',
                  );
                }),
              ),
            ),
          ),

          // Tags Filter (if any selected)
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

          // Passwords List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredPasswords.isEmpty) {
                return _buildEmptyState(context);
              }

              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: AppTheme.spacingMd.w),
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
              );
            }),
          ),
        ],
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
              padding: EdgeInsets.all(AppTheme.spacingXl.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_outline_rounded,
                size: 64.w,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              ),
            ),
            SizedBox(height: AppTheme.spacingLg.h),
            Text(
              'No passwords found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: AppTheme.spacingSm.h),
            Text(
              'Your digital vault is empty.\nAdd your first password to get started.',
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
              ),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add Password'),
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
