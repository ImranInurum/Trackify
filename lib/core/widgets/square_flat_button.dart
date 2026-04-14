import 'package:flutter/material.dart';
import 'package:trackify/core/config/style_manager.dart';

class CommonButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final String? iconAsset;
  final IconData? leading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double height;
  final double width;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;

  const CommonButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.iconAsset,
    this.leading,
    this.backgroundColor,
    this.foregroundColor,
    this.height = 44.0,
    this.width = double.infinity,
    this.borderRadius = 12.0,
    this.padding,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final elevatedButtonStyle = theme.elevatedButtonTheme.style;

    final defaultBackgroundColor = theme.colorScheme.primary;
    final defaultForegroundColor = theme.colorScheme.onPrimary;
    final disabledBackgroundColor = theme.disabledColor.withOpacity(0.2);
    final disabledForegroundColor =
        theme.textTheme.bodyMedium?.color?.withOpacity(0.5) ??
        theme.colorScheme.onSurface.withOpacity(0.5);

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: onPressed == null
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: elevatedButtonStyle?.copyWith(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.disabled)) {
              return disabledBackgroundColor;
            }
            return backgroundColor ?? defaultBackgroundColor;
          }),
          foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.disabled)) {
              return disabledForegroundColor;
            }
            return foregroundColor ?? defaultForegroundColor;
          }),
          padding: WidgetStatePropertyAll(
            padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
          ),
          elevation: const WidgetStatePropertyAll(0), // Handled by boxshadow
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: foregroundColor ?? defaultForegroundColor,
                ),
              )
            : Row(
                mainAxisAlignment: (iconAsset != null || leading != null)
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leading != null) ...[
                    Icon(leading, size: 18),
                    const SizedBox(width: 8)
                  ],
                  Flexible(
                    child: Text(
                      text,
                      overflow: TextOverflow.ellipsis,
                      style: getRegularStyle(
                        color: onPressed == null
                            ? disabledForegroundColor
                            : (foregroundColor ?? defaultForegroundColor),
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
