import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/config/font_manager.dart';
import 'package:trackify/core/widgets/searchable_dropdown.dart';
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

  bool _isBikeConfig(VehicleConfig c) {
    final t = c.type.toLowerCase();
    return t.contains('bike') ||
        t.contains('2') ||
        t.contains('two') ||
        t.contains('motorcycle') ||
        t.contains('scooter') ||
        t.contains('moped');
  }

  List<VehicleConfig> _getSortedConfigs(List<VehicleConfig> configs) {
    final sorted = List<VehicleConfig>.from(configs);
    sorted.sort((a, b) {
      final aBike = _isBikeConfig(a);
      final bBike = _isBikeConfig(b);
      if (aBike && !bBike) return -1;
      if (!aBike && bBike) return 1;
      return 0;
    });
    return sorted;
  }

  // ─── Vehicle-type circular/rounded card ─────────────────────────────────────
  Widget _buildVehicleTypeItem({
    required VehicleConfig config,
    required IconData icon,
    required String label,
    required bool selected,
    required bool isDark,
    required ColorScheme colorScheme,
  }) {
    const Color activeAccent = Color(0xFF0284C7);
    final Color inactiveBg = isDark
        ? colorScheme.onSurface.withOpacity(0.06)
        : const Color(0xFFF8FAFC);
    final Color inactiveBorder = isDark
        ? colorScheme.outline.withOpacity(0.2)
        : const Color(0xFFE2E8F0);
    final Color inactiveIcon = colorScheme.onSurface.withOpacity(0.55);

    return GestureDetector(
      onTap: () => context.read<AddVehicleCubit>().selectVehicleType(config),
      child: Container(
        width: 82,
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE0F2FE) : inactiveBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? activeAccent : inactiveBorder,
            width: selected ? 1.8 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: selected ? activeAccent : inactiveIcon,
              size: 24,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: selected ? activeAccent : inactiveIcon,
                fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                fontFamily: FontFamilyManager.fontFamily,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // ─── Fuel-type circular/rounded card ────────────────────────────────────────
  Widget _buildFuelTypeItem({
    required String type,
    required IconData icon,
    required String label,
    required bool selected,
    required bool isDark,
    required ColorScheme colorScheme,
  }) {
    const Color activeAccent = Color(0xFF0284C7);
    final Color inactiveBg = isDark
        ? colorScheme.onSurface.withOpacity(0.06)
        : const Color(0xFFF8FAFC);
    final Color inactiveBorder = isDark
        ? colorScheme.outline.withOpacity(0.2)
        : const Color(0xFFE2E8F0);
    final Color inactiveIcon = colorScheme.onSurface.withOpacity(0.55);

    return GestureDetector(
      onTap: () => context.read<AddVehicleCubit>().selectFuelType(type),
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE0F2FE) : inactiveBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? activeAccent : inactiveBorder,
            width: selected ? 1.8 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: selected ? activeAccent : inactiveIcon,
              size: 24,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: selected ? activeAccent : inactiveIcon,
                fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                fontFamily: FontFamilyManager.fontFamily,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }


  // ─── Section label ─────────────────────────────────────────────────────────
  Widget _sectionLabel(String text, ThemeData theme) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: theme.colorScheme.onSurface,
            fontFamily: FontFamilyManager.fontFamily,
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
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final appColors = theme.extension<AppColorsExtension>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: colorScheme.onSurface,
            size: 18,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.addVehicle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: FontFamilyManager.fontFamily,
            color: colorScheme.onSurface,
          ),
        ),
      ),
      body: BlocListener<AddVehicleCubit, AddVehicleState>(
        listenWhen: (previous, current) =>
            previous.selectedConfig?.id != current.selectedConfig?.id ||
            previous.successResponse != current.successResponse ||
            previous.errorMessage != current.errorMessage,
        listener: (context, state) async {
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

                        /// SORT CONFIGS SO THAT "BIKE" IS ALWAYS FIRST!
                        final sortedConfigs = _getSortedConfigs(state.configs);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),

                            // ── Vehicle Type ──────────────────────────────────────────
                            _sectionLabel(l10n.vehicleType, theme),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: sortedConfigs.map((config) {
                                  return _buildVehicleTypeItem(
                                    config: config,
                                    icon: _getVehicleIcon(config.type),
                                    label: _getVehicleLabel(
                                      config.type,
                                      l10n,
                                    ),
                                    selected:
                                        state.selectedConfig?.id == config.id,
                                    isDark: isDark,
                                    colorScheme: colorScheme,
                                  );
                                }).toList(),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // ── Fuel Type ─────────────────────────────────────────────
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
                                            return _buildFuelTypeItem(
                                              type: fuel,
                                              icon: _getFuelIcon(fuel),
                                              label: fuel.isNotEmpty
                                                  ? fuel[0].toUpperCase() +
                                                        fuel.substring(1)
                                                  : fuel,
                                              selected:
                                                  state.selectedFuelType ==
                                                  fuel,
                                              isDark: isDark,
                                              colorScheme: colorScheme,
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
                                        color: theme.hintColor.withOpacity(0.7),
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),

                            const SizedBox(height: 24),

                            // ── Vehicle Make ──────────────────────────────────────────
                            SearchableDropdown<VehicleMaker>(
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
                            const SizedBox(height: 18),

                            // ── Vehicle Model ─────────────────────────────────────────
                            SearchableDropdown<VehicleModelInfo>(
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
                            const SizedBox(height: 18),

                            // ── Vehicle Number ────────────────────────────────────────
                            VehicleNumberField(
                              controller: _vehicleNumberController,
                            ),

                            const SizedBox(height: 28),
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
                    child: BlocBuilder<AddVehicleCubit, AddVehicleState>(
                      builder: (context, state) {
                        return GestureDetector(
                          onTap: state.isSubmitting
                              ? null
                              : () {
                                  if (_formKey.currentState?.validate() ?? false) {
                                    context.read<AddVehicleCubit>().addVehicle(
                                      vehicleNumber: _vehicleNumberController.text.trim(),
                                    );
                                  }
                                },
                          child: Container(
                            height: 48,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF0284C7),
                                  Color(0xFF0369A1),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF0284C7).withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Center(
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
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
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
