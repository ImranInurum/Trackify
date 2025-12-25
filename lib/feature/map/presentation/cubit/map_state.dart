import 'package:equatable/equatable.dart';
import 'package:trackify/feature/map/data/entity/user_device_model.dart';

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object?> get props => [];
}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapLoaded extends MapState {
  final UserDeviceList deviceList;

  const MapLoaded(this.deviceList);

  @override
  List<Object?> get props => [deviceList];
}

class MapError extends MapState {
  final String message;

  const MapError(this.message);

  @override
  List<Object?> get props => [message];
}
