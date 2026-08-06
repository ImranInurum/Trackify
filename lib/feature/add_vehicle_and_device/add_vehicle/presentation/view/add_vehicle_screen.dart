import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/feature/add_vehicle_and_device/add_vehicle/data/models/vehicle_config_models.dart';

import '../../../../../app/app_navigation.dart';
import '../../../../map/presentation/cubit/map_cubit.dart';
import '../../../../profile/presentation/cubit/profile_cubit.dart';
import '../../../../../core/theme/app_theme_extension.dart';
import '../../../../../l10n/app_localizations.dart';
import '../cubit/add_vehicle_cubit.dart';
import '../cubit/add_vehicle_state.dart';
import '../widgets/vehicle_number_field.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';

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

  // ─── Vehicle-type circular chip ────────────────────────────────────────────
  Widget _buildVehicleTypeItem({
    required VehicleConfig config,
    required IconData icon,
    required String label,
    required bool selected,
  }) {
    final theme = Theme.of(context);
    final Color active = theme.colorScheme.secondary;
    final Color inactive = theme.colorScheme.onSurface.withValues(alpha: 0.5);

    return GestureDetector(
      onTap: () => context.read<AddVehicleCubit>().selectVehicleType(config),
      child: SizedBox(
        width: 75,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? active : inactive,
                  width: selected ? 2 : 1.5,
                ),
                color: selected
                    ? active.withValues(alpha: 0.06)
                    : Colors.transparent,
              ),
              child: Icon(icon, color: selected ? active : inactive, size: 22),
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
    final Color inactive = theme.colorScheme.onSurface.withValues(alpha: 0.5);

    return GestureDetector(
      onTap: () => context.read<AddVehicleCubit>().selectFuelType(type),
      child: SizedBox(
        width: 75,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? active : inactive,
                  width: selected ? 2 : 1.5,
                ),
                color: selected
                    ? active.withValues(alpha: 0.06)
                    : Colors.transparent,
              ),
              child: Icon(icon, color: selected ? active : inactive, size: 22),
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
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            if (isLoading)
              SizedBox(
                height: 12,
                width: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: theme.colorScheme.primary,
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: (onChanged == null || items.isEmpty) && !isLoading
              ? onDisabledTap
              : null,
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.12),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Theme(
              data: theme.copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<T>(
                  dropdownColor: theme.scaffoldBackgroundColor,
                  value: value,
                  isExpanded: true,
                  isDense: true,
                  focusColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  elevation: 4,
                  hint: Text(
                    hint ?? label,
                    style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      fontSize: 14,
                    ),
                  ),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: theme.colorScheme.primary,
                  ),
                  items: items
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            itemLabel(e),
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: isLoading ? null : onChanged,
                ),
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
    final t = type.toLowerCase();
    if (t.contains('2') ||
        t.contains('two') ||
        t.contains('bike') ||
        t.contains('scooter') ||
        t.contains('motor') ||
        t.contains('moped')) {
      return Icons.two_wheeler_rounded;
    } else if (t.contains('3') ||
        t.contains('rickshaw') ||
        t.contains('rikshaw') ||
        t.contains('auto')) {
      return Icons.electric_rickshaw_rounded;
    } else if (t.contains('bus')) {
      return Icons.directions_bus_rounded;
    } else if (t.contains('van') ||
        t.contains('tempo') ||
        t.contains('traveller')) {
      return Icons.airport_shuttle_rounded;
    } else if (t.contains('truck') ||
        t.contains('lorry') ||
        t.contains('heavy') ||
        t.contains('pickup') ||
        t.contains('lcv') ||
        t.contains('hcv')) {
      return Icons.local_shipping_rounded;
    } else if (t.contains('tractor') || t.contains('earth')) {
      return Icons.agriculture_rounded;
    } else if (t.contains('boat') || t.contains('ship')) {
      return Icons.directions_boat_rounded;
    } else if (t.contains('car') ||
        t.contains('suv') ||
        t.contains('four') ||
        t.contains('4')) {
      return Icons.directions_car_rounded;
    } else if (t.contains('commercial ev') || t.contains('ev')) {
      return Icons.electric_car_rounded;
    } else {
      return Icons.commute_rounded; // Generic vehicle icon fallback
    }
  }

  String _getVehicleLabel(String type, AppLocalizations l10n) {
    final t = type.toLowerCase().trim();
    if (t == 'bike') {
      return l10n.bike;
    } else if (t == 'auto rickshaw') {
      return l10n.autoRickshaw;
    }

    if (type.isNotEmpty &&
        type[0] == type[0].toUpperCase() &&
        !type.contains('_')) {
      return type;
    }

    return type
        .replaceAll('_', ' ')
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0].toUpperCase() + e.substring(1) : '')
        .join(' ')
        .trim();
  }

  IconData _getFuelIcon(String fuel) {
    final f = fuel.toLowerCase();
    if (f.contains('petrol') || f.contains('gasoline')) {
      return Icons.water_drop_rounded;
    } else if (f.contains('electric') ||
        f.contains('ev') ||
        f.contains('battery')) {
      return Icons.bolt_rounded;
    } else if (f.contains('diesel')) {
      return Icons.local_gas_station_rounded;
    } else if (f.contains('cng') || f.contains('gas') || f.contains('lpg')) {
      return Icons.eco_rounded;
    } else if (f.contains('flex')) {
      return Icons.local_gas_station_rounded;
    } else if (f.contains('hybrid')) {
      return Icons.compare_arrows_rounded;
    } else {
      return Icons.opacity_rounded;
    }
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
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: theme.colorScheme.onSurface,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.addVehicle, ),
      ),
      body: BlocListener<AddVehicleCubit, AddVehicleState>(
        listenWhen: (previous, current) =>
            previous.selectedConfig?.id != current.selectedConfig?.id ||
            previous.successResponse != current.successResponse ||
            previous.errorMessage != current.errorMessage,
        listener: (context, state) async {
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

            await Future.wait([
              context.read<ProfileCubit>().fetchVehicles(),
              context.read<MapCubit>().fetchVehicles(),
            ]);

            if (!context.mounted) return;

            Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
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
          listenWhen: (prev, curr) =>
              prev.selectedConfig?.id != curr.selectedConfig?.id,
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
                            child: Center(child: TrackifyLoader()),
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),

                            // ── Vehicle Type ──────────────────────────────────────────
                            _sectionLabel(l10n.vehicleType, theme),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: state.configs.map((config) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 4),
                                    child: _buildVehicleTypeItem(
                                      config: config,
                                      icon: _getVehicleIcon(config.type),
                                      label: _getVehicleLabel(
                                        config.type,
                                        l10n,
                                      ),
                                      selected:
                                          state.selectedConfig?.id == config.id,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: state
                                          .selectedConfig!
                                          .supportedFuelTypes
                                          .map((fuel) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                right: 4,
                                              ),
                                              child: _buildFuelTypeItem(
                                                type: fuel,
                                                icon: _getFuelIcon(fuel),
                                                label: fuel.isNotEmpty
                                                    ? fuel[0].toUpperCase() +
                                                          fuel.substring(1)
                                                    : fuel,
                                                selected:
                                                    state.selectedFuelType ==
                                                    fuel,
                                              ),
                                            );
                                          })
                                          .toList(),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Text(
                                      l10n.selectVehicleTypeForFuel,
                                      style: TextStyle(color: theme.hintColor.withValues(alpha: 0.7),
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
                                        context
                                            .read<AddVehicleCubit>()
                                            .selectMaker(val);
                                      }
                                    },
                              onDisabledTap: () {
                                if (state.selectedFuelType == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        l10n.pleaseSelectFuelTypeFirst,
                                      ),
                                    ),
                                  );
                                } else if (state.makers.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.vehicleMakeListEmpty),
                                    ),
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
                                        context
                                            .read<AddVehicleCubit>()
                                            .selectModel(val);
                                      }
                                    },
                              onDisabledTap: () {
                                if (state.selectedMaker == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        l10n.pleaseSelectVehicleMakeFirst,
                                      ),
                                    ),
                                  );
                                } else if (state.models.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.vehicleModelListEmpty),
                                    ),
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 20),

                            // ── Vehicle Number ────────────────────────────────────────
                            VehicleNumberField(
                              controller: _vehicleNumberController,
                            ),

                            const SizedBox(height: 32),
                          ],
                        );
                      },
                    ),
                  ),
                ),

                // ── Submit Button ─────────────────────────────────────────────────
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 42,
                      child: BlocBuilder<AddVehicleCubit, AddVehicleState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: state.isSubmitting
                                ? null
                                : () {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      context.read<AddVehicleCubit>().addVehicle(
                                        vehicleNumber: _vehicleNumberController
                                            .text
                                            .trim(),
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
                              disabledBackgroundColor: theme.colorScheme.secondary
                                  .withValues(alpha: 0.6),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
