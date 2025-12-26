import 'package:flutter/material.dart';

import 'font_manager.dart';

TextStyle _getTextStyle(
  double fontSize,
  String fontFamily,
  FontWeight fontWeight,
  Color color,
) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    fontFamily: fontFamily,
    color: color,
  );
}

TextStyle getThinStyle({double fontSize = FontSizeManager.s10, required Color color}) {
  return _getTextStyle(
    fontSize,
    FontFamilyManager.fontFamily,
    FontWeightManager.thin,
    color,
  );
}

TextStyle getLightStyle({double fontSize = FontSizeManager.s12, required Color color}) {
  return _getTextStyle(
    fontSize,
    FontFamilyManager.fontFamily,
    FontWeightManager.light,
    color,
  );
}

TextStyle getMediumStyle({double fontSize = FontSizeManager.s12, required Color color}) {
  return _getTextStyle(
    fontSize,
    FontFamilyManager.fontFamily,
    FontWeightManager.medium,
    color,
  );
}

TextStyle getRegularStyle({double fontSize = FontSizeManager.s14, required Color color}) {
  return _getTextStyle(
    fontSize,
    FontFamilyManager.fontFamily,
    FontWeightManager.regular,
    color,
  );
}

TextStyle getSemiBoldStyle({
  double fontSize = FontSizeManager.s16,
  required Color color,
}) {
  return _getTextStyle(
    fontSize,
    FontFamilyManager.fontFamily,
    FontWeightManager.semibold,
    color,
  );
}

TextStyle getBoldStyle({double fontSize = FontSizeManager.s16, required Color color}) {
  return _getTextStyle(
    fontSize,
    FontFamilyManager.fontFamily,
    FontWeightManager.bold,
    color,
  );
}
