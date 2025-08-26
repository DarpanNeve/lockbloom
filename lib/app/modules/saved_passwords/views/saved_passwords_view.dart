import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lockbloom/app/controllers/password_controller.dart';
import 'package:lockbloom/app/data/models/password_entry.dart';
import 'package:lockbloom/app/routes/app_pages.dart';
import 'package:lockbloom/app/widgets/password_entry_card.dart';

class SavedPasswordsView extends GetView<PasswordController> {
  const SavedPasswordsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Passwords'),
        actions: [
          IconButton(
            onPressed: _showAddPasswordSheet,
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(16.w),
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
                    onPressed: _showFilterSheet,
                    icon: const Icon(Icons.filter_list_rounded),
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
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.selectedTags.length,
                  itemBuilder: (context, index) {
                    final tag = controller.selectedTags[index];
                    return Container(
                      margin: EdgeInsets.only(right: 8.w),
                      child: Chip(
                        label: Text(tag),
                        onDeleted: () {
                          final tags = List<String>.from(controller.selectedTags);
                          tags.remove(tag);
                          controller.filterByTags(tags);
                        },
                        deleteIcon: const Icon(Icons.close, size: 16),
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
                padding: EdgeInsets.all(16.w),
                itemCount: controller.filteredPasswords.length,
                itemBuilder: (context, index) {
                  final password = controller.filteredPasswords[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_outline_rounded,
            size: 80.w,
            color: Theme.of(context).colorScheme.outline,
          ),
          SizedBox(height: 24.h),
          Text(
            'No passwords found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 8.h),
          Text(
            'Start by adding your first password',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: _showAddPasswordSheet,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Password'),
          ),
        ],
      ),
    );
  }

  void _showAddPasswordSheet() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.8,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Get.theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add Password',
                  style: Get.textTheme.headlineSmall,
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            
            SizedBox(height: 24.h),
            
            // Form
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: controller.labelController,
                      decoration: const InputDecoration(
                        labelText: 'Label *',
                        hintText: 'e.g., Gmail, Facebook',
                        prefixIcon: Icon(Icons.label_outline),
                      ),
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    TextField(
                      controller: controller.usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username/Email *',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    TextField(
                      controller: controller.passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password *',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: controller.useGeneratedPassword,
                              icon: const Icon(Icons.auto_awesome),
                              tooltip: 'Use Generated Password',
                            ),
                            Obx(() => IconButton(
                              onPressed: () => controller.showPassword.toggle(),
                              icon: Icon(
                                controller.showPassword.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            )),
                          ],
                        ),
                      ),
                      obscureText: !controller.showPassword.value,
                      onChanged: controller.calculatePasswordStrength,
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    TextField(
                      controller: controller.websiteController,
                      decoration: const InputDecoration(
                        labelText: 'Website',
                        hintText: 'https://example.com',
                        prefixIcon: Icon(Icons.web),
                      ),
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    TextField(
                      controller: controller.tagsController,
                      decoration: const InputDecoration(
                        labelText: 'Tags (comma separated)',
                        hintText: 'work, social, email',
                        prefixIcon: Icon(Icons.tag),
                      ),
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    TextField(
                      controller: controller.notesController,
                      decoration: const InputDecoration(
                        labelText: 'Notes',
                        prefixIcon: Icon(Icons.note_outlined),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
            
            // Save Button
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final tags = controller.tagsController.text
                      .split(',')
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .toList();
                  
                  controller.savePassword(
                    label: controller.labelController.text,
                    username: controller.usernameController.text,
                    password: controller.passwordController.text,
                    website: controller.websiteController.text,
                    notes: controller.notesController.text,
                    tags: tags,
                  );
                  
                  Get.back();
                },
                child: const Text('Save Password'),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showFilterSheet() {
    final allTags = controller.getAllTags();
    
    Get.bottomSheet(
      Container(
        height: Get.height * 0.6,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Get.theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter by Tags',
                  style: Get.textTheme.headlineSmall,
                ),
                TextButton(
                  onPressed: () {
                    controller.filterByTags([]);
                    Get.back();
                  },
                  child: const Text('Clear All'),
                ),
              ],
            ),
            
            SizedBox(height: 16.h),
            
            if (allTags.isEmpty)
              const Expanded(
                child: Center(
                  child: Text('No tags available'),
                ),
              )
            else
              Expanded(
                child: Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
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
                      );
                    });
                  }).toList(),
                ),
              ),
            
            // Apply Button
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}