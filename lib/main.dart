import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lockbloom/app/bindings/initial_binding.dart';
import 'package:lockbloom/app/core/localization/app_translations.dart';
import 'package:lockbloom/app/routes/app_pages.dart';
import 'package:lockbloom/app/services/locale_service.dart';
import 'package:lockbloom/app/services/storage_service.dart';
import 'package:lockbloom/app/services/theme_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  FirebasePerformance.instance.setPerformanceCollectionEnabled(true);

  await Get.putAsync(() => StorageService().init());
  await Get.putAsync(() => ThemeService().init());
  await Get.putAsync(() => LocaleService().init());
  
  final shorebirdUpdater = ShorebirdUpdater();
  final status = await shorebirdUpdater.checkForUpdate();

  if (status == UpdateStatus.outdated) {
    await shorebirdUpdater.update();
  }

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    statusBarColor: Colors.transparent,
  ));

  runApp(const LockBloomApp());
}

class LockBloomApp extends StatelessWidget {
  const LockBloomApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    final localeService = Get.find<LocaleService>();
    
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Obx(() => GetMaterialApp(
          title: 'LockBloom',
          debugShowCheckedModeBanner: false,
          initialBinding: InitialBinding(),
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          theme: themeService.lightTheme,
          darkTheme: themeService.darkTheme,
          themeMode: themeService.theme,
          translations: AppTranslations(),
          locale: localeService.currentLocale,
          fallbackLocale: const Locale('en', 'US'),
        ));
      },
    );
  }
}
