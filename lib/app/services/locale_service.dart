import 'dart:ui';
import 'package:get/get.dart';
import 'package:lockbloom/app/services/storage_service.dart';

class LocaleService extends GetxService {
  static const String _localeKey = 'app_locale';
  static const String _localeCountryKey = 'app_locale_country';
  
  final _currentLocale = const Locale('en', 'US').obs;
  Locale get currentLocale => _currentLocale.value;
  
  static const List<LocaleOption> supportedLocales = [
    LocaleOption(
      locale: Locale('en', 'US'),
      name: 'English',
      nativeName: 'English',
      flag: '🇺🇸',
    ),
    LocaleOption(
      locale: Locale('hi', 'IN'),
      name: 'Hindi',
      nativeName: 'हिंदी',
      flag: '🇮🇳',
    ),
  ];

  Future<LocaleService> init() async {
    final storage = Get.find<StorageService>();
    final savedLang = storage.read<String>(_localeKey);
    final savedCountry = storage.read<String>(_localeCountryKey);
    
    if (savedLang != null) {
      _currentLocale.value = Locale(savedLang, savedCountry ?? 'US');
    } else {
      final deviceLocale = Get.deviceLocale;
      if (deviceLocale != null && _isSupported(deviceLocale)) {
        _currentLocale.value = deviceLocale;
      }
    }
    return this;
  }

  bool _isSupported(Locale locale) {
    return supportedLocales.any(
      (option) => option.locale.languageCode == locale.languageCode,
    );
  }

  Future<void> changeLocale(Locale locale) async {
    if (!_isSupported(locale)) return;
    
    _currentLocale.value = locale;
    await Get.find<StorageService>().write(_localeKey, locale.languageCode);
    await Get.find<StorageService>().write(_localeCountryKey, locale.countryCode ?? 'US');
    await Get.updateLocale(locale);
  }

  String get currentLocaleName {
    final option = supportedLocales.firstWhere(
      (o) => o.locale.languageCode == _currentLocale.value.languageCode,
      orElse: () => supportedLocales.first,
    );
    return option.nativeName;
  }
  
  String get currentLocaleFlag {
    final option = supportedLocales.firstWhere(
      (o) => o.locale.languageCode == _currentLocale.value.languageCode,
      orElse: () => supportedLocales.first,
    );
    return option.flag;
  }
}

class LocaleOption {
  final Locale locale;
  final String name;
  final String nativeName;
  final String flag;

  const LocaleOption({
    required this.locale,
    required this.name,
    required this.nativeName,
    required this.flag,
  });
}
