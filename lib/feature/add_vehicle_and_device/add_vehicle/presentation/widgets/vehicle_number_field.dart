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

    // 1. India / UK Pattern: Letters -> Numbers -> Letters
    // If a plate starts with 2 letters, 1-2 numbers, and then letters, it's definitively this style.
    if (RegExp(r'^[A-Z]{2}[0-9]{1,2}[A-Z]').hasMatch(normalized)) {
      // Indian: UP32AB1234 (Strictly requires 4 digits at the end)
      final indianRegex = RegExp(r'^[A-Z]{2}[0-9]{1,2}[A-Z]{1,3}[0-9]{4}$');
      // UK: AB12CDE (Strictly requires 3 letters at the end)
      final ukRegex = RegExp(r'^[A-Z]{2}[0-9]{2}[A-Z]{3}$');
      
      return indianRegex.hasMatch(normalized) || ukRegex.hasMatch(normalized);
    }

    // 2. Italy: Exactly 7 characters (e.g. AB123CD)
    final italyRegex = RegExp(r'^[A-Z]{2}[0-9]{3}[A-Z]{2}$');
    if (italyRegex.hasMatch(normalized) && normalized.length == 7) {
      return true;
    }

    // 3. Germany: 5 to 9 characters (1-3 letters, 1-2 letters, 1-4 numbers)
    final germanRegex = RegExp(r'^[A-Z]{1,3}[A-Z]{1,2}[0-9]{1,4}[EH]?$');
    if (germanRegex.hasMatch(normalized) && normalized.length >= 5 && normalized.length <= 9) {
      return true;
    }

    // 4. Switzerland: 5 to 8 characters (2 letters, 3-6 numbers)
    final swissRegex = RegExp(r'^[A-Z]{2}[0-9]{3,6}$');
    if (swissRegex.hasMatch(normalized) && normalized.length >= 5 && normalized.length <= 8) {
      return true;
    }

    // 5. General Fallback: 6 to 15 characters, must contain both letters and numbers
    final generalRegex = RegExp(r'^(?=.*[A-Z])(?=.*[0-9])[A-Z0-9]{6,15}$');
    if (generalRegex.hasMatch(normalized)) {
      return true;
    }

    return false;
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
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: widget.controller,
          textCapitalization: TextCapitalization.characters,
          keyboardType: TextInputType.text,
          maxLength: 15,
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
            counterText: '',
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
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
