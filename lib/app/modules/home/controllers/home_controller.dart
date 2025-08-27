import 'package:get/get.dart';
import 'package:lockbloom/app/routes/app_pages.dart';

class HomeController extends GetxController {
  final currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
  }
}