import 'package:flutter/material.dart';
import 'package:trackify/core/config/style_manager.dart';

import '../theme/app_colors.dart';

class CommonButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final String? iconAsset;
  final IconData? leading;
  final Color color;
  final double height;
  final double width;

  CommonButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = AppColors.primaryDark,
    this.height = 35.0,
    this.width = double.infinity,
    this.iconAsset,
    this.leading,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: Theme.of(context).elevatedButtonTheme.style,
        child: Row(
          mainAxisAlignment: iconAsset != null || leading != null
              ? MainAxisAlignment.spaceEvenly
              : MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leading != null) ...[
              Icon(leading, color: Theme.of(context).colorScheme.surface),
            ],

            Flexible(
              child: Text(
                text,
                style:TextStyle(
                  color: Theme.of(context).colorScheme.tertiaryFixedDim
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
