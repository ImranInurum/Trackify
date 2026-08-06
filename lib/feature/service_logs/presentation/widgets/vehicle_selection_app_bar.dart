import 'package:flutter/material.dart';
import '../../../../core/common/models/vehicle_list_model.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/constants/app_images.dart';

class VehicleSelectionAppBar extends StatelessWidget {
  final String title;
  final Vehicle? selectedVehicle;
  final List<Vehicle> vehicles;
  final VoidCallback onBack;
  final Function(Vehicle) onVehicleSelected;
  final bool isMinimal;
  final bool showBackButton;
  final bool requireDevice;

  const VehicleSelectionAppBar({
    super.key,
    required this.title,
    required this.selectedVehicle,
    required this.vehicles,
    required this.onBack,
    required this.onVehicleSelected,
    this.isMinimal = false,
    this.showBackButton = true,
    this.requireDevice = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + (isMinimal ? 10 : 0),
        bottom: isMinimal ? 10 : 20,
      ),
      decoration: isMinimal
          ? null
          : BoxDecoration(
              color: theme.cardColor.withValues(alpha: 0.8),
              border: Border(
                left: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5), width: 0.5),
                right: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5), width: 0.5),
                bottom: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5), width: 0.5),
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isMinimal) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  if (showBackButton)
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: theme.colorScheme.onSurface,
                      ),
                      onPressed: onBack,
                    )
                  else
                    const SizedBox(width: 8),
                  Text(
                    title,
                    style: theme.appBarTheme.titleTextStyle ??
                        const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          GestureDetector(
            onTap: () => _showVehicleSelector(context),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 
                  0.5,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedVehicle != null
                          ? "${"${selectedVehicle!.vehicleMaker ?? ""} ${selectedVehicle!.vehicleModel ?? ""}"
                                    .trim()} (${selectedVehicle!.vehicleNumber ?? ""})"
                          : l10n.selectVehicle,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: theme.colorScheme.onSurface,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showVehicleSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _VehicleSelectorSheet(
        vehicles: vehicles,
        selectedVehicle: selectedVehicle,
        requireDevice: requireDevice,
        onSelected: (vehicle) {
          onVehicleSelected(vehicle);
          Navigator.pop(context);
        },
      ),
    );
  }
}

void showDeviceNotInstalledDialog(BuildContext context, Vehicle vehicle) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;
  final vehicleName =
      "${vehicle.vehicleMaker ?? ""} ${vehicle.vehicleModel ?? ""}".trim();
  final displayTitle = vehicleName.isNotEmpty
      ? vehicleName
      : (vehicle.vehicleNumber != null && vehicle.vehicleNumber!.isNotEmpty
          ? vehicle.vehicleNumber!
          : "This vehicle");

  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: isDark ? const Color(0xFF2C2C2C) : theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.sensors_off_rounded,
                color: Colors.orange,
                size: 36,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Device Not Installed",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Tracking device is not installed on $displayTitle. Please install a device to configure notification controls.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  "OK",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _VehicleSelectorSheet extends StatelessWidget {
  final List<Vehicle> vehicles;
  final Vehicle? selectedVehicle;
  final Function(Vehicle) onSelected;
  final bool requireDevice;

  const _VehicleSelectorSheet({
    required this.vehicles,
    required this.selectedVehicle,
    required this.onSelected,
    this.requireDevice = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5), width: 0.5),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              final isSelected = vehicle.id == selectedVehicle?.id;
              final hasDevice =
                  vehicle.imei != null && vehicle.imei!.trim().isNotEmpty;

              return Container(
                color: isSelected
                    ? theme.scaffoldBackgroundColor.withValues(alpha: 1)
                    : theme.cardColor,
                child: Material(
                  type: MaterialType.transparency,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      leading: Image.asset(
                        (() {
                          final lower = vehicle.vehicleType?.toLowerCase() ?? '';
                          if (lower.contains('auto rickshaw') || lower.contains('auto') || lower.contains('3_wheeler')) {
                            return AppImages.rickshawImage;
                          } else if (lower.contains('car') || lower.contains('4_wheeler') || lower.contains('commercial ev')) {
                            return AppImages.carImage;
                          } else if (lower.contains('bus')) {
                            return AppImages.busImage;
                          } else if (lower.contains('van') || lower.contains('truck') || lower.contains('pickup') || lower.contains('pick-up')) {
                            return AppImages.vanImage;
                          }
                          return AppImages.bikeImage;
                        })(),
                        width: 50,
                        height: 50,
                      ),
                      title: Text(
                        "${vehicle.vehicleMaker ?? ""} ${vehicle.vehicleModel ?? ""}"
                            .trim(),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          Text(vehicle.vehicleNumber ?? ""),
                          if (requireDevice && !hasDevice) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                "No Device",
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: theme.colorScheme.primary,
                            )
                          : null,
                      onTap: () {
                        if (requireDevice && !hasDevice) {
                          Navigator.pop(context);
                          showDeviceNotInstalledDialog(context, vehicle);
                          return;
                        }
                        onSelected(vehicle);
                      },
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
