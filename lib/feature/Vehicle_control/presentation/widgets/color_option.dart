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
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  border: Border.all(
                    color: isSelected ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.surface,
                    width: isSelected ? 2 : 1,
                  ),
                ),
              ),
              if (isLocked)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD6B57B),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(Icons.lock, color: Theme.of(context).colorScheme.surface, size: 10),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
