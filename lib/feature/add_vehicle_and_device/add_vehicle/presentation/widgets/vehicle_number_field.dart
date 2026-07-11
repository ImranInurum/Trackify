import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class VehicleNumberField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  const VehicleNumberField({
    super.key,
    required this.controller,
    this.validator,
    this.onChanged,
  });

  @override
  State<VehicleNumberField> createState() => _VehicleNumberFieldState();
}

class _VehicleNumberFieldState extends State<VehicleNumberField> {
  bool _isTouched = false;

  bool _isValidVehicleNumber(String number) {
    final normalized = number.replaceAll(' ', '').replaceAll('-', '').toUpperCase();
    if (normalized.isEmpty) return false;
    final indianRegex = RegExp(r'^[A-Z]{2}[0-9]{1,2}[A-Z]{1,3}[0-9]{1,4}$');
    final swissRegex = RegExp(r'^[A-Z]{2}[0-9]{1,6}$');
    final germanRegex = RegExp(r'^[A-Z]{2,5}[0-9]{1,4}[EH]?$');
    final italyRegex = RegExp(r'^[A-Z]{2}[0-9]{3}[A-Z]{2}$');
    return indianRegex.hasMatch(normalized) ||
        swissRegex.hasMatch(normalized) ||
        germanRegex.hasMatch(normalized) ||
        italyRegex.hasMatch(normalized);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = widget.controller.text;
    final isValid = _isValidVehicleNumber(text);
    final hasError = _isTouched && !isValid && text.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Vehicle Registration Number",
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          textCapitalization: TextCapitalization.characters,
          keyboardType: TextInputType.text,
          style: theme.textTheme.bodyLarge,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 \-]')),
            UpperCaseTextFormatter(),
          ],
          onChanged: (val) {
            if (!_isTouched) {
              setState(() => _isTouched = true);
            } else {
              setState(() {});
            }
            if (widget.onChanged != null) widget.onChanged!(val);
          },
          validator: (val) {
            if (val == null || val.trim().isEmpty) {
              return "Please enter a vehicle registration number.";
            }
            if (!_isValidVehicleNumber(val)) {
              return "Please enter a valid vehicle registration number.";
            }
            if (widget.validator != null) {
              return widget.validator!(val);
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "e.g. UP32AB1234",
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.hintColor,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            suffixIcon: text.isEmpty 
                ? null 
                : isValid 
                    ? const Icon(Icons.check_circle_rounded, color: Colors.green)
                    : hasError 
                        ? const Icon(Icons.error_outline_rounded, color: Colors.red)
                        : null,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: const Color(0xFFD1D5DB)),
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: hasError ? Colors.red : const Color(0xFFD1D5DB),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: hasError ? Colors.red : const Color(0xFF5E17EB), 
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Enter your vehicle registration number as printed on the RC.",
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
