import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lockbloom/app/themes/app_theme.dart';
import 'package:lockbloom/app/modules/saved_passwords/controllers/saved_passwords_controller.dart';

class AddPasswordSheet extends GetView<PasswordController> {
  const AddPasswordSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.85,
      padding: EdgeInsets.all(AppTheme.spacingMd.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLg)),
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
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.close_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
              ),
            ],
          ),

          SizedBox(height: AppTheme.spacingLg.h),

          // Form
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildTextField(
                    controller: controller.labelController,
                    label: 'Label *',
                    hint: 'e.g., Gmail, Facebook',
                    icon: Icons.label_outline_rounded,
                  ),

                  SizedBox(height: AppTheme.spacingMd.h),

                  _buildTextField(
                    controller: controller.usernameController,
                    label: 'Username/Email *',
                    icon: Icons.person_outline_rounded,
                  ),

                  SizedBox(height: AppTheme.spacingMd.h),

                  Obx(
                    () => _buildTextField(
                      controller: controller.passwordController,
                      label: 'Password *',
                      icon: Icons.lock_outline_rounded,
                      obscureText: !controller.showPassword.value,
                      onChanged: controller.calculatePasswordStrength,
                      suffix: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: controller.useGeneratedPassword,
                            icon: const Icon(Icons.auto_awesome_rounded),
                            tooltip: 'Generate Strong Password',
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          IconButton(
                            onPressed: () => controller.showPassword.toggle(),
                            icon: Icon(
                              controller.showPassword.value
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility_rounded,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Password Strength Indicator (Optional enhancement)
                  // You could add a strength bar here if the controller exposes strength value

                  SizedBox(height: AppTheme.spacingMd.h),

                  _buildTextField(
                    controller: controller.websiteController,
                    label: 'Website',
                    hint: 'https://example.com',
                    icon: Icons.language_rounded,
                    keyboardType: TextInputType.url,
                  ),

                  SizedBox(height: AppTheme.spacingMd.h),

                  _buildTextField(
                    controller: controller.tagsController,
                    label: 'Tags',
                    hint: 'work, social, email (comma separated)',
                    icon: Icons.tag_rounded,
                  ),

                  SizedBox(height: AppTheme.spacingMd.h),

                  _buildTextField(
                    controller: controller.notesController,
                    label: 'Notes',
                    icon: Icons.note_outlined,
                    maxLines: 3,
                  ),
                  
                  SizedBox(height: AppTheme.spacingXxl.h), // Extra space at bottom
                ],
              ),
            ),
          ),

          // Save Button
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 0 : AppTheme.spacingSm.h,
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 18.h),
                ),
                child: const Text('Save Password'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    bool obscureText = false,
    Widget? suffix,
    int maxLines = 1,
    TextInputType? keyboardType,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: const TextStyle(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: suffix,
      ),
    );
  }

  void _handleSave() {
    if (controller.labelController.text.isEmpty ||
        controller.usernameController.text.isEmpty ||
        controller.passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all required fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorColor,
        colorText: Colors.white,
        margin: EdgeInsets.all(AppTheme.spacingMd.w),
      );
      return;
    }

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
  }
}
