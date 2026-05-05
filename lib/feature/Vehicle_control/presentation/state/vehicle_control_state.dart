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

  const VehicleControlLoaded({
    required this.vehicle,
    required this.tempIcon,
    required this.tempColor,
  });

  VehicleControlLoaded copyWith({
    VehicleControlEntity? vehicle,
    String? tempIcon,
    String? tempColor,
  }) {
    return VehicleControlLoaded(
      vehicle: vehicle ?? this.vehicle,
      tempIcon: tempIcon ?? this.tempIcon,
      tempColor: tempColor ?? this.tempColor,
    );
  }

  @override
  List<Object?> get props => [vehicle, tempIcon, tempColor];
}

class VehicleControlError extends VehicleControlState {
  final String message;

  const VehicleControlError(this.message);

  @override
  List<Object?> get props => [message];
}
