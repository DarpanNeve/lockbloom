import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lockbloom/app/controllers/password_controller.dart';
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
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppTheme.spacingLg.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  'password_generator'.tr,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: AppTheme.spacingLg.h),
            
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppTheme.spacingMd.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
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
                  
                  Obx(() => PasswordStrengthIndicator(
                    strength: controller.passwordStrength.value,
                  )),
                ],
              ),
            ),
            
            SizedBox(height: AppTheme.spacingMd.h),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: controller.generatePassword,
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: Text('generate_password'.tr.split(' ')[0]),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                  ),
                ),
                SizedBox(width: AppTheme.spacingMd.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final password = controller.generatedPassword.value;
                      if (password.isEmpty) return;
                      await Clipboard.setData(ClipboardData(text: password));
                      HapticFeedback.lightImpact();
                      Fluttertoast.showToast(msg: 'password_copied'.tr);
                      Future.delayed(const Duration(seconds: 30), () {
                        Clipboard.setData(const ClipboardData(text: ''));
                      });
                    },
                    icon: const Icon(Icons.copy_rounded, size: 18),
                    label: Text('copy'.tr),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: AppTheme.spacingLg.h),
            
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
          'password_length'.tr.split(' ')[0],
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
              Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'password_length'.tr,
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
                      inactiveTrackColor: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                      thumbColor: Theme.of(context).colorScheme.primary,
                      overlayColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
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
              
              Obx(() => Column(
                children: [
                  _buildOptionRow(
                    context,
                    'include_uppercase'.tr,
                    controller.generatorConfig.value.includeUppercase,
                    (value) => controller.updateGeneratorConfig(
                      controller.generatorConfig.value.copyWith(
                        includeUppercase: value,
                      ),
                    ),
                  ),
                  _buildOptionRow(
                    context,
                    'include_lowercase'.tr,
                    controller.generatorConfig.value.includeLowercase,
                    (value) => controller.updateGeneratorConfig(
                      controller.generatorConfig.value.copyWith(
                        includeLowercase: value,
                      ),
                    ),
                  ),
                  _buildOptionRow(
                    context,
                    'include_numbers'.tr,
                    controller.generatorConfig.value.includeNumbers,
                    (value) => controller.updateGeneratorConfig(
                      controller.generatorConfig.value.copyWith(
                        includeNumbers: value,
                      ),
                    ),
                  ),
                  _buildOptionRow(
                    context,
                    'include_symbols'.tr,
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