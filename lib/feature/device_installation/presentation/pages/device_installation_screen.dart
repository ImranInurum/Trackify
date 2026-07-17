import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/feature/add_vehicle_and_device/add_vehicle/data/repository/add_vehicle_repository_impl.dart';
import 'package:trackify/feature/add_vehicle_and_device/add_vehicle/domain/use_case/add_vehicle_use_case.dart';
import 'package:trackify/feature/add_vehicle_and_device/add_vehicle/presentation/cubit/add_vehicle_cubit.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../../../core/widgets/square_flat_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/device_installation_cubit.dart';
import '../cubit/device_installation_state.dart';
import 'widgets/manual_entry_dialog.dart';
import 'widgets/add_vehicle_dialog.dart';
import 'widgets/personal_details_dialog.dart';
import '../../../../feature/profile/presentation/cubit/profile_cubit.dart';
import '../../../../feature/profile/presentation/cubit/profile_state.dart';
import '../../../../app/cubit/app_cubit.dart';
import '../../../../app/app_navigation.dart';
import '../../../../feature/map/presentation/cubit/map_cubit.dart';
import '../../../../core/utils/shared_preferences.dart';
import '../../../../core/common/models/vehicle_list_model.dart';

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
    formats: const [
      BarcodeFormat.qrCode,
      BarcodeFormat.code128,
      BarcodeFormat.code39,
      BarcodeFormat.code93,
      BarcodeFormat.ean13,
      BarcodeFormat.ean8,
      BarcodeFormat.itf,
      BarcodeFormat.upcA,
      BarcodeFormat.upcE,
      BarcodeFormat.dataMatrix,
      BarcodeFormat.pdf417,
    ],
  );

  bool _hasScanned = false;
  String? _scannedImei;

  late FlutterTts _tts;
  String _ttsLanguage = 'en-US';

  @override
  void initState() {
    super.initState();
    _initTts();
    _scannerLineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  Future<void> _initTts() async {
    _tts = FlutterTts();
    // Add a small delay to allow native TTS engine to initialize
    await Future.delayed(const Duration(milliseconds: 1000));
    _speakInstruction();
  }

  void _speakInstruction() async {
    try {
      debugPrint("Starting TTS speak in $_ttsLanguage");
      await _tts.setVolume(1.0);
      await _tts.setSpeechRate(0.5); // Adjusted for flutter_tts

      await _tts.setLanguage(_ttsLanguage);

      String textToSpeak =
          "Please scan the activation code given on the trackify box";
      switch (_ttsLanguage) {
        case 'hi-IN':
          textToSpeak =
              "Trackify box par diye gaye activation code ko scan karein";
          break;
        case 'mr-IN':
          textToSpeak = "ट्रॅकीफाय बॉक्सवर दिलेला ॲक्टिव्हेशन कोड स्कॅन करा";
          break;
        case 'ta-IN':
          textToSpeak =
              "ட்ராக்கிஃபை பாக்ஸில் கொடுக்கப்பட்டுள்ள ஆக்டிவேஷன் கோடை ஸ்கேன் செய்யவும்";
          break;
        case 'kn-IN':
          textToSpeak =
              "ಟ್ರಾಕಿಫೈ ಬಾಕ್ಸ್‌ನಲ್ಲಿ ನೀಡಲಾದ ಆಕ್ಟಿವೇಶನ್ ಕೋಡ್ ಅನ್ನು ಸ್ಕ್ಯಾನ್ ಮಾಡಿ";
          break;
        case 'en-US':
        default:
          textToSpeak =
              "Please scan the activation code given on the trackify box";
      }

      await _tts.speak(textToSpeak);
    } catch (e) {
      debugPrint("TTS Error: $e");
    }
  }

  PopupMenuItem<String> _buildLanguageMenuItem(
    String value,
    String title,
    ThemeData theme,
  ) {
    final isSelected = _ttsLanguage == value;
    return PopupMenuItem<String>(
      value: value,
      padding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: isSelected ? Colors.cyan.withOpacity(0.3) : Colors.transparent,
        child: Text(
          title,
          style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 14),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tts.stop();
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
          _scannedImei = rawValue.trim();
        });
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
          context.read<MapCubit>().reset();
          Future.wait([
            context.read<ProfileCubit>().fetchVehicles(),
            context.read<MapCubit>().fetchVehicles(),
          ]).then((_) {
            if (context.mounted) {
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const AppNavigation()),
                (route) => false,
              );
            }
          });
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
        } else if (state is DeviceInstallationImeiAlreadyAssigned) {
          setState(() {
            _hasScanned = false;
            _scannedImei = null;
          });
          _cameraController.start();
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (ctx) => AlertDialog(
              backgroundColor: theme.scaffoldBackgroundColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                  const SizedBox(width: 8),
                  Text(
                    'Device Already Installed',
                    style: TextStyle(color: theme.colorScheme.onSurface),
                  ),
                ],
              ),
              content: Text(
                'This device/IMEI is already assigned to a vehicle. '
                'Please contact support if you need to replace or reassign a device.',
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(
                    'OK',
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                ),
              ],
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          centerTitle: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            l10n.deviceInstallation,
            style: TextStyle(
              fontSize: 18,
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            Theme(
              data: Theme.of(context).copyWith(
                popupMenuTheme: PopupMenuThemeData(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              child: PopupMenuButton<String>(
                icon: Icon(Icons.translate, color: theme.colorScheme.onSurface),
                offset: const Offset(0, 40),
                onSelected: (String result) {
                  if (result == 'switch_vehicle') {
                    // Logic for switch vehicle
                  } else {
                    setState(() {
                      _ttsLanguage = result;
                      _speakInstruction();
                    });
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    enabled: false,
                    height: 36,
                    child: Text(
                      'Select audio language',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  _buildLanguageMenuItem('en-US', 'English', theme),
                  _buildLanguageMenuItem('hi-IN', 'हिंदी', theme),
                  _buildLanguageMenuItem('mr-IN', 'मराठी', theme),
                  _buildLanguageMenuItem('ta-IN', 'தமிழ்', theme),
                  _buildLanguageMenuItem('kn-IN', 'ಕನ್ನಡ', theme),
                  // const PopupMenuDivider(),
                  // PopupMenuItem<String>(
                  //   value: 'switch_vehicle',
                  //   height: 48,
                  //   child: Text(
                  //     'Switch Vehicle',
                  //     style: TextStyle(
                  //       fontWeight: FontWeight.bold,
                  //       color: theme.colorScheme.onSurface,
                  //       fontSize: 14,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
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
                                                    top:
                                                        _scannerLineController
                                                            .value *
                                                        (scanSize - 4),
                                                    left: 8,
                                                    right: 8,
                                                    child: Container(
                                                      height: 3,
                                                      decoration: BoxDecoration(
                                                        color: theme
                                                            .colorScheme
                                                            .secondary,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              2,
                                                            ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: theme
                                                                .colorScheme
                                                                .secondary
                                                                .withOpacity(0.6),
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

                                    // Success overlay after scanning
                                    if (_hasScanned && _scannedImei != null)
                                      Container(
                                        color: Colors.black54, // Darken the grey camera feed
                                        child: Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                  color: Colors.green.withValues(alpha: 0.2),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 56),
                                              ),
                                              const SizedBox(height: 16),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                decoration: BoxDecoration(
                                                  color: Colors.white.withValues(alpha: 0.1),
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

                                    // Loading overlay
                                    BlocBuilder<
                                      DeviceInstallationCubit,
                                      DeviceInstallationState
                                    >(
                                      builder: (context, state) {
                                        if (state
                                            is DeviceInstallationLoading) {
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
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                          color: theme
                                                              .colorScheme
                                                              .onSurface
                                                              .withValues(
                                                                alpha: 0.7,
                                                              ),
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
                      l10n.openTrackifyBoxInstruction,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.54,
                        ),
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
                      onPressed: _scannedImei != null ? _handleContinue : null,
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

  Future<void> _handleContinue() async {
    if (_scannedImei == null) return;
    final targetImei = _scannedImei!;

    if (!mounted) return;
    
    // First, verify the IMEI is not already assigned
    final isFree = await context.read<DeviceInstallationCubit>().checkImeiOnly(targetImei);
    if (!isFree) return; // Flow stops here if assigned, cubit emits AlreadyAssigned state

    if (!mounted) return;
    // Fetch fresh vehicles to ensure we don't use stale cached data from a previous user
    await context.read<ProfileCubit>().fetchVehicles();

    if (!mounted) return;
    final profileState = context.read<ProfileCubit>().state;
    final appState = context.read<AppCubit>().state;
    final currentUserId = appState.userData?.id;

    bool hasVehicle = false;
    if (profileState is VehiclesLoaded && profileState.vehicles.isNotEmpty) {
      // Ensure the cached vehicles belong to the current user
      final firstVehicleUserId = profileState.vehicles.first.userId;
      if (currentUserId == null ||
          firstVehicleUserId == null ||
          firstVehicleUserId == currentUserId) {
        hasVehicle = true;
      }
    }

    if (!hasVehicle) {
      final added = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => BlocProvider(
          create: (context) =>
              AddVehicleCubit(AddVehicleUseCase(AddVehicleRepositoryImpl()))
                ..fetchVehicleConfig(),
          child: const AddVehicleDialog(),
        ),
      );
      if (added != true) return;

      if (!mounted) return;

      // Await fetch to ensure state is updated
      await context.read<ProfileCubit>().fetchVehicles();
    }

    if (!mounted) return;

    // Check if personal details are already filled
    bool hasPersonalDetails = false;
    final userData = appState.userData;
    if (userData != null) {
      if ((userData.lastName?.trim().isNotEmpty ?? false) &&
          (userData.mobileNumber?.trim().isNotEmpty ?? false) &&
          (userData.country?.trim().isNotEmpty ?? false) &&
          (userData.state?.trim().isNotEmpty ?? false) &&
          (userData.city?.trim().isNotEmpty ?? false)) {
        hasPersonalDetails = true;
      }
    }

    if (!hasPersonalDetails) {
      final detailsUpdated = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => const PersonalDetailsDialog(),
      );
      if (detailsUpdated != true) return;
      if (!mounted) return;
    }

    if (!mounted) return;
    String vId = '';
    final prefsId = await AppPreference.instance.get(
      key: AppPreference.KEY_SELECTED_UID,
    );
    if (prefsId.isNotEmpty) {
      vId = prefsId;
    } else if (widget.vehicleId != null && widget.vehicleId!.isNotEmpty) {
      vId = widget.vehicleId!;
    } else {
      final state = context.read<ProfileCubit>().state;
      if (state is VehiclesLoaded && state.vehicles.isNotEmpty) {
        vId = state.vehicles.first.id ?? '';
      }
    }

    if (!mounted) return;
    context.read<DeviceInstallationCubit>().assignDevice(
      vehicleId: vId,
      imei: targetImei,
    );
  }

  void _showManualEntryDialog(BuildContext context) async {
    final imei = await showDialog<String>(
      context: context,
      useRootNavigator: false,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<DeviceInstallationCubit>(),
        child: ManualEntryDialog(vehicleId: widget.vehicleId ?? ''),
      ),
    );

    if (imei != null && imei.isNotEmpty) {
      if (!mounted) return;

      setState(() {
        _hasScanned = true;
        _scannedImei = imei;
      });
      _cameraController.stop();
      _handleContinue();
    }
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
