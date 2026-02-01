import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lockbloom/app/core/theme/app_colors.dart';
import 'package:lockbloom/app/modules/premium/premium_controller.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PremiumView extends GetView<PremiumController> {
  const PremiumView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: context.theme.iconTheme.color),
          onPressed: () => Get.back(),
        ),
        actions: [
          TextButton(
            onPressed: controller.restorePurchases,
            child: Text(
              "restore".tr,
              style: TextStyle(
                color: context.theme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        // If no offerings are available (e.g. network error or no setup), show error or generic state
        if (controller.offerings.value == null || controller.offerings.value!.current == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("premium_unavailable_offline".tr),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: controller.fetchOfferings,
                  child: Text("retry".tr),
                ),
                const SizedBox(height: 20),
                // _buildBMCButton(context) - Moved to Settings
              ],
            ),
          );
        }

        final currentOffering = controller.offerings.value!.current!;
        final monthly = currentOffering.monthly;
        final annual = currentOffering.annual;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Icon(
                Icons.diamond_outlined,
                size: 80.w,
                color: context.theme.primaryColor,
              ),
              SizedBox(height: 16.h),
              Text(
                "unlock_unlimited".tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: context.theme.textTheme.bodyLarge?.color,
                ),
              ),
              Text(
                "access_premium_forever".tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: context.theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                ),
              ),
              
              SizedBox(height: 32.h),

              // Benefits List
              _buildBenefitItem(context, Icons.cloud_off, "offline_backup_sync".tr),
              _buildBenefitItem(context, Icons.analytics_outlined, "advanced_analytics".tr),
              _buildBenefitItem(context, Icons.color_lens_outlined, "premium_themes".tr),
              _buildBenefitItem(context, Icons.security, "biometric_security".tr),
              
              SizedBox(height: 32.h),

              // Plans
              if (annual != null)
                _buildPlanCard(
                  context,
                  package: annual,
                  isYearly: true,
                  savings: "save_20_percent".tr,
                ),
              SizedBox(height: 16.h),
              if (monthly != null)
                _buildPlanCard(
                  context,
                  package: monthly,
                  isYearly: false,
                ),

              SizedBox(height: 32.h),

              // Subscribe Button
              if (controller.isPremium.value) ...[
                  SizedBox(height: 16.h),
                   Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 8.w),
                        Text(
                          "premium_active".tr,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
              ] else ...[
                 ElevatedButton(
                  onPressed: controller.makePurchase,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.theme.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    elevation: 5,
                    shadowColor: context.theme.primaryColor.withOpacity(0.4),
                  ),
                  child: Text(
                    "start_premium".tr,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],

              SizedBox(height: 24.h),
              // _buildBMCButton(context) - Moved to Settings
              
              SizedBox(height: 40.h),
              
              // Footer
              Text(
                "subscription_disclaimer".tr,
                textAlign: TextAlign.center,
                 style: TextStyle(
                  fontSize: 10.sp,
                  color: context.theme.textTheme.bodySmall?.color?.withOpacity(0.5),
                ),
              ),
               SizedBox(height: 20.h),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBenefitItem(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: context.theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: context.theme.primaryColor, size: 20.w),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context, {required Package package, required bool isYearly, String? savings}) {
    return Obx(() {
      final isSelected = controller.selectedPackage.value == package;
      final borderColor = isSelected ? context.theme.primaryColor : context.theme.dividerColor;
      final backgroundColor = isSelected ? context.theme.primaryColor.withOpacity(0.05) : Colors.transparent;

      return GestureDetector(
        onTap: () => controller.selectPackage(package),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
            borderRadius: BorderRadius.circular(16.r),
          ),
          padding: EdgeInsets.all(16.r),
          child: Row(
            children: [
              Radio<Package>(
                value: package,
                groupValue: controller.selectedPackage.value,
                onChanged: (val) => controller.selectPackage(val!),
                activeColor: context.theme.primaryColor,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          isYearly ? "annual_plan".tr : "monthly_plan".tr,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (savings != null) ...[
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Text(
                              savings,
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      package.storeProduct.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: context.theme.textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                package.storeProduct.priceString,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: context.theme.primaryColor,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
  

}
