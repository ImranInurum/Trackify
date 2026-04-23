import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/feature/add_vehicle_and_device/add_vehicle/data/models/vehicle_config_models.dart';

import '../../../../../app/app_navigation.dart';
import '../../../../../core/theme/app_theme_extension.dart';
import '../../../../../core/widgets/custom_form_field.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../onboarding/presentation/cubit/splash_cubit.dart';
import '../../../../onboarding/presentation/cubit/splash_state.dart';
import '../cubit/add_vehicle_cubit.dart';
import '../cubit/add_vehicle_state.dart';

// ─── Screen ──────────────────────────────────────────────────────────────────

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _vehicleNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<AddVehicleCubit>();
    cubit.reset();
    cubit.fetchVehicleConfig();
  }

  @override
  void dispose() {
    _vehicleNumberController.dispose();
    super.dispose();
  }

  // ─── Logo (same SplashCubit pattern as all auth screens) ───────────────────
  Widget _buildLogo(SplashState state, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child:
            (state is SplashLoaded &&
                state.logo.path != null &&
                state.logo.path!.isNotEmpty)
            ? CachedNetworkImage(
                imageUrl: state.logo.path!,
                height: 220,
                fit: BoxFit.contain,
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator(color: colorScheme.primary)),
                errorWidget: (context, url, error) => Icon(
                  Icons.track_changes_rounded,
                  size: 88,
                  color: colorScheme.primary,
                ),
              )
            : Icon(Icons.track_changes_rounded, size: 88, color: colorScheme.primary),
      ),
    );
  }

  // ─── Vehicle-type circular chip ────────────────────────────────────────────
  Widget _buildVehicleTypeItem({
    required VehicleConfig config,
    required IconData icon,
    required String label,
    required bool selected,
  }) {
    final theme = Theme.of(context);
    final Color active = theme.colorScheme.secondary;
    final Color inactive = theme.hintColor.withOpacity(0.4);

    return GestureDetector(
      onTap: () => context.read<AddVehicleCubit>().selectVehicleType(config),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? active : inactive,
                width: selected ? 2 : 1.5,
              ),
              color: selected ? active.withValues(alpha: 0.06) : Colors.transparent,
            ),
            child: Icon(icon, color: selected ? active : inactive, size: 28),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: selected ? active : inactive,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ─── Fuel-type circular chip ───────────────────────────────────────────────
  Widget _buildFuelTypeItem({
    required String type,
    required IconData icon,
    required String label,
    required bool selected,
  }) {
    final theme = Theme.of(context);
    final Color active = theme.colorScheme.secondary;
    final Color inactive = theme.hintColor.withOpacity(0.4);

    return GestureDetector(
      onTap: () => context.read<AddVehicleCubit>().selectFuelType(type),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? active : inactive,
                width: selected ? 2 : 1.5,
              ),
              color: selected ? active.withValues(alpha: 0.06) : Colors.transparent,
            ),
            child: Icon(icon, color: selected ? active : inactive, size: 28),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: selected ? active : inactive,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ─── Labelled dropdown ─────────────────────────────────────────────────────
  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required String Function(T) itemLabel,
    ValueChanged<T?>? onChanged,
    bool isLoading = false,
    String? hint,
    VoidCallback? onDisabledTap,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            if (isLoading)
              SizedBox(
                height: 12,
                width: 12,
                child: CircularProgressIndicator(strokeWidth: 1.5, color: theme.colorScheme.primary),
              ),
          ],
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: (onChanged == null || items.isEmpty) && !isLoading ? onDisabledTap : null,
          behavior: HitTestBehavior.opaque,
          child: Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.dividerColor),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                dropdownColor: theme.cardColor,
                value: value,
                isExpanded: true,
                hint: Text(
                  hint ?? label,
                  style: TextStyle(color: theme.hintColor, fontSize: 14),
                ),
                icon: Icon(Icons.arrow_drop_down, color: theme.colorScheme.secondary),
                items: items
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(itemLabel(e), style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 14)),
                      ),
                    )
                    .toList(),
                onChanged: isLoading ? null : onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Section label ─────────────────────────────────────────────────────────
  Widget _sectionLabel(String text, ThemeData theme) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      text,
      style: theme.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurface,
      ),
    ),
  );

  IconData _getVehicleIcon(String type) {
    return switch (type.toLowerCase()) {
      '2_wheeler' => Icons.two_wheeler_rounded,
      '4_wheeler' => Icons.directions_car_rounded,
      'rikshaw' => Icons.electric_rickshaw_rounded,
      _ => Icons.local_shipping_rounded,
    };
  }

  String _getVehicleLabel(String type, AppLocalizations l10n) {
    return switch (type.toLowerCase()) {
      '2_wheeler' => l10n.twoWheeler,
      '4_wheeler' => l10n.fourWheeler,
      'rikshaw' => l10n.autoRickshaw,
      _ =>
        type
            .replaceAll('_', ' ')
            .split(' ')
            .map((e) => e[0].toUpperCase() + e.substring(1))
            .join(' '),
    };
  }

  IconData _getFuelIcon(String fuel) {
    return switch (fuel.toLowerCase()) {
      'petrol' => Icons.water_drop_rounded,
      'electric' => Icons.bolt_rounded,
      'diesel' => Icons.local_gas_station_rounded,
      'cng' => Icons.eco_rounded,
      _ => Icons.opacity_rounded,
    };
  }

  // ─── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final appColors = theme.extension<AppColorsExtension>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: theme.appBarTheme.foregroundColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.addVehicle,
          style: TextStyle(
            color: theme.appBarTheme.foregroundColor,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocListener<AddVehicleCubit, AddVehicleState>(
        listenWhen: (previous, current) =>
            previous.selectedConfig?.id != current.selectedConfig?.id ||
            previous.successResponse != current.successResponse ||
            previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          // If vehicle type changed, reset the vehicle number controller
          final cubit = context.read<AddVehicleCubit>();
          // Note: We don't want to reset on initial load or if both are null
          // but if previous was something and current is different, or if current is just different from what we had.
          // However, the simplest way is to check the cubit's selectVehicleType logic which clears other fields.

          // We can use a simpler approach: if selectedConfig changed, clear controller.
          // But wait, the standard BlocListener doesn't easily give 'previous' unless we use listenWhen.
          // But I already added 'listenWhen' above!

          if (state.successResponse != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.vehicleAdded), 
                backgroundColor: appColors?.success ?? Colors.green,
              ),
            );
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const AppNavigation()),
              (route) => false,
            );
          } else if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!), 
                backgroundColor: theme.colorScheme.error,
              ),
            );
            context.read<AddVehicleCubit>().clearError();
          }
        },
        child: BlocListener<AddVehicleCubit, AddVehicleState>(
          listenWhen: (prev, curr) => prev.selectedConfig?.id != curr.selectedConfig?.id,
          listener: (context, state) {
            _vehicleNumberController.clear();
            FocusScope.of(context).unfocus();
          },
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: BlocBuilder<AddVehicleCubit, AddVehicleState>(
                      builder: (context, state) {
                        if (state.isLoadingConfig && state.configs.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 100),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Logo ─────────────────────────────────────────────────
                            BlocBuilder<SplashCubit, SplashState>(
                              builder: (context, splashState) =>
                                  _buildLogo(splashState, colorScheme),
                            ),

                            const SizedBox(height: 8),

                            // ── Vehicle Type ──────────────────────────────────────────
                            _sectionLabel(l10n.vehicleType, theme),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: state.configs.map((config) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: _buildVehicleTypeItem(
                                      config: config,
                                      icon: _getVehicleIcon(config.type),
                                      label: _getVehicleLabel(config.type, l10n),
                                      selected: state.selectedConfig?.id == config.id,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // ── Fuel Type ─────────────────────────────────────────────
                            const SizedBox(height: 24),
                            _sectionLabel(l10n.fuelType, theme),
                            state.selectedConfig != null
                                ? SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: state.selectedConfig!.supportedFuelTypes
                                          .map((fuel) {
                                            return Padding(
                                              padding: const EdgeInsets.only(right: 24),
                                              child: _buildFuelTypeItem(
                                                type: fuel,
                                                icon: _getFuelIcon(fuel),
                                                label:
                                                    fuel[0].toUpperCase() +
                                                    fuel.substring(1),
                                                selected: state.selectedFuelType == fuel,
                                              ),
                                            );
                                          })
                                          .toList(),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Text(
                                      "Select vehicle type to see fuel options",
                                      style: TextStyle(
                                        color: theme.hintColor.withOpacity(0.7),
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),

                            const SizedBox(height: 24),

                            // ── Vehicle Make ──────────────────────────────────────────
                            _buildDropdown<VehicleMaker>(
                              label: l10n.vehicleMake,
                              hint: l10n.selectMake,
                              value: state.selectedMaker,
                              items: state.makers,
                              itemLabel: (m) => m.name,
                              isLoading: state.isLoadingMakers,
                              onChanged: state.selectedFuelType == null
                                  ? null
                                  : (val) {
                                      if (val != null) {
                                        context.read<AddVehicleCubit>().selectMaker(val);
                                      }
                                    },
                              onDisabledTap: () {
                                if (state.selectedFuelType == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Please select fuel type first")),
                                  );
                                } else if (state.makers.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(l10n.vehicleMakeListEmpty)),
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 20),

                            // ── Vehicle Model ─────────────────────────────────────────
                            _buildDropdown<VehicleModelInfo>(
                              label: l10n.vehicleModel,
                              hint: l10n.selectModel,
                              value: state.selectedModel,
                              items: state.models,
                              itemLabel: (m) => m.modelName,
                              isLoading: state.isLoadingModels,
                              onChanged: state.selectedMaker == null
                                  ? null
                                  : (val) {
                                      if (val != null) {
                                        context.read<AddVehicleCubit>().selectModel(val);
                                      }
                                    },
                              onDisabledTap: () {
                                if (state.selectedMaker == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Please select vehicle make first")),
                                  );
                                } else if (state.models.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(l10n.vehicleModelListEmpty)),
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 20),

                            // ── Vehicle Number ────────────────────────────────────────
                            CustomFormField(
                              header: l10n.vehicleNumber,
                              hint: l10n.vehicleNumberHint,
                              value: _vehicleNumberController,
                              textCapitalization: TextCapitalization.characters,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return l10n.pleaseEnterVehicleNumber;
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 32),
                          ],
                        );
                      },
                    ),
                  ),
                ),

                // ── Submit Button ─────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                  child: SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: BlocBuilder<AddVehicleCubit, AddVehicleState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: state.isSubmitting
                              ? null
                              : () {
                                  if (_formKey.currentState?.validate() ?? false) {
                                    context.read<AddVehicleCubit>().addVehicle(
                                      vehicleNumber: _vehicleNumberController.text.trim(),
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            backgroundColor: theme.colorScheme.secondary,
                            foregroundColor: theme.colorScheme.onSecondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                            disabledBackgroundColor: theme.colorScheme.secondary.withOpacity(0.6),
                          ),
                          child: state.isSubmitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  l10n.addVehicle,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
