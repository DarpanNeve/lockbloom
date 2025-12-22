import 'package:get/get.dart';
import 'package:lockbloom/app/controllers/auth_controller.dart';
import 'package:lockbloom/app/controllers/password_controller.dart';
import 'package:lockbloom/app/controllers/settings_controller.dart';
import 'package:lockbloom/app/services/biometric_service.dart';
import 'package:lockbloom/app/services/encryption_service.dart';
import 'package:lockbloom/app/services/password_service.dart';
import 'package:lockbloom/app/services/storage_service.dart';
import 'package:lockbloom/app/repositories/password_repository.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<BiometricService>(BiometricService(), permanent: true);
    Get.put<PasswordService>(PasswordService(), permanent: true);
    
    if (!Get.isRegistered<StorageService>()) {
      Get.put<StorageService>(StorageService(), permanent: true);
    }
    
    Get.put<EncryptionService>(EncryptionService(), permanent: true);
    Get.put<PasswordRepository>(PasswordRepository(), permanent: true);
    
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.lazyPut<PasswordController>(() => PasswordController(), fenix: true);
    Get.lazyPut<SettingsController>(() => SettingsController(), fenix: true);
  }
}