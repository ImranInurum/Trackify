import 'package:flutter/material.dart';

class AppThemeModel {
  final String id;
  final int themeVersion;
  final ThemeConfig lightTheme;
  final ThemeConfig darkTheme;
  final CommonColors commonColors;

  AppThemeModel({
    required this.id,
    required this.themeVersion,
    required this.lightTheme,
    required this.darkTheme,
    required this.commonColors,
  });

  factory AppThemeModel.fromJson(Map<String, dynamic> json) {
    return AppThemeModel(
      id: json['_id'] ?? '',
      themeVersion: json['theme_version'] ?? 1,
      lightTheme: ThemeConfig.fromJson(json['light_theme']),
      darkTheme: ThemeConfig.fromJson(json['dark_theme']),
      commonColors: CommonColors.fromJson(json['common_colors']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'theme_version': themeVersion,
      'light_theme': lightTheme.toJson(),
      'dark_theme': darkTheme.toJson(),
      'common_colors': commonColors.toJson(),
    };
  }
}

class ThemeConfig {
  final String fontFamily;
  final ThemeColors colors;
  final AppBarConfig appBar;
  final ButtonConfig button;
  final InputConfig input;
  final CardConfig card;

  ThemeConfig({
    required this.fontFamily,
    required this.colors,
    required this.appBar,
    required this.button,
    required this.input,
    required this.card,
  });

  factory ThemeConfig.fromJson(Map<String, dynamic> json) {
    return ThemeConfig(
      fontFamily: json['font_family'] ?? 'Roboto',
      colors: ThemeColors.fromJson(json['colors']),
      appBar: AppBarConfig.fromJson(json['app_bar']),
      button: ButtonConfig.fromJson(json['button']),
      input: InputConfig.fromJson(json['input']),
      card: CardConfig.fromJson(json['card']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'font_family': fontFamily,
      'colors': colors.toJson(),
      'app_bar': appBar.toJson(),
      'button': button.toJson(),
      'input': input.toJson(),
      'card': card.toJson(),
    };
  }
}

class ThemeColors {
  final Color primary;
  final Color primaryVariant;
  final Color secondary;
  final Color background;
  final Color surface;
  final Color card;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color border;
  final Color divider;
  final Color error;
  final Color? shadow;

  ThemeColors({
    required this.primary,
    required this.primaryVariant,
    required this.secondary,
    required this.background,
    required this.surface,
    required this.card,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.border,
    required this.divider,
    required this.error,
    this.shadow,
  });

  factory ThemeColors.fromJson(Map<String, dynamic> json) {
    return ThemeColors(
      primary: HexColor(json['primary']),
      primaryVariant: HexColor(json['primary_variant']),
      secondary: HexColor(json['secondary']),
      background: HexColor(json['background']),
      surface: HexColor(json['surface']),
      card: HexColor(json['card']),
      textPrimary: HexColor(json['text_primary']),
      textSecondary: HexColor(json['text_secondary']),
      textTertiary: HexColor(json['text_tertiary']),
      border: HexColor(json['border']),
      divider: HexColor(json['divider']),
      error: HexColor(json['error']),
      shadow: json['shadow'] != null ? HexColor(json['shadow']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'primary': primary.toHex(),
      'primary_variant': primaryVariant.toHex(),
      'secondary': secondary.toHex(),
      'background': background.toHex(),
      'surface': surface.toHex(),
      'card': card.toHex(),
      'text_primary': textPrimary.toHex(),
      'text_secondary': textSecondary.toHex(),
      'text_tertiary': textTertiary.toHex(),
      'border': border.toHex(),
      'divider': divider.toHex(),
      'error': error.toHex(),
      'shadow': shadow?.toHex(),
    };
  }
}

class AppBarConfig {
  final Color background;
  final Color textColor;

  AppBarConfig({required this.background, required this.textColor});

  factory AppBarConfig.fromJson(Map<String, dynamic> json) {
    return AppBarConfig(
      background: HexColor(json['background']),
      textColor: HexColor(json['text_color']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'background': background.toHex(),
      'text_color': textColor.toHex(),
    };
  }
}

class ButtonConfig {
  final Color background;
  final Color textColor;
  final double borderRadius;
  final double paddingHorizontal;
  final double paddingVertical;

  ButtonConfig({
    required this.background,
    required this.textColor,
    required this.borderRadius,
    required this.paddingHorizontal,
    required this.paddingVertical,
  });

  factory ButtonConfig.fromJson(Map<String, dynamic> json) {
    return ButtonConfig(
      background: HexColor(json['background']),
      textColor: HexColor(json['text_color']),
      borderRadius: (json['border_radius'] as num).toDouble(),
      paddingHorizontal: (json['padding_horizontal'] as num).toDouble(),
      paddingVertical: (json['padding_vertical'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'background': background.toHex(),
      'text_color': textColor.toHex(),
      'border_radius': borderRadius,
      'padding_horizontal': paddingHorizontal,
      'padding_vertical': paddingVertical,
    };
  }
}

class InputConfig {
  final Color fillColor;
  final Color borderColor;
  final Color focusedBorderColor;
  final double borderRadius;

  InputConfig({
    required this.fillColor,
    required this.borderColor,
    required this.focusedBorderColor,
    required this.borderRadius,
  });

  factory InputConfig.fromJson(Map<String, dynamic> json) {
    return InputConfig(
      fillColor: HexColor(json['fill_color']),
      borderColor: HexColor(json['border_color']),
      focusedBorderColor: HexColor(json['focused_border_color']),
      borderRadius: (json['border_radius'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fill_color': fillColor.toHex(),
      'border_color': borderColor.toHex(),
      'focused_border_color': focusedBorderColor.toHex(),
      'border_radius': borderRadius,
    };
  }
}

class CardConfig {
  final Color color;
  final double elevation;
  final double borderRadius;

  CardConfig({
    required this.color,
    required this.elevation,
    required this.borderRadius,
  });

  factory CardConfig.fromJson(Map<String, dynamic> json) {
    return CardConfig(
      color: HexColor(json['color']),
      elevation: (json['elevation'] as num).toDouble(),
      borderRadius: (json['border_radius'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'color': color.toHex(),
      'elevation': elevation,
      'border_radius': borderRadius,
    };
  }
}

class CommonColors {
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

  CommonColors({
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

  factory CommonColors.fromJson(Map<String, dynamic> json) {
    return CommonColors(
      success: HexColor(json['success']),
      successDark: HexColor(json['success_dark']),
      warning: HexColor(json['warning']),
      warningDark: HexColor(json['warning_dark']),
      info: HexColor(json['info']),
      infoDark: HexColor(json['info_dark']),
      activeMarker: HexColor(json['active_marker']),
      inactiveMarker: HexColor(json['inactive_marker']),
      userLocation: HexColor(json['user_location']),
      userBackground: HexColor(json['user_background']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success.toHex(),
      'success_dark': successDark.toHex(),
      'warning': warning.toHex(),
      'warning_dark': warningDark.toHex(),
      'info': info.toHex(),
      'info_dark': infoDark.toHex(),
      'active_marker': activeMarker.toHex(),
      'inactive_marker': inactiveMarker.toHex(),
      'user_location': userLocation.toHex(),
      'user_background': userBackground.toHex(),
    };
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

extension ColorToHex on Color {
  String toHex() {
    return '#${(value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }
}
