import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import '../../domain/repositories/vehicle_control_repository.dart';
import '../state/vehicle_control_state.dart';

class VehicleControlCubit extends Cubit<VehicleControlState> {
  final VehicleControlRepository repository;

  VehicleControlCubit(this.repository) : super(VehicleControlInitial());

  Future<void> loadVehicleDetails([String? vehicleIMEI]) async {
    emit(VehicleControlLoading());
    try {
      final actualIMEI = (vehicleIMEI == null || vehicleIMEI.isEmpty)
          ? await AppPreference.instance.get(key: AppPreference.IMEI)
          : vehicleIMEI;
      final vehicle = await repository.getVehicleControlDetails(actualIMEI);
      emit(VehicleControlLoaded(
        vehicle: vehicle,
        tempIcon: vehicle.selectedIcon,
        tempColor: vehicle.selectedColor,
      ));
    } on VehicleNotFoundException catch (e) {
      emit(VehicleControlLoaded(
        vehicle: e.fallbackVehicle,
        tempIcon: e.fallbackVehicle.selectedIcon,
        tempColor: e.fallbackVehicle.selectedColor,
        actionError: e.message,
      ));
    } catch (e) {
      emit(VehicleControlError(e.toString()));
    }
  }

  void updateLocalIcon(String icon) {
    if (state is VehicleControlLoaded) {
      final currentState = state as VehicleControlLoaded;
      emit(currentState.copyWith(tempIcon: icon));
    }
  }

  void updateLocalColor(String color) {
    if (state is VehicleControlLoaded) {
      final currentState = state as VehicleControlLoaded;
      emit(currentState.copyWith(tempColor: color));
    }
  }

  Future<void> saveChanges(String vehicleIMEI) async {
    final currentState = state;
    if (currentState is VehicleControlLoaded) {
      try {
        await repository.updateVehicleIcon(vehicleIMEI, currentState.tempIcon);
        await repository.updateVehicleColor(vehicleIMEI, currentState.tempColor);
        loadVehicleDetails(vehicleIMEI);
      } catch (e) {
        emit(currentState.copyWith(actionError: e.toString()));
      }
    }
  }

  Future<void> updateTankCapacity(String vehicleIMEI, String capacity) async {
    final currentState = state;
    try {
      await repository.updateTankCapacity(vehicleIMEI, capacity);
      loadVehicleDetails(vehicleIMEI);
    } catch (e) {
      if (currentState is VehicleControlLoaded) {
        emit(currentState.copyWith(actionError: e.toString()));
      } else {
        emit(VehicleControlError(e.toString()));
      }
    }
  }

  Future<void> updateMileage(String vehicleIMEI, String mileage) async {
    final currentState = state;
    try {
      await repository.updateMileage(vehicleIMEI, mileage);
      loadVehicleDetails(vehicleIMEI);
    } catch (e) {
      if (currentState is VehicleControlLoaded) {
        emit(currentState.copyWith(actionError: e.toString()));
      } else {
        emit(VehicleControlError(e.toString()));
      }
    }
  }

  Future<void> updateVehicleDetails(String vehicleIMEI, String name, String number, String fuelType) async {
    final currentState = state;
    try {
      await repository.updateVehicleDetails(vehicleIMEI, name, number, fuelType);
      loadVehicleDetails(vehicleIMEI);
    } catch (e) {
      if (currentState is VehicleControlLoaded) {
        emit(currentState.copyWith(actionError: e.toString()));
      } else {
        emit(VehicleControlError(e.toString()));
      }
    }
  }

  Future<void> updateVehicleImage(String vehicleIMEI, String imagePath) async {
    final currentState = state;
    try {
      await repository.updateVehicleImage(vehicleIMEI, imagePath);
      loadVehicleDetails(vehicleIMEI);
    } catch (e) {
      if (currentState is VehicleControlLoaded) {
        emit(currentState.copyWith(actionError: e.toString()));
      } else {
        emit(VehicleControlError(e.toString()));
      }
    }
  }

  Future<void> updateVehicleLock(String vehicleIMEI, bool lockState) async {
    final currentState = state;
    try {
      await repository.updateVehicleLock(vehicleIMEI, lockState);
      loadVehicleDetails(vehicleIMEI);
    } catch (e) {
      if (currentState is VehicleControlLoaded) {
        emit(currentState.copyWith(actionError: e.toString()));
      } else {
        emit(VehicleControlError(e.toString()));
      }
    }
  }

  Future<void> deleteVehicle(String vehicleIMEI) async {
    final currentState = state;
    try {
      emit(VehicleControlLoading());
      await repository.deleteVehicle(vehicleIMEI);
      emit(const VehicleControlDeleted());
    } catch (e) {
      if (currentState is VehicleControlLoaded) {
        emit(currentState.copyWith(actionError: e.toString()));
      } else {
        emit(VehicleControlError(e.toString()));
      }
    }
  }
}
