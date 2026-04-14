import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapUtils {
  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(
      format: ui.ImageByteFormat.png,
    ))!.buffer.asUint8List();
  }

  static Future<void> applyMapTheme({
    required GoogleMapController controller,
    required ThemeMode themeMode,
    String? lightStyle,
    String? darkStyle,
    required BuildContext context,
  }) async {
    if (themeMode == ThemeMode.dark) {
      await setStyle(controller, darkStyle);
    } else if (themeMode == ThemeMode.light) {
      await setStyle(controller, lightStyle);
    } else {
      // Default to dark mode unless explicitly set to light
      await setStyle(controller, darkStyle);
    }
  }

  static Future<void> setStyle(GoogleMapController controller, String? styleJson) async {
    await controller.setMapStyle(styleJson);
  }

  static Future<String?> loadStyle(String path) async {
    try {
      return await rootBundle.loadString(path);
    } catch (e) {
      debugPrint("Error loading map style: $e");
      return null;
    }
  }
}
