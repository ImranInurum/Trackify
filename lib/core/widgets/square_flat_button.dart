import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class SquareFlatButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final String? iconAsset;
  final IconData? leading;
  final Color color;
  late Color? backgroundColor =Colors.blueGrey;
  final double height;
  final double width;
  final bool isInverted;
  final bool? isAdminPortal;
  final bool? isElevated;
  final bool? isDesctructive;
  final double? fontsize;

  SquareFlatButton(
      {super.key,
        required this.text,
        required this.onPressed,
        this.color = AppColors.errorLight,
        this.backgroundColor,
        this.height = 48.0,
        this.width = double.infinity,
        this.iconAsset,
        this.leading,
        this.isAdminPortal = false,
        this.isInverted = false,
        this.isElevated = true,
        this.isDesctructive = false,
        this.fontsize = 16.0});
  @override
  Widget build(BuildContext context) {
    backgroundColor ?? Theme.of(context).colorScheme.secondary;
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
          onPressed: onPressed,
          style: onPressed == null
              ? ButtonStyle(
              elevation: WidgetStateProperty.all<double>(0.0),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          isAdminPortal! ? 4.0 : 10.0),
                      side: BorderSide.none)),
              backgroundColor: WidgetStateProperty.all(
                Colors.grey,
              ))
              : ButtonStyle(
            elevation: WidgetStateProperty.all<double>(0.0),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  side: isInverted
                      ? BorderSide(color: backgroundColor!)
                      : BorderSide.none,
                  borderRadius:
                  BorderRadius.circular(isAdminPortal! ? 4.0 : 10.0),
                )),
            backgroundColor: WidgetStateProperty.all(
                isInverted ? Colors.transparent : backgroundColor),
          ),
          child: Row(
            mainAxisAlignment: iconAsset != null || leading != null
                ? MainAxisAlignment.spaceEvenly
                : MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (leading != null) ...[
                Icon(
                  leading,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ],
              // if (iconAsset != null) ...[
              //   Padding(
              //       padding: const EdgeInsets.only(right: 4.0),
              //       child: SvgPicture.asset(iconAsset!,
              //           colorFilter: ColorFilter.mode(
              //               onPressed == null
              //                   ? AppColours.disabled
              //                   : AppColours.cardBackground,
              //               BlendMode.srcIn))),
              // ],
              Flexible(
                child: Text(text,
                    style: TextStyle(
                       // fontFamily: AssetsConstants.defaultFont,
                        fontWeight: FontWeight.w500,
                        fontSize: fontsize,
                        letterSpacing: 1.25,
                        overflow: TextOverflow.ellipsis,
                        color: onPressed == null
                            ? Colors.grey
                            : isInverted
                            ? backgroundColor
                            : isDesctructive!
                            ? AppColors.errorLight
                            : color)),
              ),
            ],
          )),
    );
  }
}