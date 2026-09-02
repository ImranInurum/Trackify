import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trackify/l10n/app_localizations.dart';

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
    if (normalized.length < 2 || normalized.length > 20) return false;
    return RegExp(r'^[A-Z0-9]+$').hasMatch(normalized);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final text = widget.controller.text;
    final isValid = _isValidVehicleNumber(text);
    final hasError = _isTouched && !isValid && text.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.vehicleRegistrationNumberLabel,
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
              return l10n.pleaseEnterVehicleRegistrationNumber;
            }
            if (!_isValidVehicleNumber(val)) {
              return l10n.invalidVehicleRegistrationNumber;
            }
            if (widget.validator != null) {
              return widget.validator!(val);
            }
            return null;
          },
          decoration: InputDecoration(
            counterText: '',
            hintText: l10n.vehicleNumberHintAlternative,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.hintColor,
            ),
            filled: true,
            fillColor: theme.cardColor,
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
          l10n.vehicleRegNoRcHelpText,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity( 0.5),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
