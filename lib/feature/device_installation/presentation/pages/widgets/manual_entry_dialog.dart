import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../l10n/app_localizations.dart';

class ManualEntryDialog extends StatefulWidget {
  final String vehicleId;
  const ManualEntryDialog({super.key, required this.vehicleId});

  @override
  State<ManualEntryDialog> createState() => _ManualEntryDialogState();
}

class _ManualEntryDialogState extends State<ManualEntryDialog> {
  final TextEditingController _imeiController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _imeiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Dialog(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(
                    context,
                    controller: _imeiController,
                    hintText: l10n.enterIMEINumber,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(15),
                    ],
                    validator: (v) {
                      if (v == null || v.isEmpty) return l10n.imeiRequired;
                      if (v.length != 15) return l10n.invalidImeiError;
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          l10n.close,
                          style: TextStyle(
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                            fontSize: 16,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pop(context, _imeiController.text.trim());
                          }
                        },
                        child: Text(
                          l10n.continueText,
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: theme.hintColor,
        ),
        filled: true,
        fillColor: theme.dividerColor.withValues(alpha: 0.05),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.dividerColor),
          borderRadius: BorderRadius.circular(4),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.colorScheme.secondary, width: 1.5),
          borderRadius: BorderRadius.circular(4),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.colorScheme.error),
          borderRadius: BorderRadius.circular(4),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: theme.colorScheme.error, width: 1.5),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
