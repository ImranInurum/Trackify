import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/common/usecase/get_user_vehicles_usecase.dart';
import '../../domain/usecase/get_service_logs_usecase.dart';
import '../../domain/usecase/save_service_log_usecase.dart';
import 'service_logs_state.dart';

class ServiceLogsCubit extends Cubit<ServiceLogsState> {
  final GetUserVehiclesUsecase _getUserVehiclesUsecase;
  final GetServiceLogsUsecase _getServiceLogsUsecase;
  final SaveServiceLogUsecase _saveServiceLogUsecase;
  final ImagePicker _imagePicker = ImagePicker();

  ServiceLogsCubit(
    this._getUserVehiclesUsecase,
    this._getServiceLogsUsecase,
    this._saveServiceLogUsecase,
  ) : super(ServiceLogsInitial());

  Future<void> loadVehicles() async {
    emit(ServiceLogsLoading());

    final result = await _getUserVehiclesUsecase();

    result.fold((failure) => emit(ServiceLogsError(failure.message)), (
      response,
    ) {
      final vehicles = response.vehicles ?? [];
      final selected = vehicles.isNotEmpty ? vehicles.first : null;

      emit(ServiceLogsLoaded(vehicles: vehicles, selectedVehicle: selected));

      if (selected != null) {
        fetchServiceLogs(imei: selected.imei);
      }
    });
  }

  Future<void> fetchServiceLogs({
    String? imei,
    String? vehicleId,
    String? startDate,
    String? endDate,
  }) async {
    if (state is ServiceLogsLoaded) {
      final currentState = state as ServiceLogsLoaded;

      final result = await _getServiceLogsUsecase(
        imei: imei,
        vehicleId: vehicleId,
        startDate: startDate,
        endDate: endDate,
      );

      result.fold(
        (failure) => emit(
          ServiceLogsError(
            failure.message,
            vehicles: currentState.vehicles,
            selectedVehicle: currentState.selectedVehicle,
            logs: currentState.logs,
          ),
        ),
        (logs) => emit(currentState.copyWith(logs: logs)),
      );
    }
  }

  void selectVehicle(String vehicleId) {
    if (state is ServiceLogsLoaded) {
      final currentState = state as ServiceLogsLoaded;
      final selected = currentState.vehicles.firstWhere(
        (v) => v.id == vehicleId,
      );
      emit(currentState.copyWith(selectedVehicle: selected, logs: []));
      fetchServiceLogs(imei: selected.imei);
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
        emit(
          ServiceLogsError(
            "Please select a vehicle",
            vehicles: currentState.vehicles,
            selectedVehicle: currentState.selectedVehicle,
          ),
        );
        return;
      }

      emit(
        ServiceLogsSubmitting(
          vehicles: currentState.vehicles,
          selectedVehicle: currentState.selectedVehicle,
          logs: currentState.logs,
        ),
      );

      final amountDouble = double.tryParse(amount) ?? 0.0;

      final result = await _saveServiceLogUsecase(
        vehicleId: currentState.selectedVehicle?.id ?? '',
        imei: currentState.selectedVehicle?.imei ?? '',
        serviceDate: date,
        amount: amountDouble,
        images: images,
        centerName: centerName,
        contact: contact,
        note: note,
      );

      result.fold(
        (failure) => emit(
          ServiceLogsError(
            failure.message,
            vehicles: currentState.vehicles,
            selectedVehicle: currentState.selectedVehicle,
            logs: currentState.logs,
          ),
        ),
        (success) {
          emit(
            ServiceLogsSuccess(
              vehicles: currentState.vehicles,
              selectedVehicle: currentState.selectedVehicle,
              logs: currentState.logs,
            ),
          );
          // Refresh logs after success
          fetchServiceLogs(imei: currentState.selectedVehicle?.imei);
        },
      );
    }
  }
}
