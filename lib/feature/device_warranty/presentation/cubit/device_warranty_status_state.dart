part of 'device_warranty_status_cubit.dart';

abstract class DeviceWarrantyStatusState extends Equatable {
  const DeviceWarrantyStatusState();

  @override
  List<Object> get props => [];
}

class DeviceWarrantyStatusInitial extends DeviceWarrantyStatusState {}

class DeviceWarrantyStatusLoading extends DeviceWarrantyStatusState {}

class DeviceWarrantyStatusLoaded extends DeviceWarrantyStatusState {
  final WarrantyStatusModel warrantyStatus;

  const DeviceWarrantyStatusLoaded(this.warrantyStatus);

  @override
  List<Object> get props => [warrantyStatus];
}

class DeviceWarrantyStatusError extends DeviceWarrantyStatusState {
  final String message;

  const DeviceWarrantyStatusError(this.message);

  @override
  List<Object> get props => [message];
}
