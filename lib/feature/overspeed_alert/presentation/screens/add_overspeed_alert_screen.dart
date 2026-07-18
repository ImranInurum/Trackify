import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/common/models/vehicle_list_model.dart';
import 'package:trackify/l10n/app_localizations.dart';
import 'package:trackify/feature/overspeed_alert/data/model/overspeed_alert_model.dart';
import '../cubit/overspeed_alert_cubit.dart';
import '../cubit/overspeed_alert_state.dart';
import '../widgets/vehicle_multi_selection_dialog.dart';
import 'package:trackify/core/widgets/loading_screen_ol.dart';

class AddOverspeedAlertScreen extends StatefulWidget {
  /// Pass an existing alert to pre-fill the form (edit mode).
  final OverspeedAlertModel? alertToEdit;

  const AddOverspeedAlertScreen({super.key, this.alertToEdit});

  @override
  State<AddOverspeedAlertScreen> createState() =>
      _AddOverspeedAlertScreenState();
}

class _AddOverspeedAlertScreenState extends State<AddOverspeedAlertScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _speedController = TextEditingController();

  int _selectedDuration = 10;
  final List<int> _durationOptions = [10, 60, 180, 300];

  /// Local selection — the ONLY place vehicle selection lives.
  List<Vehicle> _selectedVehicles = [];
  
  /// Local cache for all vehicles to prevent UI flicker on state change
  List<Vehicle> _allVehicles = [];

  @override
  void initState() {
    super.initState();
    if (widget.alertToEdit != null) {
      final alert = widget.alertToEdit!;
      _titleController.text = alert.title;
      _speedController.text = alert.speedLimit.toString();
      _selectedDuration = alert.duration;
      
      // Find the vehicle matching the alert's IMEI
      final cubitState = context.read<OverspeedAlertCubit>().state;
      if (cubitState is OverspeedAlertLoaded) {
        _allVehicles = cubitState.userVehicles;
        final vehicle = cubitState.userVehicles.cast<Vehicle?>().firstWhere(
              (v) => v?.imei == alert.imei,
              orElse: () => null,
            );
        if (vehicle != null) {
          _selectedVehicles = [vehicle];
        }
      }
    } else {
      // Pre-select the currently active vehicle from the Cubit
      final cubitState = context.read<OverspeedAlertCubit>().state;
      if (cubitState is OverspeedAlertLoaded) {
        _allVehicles = cubitState.userVehicles;
        if (cubitState.selectedVehicle != null) {
          _selectedVehicles = [cubitState.selectedVehicle!];
        }
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _speedController.dispose();
    super.dispose();
  }



  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    if (widget.alertToEdit != null && widget.alertToEdit!.id != null) {
      context.read<OverspeedAlertCubit>().updateOverspeedAlert(
            id: widget.alertToEdit!.id!,
            title: _titleController.text.trim(),
            speedLimit: int.tryParse(_speedController.text) ?? 60,
            timeDuration: _selectedDuration,
            selectedVehicles: _selectedVehicles,
          );
    } else {
      context.read<OverspeedAlertCubit>().saveOverspeedAlert(
            title: _titleController.text.trim(),
            speedLimit: int.tryParse(_speedController.text) ?? 60,
            timeDuration: _selectedDuration,
            selectedVehicles: _selectedVehicles, // passed directly
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              color: theme.colorScheme.onSurface, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(l10n.speedAlertInput),
        centerTitle: false,
      ),
      body: BlocConsumer<OverspeedAlertCubit, OverspeedAlertState>(
        listener: (context, state) {
          if (state is OverspeedAlertSuccess) {
            if (state.message != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message!)),
              );
            }
            Navigator.pop(context);
          } else if (state is OverspeedAlertError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final isSubmitting = state is OverspeedAlertSubmitting;

          return SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInputField(
                    icon: Icons.warning_amber_rounded,
                    label: l10n.alertTitle,
                    controller: _titleController,
                  ),
                  const SizedBox(height: 24),
                  _buildInputField(
                    icon: Icons.speed_rounded,
                    label: l10n.speedLimitKmH,
                    controller: _speedController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 24),
                  _buildDropdownField(
                    icon: Icons.timer_outlined,
                    label: l10n.timeDurationSec,
                    value: _selectedDuration,
                    items: _durationOptions,
                    l10n: l10n,
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedDuration = val);
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildVehicleSelectionField(l10n),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: isSubmitting ? null : _submitForm,
                      child: isSubmitting
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              ),
                            )
                          : Text(
                              l10n.submit,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon,
            color: theme.colorScheme.onSurface.withOpacity(0.6), size: 20),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.8)),
          ),
        ),
        Expanded(
          flex: 3,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.only(bottom: 8),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: theme.dividerColor)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: theme.colorScheme.primary)),
            ),
            validator: (v) =>
                (v == null || v.isEmpty) ? '*required' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required IconData icon,
    required String label,
    required int value,
    required List<int> items,
    required AppLocalizations l10n,
    required void Function(int?) onChanged,
  }) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon,
            color: theme.colorScheme.onSurface.withOpacity(0.6), size: 20),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.8)),
          ),
        ),
        Expanded(
          flex: 3,
          child: DropdownButtonFormField<int>(
            value: value,
            icon: Icon(Icons.arrow_drop_down,
                color: theme.colorScheme.primary),
            isExpanded: true,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.only(bottom: 8),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: theme.dividerColor)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: theme.colorScheme.primary)),
            ),
            dropdownColor: theme.scaffoldBackgroundColor,
            items: items
                .map((d) => DropdownMenuItem<int>(
                      value: d,
                      child: Text('$d ${l10n.sec}',
                          style: theme.textTheme.bodyMedium),
                    ))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleSelectionField(AppLocalizations l10n) {
    final theme = Theme.of(context);
    final allVehicles = _allVehicles;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.directions_car_filled_outlined,
            color: theme.colorScheme.onSurface.withOpacity(0.6), size: 20),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: Text(
            l10n.selectYourVehicle,
            style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.8)),
          ),
        ),
        Expanded(
          flex: 3,
          child: GestureDetector(
            onTap: () async {
              if (allVehicles.isEmpty) return;
              final result = await showDialog<List<Vehicle>>(
                context: context,
                builder: (context) => VehicleMultiSelectionDialog(
                  vehicles: allVehicles,
                  initialSelection: _selectedVehicles,
                ),
              );
              if (result != null) {
                setState(() {
                  _selectedVehicles = result;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: theme.dividerColor),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_selectedVehicles.length} Selected',
                    style: theme.textTheme.bodyMedium,
                  ),
                  Icon(
                    Icons.open_in_new,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
