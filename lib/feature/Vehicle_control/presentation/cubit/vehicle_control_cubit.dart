import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/vehicle_control_repository.dart';
import '../state/vehicle_control_state.dart';

class VehicleControlCubit extends Cubit<VehicleControlState> {
  final VehicleControlRepository repository;

  VehicleControlCubit(this.repository) : super(VehicleControlInitial());

  Future<void> loadVehicleDetails(String vehicleId) async {
    emit(VehicleControlLoading());
    try {
      final vehicle = await repository.getVehicleControlDetails(vehicleId);
      emit(VehicleControlLoaded(
        vehicle: vehicle,
        tempIcon: vehicle.selectedIcon,
        tempColor: vehicle.selectedColor,
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

  Future<void> saveChanges(String vehicleId) async {
    if (state is VehicleControlLoaded) {
      final currentState = state as VehicleControlLoaded;
      
      try {
        await repository.updateVehicleIcon(vehicleId, currentState.tempIcon);
        await repository.updateVehicleColor(vehicleId, currentState.tempColor);
        loadVehicleDetails(vehicleId);
      } catch (e) {
        emit(VehicleControlError(e.toString()));
      }
    }
  }

  Future<void> updateTankCapacity(String vehicleId, String capacity) async {
    try {
      await repository.updateTankCapacity(vehicleId, capacity);
      loadVehicleDetails(vehicleId);
    } catch (e) {
      emit(VehicleControlError(e.toString()));
    }
  }

  Future<void> updateMileage(String vehicleId, String mileage) async {
    try {
      await repository.updateMileage(vehicleId, mileage);
      loadVehicleDetails(vehicleId);
    } catch (e) {
      emit(VehicleControlError(e.toString()));
    }
  }

  Future<void> updateVehicleDetails(String vehicleId, String name, String number, String fuelType) async {
    try {
      await repository.updateVehicleDetails(vehicleId, name, number, fuelType);
      loadVehicleDetails(vehicleId);
    } catch (e) {
      emit(VehicleControlError(e.toString()));
    }
  }

  Future<void> updateVehicleImage(String vehicleId, String imagePath) async {
    try {
      await repository.updateVehicleImage(vehicleId, imagePath);
      loadVehicleDetails(vehicleId);
    } catch (e) {
      emit(VehicleControlError(e.toString()));
    }
  }
}
