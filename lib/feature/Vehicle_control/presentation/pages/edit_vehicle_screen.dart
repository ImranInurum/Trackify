import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../add_vehicle_and_device/add_vehicle/data/models/vehicle_config_models.dart';
import '../../../add_vehicle_and_device/add_vehicle/data/repository/add_vehicle_repository_impl.dart';
import '../../../add_vehicle_and_device/add_vehicle/domain/use_case/add_vehicle_use_case.dart';
import '../../../add_vehicle_and_device/add_vehicle/presentation/cubit/add_vehicle_cubit.dart';
import '../../../add_vehicle_and_device/add_vehicle/presentation/cubit/add_vehicle_state.dart';
import '../../domain/entities/vehicle_control_entity.dart';
import '../cubit/vehicle_control_cubit.dart';

class EditVehicleScreen extends StatelessWidget {
  final VehicleControlEntity vehicle;
  const EditVehicleScreen({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddVehicleCubit(
        AddVehicleUseCase(AddVehicleRepositoryImpl()),
      )..fetchVehicleConfig(),
      child: _EditVehicleView(vehicle: vehicle),
    );
  }
}

class _EditVehicleView extends StatefulWidget {
  final VehicleControlEntity vehicle;
  const _EditVehicleView({required this.vehicle});

  @override
  State<_EditVehicleView> createState() => _EditVehicleViewState();
}


class _EditVehicleViewState extends State<_EditVehicleView> {
  late TextEditingController _numberController;
  bool _typeSelected = false;
  bool _makerSelected = false;
  bool _modelSelected = false;

  @override
  void initState() {
    super.initState();
    _numberController = TextEditingController(text: widget.vehicle.vehicleNumber);
  }

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  // STAGE 1: Once configs are loaded, pre-select the matching vehicleType + fuelType
  void _tryPreselectType(AddVehicleState state, AddVehicleCubit cubit) {
    if (_typeSelected) return;
    if (state.configs.isEmpty || state.isLoadingConfig) return;

    final entityType = widget.vehicle.vehicleType.trim().toLowerCase();
    final entityFuel = widget.vehicle.fuelType.trim().toLowerCase();

    VehicleConfig? matchConfig;
    try {
      matchConfig = state.configs.firstWhere(
        (c) => c.type.trim().toLowerCase() == entityType || c.id == widget.vehicle.vehicleType,
      );
    } catch (_) {
      if (state.configs.isNotEmpty) matchConfig = state.configs.first;
    }

    if (matchConfig != null) {
      _typeSelected = true;
      Future.microtask(() {
        // Select type but prevent it from auto-selecting the first fuel to avoid race conditions!
        cubit.selectVehicleType(matchConfig!, autoSelectFuel: false);
        final supportedFuelsLowerCase = matchConfig.supportedFuelTypes.map((e) => e.trim().toLowerCase()).toList();
        final fuelIndex = supportedFuelsLowerCase.indexOf(entityFuel);
        if (fuelIndex != -1) {
          cubit.selectFuelType(matchConfig.supportedFuelTypes[fuelIndex]);
        } else if (matchConfig.supportedFuelTypes.isNotEmpty) {
          cubit.selectFuelType(matchConfig.supportedFuelTypes.first);
        }
      });
    }
  }

  // STAGE 2: Once makers are loaded, pre-select the matching vehicleMaker
  void _tryPreselectMaker(AddVehicleState state, AddVehicleCubit cubit) {
    if (_makerSelected) return;
    if (!_typeSelected) return;
    
    final entityFuel = widget.vehicle.fuelType.trim().toLowerCase();
    if (state.selectedFuelType == null) return;
    if (entityFuel.isNotEmpty && state.selectedFuelType!.trim().toLowerCase() != entityFuel) {
      // If the currently selected fuel doesn't match the entity's fuel, wait for it
      // unless we fell back to the first fuel type because entityFuel was invalid
      final supportedFuels = state.selectedConfig?.supportedFuelTypes.map((e) => e.trim().toLowerCase()).toList() ?? [];
      if (supportedFuels.contains(entityFuel)) {
        return; 
      }
    }

    if (state.isLoadingMakers) return;

    final entityMaker = widget.vehicle.vehicleMaker.trim().toLowerCase();
    VehicleMaker? matchMaker;
    if (entityMaker.isNotEmpty || widget.vehicle.vehicleMaker.isNotEmpty) {
      try {
        matchMaker = state.makers.firstWhere(
          (m) {
            final mName = m.name.trim().toLowerCase();
            final mId = m.id.trim();
            final vMakerOrig = widget.vehicle.vehicleMaker.trim();

            if (mName == entityMaker || mId == vMakerOrig) return true;
            if (entityMaker.isNotEmpty && mName.isNotEmpty && mName.contains(entityMaker)) return true;
            if (entityMaker.isNotEmpty && mName.isNotEmpty && entityMaker.contains(mName)) return true;
            return false;
          }
        );
      } catch (_) {}
    }

    if (matchMaker != null) {
      _makerSelected = true;
      Future.microtask(() => cubit.selectMaker(matchMaker!));
    } else {
      // Maker not found — mark as done to avoid infinite loop
      _makerSelected = true;
      if (widget.vehicle.vehicleMaker.isNotEmpty) {
        // Use a 24-character valid ObjectId to prevent backend CastError
        final dummyMaker = VehicleMaker(id: '000000000000000000000000', name: widget.vehicle.vehicleMaker);
        Future.microtask(() => cubit.selectMaker(dummyMaker));
      }
    }
  }

  // STAGE 3: Once models are loaded, pre-select the matching vehicleModel
  void _tryPreselectModel(AddVehicleState state, AddVehicleCubit cubit) {
    if (_modelSelected) return;
    if (!_makerSelected) return;
    
    final entityMaker = widget.vehicle.vehicleMaker.trim().toLowerCase();
    if (state.selectedMaker == null) return;
    
    bool isCorrectMaker = false;
    final sMakerName = state.selectedMaker!.name.trim().toLowerCase();
    final sMakerId = state.selectedMaker!.id.trim();
    final vMakerOrig = widget.vehicle.vehicleMaker.trim();

    if (sMakerName == entityMaker || 
        sMakerId == vMakerOrig ||
        (entityMaker.isNotEmpty && sMakerName.contains(entityMaker)) ||
        (entityMaker.isNotEmpty && entityMaker.contains(sMakerName))) {
      isCorrectMaker = true;
    }
    
    if (!isCorrectMaker) {
      // User may have manually selected a different maker, skip model preselection
      return;
    }

    if (state.isLoadingModels) return;

    final entityModel = widget.vehicle.vehicleModel.trim().toLowerCase();
    VehicleModelInfo? matchModel;
    if (entityModel.isNotEmpty || widget.vehicle.vehicleModel.isNotEmpty) {
      try {
        matchModel = state.models.firstWhere(
          (m) {
            final mName = m.modelName.trim().toLowerCase();
            final mId = m.id.trim();
            final vModelOrig = widget.vehicle.vehicleModel.trim();

            if (mName == entityModel || mId == vModelOrig) return true;
            if (entityModel.isNotEmpty && mName.isNotEmpty && mName.contains(entityModel)) return true;
            if (entityModel.isNotEmpty && mName.isNotEmpty && entityModel.contains(mName)) return true;
            return false;
          }
        );
      } catch (_) {}
    }

    if (matchModel != null) {
      _modelSelected = true;
      Future.microtask(() => cubit.selectModel(matchModel!));
    } else {
      _modelSelected = true;
      if (widget.vehicle.vehicleModel.isNotEmpty) {
        final dummyModel = VehicleModelInfo(
          id: '000000000000000000000000',
          brandId: state.selectedMaker?.id ?? '',
          modelName: widget.vehicle.vehicleModel,
          vehicleType: state.selectedConfig?.type ?? '',
          fuelType: state.selectedFuelType != null ? [state.selectedFuelType!] : [],
        );
        Future.microtask(() => cubit.selectModel(dummyModel));
      }
    }
  }

  void _runPreselectStages(AddVehicleState state, AddVehicleCubit cubit) {
    _tryPreselectType(state, cubit);
    _tryPreselectMaker(state, cubit);
    _tryPreselectModel(state, cubit);
  }


  IconData _getVehicleIcon(String type) => switch (type.toLowerCase()) {
        '2_wheeler' => Icons.motorcycle_outlined,
        '4_wheeler' => Icons.directions_car_outlined,
        'rikshaw' => Icons.electric_rickshaw_outlined,
        _ => Icons.local_shipping_outlined,
      };

  String _getVehicleLabel(String type, AppLocalizations l10n) =>
      switch (type.toLowerCase()) {
        '2_wheeler' => l10n.twoWheeler,
        '4_wheeler' => l10n.fourWheeler,
        'rikshaw' => l10n.autoRickshaw,
        _ => type
            .replaceAll('_', ' ')
            .split(' ')
            .map((e) => e[0].toUpperCase() + e.substring(1))
            .join(' '),
      };

  IconData _getFuelIcon(String fuel) => switch (fuel.toLowerCase()) {
        'petrol' => Icons.water_drop_rounded,
        'electric' => Icons.bolt_rounded,
        'diesel' => Icons.local_gas_station_rounded,
        'cng' => Icons.eco_rounded,
        _ => Icons.opacity_rounded,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final primaryColor = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.editVehicle,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
      body: BlocConsumer<AddVehicleCubit, AddVehicleState>(
        listener: (context, state) {
          _runPreselectStages(state, context.read<AddVehicleCubit>());
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: theme.colorScheme.error,
              ),
            );
            context.read<AddVehicleCubit>().clearError();
          }
        },
        builder: (context, state) {
          _runPreselectStages(state, context.read<AddVehicleCubit>());

          if (state.isLoadingConfig && state.configs.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Vehicle Type ──────────────────────────────────
                _sectionTitle(l10n.vehicleType, theme),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 20,
                  runSpacing: 16,
                  children: state.configs.map((config) {
                    final isSelected = state.selectedConfig?.id == config.id;
                    return GestureDetector(
                      onTap: () => context.read<AddVehicleCubit>().selectVehicleType(config),
                      child: Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? primaryColor
                                    : theme.colorScheme.onSurface.withValues(alpha: 0.1),
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                _getVehicleIcon(config.type),
                                color: isSelected
                                    ? primaryColor
                                    : theme.colorScheme.onSurface.withValues(alpha: 0.3),
                                size: 24,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _getVehicleLabel(config.type, l10n),
                            style: TextStyle(
                              fontSize: 10,
                              color: isSelected
                                  ? primaryColor
                                  : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 32),

                // ── Fuel Type ─────────────────────────────────────
                _sectionTitle(l10n.fuelType, theme),
                const SizedBox(height: 16),
                state.selectedConfig != null
                    ? Wrap(
                        spacing: 20,
                        runSpacing: 16,
                        children: state.selectedConfig!.supportedFuelTypes.map((fuel) {
                          final isSelected = state.selectedFuelType == fuel;
                          return GestureDetector(
                            onTap: () => context.read<AddVehicleCubit>().selectFuelType(fuel),
                            child: Column(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? primaryColor
                                          : theme.colorScheme.onSurface.withValues(alpha: 0.1),
                                      width: isSelected ? 1.5 : 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      _getFuelIcon(fuel),
                                      color: isSelected
                                          ? primaryColor
                                          : theme.colorScheme.onSurface.withValues(alpha: 0.3),
                                      size: 24,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  fuel[0].toUpperCase() + fuel.substring(1),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isSelected
                                        ? primaryColor
                                        : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      )
                    : Text(
                        "Select vehicle type to see fuel options",
                        style: TextStyle(
                          color: theme.hintColor,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),

                const SizedBox(height: 32),

                // ── Vehicle Make ──────────────────────────────────
                _sectionTitle(l10n.vehicleMake, theme),
                const SizedBox(height: 12),
                _buildDropdown<VehicleMaker>(
                  context: context,
                  theme: theme,
                  isDark: isDark,
                  value: state.selectedMaker,
                  items: state.makers,
                  labelBuilder: (m) => m.name,
                  hint: state.isLoadingMakers
                      ? "Loading..."
                      : (state.makers.isEmpty
                          ? "Select fuel type first"
                          : l10n.selectMake),
                  onChanged: state.makers.isEmpty || state.isLoadingMakers
                      ? null
                      : (val) {
                          if (val != null) context.read<AddVehicleCubit>().selectMaker(val);
                        },
                  trailing: state.isLoadingMakers
                      ? SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            color: primaryColor,
                          ),
                        )
                      : null,
                ),

                const SizedBox(height: 24),

                // ── Vehicle Model ─────────────────────────────────
                _sectionTitle(l10n.vehicleModel, theme),
                const SizedBox(height: 12),
                _buildDropdown<VehicleModelInfo>(
                  context: context,
                  theme: theme,
                  isDark: isDark,
                  value: state.selectedModel,
                  items: state.models,
                  labelBuilder: (m) => m.modelName,
                  hint: state.isLoadingModels
                      ? "Loading..."
                      : (state.models.isEmpty
                          ? (state.selectedMaker == null ? "Select make first" : "No models available")
                          : l10n.selectModel),
                  onChanged: state.models.isEmpty || state.isLoadingModels
                      ? null
                      : (val) {
                          if (val != null) context.read<AddVehicleCubit>().selectModel(val);
                        },
                  trailing: state.isLoadingModels
                      ? SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            color: primaryColor,
                          ),
                        )
                      : null,
                ),

                const SizedBox(height: 24),

                // ── Vehicle Number ────────────────────────────────
                _sectionTitle(l10n.vehicleNumber, theme),
                const SizedBox(height: 12),
                _buildTextField(_numberController, l10n.vehicleNumberHint, theme, isDark),

                const SizedBox(height: 48),

                // ── Save Button ───────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      final fuelType = state.selectedFuelType ?? widget.vehicle.fuelType;
                      
                      final makerName = state.selectedMaker?.name ?? widget.vehicle.vehicleMaker;
                      final modelName = state.selectedModel?.modelName ?? widget.vehicle.vehicleModel;
                      
                      final vehicleName = (makerName.isNotEmpty && modelName.isNotEmpty) 
                          ? '$makerName $modelName' 
                          : (modelName.isNotEmpty ? modelName : widget.vehicle.vehicleName);

                      context.read<VehicleControlCubit>().updateVehicleDetails(
                            vehicleIMEI: widget.vehicle.id,
                            vehicleName: vehicleName,
                            vehicleNumber: _numberController.text.trim(),
                            fuelType: fuelType,
                            vehicleType: state.selectedConfig?.type ?? widget.vehicle.vehicleType,
                            vehicleMaker: makerName,
                            vehicleModel: modelName,
                            brandId: state.selectedMaker?.id ?? '',
                            modelId: state.selectedModel?.id ?? '',
                          );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: Text(
                      l10n.updateVehicle,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _sectionTitle(String title, ThemeData theme) => Text(
        title,
        style: TextStyle(
          fontSize: 15,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          fontWeight: FontWeight.w500,
        ),
      );

  Widget _buildDropdown<T>({
    required BuildContext context,
    required ThemeData theme,
    required bool isDark,
    required T? value,
    required List<T> items,
    required String Function(T) labelBuilder,
    required String hint,
    required ValueChanged<T?>? onChanged,
    Widget? trailing,
  }) {
    final uniqueItems = items.toSet().toList();
    if (value != null && !uniqueItems.contains(value)) {
      uniqueItems.add(value);
    }
    final safeValue = value;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.onSurface.withValues(alpha: 0.05)
            : theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                value: safeValue,
                isExpanded: true,
                dropdownColor: theme.cardColor,
                icon: trailing ??
                    Icon(Icons.arrow_drop_down, color: theme.colorScheme.primary),
                hint: Text(
                  hint,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    fontSize: 14,
                  ),
                ),
                items: uniqueItems.map((item) {
                  return DropdownMenuItem<T>(
                    value: item,
                    child: Text(
                      labelBuilder(item),
                      style: TextStyle(
                        fontSize: 15,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hint, ThemeData theme, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.onSurface.withValues(alpha: 0.05)
            : theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
      ),
      child: TextField(
        controller: controller,
        textCapitalization: TextCapitalization.characters,
        style: TextStyle(fontSize: 15, color: theme.colorScheme.onSurface),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:
              TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
