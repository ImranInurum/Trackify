import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/common/usecase/get_user_vehicles_usecase.dart';
import 'service_logs_state.dart';

class ServiceLogsCubit extends Cubit<ServiceLogsState> {
  final GetUserVehiclesUsecase _getUserVehiclesUsecase;
  final ImagePicker _imagePicker = ImagePicker();

  ServiceLogsCubit(this._getUserVehiclesUsecase) : super(ServiceLogsInitial());

  Future<void> loadVehicles() async {
    emit(ServiceLogsLoading());

    final result = await _getUserVehiclesUsecase();

    result.fold(
      (failure) => emit(ServiceLogsError(failure.message)),
      (response) {
        final vehicles = response.vehicles ?? [];
        emit(ServiceLogsLoaded(
          vehicles: vehicles,
          selectedVehicle: vehicles.isNotEmpty ? vehicles.first : null,
        ));
      },
    );
  }

  void selectVehicle(String vehicleId) {
    if (state is ServiceLogsLoaded) {
      final currentState = state as ServiceLogsLoaded;
      final selected = currentState.vehicles.firstWhere((v) => v.id == vehicleId);
      emit(currentState.copyWith(selectedVehicle: selected));
    }
  }

  Future<void> saveServiceLog({
    required String date,
    required String amount,
    required List<File> images,
    String? centerName,
    String? contact,
    String? note,
  }) async {
    if (state is ServiceLogsLoaded) {
      final currentState = state as ServiceLogsLoaded;
      
      if (currentState.selectedVehicle == null) {
        emit(const ServiceLogsError("Please select a vehicle"));
        return;
      }

      emit(ServiceLogsSubmitting());
      
      // TODO: Implement API call to save service log
      // For now, simulating success
      await Future.delayed(const Duration(seconds: 1));
      emit(ServiceLogsSuccess());
      
      // Reset state after success or navigate back
    }
  }
}
