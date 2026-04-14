import 'package:trackify/core/common/models/vehicle_list_model.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {}

class VehiclesLoading extends ProfileState {}

class VehiclesLoaded extends ProfileState {
  final List<Vehicle> vehicles;
  const VehiclesLoaded(this.vehicles);
}

class FetchVehicleError extends ProfileState {
  final String message;
  const FetchVehicleError(this.message);
}
