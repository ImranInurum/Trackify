import 'package:equatable/equatable.dart';
import '../../domain/entities/vehicle_control_entity.dart';

abstract class VehicleControlState extends Equatable {
  const VehicleControlState();

  @override
  List<Object?> get props => [];
}

class VehicleControlInitial extends VehicleControlState {}

class VehicleControlLoading extends VehicleControlState {}

class VehicleControlLoaded extends VehicleControlState {
  final VehicleControlEntity vehicle;
  final String tempIcon;
  final String tempColor;
  final String? actionError;

  const VehicleControlLoaded({
    required this.vehicle,
    required this.tempIcon,
    required this.tempColor,
    this.actionError,
  });

  VehicleControlLoaded copyWith({
    VehicleControlEntity? vehicle,
    String? tempIcon,
    String? tempColor,
    String? actionError,
  }) {
    return VehicleControlLoaded(
      vehicle: vehicle ?? this.vehicle,
      tempIcon: tempIcon ?? this.tempIcon,
      tempColor: tempColor ?? this.tempColor,
      actionError: actionError,
    );
  }

  @override
  List<Object?> get props => [vehicle, tempIcon, tempColor, actionError];
}

class VehicleControlError extends VehicleControlState {
  final String message;

  const VehicleControlError(this.message);

  @override
  List<Object?> get props => [message];
}

class VehicleControlDeleted extends VehicleControlState {
  const VehicleControlDeleted();
}
