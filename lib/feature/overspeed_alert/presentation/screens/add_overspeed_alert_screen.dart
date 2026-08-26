import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/common/models/vehicle_list_model.dart';
import 'package:trackify/core/config/font_manager.dart';
import 'package:trackify/l10n/app_localizations.dart';
import 'package:trackify/feature/overspeed_alert/data/model/overspeed_alert_model.dart';
import '../cubit/overspeed_alert_cubit.dart';
import '../cubit/overspeed_alert_state.dart';
import '../widgets/vehicle_multi_selection_dialog.dart';
import 'package:trackify/core/utils/distance_utils.dart';

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
              (v) => (alert.vehicleId != null && v?.id == alert.vehicleId) || (alert.imei != null && v?.imei == alert.imei),
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
            selectedVehicles: _selectedVehicles,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final isEditMode = widget.alertToEdit != null;

    return Scaffold(
      backgroundColor: isDark ? theme.scaffoldBackgroundColor : const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: isDark ? theme.scaffoldBackgroundColor : const Color(0xFFF7F9FC),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              color: colorScheme.onSurface, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEditMode ? "Edit Speed Alert" : l10n.speedAlertInput,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: colorScheme.onSurface,
          ),
        ),
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

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: isDark ? colorScheme.surface : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? colorScheme.outline.withOpacity(0.2) : const Color(0xFFE8EEF5),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// HEADER BANNER
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF0284C7).withOpacity(0.15) : const Color(0xFFE0F2FE),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.speed_rounded,
                                  color: Color(0xFF0284C7),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isEditMode ? "Update Speed Threshold" : "Set Speed Limit Alert",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "Get notified instantly when speed limits are crossed.",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: colorScheme.onSurface.withOpacity(0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Divider(height: 1),
                          const SizedBox(height: 24),

                          /// FIELD 1: ALERT TITLE
                          _buildModernInputField(
                            icon: Icons.warning_amber_rounded,
                            label: l10n.alertTitle,
                            hint: "e.g. High Speed Warning",
                            controller: _titleController,
                            isDark: isDark,
                            colorScheme: colorScheme,
                          ),
                          const SizedBox(height: 20),

                          /// FIELD 2: SPEED LIMIT
                          _buildModernInputField(
                            icon: Icons.speed_rounded,
                            label: l10n.speedLimitKmH.replaceAll('km/h', context.displayKmh).replaceAll('km/hr', context.displayKmHr),
                            hint: "e.g. 80",
                            controller: _speedController,
                            keyboardType: TextInputType.number,
                            isDark: isDark,
                            colorScheme: colorScheme,
                          ),
                          const SizedBox(height: 20),

                          /// FIELD 3: TIME DURATION
                          _buildModernDropdownField(
                            icon: Icons.timer_outlined,
                            label: l10n.timeDurationSec,
                            value: _selectedDuration,
                            items: _durationOptions,
                            l10n: l10n,
                            isDark: isDark,
                            colorScheme: colorScheme,
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedDuration = val);
                            },
                          ),
                          const SizedBox(height: 20),

                          /// FIELD 4: VEHICLE SELECTION
                          _buildModernVehicleSelectionField(l10n, isDark, colorScheme),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              /// BOTTOM STICKY SUBMIT BUTTON
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: isDark ? colorScheme.surface : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
                      blurRadius: 16,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF0284C7),
                          Color(0xFF0369A1),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0284C7).withOpacity(0.35),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: isSubmitting ? null : _submitForm,
                        borderRadius: BorderRadius.circular(14),
                        child: Center(
                          child: isSubmitting
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  l10n.submit,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    letterSpacing: 0.3,
                                    fontFamily: FontFamilyManager.fontFamily,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildModernInputField({
    required IconData icon,
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool isDark,
    required ColorScheme colorScheme,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFF0284C7), size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(color: colorScheme.onSurface, fontSize: 14, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.4),
              fontSize: 14,
            ),
            filled: true,
            fillColor: isDark ? colorScheme.onSurface.withOpacity(0.06) : const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? colorScheme.outline.withOpacity(0.2) : const Color(0xFFE2E8F0),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? colorScheme.outline.withOpacity(0.2) : const Color(0xFFE2E8F0),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF0284C7), width: 1.5),
            ),
          ),
          validator: (v) => (v == null || v.isEmpty) ? '*Required field' : null,
        ),
      ],
    );
  }

  Widget _buildModernDropdownField({
    required IconData icon,
    required String label,
    required int value,
    required List<int> items,
    required AppLocalizations l10n,
    required bool isDark,
    required ColorScheme colorScheme,
    required void Function(int?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFF0284C7), size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF0284C7)),
          isExpanded: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? colorScheme.onSurface.withOpacity(0.06) : const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? colorScheme.outline.withOpacity(0.2) : const Color(0xFFE2E8F0),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? colorScheme.outline.withOpacity(0.2) : const Color(0xFFE2E8F0),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF0284C7), width: 1.5),
            ),
          ),
          dropdownColor: isDark ? colorScheme.surface : Colors.white,
          items: items
              .map((d) => DropdownMenuItem<int>(
                    value: d,
                    child: Text(
                      '$d ${l10n.sec}',
                      style: TextStyle(color: colorScheme.onSurface, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildModernVehicleSelectionField(
    AppLocalizations l10n,
    bool isDark,
    ColorScheme colorScheme,
  ) {
    final allVehicles = _allVehicles;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.directions_car_filled_outlined, color: Color(0xFF0284C7), size: 18),
            const SizedBox(width: 8),
            Text(
              l10n.selectYourVehicle,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        InkWell(
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
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isDark ? colorScheme.onSurface.withOpacity(0.06) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? colorScheme.outline.withOpacity(0.2) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _selectedVehicles.isEmpty
                        ? '0 Vehicles Selected'
                        : _selectedVehicles.length == 1
                            ? '${_selectedVehicles.first.vehicleMaker ?? ''} ${_selectedVehicles.first.vehicleModel ?? ''}'.trim().isNotEmpty
                                ? '${_selectedVehicles.first.vehicleMaker ?? ''} ${_selectedVehicles.first.vehicleModel ?? ''}'.trim()
                                : _selectedVehicles.first.vehicleNumber ?? '1 Vehicle Selected'
                            : '${_selectedVehicles.length} Vehicles Selected',
                    style: TextStyle(
                      color: _selectedVehicles.isEmpty
                          ? colorScheme.onSurface.withOpacity(0.4)
                          : colorScheme.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Color(0xFF0284C7),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
