import 'package:flutter/material.dart';
import 'package:trackify/core/common/models/vehicle_list_model.dart';
import 'package:trackify/l10n/app_localizations.dart';

/// A dialog that lets the user pick one or more vehicles.
/// Vehicle list is passed in; selection state is managed by the CALLER screen.
class VehicleMultiSelectionDialog extends StatefulWidget {
  final List<Vehicle> vehicles;
  final List<Vehicle> initialSelection;

  const VehicleMultiSelectionDialog({
    super.key,
    required this.vehicles,
    required this.initialSelection,
  });

  @override
  State<VehicleMultiSelectionDialog> createState() =>
      _VehicleMultiSelectionDialogState();
}

class _VehicleMultiSelectionDialogState
    extends State<VehicleMultiSelectionDialog> {
  late List<Vehicle> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.initialSelection);
  }

  void _toggle(Vehicle vehicle) {
    setState(() {
      if (_selected.any((v) => v.id == vehicle.id)) {
        _selected.removeWhere((v) => v.id == vehicle.id);
      } else {
        _selected.add(vehicle);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${l10n.selectVehiclesOverspeedAlert}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (widget.vehicles.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'No vehicles available.',
                  style: theme.textTheme.bodyMedium,
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.vehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = widget.vehicles[index];
                  final isSelected = _selected.any((v) => v.id == vehicle.id);
                  return CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      '${vehicle.vehicleModel} — ${vehicle.vehicleNumber}',
                      style: theme.textTheme.bodyMedium,
                    ),
                    value: isSelected,
                    activeColor: theme.colorScheme.primary,
                    checkColor: theme.colorScheme.onPrimary,
                    side: BorderSide(color: theme.colorScheme.primary),
                    onChanged: (_) => _toggle(vehicle),
                  );
                },
              ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(context, _selected),
                child: Text(
                  'Done',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
