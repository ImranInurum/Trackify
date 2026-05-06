import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/common/models/vehicle_list_model.dart';
import '../../../../l10n/app_localizations.dart';
import 'document_license.dart';
import 'document_otherdocument_screen.dart';
import 'document_vehicalRC_screen.dart';
import 'document_ss.dart';
import 'package:image_cropper/image_cropper.dart';
import '../../../service_logs/presentation/screens/service_logs_screen.dart';
import '../../../service_logs/presentation/cubit/service_logs_cubit.dart';
import '../../../service_logs/presentation/cubit/service_logs_state.dart';

class DocumentFolderScreen extends StatefulWidget {
  const DocumentFolderScreen({super.key});

  @override
  State<DocumentFolderScreen> createState() => _DocumentFolderScreenState();
}

class _DocumentFolderScreenState extends State<DocumentFolderScreen> {
  File? _vehicleImage;
  bool _isPickerActive = false;

  Future<void> _pickImage(ImageSource source) async {
    if (_isPickerActive) return;
    setState(() => _isPickerActive = true);

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source, imageQuality: 50);
      if (pickedFile != null) {
        final croppedFile = await _cropImage(File(pickedFile.path));
        if (croppedFile != null) {
          setState(() {
            _vehicleImage = croppedFile;
          });
        }
      }
    } finally {
      if (mounted) setState(() => _isPickerActive = false);
    }
  }

  Future<File?> _cropImage(File imageFile) async {
    final l10n = AppLocalizations.of(context)!;
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: l10n.cropVehicleImage,
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: l10n.cropVehicleImage,
        ),
      ],
    );
    return croppedFile != null ? File(croppedFile.path) : null;
  }

  void _showImagePicker() {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                l10n.uploadImage,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 28),
              Row(
               crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _circleOption(
                    icon: Icons.camera_alt_outlined,
                    label: l10n.camera,
                    onTap: () async {
                      Navigator.pop(context);
                      await Future.delayed(const Duration(milliseconds: 300));
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  const SizedBox(width: 32),
                  _circleOption(
                    icon: Icons.photo_library_outlined,
                    label: l10n.gallery,
                    onTap: () async {
                      Navigator.pop(context);
                      await Future.delayed(const Duration(milliseconds: 300));
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circleOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              shape: BoxShape.circle,
              border: Border.all(color: colorScheme.outlineVariant, width: 1),
            ),
            child: Icon(icon, color: colorScheme.primary, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final state = context.watch<ServiceLogsCubit>().state;
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    Vehicle? selectedVehicle;
    List<Vehicle> vehicles = [];

    if (state is ServiceLogsLoaded) {
      selectedVehicle = state.selectedVehicle;
      vehicles = state.vehicles;
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── HEADER ─────────────────────────────
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back,
                        color: colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.documentFolder,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  const Icon(Icons.shield, color: Colors.green, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    l10n.documentsEncrypted,
                    style: const TextStyle(
                        color: Colors.green, fontSize: 12),
                  ),
                ],
              ),

              const SizedBox(height: 50),

              // ── PERSONAL SECTION ─────────────────────────────

              Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color:  Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle(
                        colorScheme,
                        title: l10n.personalDocumentsTitle,
                        subtitle: l10n.personalDocumentsSubtitle,
                      ),
                      const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _docTile(
                            context,
                            colorScheme,
                            title: l10n.drivingLicense,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DocumentLicense(
                                      title: l10n.drivingLicenseTitle),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 12),
                          _docTile(
                            context,
                            colorScheme,
                            title: l10n.otherDocuments,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      DocumentOtherdocumentScreen(
                                          title: l10n.otherDocumentTitle),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              


              const SizedBox(height: 25),
              LayoutBuilder(
                builder: (context, constraints) {
                  final boxWidth = constraints.constrainWidth();
                  const dashWidth = 4.0;
                  const dashHeight = 1.0;
                  const dashSpace = 4.0;
                  final dashCount = (boxWidth / (dashWidth + dashSpace)).floor();
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(dashCount, (_) {
                      return SizedBox(
                        width: dashWidth,
                        height: dashHeight,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: colorScheme.outlineVariant.withOpacity(0.5),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
              const SizedBox(height: 25),

              // ── VEHICLE IMAGE + SELECTOR ──────────────────────
              Row(
                children: [
                  // 📷 Vehicle Image
                  GestureDetector(
                    onTap: _showImagePicker,
                    child: Container(
                      width: screenWidth * 0.20,
                      height: screenHeight * 0.07,
                      decoration: BoxDecoration(
                        color:  Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.5)),
                      ),
                      child: _vehicleImage == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt,
                                    color: colorScheme.onSurfaceVariant, size: 20),
                                const SizedBox(height: 4),
                                Text(
                                  l10n.vehicleImage,
                                  style: TextStyle(
                                      color: colorScheme.onSurfaceVariant,
                                      fontSize: 10),
                                ),
                              ],
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                _vehicleImage!,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // 🚗 Vehicle Selector
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (_) => _VehicleSelectorSheet(
                            vehicles: vehicles,
                            selectedVehicle: selectedVehicle,

                            onSelected: (vehicle) {
                              context
                                  .read<ServiceLogsCubit>()
                                  .selectVehicle(vehicle.id!);
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                      child: Container(
                        height: screenHeight * 0.07,
                        padding:
                        const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color:  Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: colorScheme.outlineVariant.withOpacity(0.5)),
                        ),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                selectedVehicle != null
                                    ? "${selectedVehicle.vehicleMaker} ${selectedVehicle.vehicleModel} (${selectedVehicle.vehicleNumber})"
                                    : l10n.selectVehicle,
                                style: TextStyle(
                                    color: colorScheme.onSurface),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(Icons.keyboard_arrow_down,
                                color: colorScheme.onSurfaceVariant),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // ── VEHICLE SECTION ─────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:  Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle(
                      colorScheme,
                      title: l10n.vehicleDocumentsTitle,
                      subtitle: l10n.personalDocumentsSubtitle,
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _docTile(context, colorScheme, title: l10n.vehicleRC, onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (_) => DocumentVehicleRCScreen(title: l10n.vehicleRCTitle),
                            ));
                          }),
                          const SizedBox(width: 12),
                          _docTile(context, colorScheme, title: l10n.insurance, onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (_) => DocumentSubScreen(title: l10n.insuranceTitle),
                            ));
                          }),
                          const SizedBox(width: 12),
                          _docTile(context, colorScheme, title: l10n.puc, onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (_) => DocumentSubScreen(title: l10n.pucTitle),
                            ));
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ── BILLS SECTION ─────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle(
                      colorScheme,
                      title: l10n.billsTitle,
                      subtitle: l10n.billsDescription,
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _docTile(
                            context,
                            colorScheme,
                            title: l10n.serviceLogs,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ServiceLogsScreen(),
                                ),
                              );
                            },
                            customContent: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(l10n.movedTo,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 10)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(l10n.exploreMore,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(width: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 1),
                                        decoration: BoxDecoration(
                                          color: Colors.amber,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(l10n.newLabel,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 7,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text("${l10n.viewNow} >",
                                      style: const TextStyle(
                                          color: Colors.amber,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          _docTile(
                            context,
                            colorScheme,
                            title: l10n.accessoryBills,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(
      ColorScheme colorScheme,
      {required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(subtitle,textAlign: TextAlign.start,
            style:
            TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12)),
      ],
    );
  }

  Widget _docTile(BuildContext context, ColorScheme colorScheme,
      {required String title, required VoidCallback onTap, Widget? customContent}) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: screenWidth * 0.30,
            height: screenWidth * 0.30,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.5)),
            ),
            child: customContent ?? Center(
              child: Icon(Icons.note_add_outlined,
                  color: colorScheme.onSurfaceVariant, size: 28),
            ),
          ),
          const SizedBox(height: 8),
          Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: colorScheme.onSurfaceVariant, fontSize: 12)),
        ],
      ),
    );
  }
}

// ── Vehicle Selector Bottom Sheet ────────────────────────────────────────────

class _VehicleSelectorSheet extends StatelessWidget {
  final List<Vehicle> vehicles;
  final Vehicle? selectedVehicle;
  final ValueChanged<Vehicle> onSelected;

  const _VehicleSelectorSheet({
    required this.vehicles,
    required this.selectedVehicle,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.selectVehicle,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          if (vehicles.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  l10n.noVehiclesInGarage,
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: vehicles.length,
              separatorBuilder: (_, __) => Divider(
                color: colorScheme.outlineVariant,
                height: 1,
              ),
              itemBuilder: (context, index) {
                final vehicle = vehicles[index];
                final isSelected = selectedVehicle?.id == vehicle.id;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.directions_car,
                      color: Colors.amber),
                  title: Text(
                    '${vehicle.vehicleMaker ?? ''} ${vehicle.vehicleModel ?? ''}'.trim(),
                    style: TextStyle(
                      color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  subtitle: vehicle.vehicleNumber != null
                      ? Text(
                          vehicle.vehicleNumber!,
                          style: TextStyle(
                              color: colorScheme.onSurfaceVariant, fontSize: 12),
                        )
                      : null,
                  trailing: isSelected
                      ? Icon(Icons.check_circle,
                          color: colorScheme.primary, size: 20)
                      : null,
                  onTap: () => onSelected(vehicle),
                );
              },
            ),
        ],
      ),
    );
  }
}
