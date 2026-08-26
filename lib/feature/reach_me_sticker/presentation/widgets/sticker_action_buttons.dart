import 'package:flutter/material.dart';

class StickerActionButtons extends StatelessWidget {
  final String activateLabel;
  final String buyLabel;
  final VoidCallback onActivate;
  final VoidCallback onBuy;

  const StickerActionButtons({
    super.key,
    required this.activateLabel,
    required this.buyLabel,
    required this.onActivate,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        GestureDetector(
          onTap: onActivate,
          child: Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF0284C7),
                  Color(0xFF0369A1),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0284C7).withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                activateLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onBuy,
          child: Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              color: isDark
                  ? Theme.of(context).colorScheme.surface
                  : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFF0284C7).withOpacity(0.6),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                buyLabel,
                style: const TextStyle(
                  color: Color(0xFF0284C7),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
