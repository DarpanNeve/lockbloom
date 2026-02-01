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
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            title: Text(
              'vault'.tr, 
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20.sp,
                fontFamily: 'Inter',
              ),
            ),
            centerTitle: true,
            pinned: true,
            floating: true,
            snap: true,
            surfaceTintColor: Colors.transparent,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            actions: [
               IconButton(
                onPressed: () => Get.bottomSheet(
                  const AddPasswordSheet(),
                  isScrollControlled: true,
                  isDismissible: false,
                  enableDrag: false,
                ),
                icon: const Icon(Icons.add_circle_rounded),
                iconSize: 28.w,
                tooltip: 'add_password'.tr,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(width: 8.w),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppTheme.spacingMd.w),
              child: Column(
                children: [
                  TextField(
                    onChanged: controller.searchPasswords,
                    decoration: InputDecoration(
                        hintText: '${'search'.tr}...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: Obx(() {
                          if (controller.searchQuery.value.isNotEmpty) {
                            return IconButton(
                              onPressed: () => controller.searchPasswords(''),
                              icon: const Icon(Icons.clear_rounded),
                            );
                          }
                          return IconButton(
                            onPressed: () => Get.bottomSheet(
                              const PasswordFilterSheet(),
                              isScrollControlled: true,
                            ),
                            icon: const Icon(Icons.filter_list_rounded),
                          );
                        }),
                      ),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
             child: Obx(() {
               if (controller.selectedTags.isEmpty) return const SizedBox.shrink();
               return Container(
                  height: 48.h,
                  margin: EdgeInsets.only(bottom: 16.h),
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: AppTheme.spacingMd.w),
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.selectedTags.length,
                    separatorBuilder: (_, __) => SizedBox(width: 8.w),
                    itemBuilder: (context, index) {
                      final tag = controller.selectedTags[index];
                      return Chip(
                        label: Text(tag),
                        onDeleted: () {
                           var newTags = List<String>.from(controller.selectedTags)..remove(tag);
                           controller.filterByTags(newTags);
                        },
                      );
                    },
                  ),
               );
             }),
          ),
        ],
        body: Obx(() {
          if (controller.isLoading.value) {
            return ListView.separated(
              padding: EdgeInsets.all(AppTheme.spacingMd.w),
              itemCount: 6,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (_, __) => const SkeletonPasswordCard(),
            );
          }

          if (controller.filteredPasswords.isEmpty) {
             return _buildEmptyState(context);
          }

          return RefreshIndicator(
            onRefresh: controller.loadPasswords,
            child: ListView.separated(
              padding: EdgeInsets.only(
                left: AppTheme.spacingMd.w,
                right: AppTheme.spacingMd.w,
                bottom: 100.h,
              ),
              itemCount: controller.filteredPasswords.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final password = controller.filteredPasswords[index];
                return PasswordEntryCard(
                  entry: password,
                  onTap: () => Get.toNamed(Routes.PASSWORD_DETAIL, arguments: password),
                   onCopyPassword: () => controller.copyPassword(password),
                   onCopyUsername: () => controller.copyUsername(password),
                   onToggleFavorite: () => controller.toggleFavorite(password),
                );
              },
            ),
          );
        }),
      ),
    );
  }
  
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_clock_outlined, size: 64.w, color: Theme.of(context).colorScheme.outline),
          SizedBox(height: 16.h),
          Text(
            'empty_vault'.tr,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 8.h),
          Text(
             'add_first_password'.tr,
             style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
