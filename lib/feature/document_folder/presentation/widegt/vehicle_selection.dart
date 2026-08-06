import 'package:flutter/material.dart';
import '../../../../core/common/models/vehicle_list_model.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/constants/app_images.dart';

class VehicleSelectorSheet extends StatelessWidget {
  final String title;
  final Vehicle? selectedVehicle;
  final List<Vehicle> vehicles;
  final VoidCallback onBack;
  final Function(Vehicle) onVehicleSelected;

  const VehicleSelectorSheet({
    super.key,
    required this.title,
    required this.selectedVehicle,
    required this.vehicles,
    required this.onBack,
    required this.onVehicleSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        bottom: 20,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor.withValues(alpha: 0.8),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5), width: 0.5),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: theme.colorScheme.onSurface,
                  ),
                  onPressed: onBack,
                ),
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => _showVehicleSelector(context),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5), width: 0.5),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedVehicle != null
                          ? "${selectedVehicle!.vehicleMaker} ${selectedVehicle!.vehicleModel} (${selectedVehicle!.vehicleNumber})"
                          : l10n.selectVehicle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
        onSelected: (vehicle) {
          onVehicleSelected(vehicle);
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _VehicleSelectorSheet extends StatelessWidget {
  final List<Vehicle> vehicles;
  final Vehicle? selectedVehicle;
  final Function(Vehicle) onSelected;

  const _VehicleSelectorSheet({
    required this.vehicles,
    required this.selectedVehicle,
    required this.onSelected,
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

              return Container(
                color: isSelected
                    ? theme.scaffoldBackgroundColor
                    : theme.cardColor,
                child: Material(
                  type: MaterialType.transparency,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
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
                        "${vehicle.vehicleMaker} ${vehicle.vehicleModel}",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                      subtitle: Text(vehicle.vehicleNumber ?? ""),
                      trailing: isSelected
                          ? Icon(
                        Icons.check_circle,
                        color: theme.colorScheme.primary,
                      )
                          : null,
                      onTap: () => onSelected(vehicle),
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
