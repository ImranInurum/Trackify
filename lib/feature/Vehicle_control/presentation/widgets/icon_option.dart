import 'package:flutter/material.dart';
import 'package:trackify/core/utils/flutter_compat_extensions.dart';

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
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 56,
                height: 56,
                padding: const EdgeInsets.all(4), // Padding inside border
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade100,
                  border: Border.all(
                    color: isSelected ? theme.colorScheme.onSurface : theme.colorScheme.onSurface.withValues(alpha: 0.1),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: isSelected ? theme.colorScheme.onSurface : theme.colorScheme.onSurface.withValues(alpha: 0.2),
                    size: 26,
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
              fontSize: 12,
              color: isSelected ? theme.colorScheme.onSurface : theme.colorScheme.onSurface.withValues(alpha: 0.4),
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
