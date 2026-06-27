import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/shared_preferences.dart';
import '../../data/models/add_vehicle_request.dart';
import '../../data/models/vehicle_config_models.dart';
import '../../domain/use_case/add_vehicle_use_case.dart';
import 'add_vehicle_state.dart';

class AddVehicleCubit extends Cubit<AddVehicleState> {
  final AddVehicleUseCase _addVehicleUseCase;

  AddVehicleCubit(this._addVehicleUseCase) : super(const AddVehicleState());

  Future<void> fetchVehicleConfig() async {
    emit(state.copyWith(isLoadingConfig: true, clearError: true));
    final result = await _addVehicleUseCase.getVehicleConfig();

    result.fold(
      (failure) => emit(
        state.copyWith(isLoadingConfig: false, errorMessage: failure.message),
      ),
      (success) {
        final List<dynamic> data = success['data'] ?? [];
        final configs = data.map((e) => VehicleConfig.fromJson(e)).toList();
        emit(state.copyWith(isLoadingConfig: false, configs: configs));

        // Auto-select first vehicle type if nothing is selected yet
        if (configs.isNotEmpty && state.selectedConfig == null) {
          selectVehicleType(configs.first);
        }
      },
    );
  }

  void selectVehicleType(VehicleConfig config, {bool autoSelectFuel = true}) {
    emit(
      state.copyWith(
        selectedConfig: config,
        clearFuel: true,
        clearMaker: true,
        clearModel: true,
        clearError: true,
      ),
    );

    // Auto-select first fuel type
    if (autoSelectFuel && config.supportedFuelTypes.isNotEmpty) {
      selectFuelType(config.supportedFuelTypes.first);
    }
  }

  void selectFuelType(String fuelType) {
    emit(
      state.copyWith(
        selectedFuelType: fuelType,
        clearMaker: true,
        clearModel: true,
        clearError: true,
        isLoadingMakers: true,
      ),
    );

    _getMakers(fuelType);
  }

  Future<void> _getMakers(String fuelType) async {
    final result = await _addVehicleUseCase.getVehicleMakers(
      vehicleType: state.selectedConfig?.type ?? '',
      fuelType: fuelType,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(isLoadingMakers: false, errorMessage: failure.message),
      ),
      (success) {
        final List<dynamic> data = success['data'] ?? [];
        final makers = data.map((e) => VehicleMaker.fromJson(e)).toList();
        emit(state.copyWith(makers: makers, isLoadingMakers: false));
      },
    );
  }

  Future<void> selectMaker(VehicleMaker maker) async {
    emit(
      state.copyWith(
        selectedMaker: maker,
        isLoadingModels: true,
        clearModel: true,
        clearError: true,
      ),
    );

    final result = await _addVehicleUseCase.getVehicleModels(
      vehicleType: state.selectedConfig?.type ?? '',
      fuelType: state.selectedFuelType ?? '',
      brandId: maker.id,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(isLoadingModels: false, errorMessage: failure.message),
      ),
      (success) {
        final List<dynamic> data = success['data'] ?? [];
        final models = data.map((e) => VehicleModelInfo.fromJson(e)).toList();
        emit(state.copyWith(models: models, isLoadingModels: false));
      },
    );
  }

  void selectModel(VehicleModelInfo model) {
    emit(state.copyWith(selectedModel: model, clearError: true));
  }

  Future<void> addVehicle({required String vehicleNumber}) async {
    if (state.selectedConfig == null ||
        state.selectedFuelType == null ||
        state.selectedMaker == null ||
        state.selectedModel == null) {
      emit(state.copyWith(errorMessage: "Please select all fields"));
      return;
    }

    emit(state.copyWith(isSubmitting: true, clearError: true));

    final userId = await AppPreference.instance.get(
      key: AppPreference.KEY_USER_ID,
    );

    final request = AddVehicleRequest(
      vehicleType: state.selectedConfig!.type,
      fuelType: state.selectedFuelType!,
      brandId: state.selectedMaker!.id,
      vehicleNumber: vehicleNumber,
      modelId: state.selectedModel!.id,
      userId: userId,
    );

    final result = await _addVehicleUseCase.addVehicle(request: request);

    result.fold(
      (failure) => emit(
        state.copyWith(isSubmitting: false, errorMessage: failure.message),
      ),
      (success) =>
          emit(state.copyWith(isSubmitting: false, successResponse: success)),
    );
  }

  void clearError() {
    emit(state.copyWith(clearError: true));
  }

  void reset() {
    emit(const AddVehicleState());
  }
}
