import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lockbloom/app/core/theme/app_colors.dart';
import 'package:lockbloom/app/services/storage_service.dart';

class ThemeService extends GetxService {
  static const String _themeKey = 'theme_mode';
  static const String _accentColorKey = 'accent_color';
  
  final _themeMode = ThemeMode.system.obs;
  final _accentColorId = 'teal'.obs;
  
  ThemeMode get theme => _themeMode.value;
  String get accentColorId => _accentColorId.value;
  AccentColorOption get accentColor => AppColors.getColorById(_accentColorId.value);

  Future<ThemeService> init() async {
    final storage = Get.find<StorageService>();
    final savedTheme = storage.read<String>(_themeKey);
    final savedColor = storage.read<String>(_accentColorKey);
    
    if (savedTheme != null) {
      _themeMode.value = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == savedTheme,
        orElse: () => ThemeMode.system,
      );
    }
    
    if (savedColor != null) {
      _accentColorId.value = savedColor;
    }
    
    return this;
  }

  void changeTheme(ThemeMode themeMode) {
    _themeMode.value = themeMode;
    Get.find<StorageService>().write(_themeKey, themeMode.toString());
    Get.changeThemeMode(themeMode);
  }

  Future<void> changeAccentColor(String colorId) async {
    if (!AppColors.accentColors.any((c) => c.id == colorId)) return;
    
    _accentColorId.value = colorId;
    await Get.find<StorageService>().write(_accentColorKey, colorId);
    
    final newAccent = AppColors.getColorById(colorId);
    Get.changeTheme(_buildTheme(Brightness.light, newAccent));
    Get.changeTheme(_buildTheme(
      Get.isDarkMode ? Brightness.dark : Brightness.light,
      newAccent,
    ));
    
    Get.forceAppUpdate();
  }

  void switchTheme() {
    switch (_themeMode.value) {
      case ThemeMode.light:
        changeTheme(ThemeMode.dark);
        break;
      case ThemeMode.dark:
        changeTheme(ThemeMode.system);
        break;
      case ThemeMode.system:
        changeTheme(ThemeMode.light);
        break;
    }
  }

  bool get isDarkMode {
    if (_themeMode.value == ThemeMode.system) {
      return Get.isPlatformDarkMode;
    }
    return _themeMode.value == ThemeMode.dark;
  }

  bool get isLightMode {
    if (_themeMode.value == ThemeMode.system) {
      return !Get.isPlatformDarkMode;
    }
    return _themeMode.value == ThemeMode.light;
  }

  ThemeData get lightTheme => _buildTheme(Brightness.light, accentColor);
  ThemeData get darkTheme => _buildTheme(Brightness.dark, accentColor);

  ThemeData _buildTheme(Brightness brightness, AccentColorOption accent) {
    final isDark = brightness == Brightness.dark;
    
    final colorScheme = isDark 
        ? ColorScheme.dark(
            primary: accent.primaryLight,
            onPrimary: AppColors.darkBackgroundColor,
            primaryContainer: accent.primaryDark,
            onPrimaryContainer: accent.primaryLight,
            secondary: AppColors.secondaryLightColor,
            onSecondary: AppColors.darkBackgroundColor,
            secondaryContainer: AppColors.secondaryDarkColor,
            onSecondaryContainer: AppColors.secondaryLightColor,
            tertiary: AppColors.accentColor,
            onTertiary: AppColors.darkBackgroundColor,
            error: AppColors.errorColor,
            onError: Colors.white,
            surface: AppColors.darkSurfaceColor,
            onSurface: AppColors.darkOnSurfaceColor,
            surfaceContainerHighest: AppColors.darkOutlineVariantColor.withValues(alpha: 0.5),
            onSurfaceVariant: AppColors.darkOnSurfaceVariantColor,
            outline: AppColors.darkOutlineColor,
            outlineVariant: AppColors.darkOutlineVariantColor,
            inverseSurface: AppColors.lightSurfaceColor,
            onInverseSurface: AppColors.lightOnSurfaceColor,
            inversePrimary: accent.primary,
          )
        : ColorScheme.light(
            primary: accent.primary,
            onPrimary: Colors.white,
            primaryContainer: accent.primaryContainer,
            onPrimaryContainer: accent.onPrimaryContainer,
            secondary: AppColors.secondaryColor,
            onSecondary: Colors.white,
            secondaryContainer: AppColors.secondaryContainerColor,
            onSecondaryContainer: AppColors.onSecondaryContainerColor,
            tertiary: AppColors.accentColor,
            onTertiary: Colors.white,
            error: AppColors.errorColor,
            onError: Colors.white,
            surface: AppColors.lightSurfaceColor,
            onSurface: AppColors.lightOnSurfaceColor,
            surfaceContainerHighest: AppColors.lightOutlineVariantColor.withValues(alpha: 0.5),
            onSurfaceVariant: AppColors.lightOnSurfaceVariantColor,
            outline: AppColors.lightOutlineColor,
            outlineVariant: AppColors.lightOutlineVariantColor,
            inverseSurface: AppColors.darkSurfaceColor,
            onInverseSurface: AppColors.darkOnSurfaceColor,
            inversePrimary: accent.primaryLight,
          );

    final backgroundColor = isDark 
        ? AppColors.darkBackgroundColor 
        : AppColors.lightBackgroundColor;
    final surfaceColor = isDark 
        ? AppColors.darkSurfaceColor 
        : AppColors.lightSurfaceColor;
    final onSurfaceColor = isDark 
        ? AppColors.darkOnSurfaceColor 
        : AppColors.lightOnSurfaceColor;
    final onSurfaceVariantColor = isDark 
        ? AppColors.darkOnSurfaceVariantColor 
        : AppColors.lightOnSurfaceVariantColor;
    final outlineColor = isDark 
        ? AppColors.darkOutlineColor 
        : AppColors.lightOutlineColor;
    final primaryColor = isDark ? accent.primaryLight : accent.primary;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: backgroundColor,
      dividerTheme: DividerThemeData(
        color: outlineColor.withValues(alpha: 0.2),
        thickness: 1,
        space: 1,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: backgroundColor,
        foregroundColor: onSurfaceColor,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: onSurfaceColor,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: onSurfaceColor, size: 24),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: surfaceColor,
        shadowColor: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Premium rounding
          side: BorderSide(
            color: outlineColor.withValues(alpha: isDark ? 0.1 : 0.3),
            width: 1,
          ),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: isDark ? backgroundColor : Colors.white,
          disabledBackgroundColor: outlineColor.withValues(alpha: 0.3),
          disabledForegroundColor: onSurfaceVariantColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            fontFamily: 'Inter',
            letterSpacing: 0.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          disabledForegroundColor: onSurfaceVariantColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          side: BorderSide(color: outlineColor, width: 1.5),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            fontFamily: 'Inter',
            letterSpacing: 0.5,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          disabledForegroundColor: onSurfaceVariantColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            fontFamily: 'Inter',
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primaryColor.withValues(alpha: 0.5), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.errorColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.errorColor, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        hintStyle: TextStyle(
          color: onSurfaceVariantColor.withValues(alpha: 0.7),
          fontFamily: 'Inter',
          fontSize: 15,
        ),
        labelStyle: TextStyle(
          color: onSurfaceVariantColor,
          fontFamily: 'Inter',
          fontSize: 15,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark ? backgroundColor : surfaceColor,
        indicatorColor: primaryColor.withValues(alpha: 0.15),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              fontFamily: 'Inter',
              color: primaryColor,
            );
          }
          return TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
            fontFamily: 'Inter',
            color: onSurfaceVariantColor,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
           if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: primaryColor, size: 26);
          }
          return IconThemeData(color: onSurfaceVariantColor, size: 24);
        }),
        elevation: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? backgroundColor : surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: onSurfaceVariantColor,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          fontFamily: 'Inter',
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          fontFamily: 'Inter',
        ),
        showUnselectedLabels: true,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03),
        labelStyle: TextStyle(
          color: onSurfaceColor,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
          fontSize: 13,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide.none,
        ),
        selectedColor: primaryColor.withValues(alpha: 0.15),
        secondaryLabelStyle: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
          fontSize: 13,
        ),
        checkmarkColor: primaryColor,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return isDark ? backgroundColor : Colors.white;
          }
          return onSurfaceVariantColor;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return outlineColor.withValues(alpha: 0.5);
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w800,
          color: onSurfaceColor,
          height: 1.1,
          fontFamily: 'Inter',
          letterSpacing: -1.5,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: onSurfaceColor,
          height: 1.2,
          fontFamily: 'Inter',
          letterSpacing: -1.0,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: onSurfaceColor,
          height: 1.2,
          fontFamily: 'Inter',
          letterSpacing: -0.5,
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: onSurfaceColor,
          height: 1.3,
          fontFamily: 'Inter',
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: onSurfaceColor,
          height: 1.3,
          fontFamily: 'Inter',
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: onSurfaceColor,
          height: 1.4,
          fontFamily: 'Inter',
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: onSurfaceColor,
          height: 1.5,
          fontFamily: 'Inter',
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: onSurfaceVariantColor,
          height: 1.5,
          fontFamily: 'Inter',
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: onSurfaceVariantColor,
          height: 1.5,
          fontFamily: 'Inter',
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: onSurfaceColor,
          fontFamily: 'Inter',
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: onSurfaceVariantColor,
          fontFamily: 'Inter',
          letterSpacing: 0.5,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: onSurfaceVariantColor,
          fontFamily: 'Inter',
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}