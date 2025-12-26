// import 'package:flutter/material.dart';
//
// @immutable
// class AppColors {
//   const AppColors._();
//   static const Color primaryLight = Color(0xFF6750A4);
//   static const Color secondaryLight = Color(0xFF625B71);
//   static const Color backgroundLight = Color(0xFFFFFBFE);
//   static const Color surfaceLight = Color(0xFFFFFBFE);
//   static const Color errorLight = Color(0xFFB3261E);
//
//   static const Color primaryDark = Color(0xFFD0BCFF);
//   static const Color secondaryDark = Color(0xFFCCC2DC);
//   static const Color backgroundDark = Color(0xFF1C1B1F);
//   static const Color surfaceDark = Color(0xFF1C1B1F);
//   static const Color errorDark = Color(0xFFF2B8B5);
//
//   static const Color activeMarker = Color(0xFF4285F4);
//   static const Color inactiveMarker = Color(0xFF9E9E9E);
//   static const Color userLocation = Color(0xFF34A853);
//   static const Color userBackground = Color(0xffFFFFFF);
// }

import 'package:flutter/material.dart';

@immutable
class AppColors {
  const AppColors._();

  // Light Theme - Sage Green
  static const Color primaryLight = Color(0xFFA3C1AD);
  static const Color primaryLightVariant = Color(0xFFC5DDD0);
  static const Color secondaryLight = Color(0xFF7FA88F);
  static const Color backgroundLight = Color(0xFFF5F9F7);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFAFDFB);
  static const Color errorLight = Color(0xFFEF4444);

  // Light Theme - Text Colors
  static const Color textPrimaryLight = Color(0xFF1F1F1F);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color textTertiaryLight = Color(0xFF9CA3AF);

  // Light Theme - Borders & Dividers
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color dividerLight = Color(0xFFF3F4F6);

  // Dark Theme - Sage Green
  static const Color primaryDark = Color(0xFFA3C1AD);
  static const Color primaryDarkVariant = Color(0xFF8AAF97);
  static const Color secondaryDark = Color(0xFF7FA88F);
  static const Color backgroundDark = Color(0xFF0A0F0C);
  static const Color surfaceDark = Color(0xFF141A16);
  static const Color cardDark = Color(0xFF1C2620);
  static const Color errorDark = Color(0xFFF87171);

  // Dark Theme - Text Colors
  static const Color textPrimaryDark = Color(0xFFF9FAFB);
  static const Color textSecondaryDark = Color(0xFFD1D5DB);
  static const Color textTertiaryDark = Color(0xFF9CA3AF);

  // Dark Theme - Borders & Dividers
  static const Color borderDark = Color(0xFF374151);
  static const Color dividerDark = Color(0xFF1F2937);

  // Common Colors (Theme Independent)
  static const Color success = Color(0xFF10B981);
  static const Color successDark = Color(0xFF34D399);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningDark = Color(0xFFFBBF24);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoDark = Color(0xFF60A5FA);

  // Map Markers (keeping your existing ones)
  static const Color activeMarker = Color(0xFF4285F4);
  static const Color inactiveMarker = Color(0xFF9E9E9E);
  static const Color userLocation = Color(0xFF34A853);
  static const Color userBackground = Color(0xFFFFFFFF);
}
