import 'package:equatable/equatable.dart';
import 'package:trackify/core/common/models/vehicle_list_model.dart';
import 'package:trackify/feature/overspeed_alert/data/model/overspeed_alert_model.dart';

abstract class OverspeedAlertState extends Equatable {
  const OverspeedAlertState();

  @override
  List<Object?> get props => [];
}

class OverspeedAlertInitial extends OverspeedAlertState {}

class OverspeedAlertLoading extends OverspeedAlertState {}

class OverspeedAlertLoaded extends OverspeedAlertState {
  final List<OverspeedAlertModel> alerts;
  final List<Vehicle> userVehicles;

  const OverspeedAlertLoaded({
    required this.alerts,
    required this.userVehicles,
  });

  OverspeedAlertLoaded copyWith({
    List<OverspeedAlertModel>? alerts,
    List<Vehicle>? userVehicles,
  }) {
    return OverspeedAlertLoaded(
      alerts: alerts ?? this.alerts,
      userVehicles: userVehicles ?? this.userVehicles,
    );
  }

  @override
  List<Object?> get props => [alerts, userVehicles];
}

class OverspeedAlertError extends OverspeedAlertState {
  final String message;

  const OverspeedAlertError(this.message);

  @override
  List<Object?> get props => [message];
}

class OverspeedAlertSubmitting extends OverspeedAlertState {}

class OverspeedAlertSuccess extends OverspeedAlertState {}
