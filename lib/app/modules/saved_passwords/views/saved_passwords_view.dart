import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lockbloom/app/controllers/password_controller.dart';
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
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20,
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
                iconSize: 28,
                tooltip: 'add_password'.tr,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
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
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
             child: Obx(() {
               if (controller.selectedTags.isEmpty) return const SizedBox.shrink();
               return Container(
                  height: 48,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.selectedTags.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
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
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              itemCount: 6,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, __) => const SkeletonPasswordCard(),
            );
          }

          if (controller.filteredPasswords.isEmpty) {
             return _buildEmptyState(context);
          }

          return RefreshIndicator(
            onRefresh: controller.loadPasswords,
            child: ListView.separated(
              padding: const EdgeInsets.only(
                left: AppTheme.spacingMd,
                right: AppTheme.spacingMd,
                bottom: 100,
              ),
              itemCount: controller.filteredPasswords.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
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
          Icon(Icons.lock_clock_outlined, size: 64, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 16),
          Text(
            'empty_vault'.tr,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
             'add_first_password'.tr,
             style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
