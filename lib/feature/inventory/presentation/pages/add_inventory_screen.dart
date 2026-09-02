import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../../../core/widgets/square_flat_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/inventory_cubit.dart';
import '../cubit/inventory_state.dart';
import '../../../../feature/auth/presentation/pages/signin_screen.dart';
import '../../../../feature/device_installation/presentation/pages/widgets/manual_entry_dialog.dart';
import 'widgets/scanner_overlays.dart';

class AddInventoryScreen extends StatefulWidget {
  const AddInventoryScreen({super.key});

  @override
  State<AddInventoryScreen> createState() => _AddInventoryScreenState();
}

class _AddInventoryScreenState extends State<AddInventoryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _scannerLineController;
  final MobileScannerController _cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );

  bool _hasScanned = false;
  bool _isSuccess = false;
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

  void _onDetect(BarcodeCapture capture) async {
    if (_hasScanned) return;

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final String? rawValue = barcode.rawValue;
      if (rawValue != null && rawValue.isNotEmpty) {
        _cameraController.stop();

        setState(() {
          _hasScanned = true;
          _isSuccess = false;
          _scannedImei = rawValue.trim();
        });
        _handleContinue();
        break;
      }
    }
  }

  void _handleContinue() {
    if (_scannedImei == null) return;
    context.read<InventoryCubit>().addInventory(_scannedImei!, "abc"); // default model_no
  }

  void _logout() {
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const SignInScreen()),
      (route) => false,
    );
  }

  void _showManualEntryDialog(BuildContext context) async {
    final imei = await showDialog<String>(
      context: context,
      useRootNavigator: false,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity( 0.8),
      builder: (dialogContext) => const ManualEntryDialog(vehicleId: ''),
    );

    if (imei != null && imei.isNotEmpty) {
      if (!mounted) return;

      setState(() {
        _hasScanned = true;
        _isSuccess = false;
        _scannedImei = imei;
      });
      _cameraController.stop();
      _handleContinue();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>();

    return BlocListener<InventoryCubit, InventoryState>(
      listener: (context, state) {
        if (state is InventorySuccess) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: Offset(0.0, 10.0),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: (appColors?.success ?? Colors.green).withOpacity( 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_circle_rounded,
                          color: appColors?.success ?? Colors.green,
                          size: 64,
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      Text(
                        'Success!',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity( 0.7),
                        ),
                      ),
                      const SizedBox(height: 32.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appColors?.success ?? Colors.green,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'OK',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
          // Mark as success and leave scanner paused until user taps 'Scan Next'
          setState(() {
            _isSuccess = true;
          });
        } else if (state is InventoryFailure) {
          setState(() {
            _hasScanned = false;
            _scannedImei = null;
          });
          _cameraController.start();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: Offset(0.0, 10.0),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error.withOpacity( 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.error_outline_rounded,
                          color: theme.colorScheme.error,
                          size: 64,
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      Text(
                        'Error',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity( 0.7),
                        ),
                      ),
                      const SizedBox(height: 32.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.error,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'OK',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          centerTitle: false,
          leading: const SizedBox.shrink(),
          title: const Text('Add Inventory'),
          actions: [
            IconButton(
              icon: Icon(Icons.logout, color: theme.colorScheme.onSurface),
              onPressed: _logout,
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
                            'Scan Barcode / QR Code',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
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
                                    Positioned.fill(
                                      child: MobileScanner(
                                        controller: _cameraController,
                                        onDetect: _onDetect,
                                      ),
                                    ),
                                    // Semi-transparent overlay outside scan zone
                                    CustomPaint(
                                      size: Size.infinite,
                                      painter: ScanZoneOverlayPainter(
                                        cutoutWidth: scanSize,
                                        cutoutHeight: scanSize,
                                      ),
                                    ),
                                    // Corner brackets (centered scan zone)
                                    Center(
                                      child: ScanBrackets(
                                        width: scanSize,
                                        height: scanSize,
                                      ),
                                    ),
                                    if (!_hasScanned)
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
                                                    top: _scannerLineController.value * (scanSize - 4),
                                                    left: 8,
                                                    right: 8,
                                                    child: Container(
                                                      height: 3,
                                                      decoration: BoxDecoration(
                                                        color: theme.colorScheme.secondary,
                                                        borderRadius: BorderRadius.circular(2),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: theme.colorScheme.secondary.withOpacity( 0.6),
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
                                    if (_hasScanned && _isSuccess && _scannedImei != null)
                                      Container(
                                        color: Colors.black54,
                                        child: Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                  color: Colors.green.withOpacity( 0.2),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.check_circle_rounded,
                                                  color: Colors.green,
                                                  size: 56,
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                decoration: BoxDecoration(
                                                  color: Colors.white.withOpacity( 0.1),
                                                  borderRadius: BorderRadius.circular(20),
                                                  border: Border.all(color: Colors.white24),
                                                ),
                                                child: Text(
                                                  _scannedImei!,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    letterSpacing: 1.2,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    BlocBuilder<InventoryCubit, InventoryState>(
                                      builder: (context, state) {
                                        if (state is InventoryLoading) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: theme.colorScheme.surface.withOpacity( 0.8),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Center(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const CircularProgressIndicator(color: Colors.white),
                                                  const SizedBox(height: 12),
                                                  Text(
                                                    'Adding Inventory...',
                                                    style: theme.textTheme.bodyMedium?.copyWith(
                                                      color: theme.colorScheme.onSurface.withOpacity( 0.7),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () => _showManualEntryDialog(context),
                            child: Text(
                              'Enter activation code manually',
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
              Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 20.0, bottom: 48.0),
                child: CommonButton(
                  text: 'Scan Next',
                  backgroundColor: theme.colorScheme.secondary,
                  disabledBackgroundColor: theme.hintColor.withOpacity( 0.3),
                  disabledForegroundColor: Colors.white54,
                  foregroundColor: theme.colorScheme.onSecondary,
                  borderRadius: 8,
                  onPressed: _isSuccess ? () {
                    setState(() {
                      _hasScanned = false;
                      _isSuccess = false;
                      _scannedImei = null;
                    });
                    _cameraController.start();
                  } : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
