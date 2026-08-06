import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/entity/ride_model.dart';
import 'create_trip_state.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:trackify/core/utils/shared_preferences.dart';

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

  Future<String> _getUniqueTitle(String baseTitle) async {
    try {
      final box = await Hive.openBox('saved_trips');
      final tripsJson = box.get('trips_list', defaultValue: []) as List<dynamic>;
      final Set<String> existingTitles = {};
      for (var jsonStr in tripsJson) {
        try {
          final decoded = jsonDecode(jsonStr as String);
          if (decoded['title'] != null) {
            existingTitles.add(decoded['title'].toString().trim().toLowerCase());
          }
        } catch (_) {}
      }

      String proposedTitle = baseTitle.trim();
      if (!existingTitles.contains(proposedTitle.toLowerCase())) {
        return proposedTitle;
      }

      final tripNumberPattern = RegExp(r'^(.+?)\s*(?:(\d+)|\((\d+)\))$');
      final match = tripNumberPattern.firstMatch(proposedTitle);
      String prefix = proposedTitle;
      int counter = 1;

      if (match != null) {
        prefix = match.group(1) ?? proposedTitle;
        final numStr = match.group(2) ?? match.group(3);
        if (numStr != null) {
          counter = int.parse(numStr);
        }
      }

      prefix = prefix.trim();
      while (true) {
        counter++;
        final newTitle = "$prefix $counter";
        if (!existingTitles.contains(newTitle.toLowerCase())) {
          return newTitle;
        }
      }
    } catch (_) {
      return baseTitle;
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
      
      final baseTitle = currentSuccess.tripTitle ?? "Trip 1";
      final tripTitle = await _getUniqueTitle(baseTitle);
      final box = await Hive.openBox('saved_trips');
      final distanceUnit = await AppPreference.instance.get(key: AppPreference.KEY_DISTANCE_UNIT);
      final unit = distanceUnit.isNotEmpty ? distanceUnit : 'km';
      
      final tripData = {
        'title': tripTitle,
        'unit': unit,
        'rides': currentSuccess.selectedRides.map((e) => e.toJson()).toList(),
      };
      
      try {
        final trips = List<dynamic>.from(box.get('trips_list', defaultValue: []));
        trips.add(jsonEncode(tripData));
        await box.put('trips_list', trips);
      } catch (e) {
        debugPrint('Error saving trip: $e');
      }
      
      // Emit saved state with the data
      emit(CreateTripSaved(
        title: tripTitle,
        rides: currentSuccess.selectedRides,
        savedUnit: unit,
      ));
    }
  }
}
