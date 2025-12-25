import 'package:flutter/material.dart';

class OptionTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final String subtitle;
  final Widget? extra;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;

  const OptionTile({
    Key? key,
    required this.leading,
    required this.title,
    required this.subtitle,
    this.extra,
    this.trailing,
    this.onTap,
    this.showDivider = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Leading widget
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: leading,
                ),

                // Title, subtitle, and optional extra
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      if (extra != null) ...[
                        const SizedBox(height: 6),
                        extra!,
                      ],
                    ],
                  ),
                ),

                trailing ??
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: Colors.grey,
                    ),
              ],
            ),
          ),
        ),

        // Optional divider
        if (showDivider)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                const SizedBox(width: 45), // aligns divider after leading icon
                Expanded(
                  child: Divider(
                    color: Colors.grey[300],
                    thickness: 1,
                  ),
                ),
                const SizedBox(width: 32), // space before trailing arrow
              ],
            ),
          ),
      ],
    );
  }
}
