import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import 'icon_option.dart';
import 'color_option.dart';

class VehicleOnMapCard extends StatefulWidget {
  final Color cardColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final Color accentColor;
  final String selectedIcon;
  final String selectedColor;
  final String vehicleType;
  final Function(String) onIconChanged;
  final Function(String) onColorChanged;
  final VoidCallback onSave;
  final VoidCallback onUpgrade;
  final bool showSaveButton;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;

  const VehicleOnMapCard({
    super.key,
    required this.cardColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.accentColor,
    required this.selectedIcon,
    required this.selectedColor,
    this.vehicleType = '',
    required this.onIconChanged,
    required this.onColorChanged,
    required this.onSave,
    required this.onUpgrade,
    this.showSaveButton = false,
    this.margin,
    this.borderRadius,
  });

  @override
  State<VehicleOnMapCard> createState() => _VehicleOnMapCardState();
}

class _VehicleOnMapCardState extends State<VehicleOnMapCard> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: widget.cardColor,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity( 0.5), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.yourVehicleOnMap,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: widget.primaryTextColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.selectIcon,
            style: TextStyle(
              fontSize: 13,
              color: widget.secondaryTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Builder(
                builder: (context) {
                  String label = 'Bike';
                  IconData iconData = Icons.motorcycle;

                  final lower = widget.vehicleType.toLowerCase();
                  if (lower.contains('car') ||
                      lower.contains('4_wheeler') ||
                      lower.contains('four_wheeler') ||
                      widget.selectedIcon == 'Car' ||
                      widget.selectedIcon == 'My Vehicle') {
                    label = 'Car';
                    iconData = Icons.directions_car;
                  } else if (lower.contains('commercial ev')) {
                    label = 'Commercial EV';
                    iconData = Icons.directions_car;
                  } else if (lower.contains('bus')) {
                    label = 'Bus';
                    iconData = Icons.directions_bus;
                  } else if (lower.contains('van')) {
                    label = 'Van';
                    iconData = Icons.airport_shuttle;
                  } else if (lower.contains('pickup') || 
                      lower.contains('pick-up') || 
                      widget.selectedIcon == 'Pickup') {
                    label = 'Pickup';
                    iconData = Icons.airport_shuttle;
                  } else if (lower.contains('truck')) {
                    label = 'Truck';
                    iconData = Icons.airport_shuttle;
                  } else if (lower.contains('auto rickshaw') ||
                      lower.contains('auto') ||
                      lower.contains('3_wheeler')) {
                    label = 'Auto Rickshaw';
                    iconData = Icons.electric_rickshaw;
                  } else if (lower.contains('scoot') ||
                      widget.selectedIcon == 'Scooty') {
                    label = 'Scooter';
                    iconData = Icons.moped;
                  } else {
                    label = 'Bike';
                    iconData = Icons.motorcycle;
                  }

                  return IconOption(
                    label: label,
                    icon: iconData,
                    isSelected: true,
                    onTap: () {},
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.selectColor,
            style: TextStyle(
              fontSize: 13,
              color: widget.secondaryTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ColorOption(
                  label: AppLocalizations.of(context)!.white,
                  color: Colors.white,
                  isSelected: widget.selectedColor == 'White',
                  onTap: () => widget.onColorChanged('White'),
                ),
                const SizedBox(width: 20),
                ColorOption(
                  label: AppLocalizations.of(context)!.red,
                  color: const Color(0xFF7B3D3D),
                  isSelected: widget.selectedColor == 'Red',
                  onTap: () => widget.onColorChanged('Red'),
                ),
                const SizedBox(width: 20),
                ColorOption(
                  label: AppLocalizations.of(context)!.aqua,
                  color: const Color(0xFF4D7B7B),
                  isSelected: widget.selectedColor == 'Aqua',
                  onTap: () => widget.onColorChanged('Aqua'),
                ),
                const SizedBox(width: 20),
                ColorOption(
                  label: AppLocalizations.of(context)!.orange,
                  color: const Color(0xFF7B551D),
                  isSelected: widget.selectedColor == 'Orange',
                  onTap: () => widget.onColorChanged('Orange'),
                ),
                const SizedBox(width: 20),
                ColorOption(
                  label: AppLocalizations.of(context)!.sky,
                  color: const Color(0xFFA6D0FF),
                  isSelected: widget.selectedColor == 'Sky',
                  onTap: () => widget.onColorChanged('Sky'),
                ),
              ],
            ),
          ),
          if (widget.showSaveButton) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFBB03B),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  AppLocalizations.of(context)!.saveChanges,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
