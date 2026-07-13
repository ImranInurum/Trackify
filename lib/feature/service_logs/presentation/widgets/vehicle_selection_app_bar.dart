import 'package:flutter/material.dart';
import '../../../../core/common/models/vehicle_list_model.dart';
import '../../../../l10n/app_localizations.dart';

class VehicleSelectionAppBar extends StatelessWidget {
  final String title;
  final Vehicle? selectedVehicle;
  final List<Vehicle> vehicles;
  final VoidCallback onBack;
  final Function(Vehicle) onVehicleSelected;
  final bool isMinimal;
  final bool showBackButton;

  const VehicleSelectionAppBar({
    super.key,
    required this.title,
    required this.selectedVehicle,
    required this.vehicles,
    required this.onBack,
    required this.onVehicleSelected,
    this.isMinimal = false,
    this.showBackButton = true,
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
              color: theme.cardColor.withOpacity(0.8),
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
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
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
                color: theme.colorScheme.surfaceContainerHighest.withOpacity(
                  0.5,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedVehicle != null
                          ? "${selectedVehicle!.vehicleMaker ?? ""} ${selectedVehicle!.vehicleModel ?? ""}"
                                    .trim() +
                                " (${selectedVehicle!.vehicleNumber ?? ""})"
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
                    ? theme.scaffoldBackgroundColor.withOpacity(1)
                    : theme.cardColor,
                child: Material(
                  type: MaterialType.transparency,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      leading: Image.asset(
                        'assets/icons/bike2.png',
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
