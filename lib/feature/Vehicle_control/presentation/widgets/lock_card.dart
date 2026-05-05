import 'package:flutter/material.dart';
import '../../../../core/common/widgets/interactive_swipe_button.dart';

class LockCard extends StatelessWidget {
  final Color cardColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final VoidCallback onLock;

  const LockCard({
    super.key,
    required this.cardColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.onLock,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lock_outline, color: secondaryTextColor, size: 24),
              const SizedBox(width: 12),
              Text(
                "Lock and Unlock Vehicle",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: primaryTextColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          InteractiveSwipeButton(onSwipe: onLock),
          const SizedBox(height: 24),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    "Your vehicle will not be Locked / Unlocked if the device is in sleep mode.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: secondaryTextColor,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.info_outline, color: secondaryTextColor, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
