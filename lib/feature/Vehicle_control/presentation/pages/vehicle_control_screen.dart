import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trackify/app/app_navigation.dart';
import 'package:trackify/core/constants/app_images.dart';
import 'package:trackify/l10n/app_localizations.dart';
import '../../../document_folder/presentation/pages/document_screen.dart';
import '../../../upgrade_to_plus/presentation/pages/upgrade_to_plus.dart';
import '../../data/repositories/vehicle_control_repository_impl.dart';
import '../cubit/vehicle_control_cubit.dart';
import '../state/vehicle_control_state.dart';
import '../widgets/metric_card.dart';
import '../widgets/lock_card.dart';
import '../widgets/vehicle_on_map_card.dart';
import '../widgets/journey_card.dart';
import '../widgets/documents_card.dart';
import 'notification_controls_screen.dart';
import 'edit_vehicle_screen.dart';

class VehicleControlScreen extends StatelessWidget {
  const VehicleControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          VehicleControlCubit(VehicleControlRepositoryImpl())
            ..loadVehicleDetails("1"),
      child: const VehicleControlView(),
    );
  }
}

class VehicleControlView extends StatelessWidget {
  const VehicleControlView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    // Use theme colors
    final bgColor = theme.scaffoldBackgroundColor;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : theme.cardColor;
    final primaryTextColor = theme.colorScheme.onSurface;
    final secondaryTextColor = theme.colorScheme.onSurface.withOpacity(0.6);

    return Scaffold(
      backgroundColor: bgColor,
      body: BlocBuilder<VehicleControlCubit, VehicleControlState>(
        builder: (context, state) {
          if (state is VehicleControlLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is VehicleControlError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(color: theme.colorScheme.error),
              ),
            );
          }
          if (state is VehicleControlLoaded) {
            final vehicle = state.vehicle;
            return SingleChildScrollView(
              child: Column(
                children: [
                  /// 🔹 TOP IMAGE SECTION
                  Stack(
                    children: [
                      Container(
                        height: size.height * 0.45,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: vehicle.bikeImage != null
                                ? FileImage(File(vehicle.bikeImage!)) as ImageProvider
                                : AssetImage(AppImages.bikeImage),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: const [0.6, 0.9, 1.0],
                              colors: [
                                Colors.transparent,
                                bgColor.withOpacity(0.8),
                                bgColor,
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 10,
                        left: 16,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.arrow_back,
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                            size: 24,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: size.height * 0.1,
                        right: 20,
                        child: GestureDetector(
                          onTap: () => _showImageSourceDialog(context, vehicle.id),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            child: Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white, // Keep white for better visibility on dark image
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  /// 🔹 VEHICLE DETAILS
                  Transform.translate(
                    offset: const Offset(0, -20),
                    child: Column(
                      children: [
                        Text(
                          vehicle.vehicleName,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: primaryTextColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${vehicle.vehicleNumber} | ${vehicle.fuelType}",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: secondaryTextColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) => BlocProvider.value(
                                      value: context
                                          .read<VehicleControlCubit>(),
                                      child: EditVehicleScreen(
                                        vehicle: vehicle,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.onSurface.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.edit,
                                  color: theme.colorScheme.onSurface,
                                  size: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// 🔹 TANK & MILEAGE CARDS
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: MetricCard(
                            value: vehicle.tankCapacity,
                            unit: "L",
                            label: l10n.tankCapacity,
                            cardColor: cardColor,
                            onEdit: () => _showTankCapacityDialog(
                              context,
                              vehicle.id,
                              vehicle.tankCapacity,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: MetricCard(
                            value: vehicle.vehicleMileage,
                            unit: "Km/L",
                            label: "Vehicle Mileage",
                            cardColor: cardColor,
                            onEdit: () => _showMileageDialog(
                              context,
                              vehicle.id,
                              vehicle.vehicleMileage,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🔹 LOCK & UNLOCK VEHICLE CARD
                  LockCard(
                    cardColor: cardColor,
                    primaryTextColor: primaryTextColor,
                    secondaryTextColor: secondaryTextColor,
                    onLock: () {},
                    onInfoTap: () => _showSleepModeDialog(context),
                  ),

                  const SizedBox(height: 20),

                  /// 🔹 VEHICLE ON MAP CARD
                  VehicleOnMapCard(
                    cardColor: cardColor,
                    primaryTextColor: primaryTextColor,
                    secondaryTextColor: secondaryTextColor,
                    accentColor: theme.colorScheme.primary,
                    selectedIcon: state.tempIcon,
                    selectedColor: state.tempColor,
                    onUpgrade: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UpgradeToPlusScreen(),
                        ),
                      );
                    },
                    onIconChanged: (icon) {
                      context.read<VehicleControlCubit>().updateLocalIcon(icon);
                    },
                    onColorChanged: (color) {
                      context.read<VehicleControlCubit>().updateLocalColor(
                        color,
                      );
                    },
                    onSave: () {
                      context.read<VehicleControlCubit>().saveChanges(
                        vehicle.id,
                      );
                    },
                    showSaveButton:
                        state.tempIcon != vehicle.selectedIcon ||
                        state.tempColor != vehicle.selectedColor,
                  ),

                  const SizedBox(height: 20),

                  /// 🔹 JOURNEY CARD
                  JourneyCard(
                    cardColor: cardColor,
                    primaryTextColor: primaryTextColor,
                    secondaryTextColor: secondaryTextColor,
                    onTap: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                      AppNavigation.setIndex(2);
                    },
                  ),

                  const SizedBox(height: 20),

                  /// 🔹 DOCUMENTS CARD
                  DocumentsCard(
                    cardColor: cardColor,
                    primaryTextColor: primaryTextColor,
                    secondaryTextColor: secondaryTextColor,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DocumentFolderScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  Divider(
                    height: 1,
                    color: theme.colorScheme.onSurface.withOpacity(0.15),
                  ),

                  /// 🔹 NOTIFICATION CONTROLS
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const NotificationControlsScreen(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.settings_outlined,
                            color: secondaryTextColor,
                            size: 28,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Notification controls",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: primaryTextColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Change your notification preferences",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: secondaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: secondaryTextColor,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),

                  Divider(
                    height: 1,
                    color: theme.colorScheme.onSurface.withOpacity(0.15),
                  ),
                  const SizedBox(height: 32),

                  /// 🔹 UNMAP SECTION
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Unmap your Ajjas",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: primaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Step 1: To un-map device, call at +918061971443",
                          style: TextStyle(
                            fontSize: 14,
                            color: secondaryTextColor,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Step 2: Remove vehicle",
                          style: TextStyle(
                            fontSize: 14,
                            color: secondaryTextColor,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 60),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context, String vehicleId) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : theme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Upload Image",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                _buildSourceOption(
                  context,
                  icon: Icons.camera_alt_outlined,
                  label: "Camera",
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(context, ImageSource.camera, vehicleId);
                  },
                ),
                const SizedBox(width: 40),
                _buildSourceOption(
                  context,
                  icon: Icons.image_outlined,
                  label: "Gallery",
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(context, ImageSource.gallery, vehicleId);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
            ),
            child: Icon(icon, size: 30, color: theme.colorScheme.onSurface),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(
    BuildContext context,
    ImageSource source,
    String vehicleId,
  ) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final croppedFile = await _cropImage(pickedFile.path);
      if (croppedFile != null && context.mounted) {
        context.read<VehicleControlCubit>().updateVehicleImage(
              vehicleId,
              croppedFile.path,
            );
      }
    }
  }

  Future<CroppedFile?> _cropImage(String path) async {
    return await ImageCropper().cropImage(
      sourcePath: path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Vehicle Image',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.amber,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Crop Vehicle Image',
        ),
      ],
    );
  }

  void _showTankCapacityDialog(
    BuildContext context,
    String vehicleId,
    String currentVal,
  ) {
    final cubit = context.read<VehicleControlCubit>();
    final controller = TextEditingController(text: currentVal);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.local_gas_station_outlined,
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Update Tank Capacity",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                "Enter the maximum fuel capacity of your vehicle tank",
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.onSurface.withOpacity(0.2),
                  ),
                ),
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: "e.g, 13",
                    hintStyle: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.3),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: InputBorder.none,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 16, top: 12),
                      child: Text(
                        "Litres",
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: () {
                      cubit.updateTankCapacity(
                        vehicleId,
                        controller.text,
                      );
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMileageDialog(
    BuildContext context,
    String vehicleId,
    String currentVal,
  ) {
    final cubit = context.read<VehicleControlCubit>();
    final controller = TextEditingController(text: currentVal);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.flash_on_outlined,
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Update Mileage",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                "Enter current mileage (Km/L) to track remaining fuel & distance accurately.",
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.onSurface.withOpacity(0.2),
                  ),
                ),
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: "e.g, 50",
                    hintStyle: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.3),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: InputBorder.none,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 16, top: 12),
                      child: Text(
                        "Km/L",
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Last updated: $currentVal Km/L",
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: () {
                      cubit.updateMileage(
                        vehicleId,
                        controller.text,
                      );
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSleepModeDialog(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: isDark ? const Color(0xFF2C2C2C) : theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "What is Sleep Mode?",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "When the Ajjas device doesn't detect any vibration or motion, it automatically enters sleep mode to save the vehicle's battery.",
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "The device instantly wakes up and begins tracking when it senses any motion and is in good network coverage.",
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Okay",
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
