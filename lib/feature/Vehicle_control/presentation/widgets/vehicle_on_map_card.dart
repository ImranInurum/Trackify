import 'package:flutter/material.dart';
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
  final bool showSaveButton;

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
    this.showSaveButton = false,
  });

  @override
  State<VehicleOnMapCard> createState() => _VehicleOnMapCardState();
}

class _VehicleOnMapCardState extends State<VehicleOnMapCard> with SingleTickerProviderStateMixin {
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
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Your vehicle on map",
                style: TextStyle(
                  fontSize: 18,
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
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFD6B57B), Color(0xFFE7D0B7), Color(0xFFD6B57B)],
                    ),
                  ),
                  child: Row(
                    children: [
                      Image.asset(AppImages.kingIcon, height: 16, width: 16),
                      const SizedBox(width: 6),
                      const Text(
                        "Upgrade to Plus",
                        style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "Select Icon",
            style: TextStyle(
              fontSize: 15,
              color: widget.secondaryTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconOption(
                label: "Bike",
                icon: Icons.motorcycle,
                isSelected: widget.selectedIcon == 'Bike',
                onTap: () => widget.onIconChanged('Bike'),
              ),
              const SizedBox(width: 25),
              IconOption(
                label: "Scooty",
                icon: Icons.moped,
                isLocked: true,
                isSelected: widget.selectedIcon == 'Scooty',
                onTap: _triggerShake,
              ),
              const SizedBox(width: 25),
              IconOption(
                label: "My Vehicle",
                icon: Icons.directions_car,
                isLocked: true,
                isSelected: widget.selectedIcon == 'My Vehicle',
                onTap: _triggerShake,
              ),
            ],
          ),
          const SizedBox(height: 30),
          Text(
            "Select color",
            style: TextStyle(
              fontSize: 15,
              color: widget.secondaryTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ColorOption(
                  label: "White",
                  color: Colors.white,
                  isSelected: widget.selectedColor == 'White',
                  onTap: () => widget.onColorChanged('White'),
                ),
                const SizedBox(width: 20),
                ColorOption(
                  label: "Red",
                  color: const Color(0xFF7B3D3D),
                  isLocked: true,
                  isSelected: widget.selectedColor == 'Red',
                  onTap: _triggerShake,
                ),
                const SizedBox(width: 20),
                ColorOption(
                  label: "Aqua",
                  color: const Color(0xFF4D7B7B),
                  isLocked: true,
                  isSelected: widget.selectedColor == 'Aqua',
                  onTap: _triggerShake,
                ),
                const SizedBox(width: 20),
                ColorOption(
                  label: "Orange",
                  color: const Color(0xFF7B551D),
                  isLocked: true,
                  isSelected: widget.selectedColor == 'Orange',
                  onTap: _triggerShake,
                ),
                const SizedBox(width: 20),
                ColorOption(
                  label: "Sky",
                  color: const Color(0xFFA6D0FF),
                  isSelected: widget.selectedColor == 'Sky',
                  onTap: () => widget.onColorChanged('Sky'),
                ),
              ],
            ),
          ),
          if (widget.showSaveButton) ...[
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFBB03B),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Save Changes",
                  style: TextStyle(
                    fontSize: 16,
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
