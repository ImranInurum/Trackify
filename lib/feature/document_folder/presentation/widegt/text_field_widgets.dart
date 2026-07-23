import 'package:flutter/material.dart';



class TextFieldWidgets extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isRequired;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;

  const TextFieldWidgets({
    super.key,
    required this.controller,
    required this.hintText,
    this.isRequired = false,
    this.suffixIcon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).cardColor,
        label: Text.rich(
          TextSpan(
            text: hintText,
            children: [
              if (isRequired)
                const TextSpan(
                  text: '*',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        labelStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 14,
        ),
        floatingLabelStyle: TextStyle(
          color: colorScheme.primary,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: colorScheme.primary,
          ),
        ),
      ),
      style: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 14,
      ),
    );
  }
}