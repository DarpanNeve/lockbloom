import 'package:get/get.dart';
import 'package:lockbloom/app/routes/app_pages.dart';

class HomeController extends GetxController {
  final currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
    
    switch (index) {
      case 0:
        // Already on home, do nothing
        break;
      case 1:
        Get.toNamed(Routes.SAVED_PASSWORDS);
        break;
      case 2:
        Get.toNamed(Routes.SETTINGS);
        break;
    }
  }
}