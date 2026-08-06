import 'dart:ui' as ui;
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

  static Future<BitmapDescriptor> createGeoFenceMarkerIcon(IconData iconData, Color color) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    const double width = 60.0;
    const double height = 80.0; // Taller to accommodate the pin tip
    const double radius = width / 2;

    // Draw the pin (teardrop) shape
    final Path pinPath = Path();
    pinPath.moveTo(radius, height); // Bottom tip
    pinPath.quadraticBezierTo(0, height * 0.65, 0, radius); // Left curve
    pinPath.arcToPoint(
      const Offset(width, radius),
      radius: const Radius.circular(radius),
      clockwise: true,
    ); // Top semi-circle
    pinPath.quadraticBezierTo(width, height * 0.65, radius, height); // Right curve
    pinPath.close();

    final Paint pinPaint = Paint()..color = color;
    canvas.drawPath(pinPath, pinPaint);

    // Draw a white circle inside the pin
    final Paint innerCirclePaint = Paint()..color = Colors.white;
    const double innerRadius = radius * 0.75;
    canvas.drawCircle(const Offset(radius, radius), innerRadius, innerCirclePaint);

    // Draw the icon inside the white circle
    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    textPainter.text = TextSpan(
      text: String.fromCharCode(iconData.codePoint),
      style: TextStyle(
        fontSize: innerRadius * 1.4, // Scale icon to fit inside inner circle
        fontFamily: iconData.fontFamily,
        package: iconData.fontPackage,
        color: color, // Use the primary color for the icon
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        radius - textPainter.width / 2,
        radius - textPainter.height / 2,
      ),
    );

    final ui.Image img = await pictureRecorder.endRecording().toImage(width.toInt(), height.toInt());
    final ByteData? data = await img.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }
}
