import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/widgets/searchable_dropdown.dart';
import 'package:trackify/feature/add_vehicle_and_device/add_vehicle/data/models/vehicle_config_models.dart';

import 'package:trackify/core/theme/app_theme_extension.dart';
import 'package:trackify/l10n/app_localizations.dart';
import 'package:trackify/feature/add_vehicle_and_device/add_vehicle/presentation/cubit/add_vehicle_cubit.dart';
import 'package:trackify/feature/add_vehicle_and_device/add_vehicle/presentation/cubit/add_vehicle_state.dart';
import 'package:trackify/feature/add_vehicle_and_device/add_vehicle/presentation/widgets/vehicle_number_field.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';

class AddVehicleDialog extends StatefulWidget {
  const AddVehicleDialog({super.key});

  @override
  State<AddVehicleDialog> createState() => _AddVehicleDialogState();
}

class _AddVehicleDialogState extends State<AddVehicleDialog> {
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

  Widget _buildVehicleTypeItem({
    required VehicleConfig config,
    required IconData icon,
    required String label,
    required bool selected,
  }) {
    final theme = Theme.of(context);
    final Color active = theme.colorScheme.secondary;
    final Color inactive = theme.colorScheme.onSurface.withOpacity( 0.5);

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
                color: selected ? active.withOpacity( 0.06) : Colors.transparent,
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

  Widget _buildFuelTypeItem({
    required String type,
    required IconData icon,
    required String label,
    required bool selected,
  }) {
    final theme = Theme.of(context);
    final Color active = theme.colorScheme.secondary;
    final Color inactive = theme.colorScheme.onSurface.withOpacity( 0.5);

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
                color: selected ? active.withOpacity( 0.06) : Colors.transparent,
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
    return SearchableDropdown<T>(
      label: label,
      value: value,
      items: items,
      itemLabel: itemLabel,
      onChanged: onChanged,
      isLoading: isLoading,
      hint: hint,
      onDisabledTap: onDisabledTap,
    );
  }

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
    if (t.contains('2') || t.contains('two') || t.contains('bike') || t.contains('scooter') || t.contains('motor') || t.contains('moped')) {
      return Icons.two_wheeler_rounded;
    } else if (t.contains('3') || t.contains('rickshaw') || t.contains('rikshaw') || t.contains('auto')) {
      return Icons.electric_rickshaw_rounded;
    } else if (t.contains('bus')) {
      return Icons.directions_bus_rounded;
    } else if (t.contains('van') || t.contains('tempo') || t.contains('traveller')) {
      return Icons.airport_shuttle_rounded;
    } else if (t.contains('truck') || t.contains('lorry') || t.contains('heavy') || t.contains('pickup') || t.contains('lcv') || t.contains('hcv')) {
      return Icons.local_shipping_rounded;
    } else if (t.contains('tractor') || t.contains('earth')) {
      return Icons.agriculture_rounded;
    } else if (t.contains('boat') || t.contains('ship')) {
      return Icons.directions_boat_rounded;
    } else if (t.contains('car') || t.contains('suv') || t.contains('four') || t.contains('4')) {
      return Icons.directions_car_rounded;
    } else if (t.contains('commercial ev') || t.contains('ev')) {
      return Icons.electric_car_rounded;
    } else {
      return Icons.commute_rounded; 
    }
  }

  String _getVehicleLabel(String type, AppLocalizations l10n) {
    final t = type.toLowerCase().trim();
    if (t == 'bike') {
      return l10n.bike;
    } else if (t == 'auto rickshaw') {
      return l10n.autoRickshaw;
    }
    
    if (type.isNotEmpty && type[0] == type[0].toUpperCase() && !type.contains('_')) {
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
    } else if (f.contains('electric') || f.contains('ev') || f.contains('battery')) {
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final appColors = theme.extension<AppColorsExtension>();

    return BlocListener<AddVehicleCubit, AddVehicleState>(
      listenWhen: (previous, current) =>
          previous.selectedConfig?.id != current.selectedConfig?.id ||
          previous.successResponse != current.successResponse ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.successResponse != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.vehicleAdded), 
              backgroundColor: appColors?.success ?? Colors.green,
            ),
          );
          Navigator.of(context).pop(true);
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
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: theme.scaffoldBackgroundColor,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 700),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.addVehicle,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: SingleChildScrollView(
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
                                          label: _getVehicleLabel(config.type, l10n),
                                          selected: state.selectedConfig?.id == config.id,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),

                                const SizedBox(height: 24),

                                _sectionLabel(l10n.fuelType, theme),
                                state.selectedConfig != null
                                    ? SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: state.selectedConfig!.supportedFuelTypes
                                              .map((fuel) {
                                                return Padding(
                                                  padding: const EdgeInsets.only(right: 4),
                                                  child: _buildFuelTypeItem(
                                                    type: fuel,
                                                    icon: _getFuelIcon(fuel),
                                                    label: fuel.isNotEmpty
                                                        ? fuel[0].toUpperCase() + fuel.substring(1)
                                                        : fuel,
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
                                          l10n.selectVehicleTypeForFuel,
                                          style: TextStyle(
                                            color: theme.hintColor.withOpacity( 0.7),
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),

                                const SizedBox(height: 24),

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
                                        SnackBar(content: Text(l10n.pleaseSelectFuelTypeFirst)),
                                      );
                                    } else if (state.makers.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(l10n.vehicleMakeListEmpty)),
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(height: 20),

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
                                        SnackBar(content: Text(l10n.pleaseSelectVehicleMakeFirst)),
                                      );
                                    } else if (state.models.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(l10n.vehicleModelListEmpty)),
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(height: 20),

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

                    SizedBox(
                      width: double.infinity,
                      height: 48,
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
                              backgroundColor: theme.colorScheme.secondary,
                              foregroundColor: theme.colorScheme.onSecondary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
