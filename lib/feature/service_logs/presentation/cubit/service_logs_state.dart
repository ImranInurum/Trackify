import 'package:equatable/equatable.dart';
import '../../../../core/common/models/vehicle_list_model.dart';
import '../../domain/entities/service_log_entity.dart';

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
  final List<ServiceLogEntity> logs;

  const ServiceLogsLoaded({
    this.vehicles = const [],
    this.selectedVehicle,
    this.logs = const [],
  });

  ServiceLogsLoaded copyWith({
    List<Vehicle>? vehicles,
    Vehicle? selectedVehicle,
    List<ServiceLogEntity>? logs,
  }) {
    return ServiceLogsLoaded(
      vehicles: vehicles ?? this.vehicles,
      selectedVehicle: selectedVehicle ?? this.selectedVehicle,
      logs: logs ?? this.logs,
    );
  }

  @override
  List<Object?> get props => [vehicles, selectedVehicle, logs];
}

class ServiceLogsError extends ServiceLogsLoaded {
  final String message;

  const ServiceLogsError(
    this.message, {
    super.vehicles = const [],
    super.selectedVehicle,
    super.logs = const [],
  });

  @override
  List<Object?> get props => [message, ...super.props];
}

class ServiceLogsSubmitting extends ServiceLogsLoaded {
  const ServiceLogsSubmitting({
    super.vehicles = const [],
    super.selectedVehicle,
    super.logs = const [],
  });
}

class ServiceLogsSuccess extends ServiceLogsLoaded {
  const ServiceLogsSuccess({
    super.vehicles = const [],
    super.selectedVehicle,
    super.logs = const [],
  });
}
