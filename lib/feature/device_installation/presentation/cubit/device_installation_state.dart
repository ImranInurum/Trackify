import 'package:equatable/equatable.dart';
import 'package:trackify/core/config/network/exceptions.dart';

abstract class DeviceInstallationState extends Equatable {
  const DeviceInstallationState();

  @override
  List<Object?> get props => [];
}

class DeviceInstallationInitial extends DeviceInstallationState {}

class DeviceInstallationLoading extends DeviceInstallationState {}

class DeviceInstallationSuccess extends DeviceInstallationState {}

class DeviceInstallationImeiAlreadyAssigned extends DeviceInstallationState {
  final String? message;
  const DeviceInstallationImeiAlreadyAssigned([this.message]);

  @override
  List<Object?> get props => [message];
}

class DeviceInstallationFailure extends DeviceInstallationState {
  final AppException exception;
  const DeviceInstallationFailure(this.exception);

  @override
  List<Object?> get props => [exception];
}
