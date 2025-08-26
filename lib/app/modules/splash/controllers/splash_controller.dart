import 'package:get/get.dart';
import 'package:lockbloom/app/controllers/auth_controller.dart';
import 'package:lockbloom/app/routes/app_pages.dart';

class SplashController extends GetxController {
  final AuthController _authController = Get.find();
  
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Simulate initialization delay
    await Future.delayed(const Duration(seconds: 2));
    
    try {
      // Check if app setup is complete
      if (_authController.isSetupComplete.value) {
        // Navigate to auth screen
        Get.offNamed(Routes.AUTH);
      } else {
        // Navigate to auth screen for setup
        Get.offNamed(Routes.AUTH);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to initialize app: ${e.toString()}');
      // Still navigate to auth screen
      Get.offNamed(Routes.AUTH);
    } finally {
      isLoading.value = false;
    }
  }
}