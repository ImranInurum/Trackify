import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trackify/feature/document_folder/presentation/pages/accessory_bill_list_screen.dart';

import '../../../../core/common/models/vehicle_list_model.dart';
import '../../../../l10n/app_localizations.dart';
import 'accessory_bill_screen.dart';
import 'document_license.dart';
import 'document_otherdocument_screen.dart';
import 'document_vehicle_rc_screen.dart';
import 'document_ss.dart';
import 'package:image_cropper/image_cropper.dart';
import '../../../service_logs/presentation/screens/service_logs_screen.dart';
import '../../../service_logs/presentation/cubit/service_logs_cubit.dart';
import '../../../service_logs/presentation/cubit/service_logs_state.dart';
import '../../../Vehicle_control/data/repositories/vehicle_control_repository_impl.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';
import 'package:trackify/feature/document_folder/presentation/cubit/document_folder_cubit.dart';
import 'package:trackify/feature/document_folder/presentation/cubit/document_folder_state.dart';
import 'package:trackify/feature/document_folder/domain/entities/doucment_entity.dart';
import 'package:trackify/feature/document_folder/presentation/pages/document_details_screen.dart';
import 'package:trackify/core/config/network/api_host.dart';

class DocumentFolderScreen extends StatefulWidget {
  const DocumentFolderScreen({super.key});

  @override
  State<DocumentFolderScreen> createState() => _DocumentFolderScreenState();
}

class _DocumentFolderScreenState extends State<DocumentFolderScreen> {
  File? _vehicleImage;
  bool _isPickerActive = false;
  bool _isUploading = false;

  String? _vehicleImageUrl;
  String? _lastFetchedImei;

  @override
  void initState() {
    super.initState();
    final serviceCubit = context.read<ServiceLogsCubit>();
    serviceCubit.loadVehicles();
    final state = serviceCubit.state;
    if (state is ServiceLogsLoaded && state.selectedVehicle != null) {
      _fetchVehicleImageIfNeeded(state.selectedVehicle);
    }
  }

  void _fetchVehicleImageIfNeeded(Vehicle? vehicle) {
    final imei = vehicle?.imei;
    final vehicleId = (vehicle?.id != null && vehicle!.id!.isNotEmpty)
        ? vehicle.id
        : vehicle?.imei;

    final docCubit = context.read<DocumentFolderCubit>();
    final isDocInitial = docCubit.state is DocumentFolderInitial;

    if (_lastFetchedImei == imei && !isDocInitial) return;
    _lastFetchedImei = imei;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _vehicleImage = null;
          _vehicleImageUrl = null;
        });
      }
    });

    if (imei != null && imei.isNotEmpty) { 
      VehicleControlRepositoryImpl()
          .getVehicleControlDetails(vehicleId ?? '', imei)
          .then((details) {
            if (mounted &&
                details.bikeImage != null &&
                details.bikeImage!.isNotEmpty) {
              setState(() {
                _vehicleImageUrl = details.bikeImage;
              });
            }
          })
          .catchError((e) {
            // ignore
          });
    }

    if (vehicleId != null && vehicleId.isNotEmpty) {
      docCubit.fetchDocuments(vehicleId);
    }
  }

  Future<void> _pickImage(ImageSource source, String? imei) async {
    if (_isPickerActive) return;
    setState(() => _isPickerActive = true);

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        final croppedFile = await _cropImage(File(pickedFile.path));
        if (croppedFile != null) {
          setState(() => _vehicleImage = croppedFile);
          // Upload if vehicle is selected
          if (imei != null && imei.isNotEmpty) {
            await _uploadVehicleImage(croppedFile, imei);
          }
        }
      }
    } finally {
      if (mounted) setState(() => _isPickerActive = false);
    }
  }

  Future<void> _uploadVehicleImage(File imageFile, String imei) async {
    if (!mounted) return;
    setState(() => _isUploading = true);
    try {
      await VehicleControlRepositoryImpl().updateVehicleImage(
        imei,
        imageFile.path,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.successMessage),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizations.of(context)!.uploadFailed}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  Future<File?> _cropImage(File imageFile) async {
    final l10n = AppLocalizations.of(context)!;
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 2),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: l10n.cropVehicleImage,
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.ratio3x2,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: l10n.cropVehicleImage,
          aspectRatioLockEnabled: true,
          resetAspectRatioEnabled: false,
        ),
      ],
    );
    return croppedFile != null ? File(croppedFile.path) : null;
  }

  void _showImagePicker(String? imei) {
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
                      _pickImage(ImageSource.camera, imei);
                    },
                  ),
                  const SizedBox(width: 32),
                  _circleOption(
                    icon: Icons.photo_library_outlined,
                    label: l10n.gallery,
                    onTap: () async {
                      Navigator.pop(context);
                      await Future.delayed(const Duration(milliseconds: 300));
                      _pickImage(ImageSource.gallery, imei);
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

    if (state is ServiceLogsLoaded) {
      selectedVehicle = state.selectedVehicle;

      _fetchVehicleImageIfNeeded(selectedVehicle);
    }

    final docState = context.watch<DocumentFolderCubit>().state;
    List<DocumentEntity> uploadedDocs = [];
    if (docState is DocumentFolderLoaded) {
      uploadedDocs = docState.documents;
    }

    DocumentEntity? findDoc(String subtype) {
      try {
        return uploadedDocs.firstWhere((d) => d.subtype == subtype);
      } catch (_) {
        return null;
      }
    }

    List<DocumentEntity> findAllDocs(String subtype) {
      return uploadedDocs.where((d) => d.subtype == subtype).toList();
    }

    void handleDocTap(
      String title,
      String subtype,
      Widget Function(DocumentEntity? doc) buildUploadScreen,
    ) async {
      final doc = findDoc(subtype);
      bool? result;
      if (doc != null) {
        result = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (_) => DocumentDetailsScreen(
              title: title,
              document: doc,
              onEdit: () async {
                Navigator.pop(context);
                final res = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(builder: (_) => buildUploadScreen(doc)),
                );
                if (res == true && selectedVehicle != null) {
                  final vId = selectedVehicle.id ?? selectedVehicle.imei;
                  if (vId != null && vId.isNotEmpty) {
                    context.read<DocumentFolderCubit>().fetchDocuments(vId);
                  }
                }
              },
              onDelete: () async {
                if (doc.id.isNotEmpty) {
                  final success = await context
                      .read<DocumentFolderCubit>()
                      .deleteDocument(doc.id);
                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)!.successMessage),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context, true);
                  }
                }
              },
            ),
          ),
        );
      } else {
        result = await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (_) => buildUploadScreen(null)),
        );
      }

      if (result == true && selectedVehicle != null) {
        final vId = selectedVehicle.id ?? selectedVehicle.imei;
        if (vId != null && vId.isNotEmpty) {
          context.read<DocumentFolderCubit>().fetchDocuments(vId);
        }
      }
    }

    final isLoading = state is ServiceLogsLoading ||
        (docState is DocumentFolderLoading && uploadedDocs.isEmpty);

    return BlocListener<ServiceLogsCubit, ServiceLogsState>(
      listener: (context, state) {
        if (state is ServiceLogsLoaded && state.selectedVehicle != null) {
          _fetchVehicleImageIfNeeded(state.selectedVehicle);
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: colorScheme.onSurface),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            l10n.documentFolder,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          backgroundColor: colorScheme.surface,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: false,
        ),
        body: isLoading
            ? const Center(child: TrackifyLoader())
            : SafeArea(
                child: SingleChildScrollView(
                  key: const PageStorageKey<String>('document_folder_scroll'),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.shield,
                            color: Colors.green,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            l10n.documentsEncrypted,
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // ── PERSONAL SECTION ─────────────────────────────
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: colorScheme.outlineVariant.withValues(
                              alpha: 0.2,
                            ),
                          ),
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
                                    title: l10n.drivingLicenseTitle,
                                    document: findDoc('driving_license'),
                                    onTap: () {
                                      final vehicle = selectedVehicle;
                                      if (vehicle == null) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(l10n.selectVehicle),
                                          ),
                                        );
                                        return;
                                      }
                                      handleDocTap(
                                        l10n.drivingLicenseTitle,
                                        'driving_license',
                                        (doc) => DocumentLicense(
                                          title: l10n.drivingLicenseTitle,
                                          vehicleId: vehicle.id ?? '',
                                          initialDocument: doc,
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 12),
                                  _docTile(
                                    context,
                                    colorScheme,
                                    title: l10n.otherDocuments,
                                    document: findDoc('other_document'),
                                    onTap: () {
                                      final vehicle = selectedVehicle;
                                      if (vehicle == null) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(l10n.selectVehicle),
                                          ),
                                        );
                                        return;
                                      }
                                      handleDocTap(
                                        l10n.otherDocumentTitle,
                                        'other_document',
                                        (doc) => DocumentOtherdocumentScreen(
                                          title: l10n.otherDocumentTitle,
                                          vehicleId:
                                              vehicle.id ?? vehicle.imei ?? '',
                                          initialDocument: doc,
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
                          final dashCount = (boxWidth / (dashWidth + dashSpace))
                              .floor();
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(dashCount, (_) {
                              return SizedBox(
                                width: dashWidth,
                                height: dashHeight,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: colorScheme.outlineVariant
                                        .withValues(alpha: 0.5),
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
                            onTap: () {
                              if (_vehicleImage != null || _vehicleImageUrl != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Scaffold(
                                      backgroundColor: Colors.black,
                                      appBar: AppBar(
                                        backgroundColor: Colors.black,
                                        iconTheme: const IconThemeData(color: Colors.white),
                                        actions: [
                                          IconButton(
                                            icon: const Icon(Icons.edit, color: Colors.white),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              _showImagePicker(selectedVehicle?.imei);
                                            },
                                          ),
                                        ],
                                      ),
                                      body: Center(
                                        child: InteractiveViewer(
                                          minScale: 0.5,
                                          maxScale: 4.0,
                                          child: _vehicleImage != null
                                              ? Image.file(
                                                  _vehicleImage!,
                                                  fit: BoxFit.contain,
                                                )
                                              : Image.network(
                                                  _vehicleImageUrl!,
                                                  fit: BoxFit.contain,
                                                  errorBuilder: (_, __, ___) => const Center(
                                                    child: Icon(Icons.error, color: Colors.white),
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                _showImagePicker(selectedVehicle?.imei);
                              }
                            },
                            child: Container(
                              width: screenWidth * 0.20,
                              height: screenHeight * 0.07,
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: colorScheme.outlineVariant.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                              ),
                              child: _isUploading
                                  ? const Center(
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    )
                                  : _vehicleImage == null
                                  ? (_vehicleImageUrl != null
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child: Image.network(
                                              _vehicleImageUrl!,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) => Center(
                                                child: Icon(
                                                  Icons.camera_alt,
                                                  color: colorScheme
                                                      .onSurfaceVariant,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Center(
                                            child: Icon(
                                              Icons.camera_alt,
                                              color: colorScheme
                                                  .onSurfaceVariant,
                                              size: 20,
                                            ),
                                          ))
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
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  builder: (sheetContext) => BlocProvider.value(
                                    value: context.read<ServiceLogsCubit>(),
                                    child:
                                        BlocBuilder<
                                          ServiceLogsCubit,
                                          ServiceLogsState
                                        >(
                                          builder: (context, state) {
                                            List<Vehicle> vehicles = [];
                                            Vehicle? selectedVehicle;
                                            bool isLoading = false;
                                            String? errorMessage;
                                            if (state is ServiceLogsError) {
                                              errorMessage = state.message;
                                              vehicles = state.vehicles;
                                              selectedVehicle =
                                                  state.selectedVehicle;
                                            } else if (state
                                                is ServiceLogsLoaded) {
                                              vehicles = state.vehicles;
                                              selectedVehicle =
                                                  state.selectedVehicle;
                                            } else if (state
                                                    is ServiceLogsLoading ||
                                                state is ServiceLogsInitial) {
                                              isLoading = true;
                                            }
                                            return _VehicleSelectorSheet(
                                              vehicles: vehicles,
                                              selectedVehicle: selectedVehicle,
                                              isLoading: isLoading,
                                              errorMessage: errorMessage,
                                              onSelected: (vehicle) {
                                                context
                                                    .read<ServiceLogsCubit>()
                                                    .selectVehicle(vehicle.id!);
                                                Navigator.pop(sheetContext);
                                              },
                                            );
                                          },
                                        ),
                                  ),
                                );
                              },
                              child: Container(
                                height: screenHeight * 0.07,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: colorScheme.outlineVariant
                                        .withValues(alpha: 0.5),
                                  ),
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
                                          color: colorScheme.onSurface,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
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
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: colorScheme.outlineVariant.withValues(
                              alpha: 0.5,
                            ),
                          ),
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
                                  _docTile(
                                    context,
                                    colorScheme,
                                    title: l10n.vehicleRC,
                                    document: findDoc('rc'),
                                    onTap: () {
                                      final vehicle = selectedVehicle;
                                      if (vehicle == null) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(l10n.selectVehicle),
                                          ),
                                        );
                                        return;
                                      }
                                      handleDocTap(
                                        l10n.vehicleRCTitle,
                                        'rc',
                                        (doc) => DocumentVehicleRCScreen(
                                          title: l10n.vehicleRCTitle,
                                          vehicleId:
                                              vehicle.id ?? vehicle.imei ?? '',
                                          initialDocument: doc,
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 12),
                                  _docTile(
                                    context,
                                    colorScheme,
                                    title: l10n.insurance,
                                    document: findDoc('insurance'),
                                    onTap: () {
                                      final vehicle = selectedVehicle;
                                      if (vehicle == null) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(l10n.selectVehicle),
                                          ),
                                        );
                                        return;
                                      }
                                      handleDocTap(
                                        l10n.insuranceTitle,
                                        'insurance',
                                        (doc) => DocumentSubScreen(
                                          title: l10n.insuranceTitle,
                                          vehicleId:
                                              vehicle.id ?? vehicle.imei ?? '',
                                          subtype: 'insurance',
                                          initialDocument: doc,
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 12),
                                  _docTile(
                                    context,
                                    colorScheme,
                                    title: l10n.puc,
                                    document: findDoc('puc'),
                                    onTap: () {
                                      final vehicle = selectedVehicle;
                                      if (vehicle == null) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(l10n.selectVehicle),
                                          ),
                                        );
                                        return;
                                      }
                                      handleDocTap(
                                        l10n.pucTitle,
                                        'puc',
                                        (doc) => DocumentSubScreen(
                                          title: l10n.pucTitle,
                                          vehicleId:
                                              vehicle.id ?? vehicle.imei ?? '',
                                          subtype: 'puc',
                                          initialDocument: doc,
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

                      // ── BILLS SECTION ─────────────────────────────
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: colorScheme.outlineVariant.withValues(
                              alpha: 0.5,
                            ),
                          ),
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
                                      final vehicle = selectedVehicle;
                                      if (vehicle == null) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(l10n.selectVehicle),
                                          ),
                                        );
                                        return;
                                      }
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ServiceLogsScreen(),
                                        ),
                                      );
                                    },
                                    customContent: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(
                                          alpha: 0.3,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            l10n.movedTo,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                l10n.exploreMore,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 4,
                                                      vertical: 1,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.amber,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  l10n.newLabel,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 7,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "${l10n.viewNow} >",
                                            style: TextStyle(
                                              color: colorScheme.primary,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  _docTile(
                                    context,
                                    colorScheme,
                                    title: l10n.accessoryBills,
                                    document:
                                        findAllDocs('accessory_bill').isNotEmpty
                                        ? findAllDocs('accessory_bill').first
                                        : null,
                                    badgeCount: findAllDocs(
                                      'accessory_bill',
                                    ).length,
                                    onTap: () async {
                                      final vehicle = selectedVehicle;
                                      if (vehicle == null) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(l10n.selectVehicle),
                                          ),
                                        );
                                        return;
                                      }
                                      final bills = findAllDocs(
                                        'accessory_bill',
                                      );
                                      bool? res;
                                      if (bills.isNotEmpty) {
                                        res = await Navigator.push<bool>(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AccessoryBillListScreen(
                                                  vehicleId:
                                                      vehicle.id ??
                                                      vehicle.imei ??
                                                      '',
                                                  bills: bills,
                                                ),
                                          ),
                                        );
                                      } else {
                                        res = await Navigator.push<bool>(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AccessoryBillScreen(
                                                  vehicleId:
                                                      vehicle.id ??
                                                      vehicle.imei ??
                                                      '',
                                                ),
                                          ),
                                        );
                                      }
                                      if (res == true && selectedVehicle != null) {
                                        final vId =
                                            selectedVehicle.id ??
                                            selectedVehicle.imei;
                                        if (vId != null && vId.isNotEmpty) {
                                          context
                                              .read<DocumentFolderCubit>()
                                              .fetchDocuments(vId);
                                        }
                                      }
                                    },
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
      ),
    );
  }

  Widget _sectionTitle(
    ColorScheme colorScheme, {
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          textAlign: TextAlign.start,
          style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
        ),
      ],
    );
  }

  Widget _docTile(
    BuildContext context,
    ColorScheme colorScheme, {
    required String title,
    required VoidCallback onTap,
    Widget? customContent,
    DocumentEntity? document,
    int badgeCount = 0,
  }) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    Widget content;
    if (customContent != null) {
      content = customContent;
    } else if (document != null) {
      String? imgPath = document.fontpath ?? document.backpath;
      if (imgPath != null && imgPath.isNotEmpty) {
        String imageUrl = imgPath.startsWith('http')
            ? imgPath
            : '${ApiURL.baseURL}/$imgPath';

        if (imageUrl.toLowerCase().endsWith('.pdf')) {
          content = const Center(
            child: Icon(Icons.picture_as_pdf, color: Colors.red, size: 28),
          );
        } else {
          content = ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Center(
                child: Icon(
                  Icons.description,
                  color: colorScheme.primary,
                  size: 28,
                ),
              ),
            ),
          );
        }
      } else {
        content = Center(
          child: Icon(
            Icons.description,
            color: colorScheme.primary,
            size: 28,
          ),
        );
      }

      if (badgeCount > 1) {
        content = Stack(
          fit: StackFit.expand,
          children: [
            content,
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$badgeCount',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      }
    } else {
      content = Center(
        child: Icon(
          Icons.note_add_outlined,
          color: colorScheme.onSurfaceVariant,
          size: 28,
        ),
      );
    }
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
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            child: content,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Vehicle Selector Bottom Sheet ────────────────────────────────────────────

class _VehicleSelectorSheet extends StatelessWidget {
  final List<Vehicle> vehicles;
  final Vehicle? selectedVehicle;
  final bool isLoading;
  final String? errorMessage;
  final ValueChanged<Vehicle> onSelected;

  const _VehicleSelectorSheet({
    required this.vehicles,
    required this.selectedVehicle,
    required this.isLoading,
    this.errorMessage,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 24),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              l10n.selectVehicle,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: TrackifyLoader()),
            )
          else if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Center(
                child: Text(
                  errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            )
          else if (vehicles.isEmpty)
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
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: vehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = vehicles[index];
                  final isSelected = selectedVehicle?.id == vehicle.id;
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primaryContainer.withValues(alpha: 0.15)
                          : theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.outlineVariant.withValues(alpha: 0.4),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Material(
                      type: MaterialType.transparency,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        leading: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            'assets/icons/bike2.png',
                            width: 40,
                            height: 40,
                          ),
                        ),
                        title: Text(
                          '${vehicle.vehicleMaker ?? ''} ${vehicle.vehicleModel ?? ''}'
                              .trim(),
                        ),
                        subtitle: vehicle.vehicleNumber != null
                            ? Text(
                                vehicle.vehicleNumber!,
                                style: TextStyle(
                                  color: colorScheme.onSurfaceVariant,
                                  fontSize: 12,
                                ),
                              )
                            : null,
                        trailing: isSelected
                            ? Icon(
                                Icons.check_circle,
                                color: colorScheme.primary,
                                size: 22,
                              )
                            : null,
                        onTap: () => onSelected(vehicle),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
