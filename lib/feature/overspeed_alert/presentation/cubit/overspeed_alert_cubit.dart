import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/common/models/vehicle_list_model.dart';
import 'package:trackify/core/common/usecase/get_user_vehicles_usecase.dart';
import 'package:trackify/feature/overspeed_alert/data/model/overspeed_alert_model.dart';
import 'package:trackify/feature/overspeed_alert/domain/usecase/create_overspeed_alert_usecase.dart';
import 'package:trackify/feature/overspeed_alert/domain/usecase/get_overspeed_alerts_usecase.dart';
import 'overspeed_alert_state.dart';

class OverspeedAlertCubit extends Cubit<OverspeedAlertState> {
  final GetUserVehiclesUsecase getUserVehiclesUsecase;
  final CreateOverspeedAlertUsecase createOverspeedAlertUsecase;
  final GetOverspeedAlertsUsecase getOverspeedAlertsUsecase;

  List<OverspeedAlertModel> _alerts = [];

  OverspeedAlertCubit({
    required this.getUserVehiclesUsecase,
    required this.createOverspeedAlertUsecase,
    required this.getOverspeedAlertsUsecase,
  }) : super(OverspeedAlertInitial());

  Future<void> fetchInitialData({Vehicle? targetVehicle}) async {
    emit(OverspeedAlertLoading());
    try {
      if (targetVehicle != null) {
        // If a specific vehicle is provided (e.g. from global selection), fetch only for it.
        await selectVehicle(targetVehicle, existingVehicles: [targetVehicle]);
        return;
      }

      final vehicleResult = await getUserVehiclesUsecase.call();

      await vehicleResult.fold(
        (failure) async => emit(OverspeedAlertError(failure.message)),
        (response) async {
          final vehicles = response.vehicles ?? [];
          if (vehicles.isEmpty) {
            emit(const OverspeedAlertLoaded(alerts: [], userVehicles: []));
            return;
          }
          // Default to first vehicle
          await selectVehicle(vehicles.first, existingVehicles: vehicles);
        },
      );
    } catch (e) {
      emit(OverspeedAlertError(e.toString()));
    }
  }

  Future<void> selectVehicle(
    Vehicle vehicle, {
    List<Vehicle>? existingVehicles,
  }) async {
    final List<Vehicle> vehicles =
        existingVehicles ??
        (state is OverspeedAlertLoaded
            ? (state as OverspeedAlertLoaded).userVehicles
            : []);

    emit(OverspeedAlertLoading());

    _alerts = [];
    if (vehicle.imei != null && vehicle.imei!.isNotEmpty) {
      final alertResult = await getOverspeedAlertsUsecase.call(vehicle.imei!);
      alertResult.fold(
        (failure) => null, // Ignore failures for individual vehicles
        (alerts) => _alerts = alerts,
      );
    }

    emit(
      OverspeedAlertLoaded(
        alerts: List.unmodifiable(_alerts),
        userVehicles: vehicles,
        selectedVehicle: vehicle,
      ),
    );
  }

  Future<void> saveOverspeedAlert({
    required String title,
    required int speedLimit,
    required int timeDuration,
    required List<Vehicle> selectedVehicles,
  }) async {
    if (state is! OverspeedAlertLoaded) return;
    final currentState = state as OverspeedAlertLoaded;

    if (selectedVehicles.isEmpty) {
      emit(const OverspeedAlertError('Please select at least one vehicle'));
      emit(currentState);
      return;
    }

    emit(OverspeedAlertSubmitting());

    try {
      final imeiString = selectedVehicles
          .map((v) => v.imei)
          .where((imei) => imei != null && imei.isNotEmpty)
          .join(',');

      if (imeiString.isEmpty) {
        emit(
          const OverspeedAlertError('Selected vehicles do not have an IMEI'),
        );
        emit(currentState);
        return;
      }

      final result = await createOverspeedAlertUsecase.call(
        alertTitle: title,
        speedLimit: speedLimit,
        duration: timeDuration,
        imei: imeiString,
      );

      result.fold(
        (failure) {
          emit(OverspeedAlertError(failure.message));
          emit(currentState);
        },
        (message) {
          emit(OverspeedAlertSuccess(message: message));
          // Re-fetch data for the currently selected vehicle
          if (currentState.selectedVehicle != null) {
            selectVehicle(currentState.selectedVehicle!);
          } else {
            fetchInitialData();
          }
        },
      );
    } catch (e) {
      emit(OverspeedAlertError(e.toString()));
      emit(currentState);
    }
  }
}
