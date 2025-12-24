import 'package:get/get.dart';
import 'package:lockbloom/app/modules/auth/bindings/auth_binding.dart';
import 'package:lockbloom/app/modules/auth/views/auth_view.dart';
import 'package:lockbloom/app/modules/home/bindings/home_binding.dart';
import 'package:lockbloom/app/modules/home/views/home_view.dart';
import 'package:lockbloom/app/modules/password_detail/bindings/password_detail_binding.dart';
import 'package:lockbloom/app/modules/password_detail/views/password_detail_view.dart';
import 'package:lockbloom/app/modules/saved_passwords/bindings/saved_passwords_binding.dart';
import 'package:lockbloom/app/modules/saved_passwords/views/saved_passwords_view.dart';
import 'package:lockbloom/app/modules/settings/bindings/settings_binding.dart';
import 'package:lockbloom/app/modules/settings/views/settings_view.dart';
import 'package:lockbloom/app/modules/splash/bindings/splash_binding.dart';
import 'package:lockbloom/app/modules/splash/views/splash_view.dart';
import 'package:lockbloom/app/modules/premium/premium_binding.dart';
import 'package:lockbloom/app/modules/premium/premium_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SAVED_PASSWORDS,
      page: () => const SavedPasswordsView(),
      binding: SavedPasswordsBinding(),
    ),
    GetPage(
      name: _Paths.PASSWORD_DETAIL,
      page: () => const PasswordDetailView(),
      binding: PasswordDetailBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.PREMIUM,
      page: () => const PremiumView(),
      binding: PremiumBinding(),
    ),
  ];
}