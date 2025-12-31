import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trackify/feature/map/data/entity/user_device_model.dart';

import '../../data/entity/device_data_by_date_response.dart';

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

class MapDataByDateLoaded extends MapState {
  final List<DataByDate> data;
  final Set<Polyline>? polylines;

  const MapDataByDateLoaded({required this.data, required this.polylines});

  @override
  List<Object?> get props => [data, polylines];
}

class MapError extends MapState {
  final String message;

  const MapError(this.message);

  @override
  List<Object?> get props => [message];
}
