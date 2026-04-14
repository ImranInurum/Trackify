import 'package:trackify/core/common/models/vehicle_list_model.dart';

abstract class MyGarageState {
  const MyGarageState();
}

class MyGarageInitial extends MyGarageState {}

class VehiclesLoading extends MyGarageState {}

class VehiclesLoaded extends MyGarageState {
  final List<Vehicle> vehicles;
  const VehiclesLoaded(this.vehicles);
}

class FetchVehicleError extends MyGarageState {
  final String message;
  const FetchVehicleError(this.message);
}
