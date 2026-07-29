import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/feature/Vehicle_control/data/repositories/vehicle_control_repository_impl.dart';
import 'package:trackify/core/config/network/network_api_service.dart';
import 'package:trackify/core/utils/shared_preferences.dart';

import 'fuel_logs_state.dart';

class FuelLogsCubit extends Cubit<FuelLogsState> {
  /// Stores the current vehicleId so we can reload after adding a refuel.
  String _currentVehicleId = '';

  FuelLogsCubit() : super(FuelLogsInitial());

  @override
  void emit(FuelLogsState state) {
    if (isClosed) return;
    super.emit(state);
  }

  Future<void> loadFuelLogs(String vehicleId) async {
    try {
      _currentVehicleId = vehicleId;

      emit(FuelLogsLoading());

      final unit = AppPreference.instance.getSync(key: AppPreference.KEY_DISTANCE_UNIT);
      final response = await http.get(Uri.parse(ApiURL.dashboard(vehicleId, unit: unit.isNotEmpty ? unit : 'km')));

      print("=========== FUEL LOG API HIT ===========");

      print("STATUS CODE : ${response.statusCode}");

      print("RESPONSE BODY : ${response.body}");

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);

        final data = decodedData['data'];

        final lastRefuel = data['lastRefuel'];

        emit(
          FuelLogsLoaded(
            // =========================
            // OLD STATE DATA
            // =========================
            odometerReading: data['odometerReading']?.toString() ?? '0',

            tankCapacity: data['tankCapacity']?.toString() ?? '0',

            fuelRemaining: data['fuelRemaining']?.toString() ?? '0',

            distanceRemaining: data['distanceRemaining']?.toString() ?? '0',

            mileageArai: data['vehicleMileage']?.toString() ?? '0',

            distanceTravelled: data['distanceTravelled']?.toString() ?? '0',

            spendingAmount:
                data['spending']?['thisMonthAmount']?.toString() ?? '0',

            spendingLiters:
                data['spending']?['thisMonthFuel']?.toString() ?? '0',

            lastRefuelDate: lastRefuel?['date']?.toString() ?? "N/A",

            lastRefuelAmount: lastRefuel?['amount']?.toString() ?? "0",

            lastRefuelLiters: lastRefuel?['fuelFilled']?.toString() ?? "0",

            totalFuelAdded:
                data['spending']?['thisMonthFuel']?.toString() ?? '0',

            totalSpendings:
                data['spending']?['thisMonthAmount']?.toString() ?? '0',

            averageMileage: data['vehicleMileage']?.toString() ?? '0',

            refuelCount: data['refuelCount']?.toString() ?? '0',

            refuelLogs: const [],

            // =========================
            // NEW API DATA
            // =========================
            imei: data['imei']?.toString() ?? '',

            vehicleImage: data['vehicleImage']?.toString() ?? '',

            vehicleIcon: data['vehicleIcon']?.toString() ?? '',

            vehicleColor: data['vehicleColor']?.toString() ?? '',

            thisWeekAmount:
                data['spending']?['thisWeekAmount']?.toString() ?? '0',

            thisWeekFuel: data['spending']?['thisWeekFuel']?.toString() ?? '0',

            thisMonthAmount:
                data['spending']?['thisMonthAmount']?.toString() ?? '0',

            thisMonthFuel:
                data['spending']?['thisMonthFuel']?.toString() ?? '0',

            id: '',
          ),
        );
      } else {
        emit(const FuelLogsError("Failed To Load Fuel Logs"));
      }
    } catch (e) {
      print("FUEL LOG ERROR : $e");

      emit(FuelLogsError(e.toString()));
    }
  }

  /// Reloads the fuel logs using the last known vehicleId.
  /// Call this after successfully adding a new refuel entry.
  Future<void> reloadFuelLogs() async {
    if (_currentVehicleId.isNotEmpty) {
      await loadFuelLogs(_currentVehicleId);
    }
  }

  Future<String?> updateOdometer(String odometerReading) async {
    if (_currentVehicleId.isEmpty) return "Vehicle ID is empty";
    try {
      final apiService = NetworkApiService();
      final response = await apiService.getPostApiResponse(
        ApiURL.updateOdometer,
        {
          "vehicleId": _currentVehicleId,
          "currentOdometer": (double.tryParse(odometerReading) ?? 0).toInt(),
        },
      );

      return response.fold(
        (failure) => failure.message,
        (success) async {
          await reloadFuelLogs();
          return null;
        },
      );
    } catch (e) {
      print("Odometer update error: $e");
      return e.toString();
    }
  }

  Future<String?> updateTankCapacity(String capacity) async {
    if (_currentVehicleId.isEmpty) return "Vehicle ID is empty";
    final currentState = state;
    try {
      final repo = VehicleControlRepositoryImpl();
      String currentMileage = '';
      if (currentState is FuelLogsLoaded) {
        currentMileage = currentState.mileageArai;
      }
      await repo.updateTankCapacity(_currentVehicleId, capacity, currentMileage);
      await reloadFuelLogs();
      return null;
    } catch (e) {
      print("Tank capacity update error: $e");
      return e.toString();
    }
  }

  Future<String?> updateMileage(String mileage) async {
    if (_currentVehicleId.isEmpty) return "Vehicle ID is empty";
    final currentState = state;
    try {
      final repo = VehicleControlRepositoryImpl();
      String currentTankCapacity = '';
      if (currentState is FuelLogsLoaded) {
        currentTankCapacity = currentState.tankCapacity;
      }
      await repo.updateMileage(_currentVehicleId, mileage, currentTankCapacity);
      await reloadFuelLogs();
      return null;
    } catch (e) {
      print("Mileage update error: $e");
      return e.toString();
    }
  }
}
