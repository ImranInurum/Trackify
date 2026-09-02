import 'package:flutter/material.dart';
import 'package:trackify/core/utils/flutter_compat_extensions.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme_extension.dart';
import '../theme/models/app_theme_model.dart';

class ThemeManager {
  const ThemeManager._();

  static ThemeData getApplicationLightTheme(AppThemeModel? dynamicTheme) {
    if (dynamicTheme == null) return ThemeData(useMaterial3: true, brightness: Brightness.light);
    return _buildTheme(dynamicTheme.lightTheme, dynamicTheme.commonColors, Brightness.light);
  }

  static ThemeData getApplicationDarkTheme(AppThemeModel? dynamicTheme) {
    if (dynamicTheme == null) return ThemeData(useMaterial3: true, brightness: Brightness.dark);
    return _buildTheme(dynamicTheme.darkTheme, dynamicTheme.commonColors, Brightness.dark);
  }

  static ThemeData _buildTheme(ThemeConfig config, CommonColors common, Brightness brightness) {
    final colors = config.colors;
    
    // Choose base text theme
    TextTheme baseTextTheme = brightness == Brightness.light 
      ? Typography.material2021().black 
      : Typography.material2021().white;

    TextTheme textTheme = GoogleFonts.robotoTextTheme(baseTextTheme);

    // Apply dynamic text colors to the theme
    textTheme = textTheme.copyWith(
      displayLarge: textTheme.displayLarge?.copyWith(color: colors.textPrimary),
      displayMedium: textTheme.displayMedium?.copyWith(color: colors.textPrimary),
      displaySmall: textTheme.displaySmall?.copyWith(color: colors.textPrimary),
      headlineLarge: textTheme.headlineLarge?.copyWith(color: colors.textPrimary),
      headlineMedium: textTheme.headlineMedium?.copyWith(color: colors.textPrimary),
      headlineSmall: textTheme.headlineSmall?.copyWith(color: colors.textPrimary),
      titleLarge: textTheme.titleLarge?.copyWith(color: colors.textPrimary),
      titleMedium: textTheme.titleMedium?.copyWith(color: colors.textPrimary),
      titleSmall: textTheme.titleSmall?.copyWith(color: colors.textPrimary),
      bodyLarge: textTheme.bodyLarge?.copyWith(color: colors.textPrimary),
      bodyMedium: textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
      bodySmall: textTheme.bodySmall?.copyWith(color: colors.textSecondary),
      labelLarge: textTheme.labelLarge?.copyWith(color: colors.textPrimary),
      labelMedium: textTheme.labelMedium?.copyWith(color: colors.textSecondary),
      labelSmall: textTheme.labelSmall?.copyWith(color: colors.textTertiary),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      textTheme: textTheme,
      primaryColor: colors.primary,
      scaffoldBackgroundColor: colors.background,
      dividerColor: colors.divider,
      shadowColor: colors.shadow ?? Colors.black.withOpacity( 0.1),
      cardColor: config.card.color,
      hintColor: colors.textTertiary,
      
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: colors.primary,
        onPrimary: colors.onPrimary,
        primaryContainer: colors.primaryVariant,
        secondary: colors.secondary,
        onSecondary: colors.onSecondary,
        surface: colors.surface,
        onSurface: colors.onSurface,
        background: colors.background,
        onBackground: colors.onSurface,
        error: colors.error,
        onError: colors.onError,
      ),
      
      dividerTheme: DividerThemeData(
        color: colors.divider,
        thickness: 1,
        space: 1,
      ),

      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: config.appBar.background,
        foregroundColor: brightness == Brightness.light ? Colors.black : Colors.white,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
          color: brightness == Brightness.light ? Colors.black : Colors.white,
        ),
      ),
      
      cardTheme: CardTheme(
        color: config.card.color,
        elevation: config.card.elevation,
        shadowColor: colors.shadow,
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
        hintStyle: TextStyle(color: colors.textTertiary),
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

      extensions: [
        AppColorsExtension(
          success: common.success,
          successDark: common.successDark,
          warning: common.warning,
          warningDark: common.warningDark,
          info: common.info,
          infoDark: common.infoDark,
          activeMarker: common.activeMarker,
          inactiveMarker: common.inactiveMarker,
          userLocation: common.userLocation,
          userBackground: common.userBackground,
        ),
      ],
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
      centerTitle: false,
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    ),
    cardTheme: CardTheme(
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
      centerTitle: false,
      elevation: 0,
      backgroundColor: AppColors.backgroundDark,
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    cardTheme: CardTheme(
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
