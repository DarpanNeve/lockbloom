import 'package:get/get.dart';
import 'package:lockbloom/app/modules/premium/premium_controller.dart';

class PremiumBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PremiumController>(() => PremiumController());
  }
}
