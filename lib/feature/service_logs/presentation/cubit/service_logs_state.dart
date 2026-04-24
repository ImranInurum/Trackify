import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../../../core/common/models/vehicle_list_model.dart';

abstract class ServiceLogsState extends Equatable {
  const ServiceLogsState();

  @override
  List<Object?> get props => [];
}

class ServiceLogsInitial extends ServiceLogsState {}

class ServiceLogsLoading extends ServiceLogsState {}

class ServiceLogsLoaded extends ServiceLogsState {
  final List<Vehicle> vehicles;
  final Vehicle? selectedVehicle;

  const ServiceLogsLoaded({
    required this.vehicles,
    this.selectedVehicle,
  });

  ServiceLogsLoaded copyWith({
    List<Vehicle>? vehicles,
    Vehicle? selectedVehicle,
  }) {
    return ServiceLogsLoaded(
      vehicles: vehicles ?? this.vehicles,
      selectedVehicle: selectedVehicle ?? this.selectedVehicle,
    );
  }

  @override
  List<Object?> get props => [vehicles, selectedVehicle];
}

class ServiceLogsError extends ServiceLogsState {
  final String message;
  const ServiceLogsError(this.message);

  @override
  List<Object?> get props => [message];
}

class ServiceLogsSubmitting extends ServiceLogsState {}

class ServiceLogsSuccess extends ServiceLogsState {}
