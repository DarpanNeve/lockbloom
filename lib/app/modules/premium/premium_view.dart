import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lockbloom/app/modules/premium/premium_controller.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:lockbloom/app/themes/app_theme.dart';

class PremiumView extends GetView<PremiumController> {
  const PremiumView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('premium'.tr),
        actions: [
          TextButton(
            onPressed: controller.restorePurchases,
            child: Text("restore".tr),
          )
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        // Error or Offline State
        if (controller.offerings.value == null || controller.offerings.value!.current == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi_off_rounded, size: 64, color: Theme.of(context).colorScheme.outline),
                  const SizedBox(height: 16),
                  Text(
                    "premium_unavailable_offline".tr,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: controller.fetchOfferings,
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text("retry".tr),
                  ),
                ],
              ),
            ),
          );
        }

        final currentOffering = controller.offerings.value!.current!;
        final monthly = currentOffering.monthly;
        final annual = currentOffering.annual;

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    // Header Icon
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.diamond_rounded,
                        size: 48,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Value Proposition
                    Text(
                      "unlock_unlimited".tr,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "access_premium_forever".tr,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    
                    const SizedBox(height: 40),

                    // Benefits List
                    _buildBenefitItem(context, Icons.cloud_sync_rounded, "offline_backup_sync".tr),
                    _buildBenefitItem(context, Icons.analytics_rounded, "advanced_analytics".tr),
                    _buildBenefitItem(context, Icons.palette_rounded, "premium_themes".tr),
                    _buildBenefitItem(context, Icons.fingerprint_rounded, "biometric_security".tr),
                    
                    const SizedBox(height: 40),

                    // Plans
                    if (annual != null)
                      _buildPlanCard(
                        context,
                        package: annual,
                        isYearly: true,
                        savings: "save_20_percent".tr,
                      ),
                    if (annual != null && monthly != null) const SizedBox(height: 16),
                    if (monthly != null)
                      _buildPlanCard(
                        context,
                        package: monthly,
                        isYearly: false,
                      ),

                    const SizedBox(height: 32),
                    
                     Text(
                      "subscription_disclaimer".tr,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 100), // Bottom padding for scroll
                  ],
                ),
              ),
            ),
            
            // Sticky Bottom Button
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
                  ),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Obx(() {
                  if (controller.isPremium.value) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_rounded, color: Colors.green, size: 24),
                          const SizedBox(width: 12),
                          Text(
                            "premium_active".tr,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: controller.selectedPackage.value != null 
                          ? controller.makePurchase 
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        "start_premium".tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildBenefitItem(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(Icons.check_rounded, color: Colors.green, size: 24),
        ],
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context, {required Package package, required bool isYearly, String? savings}) {
      return Obx(() {
      final isSelected = controller.selectedPackage.value == package;
      final borderColor = isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3);
      final backgroundColor = isSelected ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.05) : Theme.of(context).cardTheme.color;
      final textColor = isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface;

      return GestureDetector(
        onTap: () => controller.selectPackage(package),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
              ),
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                   Container(
                    width: 24, 
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline,
                        width: 2,
                      ),
                      color: isSelected ? Theme.of(context).colorScheme.primary : null,
                    ),
                    child: isSelected 
                        ? Icon(Icons.check, size: 16, color: Theme.of(context).colorScheme.onPrimary)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isYearly ? "annual_plan".tr : "monthly_plan".tr,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          package.storeProduct.description, // Often just the duration
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                             color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        package.storeProduct.priceString,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                        ),
                      ),
                      if (isYearly) ...[
                        const SizedBox(height: 4),
                        Text(
                          '/ ${'year'.tr}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ] else ...[
                         const SizedBox(height: 4),
                        Text(
                           '/ ${'month'.tr}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ]
                    ],
                  ),
                ],
              ),
            ),
            if (savings != null)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(18),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                  child: Text(
                    savings,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
