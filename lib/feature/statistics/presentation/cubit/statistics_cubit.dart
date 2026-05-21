import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:trackify/core/common/models/vehicle_list_model.dart';
import 'package:trackify/core/common/usecase/get_user_vehicles_usecase.dart';
import '../../data/model/statistics_request_model.dart';
import '../../domain/repository/statistics_repository.dart';
import 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  final GetUserVehiclesUsecase getUserVehiclesUsecase;
  final StatisticsRepository repository;

  StatisticsCubit({
    required this.getUserVehiclesUsecase,
    required this.repository,
  }) : super(StatisticsInitial());

  Future<void> fetchInitialData({
    Vehicle? targetVehicle,
    DateTime? targetDate,
  }) async {
    final dateToUse = targetDate ?? DateTime.now();
    emit(StatisticsLoading(selectedDate: dateToUse));

    try {
      final vehicleResult = await getUserVehiclesUsecase.call();

      await vehicleResult.fold(
        (failure) async => emit(
          StatisticsError(message: failure.message, selectedDate: dateToUse),
        ),
        (response) async {
          final vehicles = response.vehicles ?? [];
          if (vehicles.isEmpty) {
            emit(
              StatisticsError(
                message: 'No vehicles found',
                selectedDate: dateToUse,
              ),
            );
            return;
          }
          final selectedVehicle = targetVehicle ?? vehicles.first;
          await loadStatistics(
            vehicle: selectedVehicle,
            date: dateToUse,
            vehicles: vehicles,
          );
        },
      );
    } catch (e) {
      emit(StatisticsError(message: e.toString(), selectedDate: dateToUse));
    }
  }

  Future<void> loadStatistics({
    required Vehicle vehicle,
    required DateTime date,
    List<Vehicle>? vehicles,
  }) async {
    final List<Vehicle> userVehicles =
        vehicles ??
        (state is StatisticsLoaded
            ? (state as StatisticsLoaded).userVehicles
            : state is StatisticsLoading
            ? (state as StatisticsLoading).userVehicles
            : state is StatisticsError
            ? (state as StatisticsError).userVehicles
            : [vehicle]);

    emit(
      StatisticsLoading(
        userVehicles: userVehicles,
        selectedVehicle: vehicle,
        selectedDate: date,
      ),
    );

    final formattedDate = DateFormat('yyyy-MM-dd').format(date);

    final request = StatisticsRequestModel(
      imei: vehicle.imei ?? '',
      date: formattedDate,
    );

    final result = await repository.getStatistics(request);

    result.fold(
      (failure) => emit(
        StatisticsError(
          message: failure.message,
          userVehicles: userVehicles,
          selectedVehicle: vehicle,
          selectedDate: date,
        ),
      ),
      (response) {
        emit(
          StatisticsLoaded(
            statistics: response,
            userVehicles: userVehicles,
            selectedVehicle: vehicle,
            selectedDate: date,
          ),
        );
      },
    );
  }

  Future<void> selectVehicle(Vehicle vehicle) async {
    DateTime dateToUse = DateTime.now();
    List<Vehicle> userVehicles = [];

    if (state is StatisticsLoaded) {
      final currentState = state as StatisticsLoaded;
      dateToUse = currentState.selectedDate;
      userVehicles = currentState.userVehicles;
    } else if (state is StatisticsLoading) {
      final currentState = state as StatisticsLoading;
      dateToUse = currentState.selectedDate;
      userVehicles = currentState.userVehicles;
    } else if (state is StatisticsError) {
      final currentState = state as StatisticsError;
      dateToUse = currentState.selectedDate;
      userVehicles = currentState.userVehicles;
    }

    await loadStatistics(
      vehicle: vehicle,
      date: dateToUse,
      vehicles: userVehicles,
    );
  }

  Future<void> selectDate(DateTime date) async {
    Vehicle? selectedVehicle;
    List<Vehicle> userVehicles = [];

    if (state is StatisticsLoaded) {
      final currentState = state as StatisticsLoaded;
      selectedVehicle = currentState.selectedVehicle;
      userVehicles = currentState.userVehicles;
    } else if (state is StatisticsLoading) {
      final currentState = state as StatisticsLoading;
      selectedVehicle = currentState.selectedVehicle;
      userVehicles = currentState.userVehicles;
    } else if (state is StatisticsError) {
      final currentState = state as StatisticsError;
      selectedVehicle = currentState.selectedVehicle;
      userVehicles = currentState.userVehicles;
    }

    if (selectedVehicle == null) return;

    await loadStatistics(
      vehicle: selectedVehicle,
      date: date,
      vehicles: userVehicles,
    );
  }
}
