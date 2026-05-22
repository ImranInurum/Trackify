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
  final bool isFromGarage;
  const VehicleControlScreen({super.key, this.isFromGarage = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          VehicleControlCubit(VehicleControlRepositoryImpl())
            ..loadVehicleDetails(),
      child: VehicleControlView(isFromGarage: isFromGarage)); 
  }

}

class VehicleControlView extends StatelessWidget {
  final bool isFromGarage;
  const VehicleControlView({super.key, this.isFromGarage = false});

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
      body: BlocListener<VehicleControlCubit, VehicleControlState>(
        listener: (context, state) {
          if (state is VehicleControlDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Vehicle removed successfully"),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          }
          if (state is VehicleControlLoaded && state.actionError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.actionError!),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          }
        },
        child: BlocBuilder<VehicleControlCubit, VehicleControlState>(
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
              return CustomScrollView(
                slivers: [
                /// 🔹 TOP IMAGE SECTION
                SliverAppBar(
                  expandedHeight: size.height * 0.30,
                  pinned: true,
                  backgroundColor: bgColor,
                  elevation: 0,
                  leading: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                  flexibleSpace: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                          final top = constraints.biggest.height;
                          final isCollapsed =
                              top <=
                              kToolbarHeight +
                                  MediaQuery.of(context).padding.top +
                                  30;

                          return FlexibleSpaceBar(
                            centerTitle: false,
                            title: AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: isCollapsed ? 1.0 : 0.0,
                              child: Text(
                                vehicle.vehicleName,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: theme.colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            background: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image(
                                  image: vehicle.bikeImage != null
                                      ? (vehicle.bikeImage!.startsWith('http')
                                          ? NetworkImage(vehicle.bikeImage!)
                                          : FileImage(File(vehicle.bikeImage!)) as ImageProvider)
                                      : AssetImage(AppImages.bikeInfoImage),
                                  fit: BoxFit.cover,
                                ),
                                Container(
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
                                Positioned(
                                  bottom: size.height * 0.1,
                                  right: 20,
                                  child: GestureDetector(
                                    onTap: () => _showImageSourceDialog(
                                      context,
                                      vehicle.id,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.2),
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt_outlined,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                  ),
                ),

                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      /// 🔹 VEHICLE DETAILS
                      Column(
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
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.1),
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

                      const SizedBox(height: 10),

                      /// 🔹 TANK & MILEAGE CARDS
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: MetricCard(
                                value: vehicle.tankCapacity,
                                unit: l10n.litresShort,
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
                                unit: l10n.kmL,
                                label: l10n.vehicleMileage,
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
                        isLocked: vehicle.vehicleLock,
                        onLock: () {
                          context.read<VehicleControlCubit>().updateVehicleLock(
                                vehicle.id,
                                !vehicle.vehicleLock,
                              );
                        },
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
                          context.read<VehicleControlCubit>().updateLocalIcon(
                            icon,
                          );
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
                        imei: vehicle.id,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const DocumentFolderScreen(),
                            ),
                          );
                        },
                      ),

                      if (isFromGarage == false) const SizedBox(height: 20),

                      Divider(
                        height: 1,
                        color: theme.colorScheme.onSurface.withOpacity(0.15),
                      ),

                      /// 🔹 NOTIFICATION CONTROLS
                      if (isFromGarage == false)
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.notificationControls,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: primaryTextColor,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        l10n.changeNotificationPreferences,
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
                      if (isFromGarage == false)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.unmapTrackify,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: primaryTextColor,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                l10n.unmapStep1,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: secondaryTextColor,
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                l10n.unmapStep2,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: secondaryTextColor,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),

                      if (isFromGarage) ...[
                        const SizedBox(height: 32),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.add_ic_call,
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.6),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    "Emergency Contact/s",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: primaryTextColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.only(left: 32),
                                child: Text(
                                  "..add 1 more",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Divider(
                          height: 1,
                          color: theme.colorScheme.onSurface.withOpacity(0.15),
                        ),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Remove ${vehicle.vehicleName} ${vehicle.vehicleNumber}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: primaryTextColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Warning: this cannot be undone. All your vehicle history will be deleted permanently.",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: secondaryTextColor,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _showDeleteConfirmationDialog(context, vehicle.id);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isDark
                                        ? const Color(0xFF2C2C2C)
                                        : Colors.grey.shade200,
                                    foregroundColor: Colors.redAccent,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    "Remove Vehicle",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],


                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    ),
  );
  }

  void _showImageSourceDialog(BuildContext context, String vehicleIMEI) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

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
              l10n.uploadImage,
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
                  label: l10n.camera,
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(context, ImageSource.camera, vehicleIMEI);
                  },
                ),
                const SizedBox(width: 40),
                _buildSourceOption(
                  context,
                  icon: Icons.image_outlined,
                  label: l10n.gallery,
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(context, ImageSource.gallery, vehicleIMEI);
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
              border: Border.all(
                color: theme.colorScheme.onSurface.withOpacity(0.1),
              ),
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
    String vehicleIMEI,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final croppedFile = await _cropImage(pickedFile.path, l10n);
      if (croppedFile != null && context.mounted) {
        context.read<VehicleControlCubit>().updateVehicleImage(
          vehicleIMEI,
          croppedFile.path,
        );
      }
    }
  }

  Future<CroppedFile?> _cropImage(String path, AppLocalizations l10n) async {
    return await ImageCropper().cropImage(
      sourcePath: path,
      aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 2),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: l10n.cropVehicleImage,
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.amber,
          initAspectRatio: CropAspectRatioPreset.ratio3x2,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: l10n.cropVehicleImage,
          aspectRatioLockEnabled: true,
        ),
      ],
    );
  }

  void _showTankCapacityDialog(
    BuildContext context,
    String vehicleIMEI,
    String currentVal,
  ) {
    final cubit = context.read<VehicleControlCubit>();
    final controller = TextEditingController(text: currentVal);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

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
                  Text(
                     l10n.updateTankCapacity,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                l10n.tankCapacityDesc,
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
                    hintText: l10n.tankCapacityHint,
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
                        l10n.litres,
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
                      l10n.cancel,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: () {
                      cubit.updateTankCapacity(vehicleIMEI, controller.text);
                      Navigator.pop(context);
                    },
                    child: Text(
                      l10n.save,
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
    String vehicleIMEI,
    String currentVal,
  ) {
    final cubit = context.read<VehicleControlCubit>();
    final controller = TextEditingController(text: currentVal);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

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
                  Text(
                    l10n.updateMileage,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                l10n.mileageDesc,
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
                    hintText: l10n.mileageHint,
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
                        l10n.kmL,
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
                "${l10n.lastUpdatedLabel}$currentVal ${l10n.kmL}",
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
                      l10n.cancel,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: () {
                      cubit.updateMileage(vehicleIMEI, controller.text);
                      Navigator.pop(context);
                    },
                    child: Text(
                      l10n.save,
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
    final l10n = AppLocalizations.of(context)!;

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
                  l10n.whatIsSleepMode,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.sleepModeDesc1,
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.sleepModeDesc2,
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
                    l10n.gotIt,
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

  void _showDeleteConfirmationDialog(BuildContext context, String vehicleIMEI) {
    final cubit = context.read<VehicleControlCubit>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : theme.cardColor,
        title: const Text("Remove Vehicle"),
        content: const Text("Are you sure you want to remove this vehicle? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Cancel", style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              cubit.deleteVehicle(vehicleIMEI);
            },
            child: const Text("Remove", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
