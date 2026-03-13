import 'package:flutter/material.dart';

import '../config/style_manager.dart';

class OptionTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final String subtitle;
  final Widget? extra;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final EdgeInsetsGeometry? contentPadding;



  const OptionTile({
    super.key,
    required this.leading,
    required this.title,
    required this.subtitle,
    this.extra,
    this.trailing,
    this.onTap,
    this.showDivider = true,
    this.titleStyle,
    this.subtitleStyle,
    this.contentPadding,

  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Leading widget
                Padding(padding: const EdgeInsets.only(right: 12),

                    child: leading,),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style:
                            titleStyle ??
                            getRegularStyle(
                              color: Theme.of(context).colorScheme.tertiaryFixedDim,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style:
                            subtitleStyle ??
                            getMediumStyle(
                              color: Theme.of(context).colorScheme.tertiaryFixed,
                            ),
                      ),
                      if (extra != null) ...[const SizedBox(height: 6), extra!],
                    ],
                  ),
                ),

                trailing ??
                    const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              ],
            ),
          ),
        ),

        // Optional divider
        if (showDivider)
          Row(
            children: [
              const SizedBox(width: 45), // aligns divider after leading icon
              Expanded(child: Divider(color: Colors.grey[300], thickness: 2)),
              const SizedBox(width: 32), // space before trailing arrow
            ],
          ),
      ],
    );
  }
}
