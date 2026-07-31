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
  final String journeyDistance;
  final String journeyHours;
  final String journeyMinutes;

  const VehicleControlLoaded({
    required this.vehicle,
    required this.tempIcon,
    required this.tempColor,
    this.actionError,
    this.journeyDistance = "0.0",
    this.journeyHours = "0",
    this.journeyMinutes = "0",
  });

  VehicleControlLoaded copyWith({
    VehicleControlEntity? vehicle,
    String? tempIcon,
    String? tempColor,
    String? actionError,
    String? journeyDistance,
    String? journeyHours,
    String? journeyMinutes,
  }) {
    return VehicleControlLoaded(
      vehicle: vehicle ?? this.vehicle,
      tempIcon: tempIcon ?? this.tempIcon,
      tempColor: tempColor ?? this.tempColor,
      actionError: actionError,
      journeyDistance: journeyDistance ?? this.journeyDistance,
      journeyHours: journeyHours ?? this.journeyHours,
      journeyMinutes: journeyMinutes ?? this.journeyMinutes,
    );
  }

  @override
  List<Object?> get props => [
        vehicle,
        tempIcon,
        tempColor,
        actionError,
        journeyDistance,
        journeyHours,
        journeyMinutes,
      ];
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
