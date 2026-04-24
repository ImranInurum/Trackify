import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/common/models/vehicle_list_model.dart';
import 'package:trackify/core/common/usecase/get_user_vehicles_usecase.dart';
import 'package:trackify/feature/overspeed_alert/data/model/overspeed_alert_model.dart';
import 'overspeed_alert_state.dart';

class OverspeedAlertCubit extends Cubit<OverspeedAlertState> {
  final GetUserVehiclesUsecase getUserVehiclesUsecase;

  // Mock data — one alert has a LIST of vehicles
  final List<OverspeedAlertModel> _mockAlerts = [
    OverspeedAlertModel(
      title: 'Overspeed Alert',
      speedLimit: 60,
      timeDuration: 30,
      date: '24 Apr 2026',
      vehicles: [
        Vehicle(id: '1', vehicleNumber: 'KA04MK1234', vehicleModel: 'Maruti Baleno'),
        Vehicle(id: '2', vehicleNumber: 'KA04MK5678', vehicleModel: 'Honda SP 125'),
      ],
    ),
  ];

  OverspeedAlertCubit({required this.getUserVehiclesUsecase})
      : super(OverspeedAlertInitial());

  Future<void> fetchInitialData() async {
    emit(OverspeedAlertLoading());
    try {
      final result = await getUserVehiclesUsecase.call();
      result.fold(
        (failure) => emit(OverspeedAlertError(failure.message)),
        (response) => emit(OverspeedAlertLoaded(
          alerts: List.unmodifiable(_mockAlerts),
          userVehicles: response.vehicles ?? [],
        )),
      );
    } catch (e) {
      emit(OverspeedAlertError(e.toString()));
    }
  }

  /// Called from AddOverspeedAlertScreen with the locally selected vehicles.
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
      // TODO: Replace with real API call
      await Future.delayed(const Duration(seconds: 1));

      _mockAlerts.add(OverspeedAlertModel(
        title: title,
        speedLimit: speedLimit,
        timeDuration: timeDuration,
        date: _formattedToday(),
        vehicles: selectedVehicles,
      ));

      emit(OverspeedAlertSuccess());
      emit(currentState.copyWith(alerts: List.unmodifiable(_mockAlerts)));
    } catch (e) {
      emit(const OverspeedAlertError('Failed to save alert.'));
      emit(currentState);
    }
  }

  String _formattedToday() {
    final now = DateTime.now();
    return '${now.day} ${_monthName(now.month)} ${now.year}';
  }

  String _monthName(int month) {
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec',
    ];
    return months[month - 1];
  }
}
