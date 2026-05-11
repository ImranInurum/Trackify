import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/entity/ride_model.dart';
import 'create_trip_state.dart';

class CreateTripCubit extends Cubit<CreateTripState> {
  CreateTripCubit() : super(CreateTripInitial());

  void init({String? title, List<Ride>? selectedRides}) {
    emit(CreateTripSuccess(
      selectedRides: selectedRides ?? [],
      tripTitle: title,
    ));
  }

  void toggleRideSelection(Ride ride) {
    if (state is CreateTripSuccess) {
      final currentSuccess = state as CreateTripSuccess;
      final updatedRides = List<Ride>.from(currentSuccess.selectedRides);

      if (updatedRides.any((r) => r.id == ride.id)) {
        updatedRides.removeWhere((r) => r.id == ride.id);
      } else {
        updatedRides.add(ride);
      }

      emit(currentSuccess.copyWith(selectedRides: updatedRides));
    }
  }

  void clearSelection() {
    if (state is CreateTripSuccess) {
      final currentSuccess = state as CreateTripSuccess;
      emit(currentSuccess.copyWith(selectedRides: []));
    }
  }

  void updateTitle(String title) {
    if (state is CreateTripSuccess) {
      final currentSuccess = state as CreateTripSuccess;
      emit(currentSuccess.copyWith(tripTitle: title));
    }
  }

  Future<void> saveTrip() async {
    if (state is CreateTripSuccess) {
      final currentSuccess = state as CreateTripSuccess;
      if (currentSuccess.selectedRides.isEmpty) {
        emit(const CreateTripFailure('Please select at least one ride.'));
        return;
      }
      
      emit(CreateTripLoading());
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Emit saved state with the data
      emit(CreateTripSaved(
        title: currentSuccess.tripTitle ?? "Trip 1",
        rides: currentSuccess.selectedRides,
      ));
    }
  }
}
