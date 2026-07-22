import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/common/models/vehicle_list_model.dart';
import 'package:trackify/core/common/usecase/get_user_vehicles_usecase.dart';
import '../../domain/usecase/get_service_logs_usecase.dart';
import '../../domain/usecase/save_service_log_usecase.dart';
import '../../domain/usecase/update_service_log_usecase.dart';
import '../../domain/usecase/delete_service_log_usecase.dart';
import 'service_logs_state.dart';

class ServiceLogsCubit extends Cubit<ServiceLogsState> {
  final GetUserVehiclesUsecase _getUserVehiclesUsecase;
  final GetServiceLogsUsecase _getServiceLogsUsecase;
  final SaveServiceLogUsecase _saveServiceLogUsecase;
  final UpdateServiceLogUsecase _updateServiceLogUsecase;
  final DeleteServiceLogUsecase _deleteServiceLogUsecase;

  ServiceLogsCubit(
    this._getUserVehiclesUsecase,
    this._getServiceLogsUsecase,
    this._saveServiceLogUsecase,
    this._updateServiceLogUsecase,
    this._deleteServiceLogUsecase,
  ) : super(ServiceLogsInitial());

  void reset() {
    emit(ServiceLogsInitial());
  }

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

  Future<void> selectVehicle(String vehicleId) async {
    if (state is ServiceLogsLoaded) {
      final currentState = state as ServiceLogsLoaded;
      final selected = currentState.vehicles.firstWhere((v) => v.id == vehicleId);
      emit(currentState.copyWith(selectedVehicle: selected));
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
      final vehicle = currentState.selectedVehicle;

      if (vehicle == null) return;

      emit(
        ServiceLogsSubmitting(
          vehicles: currentState.vehicles,
          selectedVehicle: currentState.selectedVehicle,
          logs: currentState.logs,
        ),
      );

      final result = await _saveServiceLogUsecase(
        vehicleId: vehicle.id ?? "",
        imei: vehicle.imei ?? "",
        serviceDate: date,
        amount: double.tryParse(amount) ?? 0.0,
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
          fetchServiceLogs(imei: vehicle.imei);
        },
      );
    }
  }

  Future<void> updateServiceLog({
    required String id,
    String? date,
    String? amount,
    File? image,
    String? centerName,
    String? note,
  }) async {
    if (state is ServiceLogsLoaded) {
      final currentState = state as ServiceLogsLoaded;
      final vehicle = currentState.selectedVehicle;

      emit(
        ServiceLogsSubmitting(
          vehicles: currentState.vehicles,
          selectedVehicle: currentState.selectedVehicle,
          logs: currentState.logs,
        ),
      );

      final result = await _updateServiceLogUsecase(
        id: id,
        serviceDate: date,
        amount: amount != null ? double.tryParse(amount) : null,
        image: image,
        centerName: centerName,
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
          if (vehicle != null) {
            fetchServiceLogs(imei: vehicle.imei);
          } else {
            loadVehicles(); // Fallback if vehicle is somehow null but we have a success
          }
        },
      );
    }
  }

  Future<void> deleteServiceLog(String id) async {
    if (state is ServiceLogsLoaded) {
      final currentState = state as ServiceLogsLoaded;
      final vehicle = currentState.selectedVehicle;

      emit(
        ServiceLogsSubmitting(
          vehicles: currentState.vehicles,
          selectedVehicle: currentState.selectedVehicle,
          logs: currentState.logs,
        ),
      );

      final result = await _deleteServiceLogUsecase(id);

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
          if (vehicle != null) {
            fetchServiceLogs(imei: vehicle.imei);
          } else {
            loadVehicles();
          }
        },
      );
    }
  }
}
