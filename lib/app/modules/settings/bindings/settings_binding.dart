import 'package:get/get.dart';
import 'package:lockbloom/app/controllers/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    // SettingsController is already bound in InitialBinding as permanent
    // So we don't need to bind it again here
  }
}