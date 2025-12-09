import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lockbloom/app/controllers/password_controller.dart';
import 'package:lockbloom/app/data/models/password_entry.dart';
import 'package:lockbloom/app/widgets/password_strength_indicator.dart';
import 'package:lockbloom/app/themes/app_theme.dart';

class PasswordGeneratorCard extends GetView<PasswordController> {
  const PasswordGeneratorCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppTheme.spacingLg.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppTheme.spacingSm.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20.w,
                  ),
                ),
                SizedBox(width: AppTheme.spacingMd.w),
                Text(
                  'Password Generator',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: AppTheme.spacingLg.h),
            
            // Generated Password Display
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppTheme.spacingMd.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => SelectableText(
                    controller.generatedPassword.value,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 18.sp,
                      letterSpacing: 1.0,
                    ),
                  )),
                  
                  SizedBox(height: AppTheme.spacingMd.h),
                  
                  // Password Strength Indicator
                  Obx(() => PasswordStrengthIndicator(
                    strength: controller.passwordStrength.value,
                  )),
                ],
              ),
            ),
            
            SizedBox(height: AppTheme.spacingMd.h),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: controller.generatePassword,
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: const Text('Generate'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                  ),
                ),
                SizedBox(width: AppTheme.spacingMd.w),
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
                    icon: const Icon(Icons.copy_rounded, size: 18),
                    label: const Text('Copy'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: AppTheme.spacingLg.h),
            
            // Generator Options
            _buildGeneratorOptions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneratorOptions(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          'Generator Options',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: Icon(
          Icons.tune_rounded,
          color: Theme.of(context).colorScheme.primary,
        ),
        initiallyExpanded: false,
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.symmetric(vertical: AppTheme.spacingSm.h),
        children: [
          Column(
            children: [
              // Length Slider
              Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Length',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingSm.w,
                          vertical: AppTheme.spacingXs.h,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                        ),
                        child: Text(
                          '${controller.generatorConfig.value.length}',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Theme.of(context).colorScheme.primary,
                      inactiveTrackColor: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                      thumbColor: Theme.of(context).colorScheme.primary,
                      overlayColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      trackHeight: 4.0,
                    ),
                    child: Slider(
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
                  ),
                ],
              )),
              
              SizedBox(height: AppTheme.spacingMd.h),
              
              // Character Type Options
              Obx(() => Column(
                children: [
                  _buildOptionRow(
                    context,
                    'Include Uppercase (A-Z)',
                    controller.generatorConfig.value.includeUppercase,
                    (value) => controller.updateGeneratorConfig(
                      controller.generatorConfig.value.copyWith(
                        includeUppercase: value,
                      ),
                    ),
                  ),
                  _buildOptionRow(
                    context,
                    'Include Lowercase (a-z)',
                    controller.generatorConfig.value.includeLowercase,
                    (value) => controller.updateGeneratorConfig(
                      controller.generatorConfig.value.copyWith(
                        includeLowercase: value,
                      ),
                    ),
                  ),
                  _buildOptionRow(
                    context,
                    'Include Numbers (0-9)',
                    controller.generatorConfig.value.includeNumbers,
                    (value) => controller.updateGeneratorConfig(
                      controller.generatorConfig.value.copyWith(
                        includeNumbers: value,
                      ),
                    ),
                  ),
                  _buildOptionRow(
                    context,
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
              
              SizedBox(height: AppTheme.spacingMd.h),
              
              // Advanced Options
              Obx(() => Column(
                children: [
                  _buildOptionRow(
                    context,
                    'Exclude Ambiguous (0, O, l, 1)',
                    controller.generatorConfig.value.excludeAmbiguous,
                    (value) => controller.updateGeneratorConfig(
                      controller.generatorConfig.value.copyWith(
                        excludeAmbiguous: value,
                      ),
                    ),
                  ),
                  _buildOptionRow(
                    context,
                    'Exclude Similar Characters',
                    controller.generatorConfig.value.excludeSimilar,
                    (value) => controller.updateGeneratorConfig(
                      controller.generatorConfig.value.copyWith(
                        excludeSimilar: value,
                      ),
                    ),
                  ),
                  _buildOptionRow(
                    context,
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
        ],
      ),
    );
  }

  Widget _buildOptionRow(
    BuildContext context,
    String title, 
    bool value, 
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppTheme.spacingXs.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
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