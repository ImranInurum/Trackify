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

  const CommonButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = AppColors.errorLight,
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
        style: ElevatedButton.styleFrom(backgroundColor:
              onPressed == null
                  ? Colors.grey
                  : Theme.of(context).colorScheme.primaryContainer,
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
      ),
        ),



        // style: ButtonStyle(
        //   elevation: WidgetStateProperty.all<double>(0.0),
        //   shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        //     RoundedRectangleBorder(
        //       side: BorderSide.none,
        //       borderRadius: BorderRadius.circular(4.0),
        //     ),
        //   ),
        //   backgroundColor: WidgetStateProperty.all(
        //     onPressed == null
        //         ? Colors.grey
        //         : Theme.of(context).colorScheme.primaryContainer,
        //   ),
        // ),
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
                style: getRegularStyle(color: Theme.of(context).colorScheme.surface),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
