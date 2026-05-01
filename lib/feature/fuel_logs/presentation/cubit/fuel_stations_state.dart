import 'package:equatable/equatable.dart';
import '../../data/model/fuel_station_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class FuelStationsState extends Equatable {
  const FuelStationsState();

  @override
  List<Object?> get props => [];
}

class FuelStationsInitial extends FuelStationsState {}

class FuelStationsLoading extends FuelStationsState {}

class FuelStationsLoaded extends FuelStationsState {
  final List<FuelStation> stations;
  final LatLng userLocation;
  final Set<Marker> markers;

  const FuelStationsLoaded({
    required this.stations,
    required this.userLocation,
    required this.markers,
  });

  @override
  List<Object?> get props => [stations, userLocation, markers];
}

class FuelStationsError extends FuelStationsState {
  final String message;

  const FuelStationsError(this.message);

  @override
  List<Object?> get props => [message];
}
