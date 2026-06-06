import 'package:flutter/material.dart';

class AppTheme {
  // Dark Color Palette
  static const Color bgDark = Color(0xFF0D0D0D);
  static const Color surfaceDark = Color(0xFF161616);
  static const Color borderDark = Color(0xFF262626);
  
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA3A3A3);
  static const Color textMuted = Color(0xFF525252);

  // Light Color Palette
  static const Color bgLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFE2E8F0);
  
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF475569);
  static const Color textMutedLight = Color(0xFF94A3B8);
  
  // Shared Brand Colors
  static const Color primary = Color(0xFF5B4FE8);
  static const Color primaryLight = Color(0xFF7C72F2);
  static const Color primaryGlow = Color(0x265B4FE8); // 15% opacity
  
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryLight, primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFBBF24), Color(0xFFD97706)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient privacyGradient = LinearGradient(
    colors: [Color(0xFF059669), Color(0xFF0D9488)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Dynamic Theme Helpers
  static Color getBackgroundColor(bool isDark) => isDark ? bgDark : bgLight;
  static Color getSurfaceColor(bool isDark) => isDark ? surfaceDark : surfaceLight;
  static Color getBorderColor(bool isDark) => isDark ? borderDark : borderLight;
  static Color getTextPrimary(bool isDark) => isDark ? textPrimary : textPrimaryLight;
  static Color getTextSecondary(bool isDark) => isDark ? textSecondary : textSecondaryLight;
  static Color getTextMuted(bool isDark) => isDark ? textMuted : textMutedLight;

  // Custom Glassmorphic Card decoration based on active theme
  static BoxDecoration glassCard([bool isDark = true, Color? borderOverride]) {
    return BoxDecoration(
      color: isDark ? surfaceDark.withOpacity(0.85) : surfaceLight,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: borderOverride ?? (isDark ? borderDark : borderLight),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(isDark ? 0.4 : 0.05),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // Material Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primary,
      scaffoldBackgroundColor: bgDark,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: primaryLight,
        background: bgDark,
        surface: surfaceDark,
        error: danger,
        onPrimary: Colors.white,
        onBackground: textPrimary,
        onSurface: textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      fontFamily: 'Inter',
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryLight,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: bgDark,
        selectedItemColor: primaryLight,
        unselectedItemColor: textSecondary,
        elevation: 10,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  // Material Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: bgLight,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: primaryLight,
        background: bgLight,
        surface: surfaceLight,
        error: danger,
        onPrimary: Colors.white,
        onBackground: textPrimaryLight,
        onSurface: textPrimaryLight,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgLight,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textPrimaryLight,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: textPrimaryLight),
      ),
      fontFamily: 'Inter',
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: bgLight,
        selectedItemColor: primary,
        unselectedItemColor: textSecondaryLight,
        elevation: 10,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
