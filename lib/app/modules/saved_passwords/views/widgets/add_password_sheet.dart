import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lockbloom/app/core/theme/app_colors.dart';
import 'package:lockbloom/app/themes/app_theme.dart';
import 'package:lockbloom/app/modules/saved_passwords/controllers/saved_passwords_controller.dart';
import 'package:lockbloom/app/controllers/password_controller.dart';

class AddPasswordSheet extends GetView<PasswordController> {
  const AddPasswordSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.85,
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLg)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'add_password'.tr,
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

          const SizedBox(height: AppTheme.spacingLg),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildTextField(
                    controller: controller.labelController,
                    label: '${'title'.tr} *',
                    hint: 'hint_example'.tr,
                    icon: Icons.label_outline_rounded,
                  ),

                  const SizedBox(height: AppTheme.spacingMd),

                  _buildTextField(
                    controller: controller.usernameController,
                    label: '${'username'.tr} *',
                    icon: Icons.person_outline_rounded,
                  ),

                  const SizedBox(height: AppTheme.spacingMd),

                  Obx(
                    () => _buildTextField(
                      controller: controller.passwordController,
                      label: '${'password'.tr} *',
                      icon: Icons.lock_outline_rounded,
                      obscureText: !controller.showPassword.value,
                      onChanged: controller.calculatePasswordStrength,
                      suffix: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: controller.useGeneratedPassword,
                            icon: const Icon(Icons.auto_awesome_rounded),
                            tooltip: 'generate_password'.tr,
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

                  const SizedBox(height: AppTheme.spacingMd),

                  _buildTextField(
                    controller: controller.websiteController,
                    label: 'website'.tr,
                    hint: 'https://example.com',
                    icon: Icons.language_rounded,
                    keyboardType: TextInputType.url,
                  ),

                  const SizedBox(height: AppTheme.spacingMd),

                  _buildTextField(
                    controller: controller.tagsController,
                    label: 'category'.tr,
                    hint: '${'work'.tr}, ${'social'.tr}, ${'finance'.tr}',
                    icon: Icons.tag_rounded,
                  ),

                  const SizedBox(height: AppTheme.spacingMd),

                  _buildTextField(
                    controller: controller.notesController,
                    label: 'notes'.tr,
                    icon: Icons.note_outlined,
                    maxLines: 3,
                  ),
                  
                  const SizedBox(height: AppTheme.spacingXxl),
                ],
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom > 0 
                  ? 0 
                  : (AppTheme.spacingSm + MediaQuery.of(context).padding.bottom),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
                child: Text('save'.tr),
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
        'error'.tr,
        'fill_required_fields'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.errorColor,
        colorText: Colors.white,
        margin: const EdgeInsets.all(AppTheme.spacingMd),
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
