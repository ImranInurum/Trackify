import 'package:flutter/material.dart';

class ColorOption extends StatelessWidget {
  final String label;
  final Color color;
  final bool isLocked;
  final bool isSelected;
  final VoidCallback onTap;

  const ColorOption({
    super.key,
    required this.label,
    required this.color,
    this.isLocked = false,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 44,
                height: 44,
                padding: const EdgeInsets.all(4), // Space between border and color
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected 
                        ? (theme.brightness == Brightness.dark ? Colors.white : theme.colorScheme.primary)
                        : theme.colorScheme.onSurface.withOpacity(0.15),
                    width: 1.5,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                ),
              ),
              if (isLocked)
                const Positioned(
                  top: -2,
                  right: -2,
                  child: Icon(
                    Icons.lock,
                    color: Color(0xFFFBB03B),
                    size: 14,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isSelected 
                  ? theme.colorScheme.onSurface 
                  : theme.colorScheme.onSurface.withOpacity(0.4),
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
