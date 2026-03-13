// import 'package:flutter/material.dart';
// import '../theme/app_colors.dart';
//
// class ThemeManager {
//   const ThemeManager._();
//
//   ThemeData getApplicationLightTheme() {
//     return ThemeData();
//   }
//
//   ThemeData getApplicationDarkTheme() {
//     return ThemeData();
//   }
//
//   static final lightTheme = ThemeData.light().copyWith(
//     scaffoldBackgroundColor: AppColors.backgroundLight,
//     colorScheme: ColorScheme.light(
//       primary: AppColors.primaryLight,
//       secondary: AppColors.secondaryLight,
//       surface: AppColors.backgroundLight,
//       error: AppColors.errorLight,
//     ),
//     appBarTheme: const AppBarTheme(
//       centerTitle: true,
//       elevation: 0,
//       backgroundColor: AppColors.backgroundLight,
//       foregroundColor: Colors.black,
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: AppColors.primaryLight,
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       ),
//     ),
//   );
//
//   static ThemeData darkTheme = ThemeData.dark().copyWith(
//     brightness: Brightness.dark,
//     scaffoldBackgroundColor: AppColors.backgroundDark,
//     colorScheme: ColorScheme.dark(
//       primary: AppColors.primaryDark,
//       secondary: AppColors.secondaryDark,
//       surface: AppColors.surfaceDark,
//       error: AppColors.errorDark,
//     ),
//     appBarTheme: const AppBarTheme(
//       centerTitle: true,
//       elevation: 0,
//       backgroundColor: AppColors.backgroundDark,
//       foregroundColor: Colors.white,
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: AppColors.primaryDark,
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       ),
//     ),
//   );
// }

import 'package:flutter/material.dart';
import 'app_colors.dart';
class ThemeManager {
  const ThemeManager._();
  static ThemeData getApplicationLightTheme() {
    return ThemeData(

      colorScheme: ColorScheme.light(
        primaryContainer: AppColors.secondaryLight,
        secondaryContainer: AppColors.primaryLightVariant,
        surface: AppColors.surfaceLight,
        primary: AppColors.primaryLight,
        tertiaryFixed: AppColors.textSecondaryLight,
        tertiaryFixedDim: AppColors.textPrimaryLight,
        outline: AppColors.secondaryLight,
          background: AppColors.backgroundLight
      ),
      scaffoldBackgroundColor: AppColors.surfaceLight,
      primaryColor: AppColors.primaryLight,
      cardTheme: CardThemeData(color: AppColors.surfaceLight),

    );
  }

  static ThemeData getApplicationDarkTheme() {
    return ThemeData(

      colorScheme: ColorScheme.dark(
        primaryContainer: AppColors.secondaryDark,
        secondaryContainer: AppColors.primaryDarkVariant,
        surface: AppColors.surfaceDark,
        primary: AppColors.primaryDark,
        tertiaryFixed: AppColors.textSecondaryDark,
        tertiaryFixedDim: AppColors.textPrimaryDark,
        outline: AppColors.cardDark,
          background: AppColors.backgroundDark

      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      primaryColor: AppColors.primaryDark,
      cardTheme: CardThemeData(color: AppColors.surfaceDark),
    );
  }

  static final lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppColors.backgroundLight,
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryLight,
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
      backgroundColor: AppColors.backgroundLight,
      foregroundColor: AppColors.textPrimaryLight,

    ),

    textTheme: TextTheme(
      titleMedium: TextStyle(
          color: AppColors.textPrimaryLight
      ),
    ),
    iconTheme: const IconThemeData(
      color: AppColors.secondaryLight, // soft light grey
      size: 18,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    cardTheme: CardThemeData(
      color: AppColors.cardLight,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  static ThemeData darkTheme = ThemeData.dark().copyWith(

    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryDark,
      secondary: AppColors.secondaryDark,
      surface: AppColors.surfaceDark,
      error: AppColors.errorDark,
      onPrimary: Colors.black,
      onSecondary: Colors.white,
      onSurface: AppColors.textPrimaryDark,
      onError: Colors.black,

    ),


    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.backgroundDark,
      foregroundColor: AppColors.textPrimaryDark,


    ),

    elevatedButtonTheme: ElevatedButtonThemeData(

      style: ElevatedButton.styleFrom(

        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      ),
    ),


    textTheme: const TextTheme(

      // 🔥 Labels (Buttons, chips)
      labelLarge: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.surfaceDark, // button text (as per your design)
      ),

      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimaryDark,
      ),

      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondaryDark,
      ),

      //title
      titleMedium: TextStyle(
        color: AppColors.textPrimaryDark
      )


    ),


    iconTheme: const IconThemeData(
      color: AppColors.secondaryDark, //
      size: 20,
    ),






    cardTheme: CardThemeData(
      color: AppColors.cardDark,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.backgroundDark,
      hintStyle: TextStyle(
        color: AppColors.textPrimaryDark,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: AppColors.borderDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: AppColors.borderDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: AppColors.primaryDark,
            width: 2),
      ),
    ),








  );
}
