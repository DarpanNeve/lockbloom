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
    // Services
    Get.put<StorageService>(StorageService(), permanent: true);
    Get.put<EncryptionService>(EncryptionService(), permanent: true);
    Get.put<BiometricService>(BiometricService(), permanent: true);
    Get.put<PasswordService>(PasswordService(), permanent: true);
    
    // Repositories
    Get.put<PasswordRepository>(PasswordRepository(), permanent: true);
    
    // Controllers
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<PasswordController>(PasswordController(), permanent: true);
    Get.put<SettingsController>(SettingsController(), permanent: true);
  }
}