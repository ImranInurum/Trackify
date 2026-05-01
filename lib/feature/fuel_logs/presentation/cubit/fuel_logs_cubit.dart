import 'package:flutter_bloc/flutter_bloc.dart';
import 'fuel_logs_state.dart';

class FuelLogsCubit extends Cubit<FuelLogsState> {
  FuelLogsCubit() : super(FuelLogsInitial());

  void loadFuelLogs() {
    emit(FuelLogsLoading());
    // Simulating API call
    Future.delayed(const Duration(milliseconds: 500), () {
      emit(FuelLogsLoaded(
        odometerReading: "031782",
        tankCapacity: "11.0",
        fuelRemaining: "7.5",
        distanceRemaining: "374.0",
        mileageArai: "50",
        distanceTravelled: "0.0",
        spendingAmount: "0.00",
        spendingLiters: "0.00",
        lastRefuelDate: "15 April",
        lastRefuelAmount: "800",
        lastRefuelLiters: "7.48",
        totalFuelAdded: "14.99",
        totalSpendings: "1,600",
        averageMileage: "0.0",
        refuelCount: "02",
        refuelLogs: [
          RefuelLog(
            id: "1",
            dateTime: DateTime(2026, 4, 27, 22, 57),
            odometer: "32105",
            location: "C.m. Petro Point, Bpcl Petrol Pump",
            amount: "800",
            rate: "106.54",
            distanceSinceLast: "323",
            liters: "6.5",
            mileage: "50",
          ),
          RefuelLog(
            id: "2",
            dateTime: DateTime(2026, 4, 15, 21, 16),
            odometer: "31782",
            location: "C.m. Petro Point, Bpcl Petrol Pump",
            amount: "800",
            rate: "106.97",
          ),
        ],
      ));
    });
  }
}
