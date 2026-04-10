import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';
import '../theme/models/app_theme_model.dart';

class ThemeManager {
  const ThemeManager._();

  static ThemeData getApplicationLightTheme(AppThemeModel? dynamicTheme) {
    // If no dynamic theme is provided, return a default Material 3 theme instead of the old fallback.
    // This allows you to see exactly when the network theme kicks in.
    if (dynamicTheme == null) return ThemeData(useMaterial3: true, brightness: Brightness.light);
    return _buildTheme(dynamicTheme.lightTheme, Brightness.light);
  }

  static ThemeData getApplicationDarkTheme(AppThemeModel? dynamicTheme) {
    // If no dynamic theme is provided, return a default Material 3 theme instead of the old fallback.
    // This allows you to see exactly when the network theme kicks in.
    if (dynamicTheme == null) return ThemeData(useMaterial3: true, brightness: Brightness.dark);
    return _buildTheme(dynamicTheme.darkTheme, Brightness.dark);
  }

  static ThemeData _buildTheme(ThemeConfig config, Brightness brightness) {
    final colors = config.colors;
    
    // Choose base text theme
    TextTheme baseTextTheme = brightness == Brightness.light 
      ? Typography.material2021().black 
      : Typography.material2021().white;

    TextTheme textTheme;
    try {
      textTheme = GoogleFonts.getTextTheme(config.fontFamily, baseTextTheme);
    } catch (e) {
      // Fallback to Roboto if font not found
      textTheme = GoogleFonts.robotoTextTheme(baseTextTheme);
    }

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      textTheme: textTheme,
      primaryColor: colors.primary,
      scaffoldBackgroundColor: colors.background,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: colors.primary,
        onPrimary: Colors.white,
        primaryContainer: colors.primaryVariant,
        secondary: colors.secondary,
        onSecondary: Colors.white,
        surface: colors.surface,
        onSurface: colors.textPrimary,
        error: colors.error,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: config.appBar.background,
        foregroundColor: config.appBar.textColor,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: config.card.color,
        elevation: config.card.elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(config.card.borderRadius),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: config.button.background,
          foregroundColor: config.button.textColor,
          padding: EdgeInsets.symmetric(
            horizontal: config.button.paddingHorizontal,
            vertical: config.button.paddingVertical,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(config.button.borderRadius),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: config.input.fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(config.input.borderRadius),
          borderSide: BorderSide(color: config.input.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(config.input.borderRadius),
          borderSide: BorderSide(color: config.input.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(config.input.borderRadius),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
      ),
    );
  }

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    textTheme: GoogleFonts.robotoTextTheme(),
    primaryColor: AppColors.primaryLight,
    scaffoldBackgroundColor: AppColors.backgroundLight,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryLight,
      primaryContainer: AppColors.primaryLightVariant,
      secondary: AppColors.secondaryLight,
      surface: AppColors.surfaceLight,
      error: AppColors.errorLight,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textPrimaryLight,
      onError: Colors.white,
    ),

    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: AppColors.textPrimaryLight,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      color: AppColors.cardLight,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme),

    primaryColor: AppColors.primaryDark,
    scaffoldBackgroundColor: AppColors.backgroundDark,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryDark,
      primaryContainer: AppColors.primaryDarkVariant,
      secondary: AppColors.secondaryDark,
      surface: AppColors.surfaceDark,
      error: AppColors.errorDark,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textPrimaryDark,
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.backgroundDark,
      foregroundColor: AppColors.textPrimaryDark,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      color: AppColors.cardDark,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryDark, width: 2),
      ),
    ),
  );
}
