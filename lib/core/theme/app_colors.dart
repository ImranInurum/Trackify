// import 'package:flutter/material.dart';
//
// @immutable
// class AppColors {
//   const AppColors._();
//
//   // Light Theme - Sage Green
//   static const Color primaryLight = Color(0xFFA3C1AD);
//   static const Color primaryLightVariant = Color(0xFFC5DDD0);
//   static const Color secondaryLight = Color(0xFF7FA88F);
//   static const Color backgroundLight = Color(0xFFF5F9F7);
//   static const Color surfaceLight = Color(0xFFFFFFFF);
//   static const Color cardLight = Color(0xFFFAFDFB);
//   static const Color errorLight = Color(0xFFEF4444);
//
//   // Light Theme - Text Colors
//   static const Color textPrimaryLight = Color(0xFF1F1F1F);
//   static const Color textSecondaryLight = Color(0xFF6B7280);
//   static const Color textTertiaryLight = Color(0xFF9CA3AF);
//
//   // Light Theme - Borders & Dividers
//   static const Color borderLight = Color(0xFFE5E7EB);
//   static const Color dividerLight = Color(0xFFF3F4F6);
//
//   // Dark Theme - Sage Green
//   static const Color primaryDark = Color(0xFFA3C1AD);
//   static const Color primaryDarkVariant = Color(0xFF8AAF97);
//   static const Color secondaryDark = Color(0xFF7FA88F);
//   static const Color backgroundDark = Color(0xFF0A0F0C);
//   static const Color surfaceDark = Color(0xFF141A16);
//   static const Color cardDark = Color(0xFF1C2620);
//   static const Color errorDark = Color(0xFFF87171);
//
//   // Dark Theme - Text Colors
//   static const Color textPrimaryDark = Color(0xFFF9FAFB);
//   static const Color textSecondaryDark = Color(0xFFD1D5DB);
//   static const Color textTertiaryDark = Color(0xFF9CA3AF);
//
//   // Dark Theme - Borders & Dividers
//   static const Color borderDark = Color(0xFF374151);
//   static const Color dividerDark = Color(0xFF1F2937);
//
//   // Common Colors (Theme Independent)
//   static const Color success = Color(0xFF10B981);
//   static const Color successDark = Color(0xFF34D399);
//   static const Color warning = Color(0xFFF59E0B);
//   static const Color warningDark = Color(0xFFFBBF24);
//   static const Color info = Color(0xFF3B82F6);
//   static const Color infoDark = Color(0xFF60A5FA);
//
//   // Map Markers (keeping your existing ones)
//   static const Color activeMarker = Color(0xFF4285F4);
//   static const Color inactiveMarker = Color(0xFF9E9E9E);
//   static const Color userLocation = Color(0xFF34A853);
//   static const Color userBackground = Color(0xFFFFFFFF);
// }

import 'package:flutter/material.dart';

@immutable
class AppColors {
  const AppColors._();

  // Light Theme - Palette Matched (Image 1 & 2)
  static const Color primaryLight = Color(0xFF52ACCC); // Teal-Blue (Last bar in palette)
  // static const Color primaryLightVariant = Color(0xFFE3E8F3); // Pale Blue-Grey (5th bar)
  static const Color primaryLightVariant = Color(0xFFD7E3F3); // Pale Blue-Grey (5th bar)
  static const Color secondaryLight = Color(0xFF1CA5D4); // Bright Blue (3rd bar)
  static const Color backgroundLight = Color(0xFFF7F8FA); // Near-white
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color errorLight = Color(0xFFD22321); // Red (1st bar)
  static const Color shadowColor = Color(0xFFDCE5EC); // Red (1st bar)

  // Light Theme - Text Colors
  static const Color textPrimaryLight = Color(0xFF1F1F1F);
  static const Color textSecondaryLight = Color(0xFF535A63); // Dark Grey (7th bar)
  static const Color textTertiaryLight = Color(0xFF9CA3AF);

  // Light Theme - Borders & Dividers
  static const Color borderLight = Color(0xFFE8EDF2);
  static const Color dividerLight = Color(0xFFF3F5F7);

  // Specific Palette Colors for reference
  static const Color paletteGreen = Color(0xFF6FB06A); // 4th bar
  static const Color paletteTan = Color(0xFFDBBE8F); // 6th bar
  static const Color paletteCyan = Color(0xFFB6F3F7); // 8th bar
  static const Color paletteDarkRed = Color(0xFFC7514D); // 2nd bar

  // Dark Theme
  static const Color primaryDark = Color(0xFF8EBED0);
  static const Color primaryDarkVariant = Color(0xFF3A9AB8);
  static const Color secondaryDark = Color(0xFF2D7A94);
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

  // Common Colors
  static const Color success = Color(0xFF6FB06A);
  static const Color successDark = Color(0xFF34D399);
  static const Color warning = Color(0xFFDBBE8F);
  static const Color warningDark = Color(0xFFFBBF24);
  static const Color info = Color(0xFF1CA5D4);
  static const Color infoDark = Color(0xFF60A5FA);

  // Map Markers
  static const Color activeMarker = Color(0xFF4285F4);
  static const Color inactiveMarker = Color(0xFF9E9E9E);
  static const Color userLocation = Color(0xFF34A853);
  static const Color userBackground = Color(0xFFFFFFFF);

  // Device Warranty Screen
  static const Color warrantyCardStart = Color(0xFF1CA5D4); // brand cyan-blue
  static const Color warrantyCardEnd   = Color(0xFF0D6B8C); // deep teal
  static const Color warrantyTileDark  = Color(0xFF1C2620); // reuse cardDark
  static const Color warrantyButtonStart = Color(0xFFDBBE8F); // paletteTan
  static const Color warrantyButtonEnd   = Color(0xFFF5D9A8); // lighter tan
}
