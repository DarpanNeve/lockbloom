import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lockbloom/app/services/subscription_service.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PremiumController extends GetxController {
  final SubscriptionService _subscriptionService = Get.find<SubscriptionService>();
  
  final Rx<Offerings?> offerings = Rx<Offerings?>(null);
  final RxBool isLoading = true.obs;
  final Rx<Package?> selectedPackage = Rx<Package?>(null);
  
  RxBool get isPremium => _subscriptionService.isPremium;
  
  @override
  void onInit() {
    super.onInit();
    fetchOfferings();
  }

  Future<void> fetchOfferings() async {
    isLoading.value = true;
    try {
      offerings.value = await _subscriptionService.getOfferings();
      
      // Auto-select yearly package if available (optimization for conversion)
      if (offerings.value?.current != null) {
        if (offerings.value!.current!.annual != null) {
          selectedPackage.value = offerings.value!.current!.annual;
        } else if (offerings.value!.current!.monthly != null) {
          selectedPackage.value = offerings.value!.current!.monthly;
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch offerings. Please try again later.",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void selectPackage(Package package) {
    selectedPackage.value = package;
  }

  Future<void> makePurchase() async {
    if (selectedPackage.value == null) return;
    
    isLoading.value = true;
    try {
      await _subscriptionService.purchasePackage(selectedPackage.value!);
      Get.back(); // Close the paywall
      Get.snackbar("Success", "Welcome to Premium!",
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
       // Error handled in service or user cancelled. 
       // Service throws if not cancelled.
       Get.snackbar("Error", "Purchase failed. Please try again.",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> restorePurchases() async {
    isLoading.value = true;
    try {
      await _subscriptionService.restorePurchases();
      if (_subscriptionService.isPremium.value) {
         Get.back();
         Get.snackbar("Success", "Purchases restored!",
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
          snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar("Info", "No active subscription found to restore.",
          snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to restore purchases.",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
  

}
