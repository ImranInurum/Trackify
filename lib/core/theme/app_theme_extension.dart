import 'package:flutter/material.dart';

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color success;
  final Color successDark;
  final Color warning;
  final Color warningDark;
  final Color info;
  final Color infoDark;
  final Color activeMarker;
  final Color inactiveMarker;
  final Color userLocation;
  final Color userBackground;

  AppColorsExtension({
    required this.success,
    required this.successDark,
    required this.warning,
    required this.warningDark,
    required this.info,
    required this.infoDark,
    required this.activeMarker,
    required this.inactiveMarker,
    required this.userLocation,
    required this.userBackground,
  });

  @override
  AppColorsExtension copyWith({
    Color? success,
    Color? successDark,
    Color? warning,
    Color? warningDark,
    Color? info,
    Color? infoDark,
    Color? activeMarker,
    Color? inactiveMarker,
    Color? userLocation,
    Color? userBackground,
  }) {
    return AppColorsExtension(
      success: success ?? this.success,
      successDark: successDark ?? this.successDark,
      warning: warning ?? this.warning,
      warningDark: warningDark ?? this.warningDark,
      info: info ?? this.info,
      infoDark: infoDark ?? this.infoDark,
      activeMarker: activeMarker ?? this.activeMarker,
      inactiveMarker: inactiveMarker ?? this.inactiveMarker,
      userLocation: userLocation ?? this.userLocation,
      userBackground: userBackground ?? this.userBackground,
    );
  }

  @override
  AppColorsExtension lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) {
      return this;
    }
    return AppColorsExtension(
      success: Color.lerp(success, other.success, t)!,
      successDark: Color.lerp(successDark, other.successDark, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningDark: Color.lerp(warningDark, other.warningDark, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoDark: Color.lerp(infoDark, other.infoDark, t)!,
      activeMarker: Color.lerp(activeMarker, other.activeMarker, t)!,
      inactiveMarker: Color.lerp(inactiveMarker, other.inactiveMarker, t)!,
      userLocation: Color.lerp(userLocation, other.userLocation, t)!,
      userBackground: Color.lerp(userBackground, other.userBackground, t)!,
    );
  }
}
