import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lockbloom/app/bindings/initial_binding.dart';
import 'package:lockbloom/app/routes/app_pages.dart';
import 'package:lockbloom/app/services/theme_service.dart';
import 'package:lockbloom/app/themes/app_theme.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:upgrader/upgrader.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart'; // <-- add

import 'app/services/storage_service.dart';
import 'app/services/encryption_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Enable performance monitoring
  FirebasePerformance.instance.setPerformanceCollectionEnabled(true);

  // Initialize services
  await Get.putAsync(() async => StorageService());
  await Get.putAsync<EncryptionService>(() async {
    final encryptionService = EncryptionService();
    await encryptionService.init();
    return encryptionService;
  });
  await Get.putAsync(() => ThemeService().init());
  final shorebirdUpdater = ShorebirdUpdater();
  final status = await shorebirdUpdater.checkForUpdate();

  if (status == UpdateStatus.outdated) {
    await shorebirdUpdater.update();
  }

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const LockBloomApp());
}

class LockBloomApp extends StatelessWidget {
  const LockBloomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone 13 Pro size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'LockBloom',
          debugShowCheckedModeBanner: false,
          initialBinding: InitialBinding(),
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: Get.find<ThemeService>().theme,
          locale: Get.deviceLocale,
          fallbackLocale: const Locale('en', 'US'),
        );
      },
    );
  }
}
