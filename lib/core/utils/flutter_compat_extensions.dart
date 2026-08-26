import 'package:flutter/material.dart';

class TextScalerCompat {
  final double textScaleFactor;
  const TextScalerCompat(this.textScaleFactor);
  double scale(double fontSize) => fontSize * textScaleFactor;
}

extension MediaQueryDataCompat on MediaQueryData {
  TextScalerCompat get textScaler => TextScalerCompat(textScaleFactor);
}

extension MediaQueryStaticCompat on MediaQuery {
  static TextScalerCompat textScalerOf(BuildContext context) {
    return TextScalerCompat(MediaQuery.of(context).textScaleFactor);
  }
}

extension ColorCompat on Color {
  Color withValues({double? alpha, double? red, double? green, double? blue}) {
    return withOpacity(alpha ?? this.opacity);
  }
}

extension MaterialColorCompat on MaterialColor {
  Color withValues({double? alpha, double? red, double? green, double? blue}) {
    return withOpacity(alpha ?? this.opacity);
  }
}

extension ColorSchemeCompat on ColorScheme {
  Color get surfaceContainer => surfaceVariant;
  Color get surfaceContainerHigh => surfaceVariant;
  Color get surfaceContainerHighest => surfaceVariant;
  Color get surfaceContainerLow => surfaceVariant;
  Color get surfaceContainerLowest => surfaceVariant;
  Color get surfaceBright => surfaceVariant;
  Color get surfaceDim => surfaceVariant;
  Color get outlineVariant => outline.withOpacity(0.5);
}
