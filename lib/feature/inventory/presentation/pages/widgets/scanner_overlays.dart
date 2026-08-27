import 'package:flutter/material.dart';

/// Paints a semi-transparent overlay with a clear rectangular cutout in the center.
class ScanZoneOverlayPainter extends CustomPainter {
  final double cutoutWidth;
  final double cutoutHeight;

  ScanZoneOverlayPainter({
    required this.cutoutWidth,
    required this.cutoutHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.35);

    // Full overlay
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Clear cutout in center
    final left = (size.width - cutoutWidth) / 2;
    final top = (size.height - cutoutHeight) / 2;

    final clearPaint = Paint()..blendMode = BlendMode.clear;
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, cutoutWidth, cutoutHeight),
        const Radius.circular(4),
      ),
      clearPaint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Large corner brackets forming the scan zone.
class ScanBrackets extends StatelessWidget {
  final double width;
  final double height;
  const ScanBrackets({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          // Top-Left
          Positioned(
            top: 0,
            left: 0,
            child: _corner(isTop: true, isLeft: true),
          ),
          // Top-Right
          Positioned(
            top: 0,
            right: 0,
            child: _corner(isTop: true, isLeft: false),
          ),
          // Bottom-Left
          Positioned(
            bottom: 0,
            left: 0,
            child: _corner(isTop: false, isLeft: true),
          ),
          // Bottom-Right
          Positioned(
            bottom: 0,
            right: 0,
            child: _corner(isTop: false, isLeft: false),
          ),
        ],
      ),
    );
  }

  Widget _corner({required bool isTop, required bool isLeft}) {
    const double armLength = 45;
    const double thickness = 4;
    const color = Colors.white;

    return SizedBox(
      width: armLength,
      height: armLength,
      child: Stack(
        children: [
          // Horizontal arm
          Positioned(
            top: isTop ? 0 : null,
            bottom: isTop ? null : 0,
            left: isLeft ? 0 : null,
            right: isLeft ? null : 0,
            child: Container(
              width: armLength,
              height: thickness,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Vertical arm
          Positioned(
            top: isTop ? 0 : null,
            bottom: isTop ? null : 0,
            left: isLeft ? 0 : null,
            right: isLeft ? null : 0,
            child: Container(
              width: thickness,
              height: armLength,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
