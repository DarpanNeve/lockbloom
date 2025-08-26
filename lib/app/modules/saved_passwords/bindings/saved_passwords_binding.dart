import 'package:get/get.dart';
import 'package:lockbloom/app/controllers/password_controller.dart';

class SavedPasswordsBinding extends Bindings {
  @override
  void dependencies() {
    // PasswordController is already bound in InitialBinding as permanent
    // So we don't need to bind it again here
  }
}