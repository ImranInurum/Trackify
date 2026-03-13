import 'package:flutter/material.dart';
import 'package:trackify/core/theme/app_colors.dart';

import '../config/style_manager.dart'; // where getRegularStyle/getMediumStyle are defined

class GradientButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon;
  final VoidCallback? onTap;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Gradient? gradient;
  final bool showBorder;

  const GradientButton({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.arrow_forward_ios,
    this.onTap,
    this.borderRadius = 5,
    this.padding = const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
    this.gradient,
    this.showBorder = false,
    
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final defaultGradient = const LinearGradient(
      colors: [
        Color(0xFFF2F2F2),
        Color(0xFFE5E5E5)],

      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return InkWell(
      borderRadius: BorderRadius.circular(borderRadius),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          gradient: gradient ?? defaultGradient,
          borderRadius: BorderRadius.circular(borderRadius),
          border: showBorder
              ? Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight)
              : null,
        ),
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Texts
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getMediumStyle(
                    color:  AppColors.textPrimaryLight,
                  ),
                ),
                Text(
                  subtitle,
                  style: getLightStyle(
                    color:isDark?
                         AppColors.subtitleDark:
                        AppColors.subtitleLight

                  ),
                ),
              ],
            ),

            // Icon
            if (icon != null)
              Icon(
                icon,
                color: isDark
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.primaryContainer,
              ),
          ],
        ),
      ),
    );
  }
}
