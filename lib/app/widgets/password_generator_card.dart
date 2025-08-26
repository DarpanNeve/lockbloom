import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lockbloom/app/controllers/password_controller.dart';
import 'package:lockbloom/app/data/models/password_entry.dart';
import 'package:lockbloom/app/widgets/password_strength_indicator.dart';

class PasswordGeneratorCard extends GetView<PasswordController> {
  const PasswordGeneratorCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.auto_awesome,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20.w,
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  'Password Generator',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            
            SizedBox(height: 20.h),
            
            // Generated Password Display
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => SelectableText(
                    controller.generatedPassword.value,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w500,
                    ),
                  )),
                  
                  SizedBox(height: 12.h),
                  
                  // Password Strength Indicator
                  Obx(() => PasswordStrengthIndicator(
                    strength: controller.passwordStrength.value,
                  )),
                ],
              ),
            ),
            
            SizedBox(height: 16.h),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: controller.generatePassword,
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Generate'),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await controller.copyPassword(PasswordEntry(
                        id: '',
                        label: '',
                        username: '',
                        encryptedPassword: controller.generatedPassword.value,
                        tags: [],
                        notes: '',
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                      ));
                    },
                    icon: const Icon(Icons.copy, size: 18),
                    label: const Text('Copy'),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 20.h),
            
            // Generator Options
            _buildGeneratorOptions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneratorOptions(BuildContext context) {
    return ExpansionTile(
      title: const Text('Generator Options'),
      leading: const Icon(Icons.tune),
      initiallyExpanded: false,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            children: [
              // Length Slider
              Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Length'),
                      Text('${controller.generatorConfig.value.length}'),
                    ],
                  ),
                  Slider(
                    value: controller.generatorConfig.value.length.toDouble(),
                    min: 8,
                    max: 64,
                    divisions: 56,
                    onChanged: (value) {
                      controller.updateGeneratorConfig(
                        controller.generatorConfig.value.copyWith(
                          length: value.round(),
                        ),
                      );
                    },
                  ),
                ],
              )),
              
              SizedBox(height: 16.h),
              
              // Character Type Options
              Obx(() => Column(
                children: [
                  _buildOptionRow(
                    'Include Uppercase (A-Z)',
                    controller.generatorConfig.value.includeUppercase,
                    (value) => controller.updateGeneratorConfig(
                      controller.generatorConfig.value.copyWith(
                        includeUppercase: value,
                      ),
                    ),
                  ),
                  _buildOptionRow(
                    'Include Lowercase (a-z)',
                    controller.generatorConfig.value.includeLowercase,
                    (value) => controller.updateGeneratorConfig(
                      controller.generatorConfig.value.copyWith(
                        includeLowercase: value,
                      ),
                    ),
                  ),
                  _buildOptionRow(
                    'Include Numbers (0-9)',
                    controller.generatorConfig.value.includeNumbers,
                    (value) => controller.updateGeneratorConfig(
                      controller.generatorConfig.value.copyWith(
                        includeNumbers: value,
                      ),
                    ),
                  ),
                  _buildOptionRow(
                    'Include Symbols (!@#\$%)',
                    controller.generatorConfig.value.includeSymbols,
                    (value) => controller.updateGeneratorConfig(
                      controller.generatorConfig.value.copyWith(
                        includeSymbols: value,
                      ),
                    ),
                  ),
                ],
              )),
              
              SizedBox(height: 16.h),
              
              // Advanced Options
              Obx(() => Column(
                children: [
                  _buildOptionRow(
                    'Exclude Ambiguous (0, O, l, 1)',
                    controller.generatorConfig.value.excludeAmbiguous,
                    (value) => controller.updateGeneratorConfig(
                      controller.generatorConfig.value.copyWith(
                        excludeAmbiguous: value,
                      ),
                    ),
                  ),
                  _buildOptionRow(
                    'Exclude Similar Characters',
                    controller.generatorConfig.value.excludeSimilar,
                    (value) => controller.updateGeneratorConfig(
                      controller.generatorConfig.value.copyWith(
                        excludeSimilar: value,
                      ),
                    ),
                  ),
                  _buildOptionRow(
                    'Pronounceable Password',
                    controller.generatorConfig.value.pronounceable,
                    (value) => controller.updateGeneratorConfig(
                      controller.generatorConfig.value.copyWith(
                        pronounceable: value,
                      ),
                    ),
                  ),
                ],
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOptionRow(String title, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Get.textTheme.bodyMedium,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}