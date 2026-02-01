import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // AuthController is already bound in InitialBinding as permanent
    // So we don't need to bind it again here
  }
}