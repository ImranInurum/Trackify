import 'package:flutter/material.dart';

class IconOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isLocked;
  final bool isSelected;
  final VoidCallback onTap;

  const IconOption({
    super.key,
    required this.label,
    required this.icon,
    this.isLocked = false,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? const Color(0xFF121212) : Colors.grey.shade200,
                  border: Border.all(
                    color: isSelected ? theme.colorScheme.onSurface : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: isSelected ? theme.colorScheme.onSurface : theme.colorScheme.onSurface.withOpacity(0.2),
                    size: 32,
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
                    child: Icon(Icons.lock, color: theme.colorScheme.surface, size: 12),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isSelected ? theme.colorScheme.onSurface : theme.colorScheme.onSurface.withOpacity(0.3),
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
