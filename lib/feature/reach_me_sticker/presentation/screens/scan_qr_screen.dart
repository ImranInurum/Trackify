import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> with SingleTickerProviderStateMixin {
  late MobileScannerController controller;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController(
      formats: const [BarcodeFormat.qrCode],
      facing: CameraFacing.back,
      detectionSpeed: DetectionSpeed.normal,
    );
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final String? code = barcodes.first.rawValue;
      if (code != null) {
        controller.stop();
        Navigator.pop(context, code);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scanAreaSize = MediaQuery.of(context).size.width * 0.65;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Scan QR Code",
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.qr_code_scanner, color: theme.colorScheme.onSurface),
              const SizedBox(width: 10),
              Text(
                "Scan QR code on the contact sticker",
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Camera
                    MobileScanner(
                      controller: controller,
                      onDetect: _onDetect,
                    ),
                    // Overlay
                    CustomPaint(
                      painter: ScannerOverlayPainter(
                        overlayColor: Colors.black.withOpacity(0.6),
                        borderColor: theme.colorScheme.onSurface.withOpacity(0.8),
                        scanAreaSize: scanAreaSize,
                      ),
                    ),
                    // Animated Line
                    Center(
                      child: SizedBox(
                        width: scanAreaSize,
                        height: scanAreaSize,
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Stack(
                              children: [
                                Positioned(
                                  top: _animationController.value * (scanAreaSize - 4),
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 3,
                                    decoration: BoxDecoration(
                                      color: Colors.cyan,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.cyan.withOpacity(0.5),
                                          blurRadius: 4,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  final Color overlayColor;
  final Color borderColor;
  final double scanAreaSize;

  ScannerOverlayPainter({
    required this.overlayColor,
    required this.borderColor,
    required this.scanAreaSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = overlayColor;
    
    // Calculate scan area
    final left = (size.width - scanAreaSize) / 2;
    final top = (size.height - scanAreaSize) / 2;
    final scanArea = Rect.fromLTWH(left, top, scanAreaSize, scanAreaSize);
    
    // Draw background with cutout
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()..addRRect(RRect.fromRectAndRadius(scanArea, const Radius.circular(0))),
      ),
      backgroundPaint,
    );

    // Draw borders (corners)
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.square;

    final cornerLength = 30.0;
    
    // Top-left
    canvas.drawLine(Offset(left, top), Offset(left + cornerLength, top), borderPaint);
    canvas.drawLine(Offset(left, top), Offset(left, top + cornerLength), borderPaint);

    // Top-right
    canvas.drawLine(Offset(left + scanAreaSize, top), Offset(left + scanAreaSize - cornerLength, top), borderPaint);
    canvas.drawLine(Offset(left + scanAreaSize, top), Offset(left + scanAreaSize, top + cornerLength), borderPaint);

    // Bottom-left
    canvas.drawLine(Offset(left, top + scanAreaSize), Offset(left + cornerLength, top + scanAreaSize), borderPaint);
    canvas.drawLine(Offset(left, top + scanAreaSize), Offset(left, top + scanAreaSize - cornerLength), borderPaint);

    // Bottom-right
    canvas.drawLine(Offset(left + scanAreaSize, top + scanAreaSize), Offset(left + scanAreaSize - cornerLength, top + scanAreaSize), borderPaint);
    canvas.drawLine(Offset(left + scanAreaSize, top + scanAreaSize), Offset(left + scanAreaSize, top + scanAreaSize - cornerLength), borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
