import 'package:equatable/equatable.dart';
import '../../domain/entities/device_warranty_entity.dart';

abstract class DeviceWarrantyState extends Equatable {
  const DeviceWarrantyState();

  @override
  List<Object?> get props => [];
}

class DeviceWarrantyInitial extends DeviceWarrantyState {
  const DeviceWarrantyInitial();
}

class DeviceWarrantyLoading extends DeviceWarrantyState {
  const DeviceWarrantyLoading();
}

class DeviceWarrantyLoaded extends DeviceWarrantyState {
  final DeviceWarrantyEntity warranty;

  const DeviceWarrantyLoaded(this.warranty);

  @override
  List<Object?> get props => [warranty];
}

class DeviceWarrantyError extends DeviceWarrantyState {
  final String message;

  const DeviceWarrantyError(this.message);

  @override
  List<Object?> get props => [message];
}
