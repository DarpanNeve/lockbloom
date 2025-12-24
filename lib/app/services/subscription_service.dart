import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lockbloom/app/core/values/app_constants.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionService extends GetxService {
  final RxBool isPremium = false.obs;
  final Rx<CustomerInfo?> customerInfo = Rx<CustomerInfo?>(null);

  Future<SubscriptionService> init() async {
    await _initRevenueCat();
    return this;
  }

  Future<void> _initRevenueCat() async {
    try {
      if (Platform.isIOS) {
        await Purchases.configure(PurchasesConfiguration(AppConstants.revenueCatAppleKey));
      } else if (Platform.isAndroid) {
        await Purchases.configure(PurchasesConfiguration(AppConstants.revenueCatGoogleKey));
      }

      await checkSubscriptionStatus();

      // Listen for updates
      Purchases.addCustomerInfoUpdateListener((info) {
        customerInfo.value = info;
        _updatePremiumStatus(info);
      });
    } catch (e) {
      // debugPrint("Error initializing RevenueCat: $e");
    }
  }

  Future<void> checkSubscriptionStatus() async {
    try {
      final info = await Purchases.getCustomerInfo();
      // print('Debug CustomerInfo: $info');
      // print('Debug Entitlements from checkStatus: ${info.entitlements.all}');
      customerInfo.value = info;
      _updatePremiumStatus(info);
    } catch (e) {
      // debugPrint("Error checking subscription status: $e");
    }
  }

  void _updatePremiumStatus(CustomerInfo info) {
    // print('Entitlements: ${info.entitlements.all}'); 
    // print('Active Entitlements: ${info.entitlements.active}');
    if (info.entitlements.all[AppConstants.entitlementId] != null &&
        info.entitlements.all[AppConstants.entitlementId]!.isActive) {
      isPremium.value = true;
    } else {
      isPremium.value = false;
    }
  }

  Future<Offerings?> getOfferings() async {
    try {
      final offerings = await Purchases.getOfferings();
      return offerings;
    } on PlatformException {
      // Allow user to handle error
      rethrow;
    }
  }

  Future<void> restorePurchases() async {
    try {
      final info = await Purchases.restorePurchases();
      customerInfo.value = info;
      _updatePremiumStatus(info);
    } on PlatformException {
       rethrow;
    }
  }

  Future<void> purchasePackage(Package package) async {
    try {
      // ignore: deprecated_member_use
      final result = await Purchases.purchasePackage(package);
      customerInfo.value = result.customerInfo;
      _updatePremiumStatus(result.customerInfo);
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        rethrow;
      }
    }
  }
  
  Future<void> openBuyMeACoffee() async {
    final Uri url = Uri.parse(AppConstants.buyMeACoffeeUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
       throw 'Could not launch $url';
    }
  }

  Future<void> manageSubscription() async {
    Uri? url;
    if (Platform.isIOS) {
      url = Uri.parse('https://apps.apple.com/account/subscriptions');
    } else if (Platform.isAndroid) {
      url = Uri.parse('https://play.google.com/store/account/subscriptions');
    }

    if (url != null) {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        // Try default mode if external fails
        await launchUrl(url);
      }
    }
  }
}
