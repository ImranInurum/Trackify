import 'package:equatable/equatable.dart';
import 'package:trackify/core/config/network/exceptions.dart';

import '../../data/entity/ride_model.dart';

abstract class RideHistoryState extends Equatable {
  const RideHistoryState();

  @override
  List<Object?> get props => [];
}

class RideHistoryInitial extends RideHistoryState {}

class RideHistoryLoading extends RideHistoryState {}

class RideHistorySuccess extends RideHistoryState {
  final List<Ride> rides;
  const RideHistorySuccess(this.rides);

  @override
  List<Object?> get props => [rides];
}

class RideHistoryFailure extends RideHistoryState {
  final AppException exception;
  const RideHistoryFailure(this.exception);

  @override
  List<Object?> get props => [exception];
}
