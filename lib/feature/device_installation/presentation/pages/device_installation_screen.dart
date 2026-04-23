import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../../../core/widgets/square_flat_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/device_installation_cubit.dart';
import '../cubit/device_installation_state.dart';
import 'widgets/manual_entry_dialog.dart';

class DeviceInstallationScreen extends StatefulWidget {
  final String? vehicleId;
  const DeviceInstallationScreen({super.key, this.vehicleId});

  @override
  State<DeviceInstallationScreen> createState() =>
      _DeviceInstallationScreenState();
}

class _DeviceInstallationScreenState extends State<DeviceInstallationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _scannerLineController;
  final MobileScannerController _cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );

  bool _hasScanned = false;
  String? _scannedImei;

  @override
  void initState() {
    super.initState();
    _scannerLineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scannerLineController.dispose();
    _cameraController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_hasScanned) return;

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final String? rawValue = barcode.rawValue;
      if (rawValue != null && rawValue.isNotEmpty) {
        final imei = rawValue.trim();
        setState(() {
          _hasScanned = true;
          _scannedImei = imei;
        });
        _cameraController.stop();
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>();

    return BlocListener<DeviceInstallationCubit, DeviceInstallationState>(
      listener: (context, state) {
        if (state is DeviceInstallationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.deviceAssignedSuccess),
              backgroundColor: appColors?.success ?? Colors.green,
            ),
          );
          Navigator.pop(context);
        } else if (state is DeviceInstallationFailure) {
          setState(() {
            _hasScanned = false;
            _scannedImei = null;
          });
          _cameraController.start();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.exception.message),
              backgroundColor: theme.colorScheme.error,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.appBarTheme.backgroundColor,
          elevation: 0,
          centerTitle: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            l10n.deviceInstallation,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.more_vert, color: theme.colorScheme.onSurface),
              onPressed: () {},
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 32),

                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.qr_code_scanner,
                            color: theme.colorScheme.onSurface,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            l10n.scanActivationCode,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Camera Preview — dynamic sizing
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final availableWidth = constraints.maxWidth;
                            final scanSize = availableWidth * 0.7;

                            return AspectRatio(
                              aspectRatio: 1.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Stack(
                                  children: [
                                    // Live camera feed
                                    Positioned.fill(
                                      child: MobileScanner(
                                        controller: _cameraController,
                                        onDetect: _onDetect,
                                      ),
                                    ),

                                    // Semi-transparent overlay outside scan zone
                                    CustomPaint(
                                      size: Size.infinite,
                                      painter: _ScanZoneOverlayPainter(
                                        cutoutWidth: scanSize,
                                        cutoutHeight: scanSize,
                                      ),
                                    ),

                                    // Corner brackets (centered scan zone)
                                    Center(
                                      child: _ScanBrackets(
                                        width: scanSize,
                                        height: scanSize,
                                      ),
                                    ),

                                    // Animated scanning line inside bracket zone
                                    Center(
                                      child: SizedBox(
                                        width: scanSize,
                                        height: scanSize,
                                        child: AnimatedBuilder(
                                          animation: _scannerLineController,
                                          builder: (context, child) {
                                            return Stack(
                                              children: [
                                                Positioned(
                                                  top:
                                                      _scannerLineController
                                                          .value *
                                                      (scanSize - 4),
                                                  left: 8,
                                                  right: 8,
                                                  child: Container(
                                                    height: 3,
                                                    decoration: BoxDecoration(
                                                      color: theme.colorScheme.secondary,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            2,
                                                          ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: theme.colorScheme.secondary.withOpacity(0.6),
                                                          blurRadius: 12,
                                                          spreadRadius: 3,
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

                                    // Loading overlay
                                    BlocBuilder<DeviceInstallationCubit,
                                        DeviceInstallationState>(
                                      builder: (context, state) {
                                        if (state is DeviceInstallationLoading) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: theme.colorScheme.surface
                                                  .withValues(alpha: 0.8),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Center(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const CircularProgressIndicator(
                                                    color: Colors.white,
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Text(
                                                    l10n.assigningDevice,
                                                    style: theme
                                                        .textTheme.bodyMedium
                                                        ?.copyWith(
                                                      color: theme.colorScheme.onSurface
                                                          .withValues(
                                                              alpha: 0.7),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Manual Enter Link — left aligned
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () => _showManualEntryDialog(context),
                            child: Text(
                              l10n.enterActivationCodeManually,
                              style: TextStyle(
                                color: theme.colorScheme.secondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Footer
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.openAjjasBoxInstruction,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.54),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CommonButton(
                      text: l10n.continueText,
                      backgroundColor: theme.colorScheme.secondary,
                      disabledBackgroundColor: theme.hintColor.withOpacity(0.3),
                      disabledForegroundColor: Colors.white54,
                      foregroundColor: theme.colorScheme.onSecondary,
                      borderRadius: 8,
                      onPressed: _scannedImei != null
                          ? () {
                              context
                                  .read<DeviceInstallationCubit>()
                                  .assignDevice(
                                    vehicleId: widget.vehicleId ?? '',
                                    imei: _scannedImei!,
                                  );
                            }
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showManualEntryDialog(BuildContext context) {
    showDialog(
      context: context,
      useRootNavigator: false,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<DeviceInstallationCubit>(),
        child: ManualEntryDialog(vehicleId: widget.vehicleId ?? ''),
      ),
    );
  }
}

/// Paints a semi-transparent overlay with a clear rectangular cutout in the center.
class _ScanZoneOverlayPainter extends CustomPainter {
  final double cutoutWidth;
  final double cutoutHeight;

  _ScanZoneOverlayPainter({
    required this.cutoutWidth,
    required this.cutoutHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withValues(alpha: 0.35);

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
class _ScanBrackets extends StatelessWidget {
  final double width;
  final double height;
  const _ScanBrackets({required this.width, required this.height});

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
