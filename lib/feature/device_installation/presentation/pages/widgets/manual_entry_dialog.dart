import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../core/utils/shared_preferences.dart';
import '../../cubit/device_installation_cubit.dart';

class ManualEntryDialog extends StatefulWidget {
  final String vehicleId;
  const ManualEntryDialog({super.key, required this.vehicleId});

  @override
  State<ManualEntryDialog> createState() => _ManualEntryDialogState();
}

class _ManualEntryDialogState extends State<ManualEntryDialog> {
  final TextEditingController _uidController = TextEditingController();
  final TextEditingController _imeiController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final userId =
        await AppPreference.instance.get(key: AppPreference.KEY_USER_ID);
    if (mounted) {
      setState(() {
        _uidController.text = userId;
      });
    }
  }

  @override
  void dispose() {
    _uidController.dispose();
    _imeiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Dialog(
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
                    controller: _uidController,
                    hintText: l10n.enterUID,
                    keyboardType: TextInputType.text,
                    validator: (v) =>
                        v == null || v.isEmpty ? l10n.uidRequired : null,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    context,
                    controller: _imeiController,
                    hintText: l10n.enterIMEINumber,
                    keyboardType: TextInputType.number,
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
                            context
                                .read<DeviceInstallationCubit>()
                                .assignDevice(
                                  vehicleId: widget.vehicleId,
                                  imei: _imeiController.text.trim(),
                                  uid: _uidController.text.trim(),
                                );
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          l10n.continueText,
                          style: const TextStyle(
                            color: Color(0xFFFFA000),
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
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
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
          borderSide: const BorderSide(color: Color(0xFFFFA000), width: 1.5),
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
