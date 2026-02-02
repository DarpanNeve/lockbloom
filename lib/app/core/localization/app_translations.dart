import 'package:get/get.dart';
import 'package:lockbloom/app/core/localization/locales/en_us.dart';
import 'package:lockbloom/app/core/localization/locales/hi_in.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
    'hi_IN': hiIN,
  };
}
