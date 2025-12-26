import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  final double? innerPadding;
  final Color? backgroundColor;
  final double? borderRadius;
  final double? elevation;
  final BoxBorder? border;
  const CustomCard(
      {super.key,
        required this.child,
        this.height,
        this.elevation = 4.0,
        this.borderRadius = 12.0,
        this.border,
        this.backgroundColor,
        this.width,
        this.innerPadding});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          border: border,
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius!),
          ),
        ),
        padding: EdgeInsets.all(innerPadding ?? 16.0),
        child: child,
      ),
    );
  }
}
