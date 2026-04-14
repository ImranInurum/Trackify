import 'package:equatable/equatable.dart';
import '../../data/models/vehicle_config_models.dart';

class AddVehicleState extends Equatable {
  final List<VehicleConfig> configs;
  final List<VehicleMaker> makers;
  final List<VehicleModelInfo> models;

  final VehicleConfig? selectedConfig;
  final String? selectedFuelType;
  final VehicleMaker? selectedMaker;
  final VehicleModelInfo? selectedModel;

  final bool isLoadingConfig;
  final bool isLoadingMakers;
  final bool isLoadingModels;
  final bool isSubmitting;

  final String? errorMessage;
  final dynamic successResponse;

  const AddVehicleState({
    this.configs = const [],
    this.makers = const [],
    this.models = const [],
    this.selectedConfig,
    this.selectedFuelType,
    this.selectedMaker,
    this.selectedModel,
    this.isLoadingConfig = false,
    this.isLoadingMakers = false,
    this.isLoadingModels = false,
    this.isSubmitting = false,
    this.errorMessage,
    this.successResponse,
  });

  AddVehicleState copyWith({
    List<VehicleConfig>? configs,
    List<VehicleMaker>? makers,
    List<VehicleModelInfo>? models,
    VehicleConfig? selectedConfig,
    String? selectedFuelType,
    VehicleMaker? selectedMaker,
    VehicleModelInfo? selectedModel,
    bool? isLoadingConfig,
    bool? isLoadingMakers,
    bool? isLoadingModels,
    bool? isSubmitting,
    String? errorMessage,
    dynamic successResponse,
    bool clearFuel = false,
    bool clearMaker = false,
    bool clearModel = false,
    bool clearError = false,
  }) {
    return AddVehicleState(
      configs: configs ?? this.configs,
      makers: makers ?? (clearMaker ? [] : this.makers),
      models: models ?? (clearModel ? [] : this.models),
      selectedConfig: selectedConfig ?? this.selectedConfig,
      selectedFuelType: clearFuel ? null : (selectedFuelType ?? this.selectedFuelType),
      selectedMaker: clearMaker ? null : (selectedMaker ?? this.selectedMaker),
      selectedModel: clearModel ? null : (selectedModel ?? this.selectedModel),
      isLoadingConfig: isLoadingConfig ?? this.isLoadingConfig,
      isLoadingMakers: isLoadingMakers ?? this.isLoadingMakers,
      isLoadingModels: isLoadingModels ?? this.isLoadingModels,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successResponse: successResponse ?? this.successResponse,
    );
  }

  @override
  List<Object?> get props => [
    configs,
    makers,
    models,
    selectedConfig,
    selectedFuelType,
    selectedMaker,
    selectedModel,
    isLoadingConfig,
    isLoadingMakers,
    isLoadingModels,
    isSubmitting,
    errorMessage,
    successResponse,
  ];
}
