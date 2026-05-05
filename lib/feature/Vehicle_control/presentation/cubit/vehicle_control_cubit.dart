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
      
      // Optionally show a small loading overlay or just perform the save
      try {
        await repository.updateVehicleIcon(vehicleId, currentState.tempIcon);
        await repository.updateVehicleColor(vehicleId, currentState.tempColor);
        
        // After saving, reload to get fresh entity from "API"
        loadVehicleDetails(vehicleId);
      } catch (e) {
        emit(VehicleControlError(e.toString()));
      }
    }
  }
}
