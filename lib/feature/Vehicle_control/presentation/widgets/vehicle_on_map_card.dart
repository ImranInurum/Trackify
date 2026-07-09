import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/constants/app_images.dart';
import 'icon_option.dart';
import 'color_option.dart';

class VehicleOnMapCard extends StatefulWidget {
  final Color cardColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final Color accentColor;
  final String selectedIcon;
  final String selectedColor;
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

class _VehicleOnMapCardState extends State<VehicleOnMapCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: 0.0), weight: 1),
    ]).animate(_shakeController);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _triggerShake() {
    _shakeController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: widget.cardColor,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.5), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.yourVehicleOnMap,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: widget.primaryTextColor,
                ),
              ),
              AnimatedBuilder(
                animation: _shakeAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_shakeAnimation.value, 0),
                    child: child,
                  );
                },
                child: InkWell(
                  onTap: widget.onUpgrade,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFD6B57B),
                          Color(0xFFE7D0B7),
                          Color(0xFFD6B57B),
                        ],
                      ),
                    ),
                    child: Row(
                      children: [
                        Image.asset(AppImages.kingIcon, height: 16, width: 16),
                        const SizedBox(width: 6),
                        Text(
                          AppLocalizations.of(context)!.upgradeToPlus,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
              if (widget.selectedIcon == 'Bike' || (widget.selectedIcon != 'Scooty' && widget.selectedIcon != 'My Vehicle'))
                IconOption(
                  label: AppLocalizations.of(context)!.bike,
                  icon: Icons.motorcycle,
                  isSelected: true,
                  onTap: () {},
                ),
              if (widget.selectedIcon == 'Scooty')
                IconOption(
                  label: AppLocalizations.of(context)!.scooty,
                  icon: Icons.moped,
                  isSelected: true,
                  onTap: () {},
                ),
              if (widget.selectedIcon == 'My Vehicle' || widget.selectedIcon == 'Car')
                IconOption(
                  label: AppLocalizations.of(context)!.myVehicle,
                  icon: Icons.directions_car,
                  isSelected: true,
                  onTap: () {},
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
                  isLocked: true,
                  isSelected: widget.selectedColor == 'Red',
                  onTap: _triggerShake,
                ),
                const SizedBox(width: 20),
                ColorOption(
                  label: AppLocalizations.of(context)!.aqua,
                  color: const Color(0xFF4D7B7B),
                  isLocked: true,
                  isSelected: widget.selectedColor == 'Aqua',
                  onTap: _triggerShake,
                ),
                const SizedBox(width: 20),
                ColorOption(
                  label: AppLocalizations.of(context)!.orange,
                  color: const Color(0xFF7B551D),
                  isLocked: true,
                  isSelected: widget.selectedColor == 'Orange',
                  onTap: _triggerShake,
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
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
