import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/feature/trips/data/entity/trip_model.dart';
import 'trips_state.dart';

class TripsCubit extends Cubit<TripsState> {
  TripsCubit() : super(TripsInitial());

  Future<void> fetchTrips() async {
    emit(TripsLoading());
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data for Trips
      final List<TripModel> mockTrips = [
        TripModel(
          id: "1",
          name: "Trip 1",
          distance: 46.2,
          rideCount: 2,
        ),
      ];
      
      emit(TripsLoaded(mockTrips));
    } catch (e) {
      emit(TripsError(e.toString()));
    }
  }
}
