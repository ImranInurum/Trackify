import 'package:equatable/equatable.dart';
import 'package:trackify/core/common/models/vehicle_list_model.dart';
import '../../data/model/statistics_response_model.dart';

abstract class StatisticsState extends Equatable {
  const StatisticsState();

  @override
  List<Object?> get props => [];
}

class StatisticsInitial extends StatisticsState {}

class StatisticsLoading extends StatisticsState {
  final List<Vehicle> userVehicles;
  final Vehicle? selectedVehicle;
  final DateTime selectedDate;

  const StatisticsLoading({
    this.userVehicles = const [],
    this.selectedVehicle,
    required this.selectedDate,
  });

  @override
  List<Object?> get props => [userVehicles, selectedVehicle, selectedDate];
}

class StatisticsLoaded extends StatisticsState {
  final StatisticsResponseModel statistics;
  final List<Vehicle> userVehicles;
  final Vehicle? selectedVehicle;
  final DateTime selectedDate;

  const StatisticsLoaded({
    required this.statistics,
    required this.userVehicles,
    required this.selectedVehicle,
    required this.selectedDate,
  });

  StatisticsLoaded copyWith({
    StatisticsResponseModel? statistics,
    List<Vehicle>? userVehicles,
    Vehicle? selectedVehicle,
    DateTime? selectedDate,
  }) {
    return StatisticsLoaded(
      statistics: statistics ?? this.statistics,
      userVehicles: userVehicles ?? this.userVehicles,
      selectedVehicle: selectedVehicle ?? this.selectedVehicle,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }

  @override
  List<Object?> get props => [
    statistics,
    userVehicles,
    selectedVehicle,
    selectedDate,
  ];
}

class StatisticsError extends StatisticsState {
  final String message;
  final List<Vehicle> userVehicles;
  final Vehicle? selectedVehicle;
  final DateTime selectedDate;

  const StatisticsError({
    required this.message,
    this.userVehicles = const [],
    this.selectedVehicle,
    required this.selectedDate,
  });

  @override
  List<Object?> get props => [
    message,
    userVehicles,
    selectedVehicle,
    selectedDate,
  ];
}
