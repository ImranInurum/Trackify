import 'package:equatable/equatable.dart';
import '../../data/entity/ride_model.dart';

abstract class CreateTripState extends Equatable {
  const CreateTripState();

  @override
  List<Object?> get props => [];
}

class CreateTripInitial extends CreateTripState {}

class CreateTripLoading extends CreateTripState {}

class CreateTripSuccess extends CreateTripState {
  final List<Ride> selectedRides;
  final String? tripTitle;

  const CreateTripSuccess({
    required this.selectedRides,
    this.tripTitle,
  });

  CreateTripSuccess copyWith({
    List<Ride>? selectedRides,
    String? tripTitle,
  }) {
    return CreateTripSuccess(
      selectedRides: selectedRides ?? this.selectedRides,
      tripTitle: tripTitle ?? this.tripTitle,
    );
  }

  @override
  List<Object?> get props => [selectedRides, tripTitle];
}

class CreateTripFailure extends CreateTripState {
  final String message;

  const CreateTripFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class CreateTripSaved extends CreateTripState {
  final String title;
  final List<Ride> rides;
  final String savedUnit;

  const CreateTripSaved({required this.title, required this.rides, required this.savedUnit});

  @override
  List<Object?> get props => [title, rides, savedUnit];
}
