import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lockbloom/app/themes/app_theme.dart';
import 'package:lockbloom/app/controllers/password_controller.dart';

class PasswordFilterSheet extends GetView<PasswordController> {
  const PasswordFilterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final allTags = controller.getAllTags();

    return Container(
      height: Get.height * 0.6,
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLg)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'filter_by_tags'.tr,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () {
                  controller.filterByTags([]);
                  Get.back();
                },
                child: Text('clear_all'.tr),
              ),
            ],
          ),

          const SizedBox(height: AppTheme.spacingMd),

          if (allTags.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.label_off_rounded,
                      size: 48,
                      color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: AppTheme.spacingSm),
                    Text(
                      'no_tags_available'.tr,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: AppTheme.spacingSm,
                  runSpacing: AppTheme.spacingSm,
                  children: allTags.map((tag) {
                    return Obx(() {
                      final isSelected = controller.selectedTags.contains(tag);
                      return FilterChip(
                        label: Text(tag),
                        selected: isSelected,
                        onSelected: (selected) {
                          final tags = List<String>.from(controller.selectedTags);
                          if (selected) {
                            tags.add(tag);
                          } else {
                            tags.remove(tag);
                          }
                          controller.filterByTags(tags);
                        },
                        selectedColor: Theme.of(context).colorScheme.primaryContainer,
                        checkmarkColor: Theme.of(context).colorScheme.onPrimaryContainer,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Theme.of(context).colorScheme.onPrimaryContainer
                              : Theme.of(context).colorScheme.onSurface,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      );
                    });
                  }).toList(),
                ),
              ),
            ),

          // Apply Button
          const SizedBox(height: AppTheme.spacingMd),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('apply_filters'.tr),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
