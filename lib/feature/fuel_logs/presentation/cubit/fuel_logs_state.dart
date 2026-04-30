import 'package:equatable/equatable.dart';

class RefuelLog extends Equatable {
  final String id;
  final DateTime dateTime;
  final String odometer;
  final String location;
  final String amount;
  final String rate;
  final String? distanceSinceLast;
  final String? liters;
  final String? mileage;

  const RefuelLog({
    required this.id,
    required this.dateTime,
    required this.odometer,
    required this.location,
    required this.amount,
    required this.rate,
    this.distanceSinceLast,
    this.liters,
    this.mileage,
  });

  @override
  List<Object?> get props => [
        id,
        dateTime,
        odometer,
        location,
        amount,
        rate,
        distanceSinceLast,
        liters,
        mileage,
      ];
}

abstract class FuelLogsState extends Equatable {
  const FuelLogsState();

  @override
  List<Object?> get props => [];
}

class FuelLogsInitial extends FuelLogsState {}

class FuelLogsLoading extends FuelLogsState {}

class FuelLogsLoaded extends FuelLogsState {
  final String odometerReading;
  final String tankCapacity;
  final String fuelRemaining;
  final String distanceRemaining;
  final String mileageArai;
  final String distanceTravelled;
  final String spendingAmount;
  final String spendingLiters;
  final String lastRefuelDate;
  final String lastRefuelAmount;
  final String lastRefuelLiters;
  
  // New fields for Refuel History tab
  final List<RefuelLog> refuelLogs;
  final String totalFuelAdded;
  final String totalSpendings;
  final String averageMileage;
  final String refuelCount;

  const FuelLogsLoaded({
    required this.odometerReading,
    required this.tankCapacity,
    required this.fuelRemaining,
    required this.distanceRemaining,
    required this.mileageArai,
    required this.distanceTravelled,
    required this.spendingAmount,
    required this.spendingLiters,
    required this.lastRefuelDate,
    required this.lastRefuelAmount,
    required this.lastRefuelLiters,
    this.refuelLogs = const [],
    this.totalFuelAdded = "0.0",
    this.totalSpendings = "0",
    this.averageMileage = "0.0",
    this.refuelCount = "0",
  });

  @override
  List<Object?> get props => [
        odometerReading,
        tankCapacity,
        fuelRemaining,
        distanceRemaining,
        mileageArai,
        distanceTravelled,
        spendingAmount,
        spendingLiters,
        lastRefuelDate,
        lastRefuelAmount,
        lastRefuelLiters,
        refuelLogs,
        totalFuelAdded,
        totalSpendings,
        averageMileage,
        refuelCount,
      ];
}

class FuelLogsError extends FuelLogsState {
  final String message;

  const FuelLogsError(this.message);

  @override
  List<Object?> get props => [message];
}
