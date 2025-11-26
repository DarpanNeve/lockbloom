import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // Primary Color Palette (Teal - Trust & Security)
  static const Color primaryColor = Color(0xFF0D9488); // Teal 600
  static const Color primaryLightColor = Color(0xFF2DD4BF); // Teal 400
  static const Color primaryDarkColor = Color(0xFF115E59); // Teal 800
  static const Color primaryContainerColor = Color(0xFFF0FDFA); // Teal 50
  static const Color onPrimaryContainerColor = Color(0xFF134E4A); // Teal 900

  // Secondary Color Palette (Rose - Accent & Action)
  static const Color secondaryColor = Color(0xFFE11D48); // Rose 600
  static const Color secondaryLightColor = Color(0xFFFB7185); // Rose 400
  static const Color secondaryDarkColor = Color(0xFF9F1239); // Rose 800
  static const Color secondaryContainerColor = Color(0xFFFFF1F2); // Rose 50
  static const Color onSecondaryContainerColor = Color(0xFF881337); // Rose 900

  // Accent Colors
  static const Color accentColor = Color(0xFFF59E0B); // Amber
  static const Color successColor = Color(0xFF10B981); // Emerald
  static const Color warningColor = Color(0xFFF59E0B); // Amber
  static const Color errorColor = Color(0xFFEF4444); // Red

  // Light Theme Colors
  static const Color lightBackgroundColor = Color(0xFFF8FAFC); // Slate 50
  static const Color lightSurfaceColor = Color(0xFFFFFFFF);
  static const Color lightCardColor = Color(0xFFFFFFFF);
  static const Color lightOutlineColor = Color(0xFFE2E8F0); // Slate 200
  static const Color lightOutlineVariantColor = Color(0xFFF1F5F9); // Slate 100
  static const Color lightOnSurfaceColor = Color(0xFF0F172A); // Slate 900
  static const Color lightOnSurfaceVariantColor = Color(0xFF64748B); // Slate 500

  // Dark Theme Colors
  static const Color darkBackgroundColor = Color(0xFF0F172A); // Slate 900
  static const Color darkSurfaceColor = Color(0xFF1E293B); // Slate 800
  static const Color darkCardColor = Color(0xFF1E293B); // Slate 800 (Same as surface for seamless look)
  static const Color darkOutlineColor = Color(0xFF334155); // Slate 700
  static const Color darkOutlineVariantColor = Color(0xFF475569); // Slate 600
  static const Color darkOnSurfaceColor = Color(0xFFF8FAFC); // Slate 50
  static const Color darkOnSurfaceVariantColor = Color(0xFF94A3B8); // Slate 400

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.light(
      primary: primaryColor,
      onPrimary: Colors.white,
      primaryContainer: primaryContainerColor,
      onPrimaryContainer: onPrimaryContainerColor,
      secondary: secondaryColor,
      onSecondary: Colors.white,
      secondaryContainer: secondaryContainerColor,
      onSecondaryContainer: onSecondaryContainerColor,
      tertiary: accentColor,
      onTertiary: Colors.white,
      error: errorColor,
      onError: Colors.white,
      surface: lightSurfaceColor,
      onSurface: lightOnSurfaceColor,
      surfaceContainerHighest: lightOutlineVariantColor,
      onSurfaceVariant: lightOnSurfaceVariantColor,
      outline: lightOutlineColor,
      outlineVariant: lightOutlineVariantColor,
      inverseSurface: darkSurfaceColor,
      onInverseSurface: darkOnSurfaceColor,
      inversePrimary: primaryLightColor,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: lightBackgroundColor,

      // AppBar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: lightBackgroundColor, // Seamless with background
        foregroundColor: lightOnSurfaceColor,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: lightOnSurfaceColor,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
          letterSpacing: -0.5,
        ),
        iconTheme: const IconThemeData(color: lightOnSurfaceColor, size: 24),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 0, // Flat design
        color: lightCardColor,
        shadowColor: Colors.black.withOpacity(0.04),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: lightOutlineColor, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: lightOutlineColor,
          disabledForegroundColor: lightOnSurfaceVariantColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            fontFamily: 'Inter',
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          disabledForegroundColor: lightOnSurfaceVariantColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          side: const BorderSide(color: lightOutlineColor, width: 1),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            fontFamily: 'Inter',
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          disabledForegroundColor: lightOnSurfaceVariantColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            fontFamily: 'Inter',
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightOutlineColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightOutlineColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: TextStyle(
          color: lightOnSurfaceVariantColor,
          fontFamily: 'Inter',
          fontSize: 14,
        ),
        labelStyle: TextStyle(
          color: lightOnSurfaceVariantColor,
          fontFamily: 'Inter',
          fontSize: 14,
        ),
        floatingLabelStyle: TextStyle(
          color: primaryColor,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: lightSurfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: lightOnSurfaceVariantColor,
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

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: lightOutlineVariantColor,
        labelStyle: const TextStyle(
          color: lightOnSurfaceColor,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
          fontSize: 13,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Colors.transparent),
        ),
        selectedColor: primaryContainerColor,
        secondaryLabelStyle: const TextStyle(
          color: onPrimaryContainerColor,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
          fontSize: 13,
        ),
        checkmarkColor: onPrimaryContainerColor,
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return lightOnSurfaceVariantColor;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return lightOutlineColor;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: lightOnSurfaceColor,
          height: 1.2,
          fontFamily: 'Inter',
          letterSpacing: -1.0,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: lightOnSurfaceColor,
          height: 1.2,
          fontFamily: 'Inter',
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: lightOnSurfaceColor,
          height: 1.2,
          fontFamily: 'Inter',
        ),
        headlineLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: lightOnSurfaceColor,
          height: 1.3,
          fontFamily: 'Inter',
        ),
        headlineMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: lightOnSurfaceColor,
          height: 1.3,
          fontFamily: 'Inter',
        ),
        headlineSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: lightOnSurfaceColor,
          height: 1.4,
          fontFamily: 'Inter',
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: lightOnSurfaceColor,
          height: 1.5,
          fontFamily: 'Inter',
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: lightOnSurfaceVariantColor, // Softer body text
          height: 1.5,
          fontFamily: 'Inter',
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: lightOnSurfaceVariantColor,
          height: 1.4,
          fontFamily: 'Inter',
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: lightOnSurfaceColor,
          fontFamily: 'Inter',
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: lightOnSurfaceVariantColor,
          fontFamily: 'Inter',
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: lightOnSurfaceVariantColor,
          fontFamily: 'Inter',
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.dark(
      primary: primaryLightColor,
      onPrimary: darkBackgroundColor,
      primaryContainer: primaryDarkColor,
      onPrimaryContainer: primaryLightColor,
      secondary: secondaryLightColor,
      onSecondary: darkBackgroundColor,
      secondaryContainer: secondaryDarkColor,
      onSecondaryContainer: secondaryLightColor,
      tertiary: accentColor,
      onTertiary: darkBackgroundColor,
      error: errorColor,
      onError: Colors.white,
      surface: darkSurfaceColor,
      onSurface: darkOnSurfaceColor,
      surfaceContainerHighest: darkOutlineVariantColor,
      onSurfaceVariant: darkOnSurfaceVariantColor,
      outline: darkOutlineColor,
      outlineVariant: darkOutlineVariantColor,
      inverseSurface: lightSurfaceColor,
      onInverseSurface: lightOnSurfaceColor,
      inversePrimary: primaryColor,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: darkBackgroundColor,

      // AppBar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: darkBackgroundColor,
        foregroundColor: darkOnSurfaceColor,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: darkOnSurfaceColor,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
          letterSpacing: -0.5,
        ),
        iconTheme: const IconThemeData(color: darkOnSurfaceColor, size: 24),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 0,
        color: darkSurfaceColor,
        shadowColor: Colors.black.withOpacity(0.2),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: darkOutlineColor.withOpacity(0.5), width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryLightColor,
          foregroundColor: darkBackgroundColor,
          disabledBackgroundColor: darkOutlineColor,
          disabledForegroundColor: darkOnSurfaceVariantColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            fontFamily: 'Inter',
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryLightColor,
          disabledForegroundColor: darkOnSurfaceVariantColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          side: const BorderSide(color: darkOutlineColor, width: 1),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            fontFamily: 'Inter',
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryLightColor,
          disabledForegroundColor: darkOnSurfaceVariantColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            fontFamily: 'Inter',
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkOutlineColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkOutlineColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryLightColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: TextStyle(
          color: darkOnSurfaceVariantColor,
          fontFamily: 'Inter',
          fontSize: 14,
        ),
        labelStyle: TextStyle(
          color: darkOnSurfaceVariantColor,
          fontFamily: 'Inter',
          fontSize: 14,
        ),
        floatingLabelStyle: TextStyle(
          color: primaryLightColor,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkBackgroundColor,
        selectedItemColor: primaryLightColor,
        unselectedItemColor: darkOnSurfaceVariantColor,
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

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: darkOutlineColor,
        labelStyle: const TextStyle(
          color: darkOnSurfaceColor,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
          fontSize: 13,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Colors.transparent),
        ),
        selectedColor: primaryDarkColor,
        secondaryLabelStyle: const TextStyle(
          color: primaryLightColor,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
          fontSize: 13,
        ),
        checkmarkColor: primaryLightColor,
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return darkBackgroundColor;
          }
          return darkOnSurfaceVariantColor;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryLightColor;
          }
          return darkOutlineColor;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: darkOnSurfaceColor,
          height: 1.2,
          fontFamily: 'Inter',
          letterSpacing: -1.0,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: darkOnSurfaceColor,
          height: 1.2,
          fontFamily: 'Inter',
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: darkOnSurfaceColor,
          height: 1.2,
          fontFamily: 'Inter',
        ),
        headlineLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: darkOnSurfaceColor,
          height: 1.3,
          fontFamily: 'Inter',
        ),
        headlineMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: darkOnSurfaceColor,
          height: 1.3,
          fontFamily: 'Inter',
        ),
        headlineSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: darkOnSurfaceColor,
          height: 1.4,
          fontFamily: 'Inter',
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: darkOnSurfaceColor,
          height: 1.5,
          fontFamily: 'Inter',
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: darkOnSurfaceVariantColor,
          height: 1.5,
          fontFamily: 'Inter',
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: darkOnSurfaceVariantColor,
          height: 1.4,
          fontFamily: 'Inter',
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: darkOnSurfaceColor,
          fontFamily: 'Inter',
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: darkOnSurfaceVariantColor,
          fontFamily: 'Inter',
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: darkOnSurfaceVariantColor,
          fontFamily: 'Inter',
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // Helper methods for consistent spacing
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;

  // Helper methods for consistent border radius
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radiusXxl = 24.0;

  // Helper methods for consistent elevation
  static const double elevationXs = 1.0;
  static const double elevationSm = 2.0;
  static const double elevationMd = 4.0;
  static const double elevationLg = 8.0;
  static const double elevationXl = 12.0;
}
