import 'package:equatable/equatable.dart';

abstract class AddVehicleState extends Equatable {
  const AddVehicleState();

  @override
  List<Object?> get props => [];
}

class AddVehicleInitial extends AddVehicleState {}

class AddVehicleLoading extends AddVehicleState {}

class AddVehicleError extends AddVehicleState {
  final String message;

  const AddVehicleError(this.message);

  @override
  List<Object?> get props => [message];
}

class AddVehicleSuccess extends AddVehicleState {
  final dynamic response;

  const AddVehicleSuccess(this.response);

  @override
  List<Object?> get props => [response];
}
