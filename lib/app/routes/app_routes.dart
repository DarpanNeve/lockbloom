part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  
  static const SPLASH = _Paths.SPLASH;
  static const AUTH = _Paths.AUTH;
  static const HOME = _Paths.HOME;
  static const SAVED_PASSWORDS = _Paths.SAVED_PASSWORDS;
  static const PASSWORD_DETAIL = _Paths.PASSWORD_DETAIL;
  static const SETTINGS = _Paths.SETTINGS;
}

abstract class _Paths {
  _Paths._();
  
  static const SPLASH = '/splash';
  static const AUTH = '/auth';
  static const HOME = '/home';
  static const SAVED_PASSWORDS = '/saved-passwords';
  static const PASSWORD_DETAIL = '/password-detail';
  static const SETTINGS = '/settings';
}