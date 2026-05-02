import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import '../../domain/entity/geo_fence_entity.dart';
import '../../domain/usecase/add_geo_fence_usecase.dart';
import '../../domain/usecase/get_geo_fence_usecase.dart';

import 'geo_fence_state.dart';

class GeoFenceCubit extends Cubit<GeoFenceState> {
  final GetGeoFenceUseCase _getGeoFenceUseCase;
  final AddGeoFenceUseCase _addGeoFenceUseCase;

  GeoFenceCubit(this._getGeoFenceUseCase, this._addGeoFenceUseCase)
    : super(GeoFenceInitial());

  Future<void> fetchGeoFences() async {
    emit(GeoFenceLoading());

    try {
      final geoFences = await _getGeoFenceUseCase();
      emit(GeoFenceLoaded(geoFences: geoFences));
    } catch (e) {
      emit(GeoFenceError(e.toString()));
    }
  }

  // Handle form updates via Cubit
  void updateForm({
    required double latitude,
    required double longitude,
    required double radius,
    required String selectedType,
    String? address,
  }) {
    emit(
      GeoFenceFormUpdated(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        selectedType: selectedType,
        address: address,
      ),
    );
  }

  // Fetch address from coordinates
  Future<void> updateAddress({
    required double latitude,
    required double longitude,
    required double radius,
    required String selectedType,
  }) async {
    try {
      // Use locale for better local results
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        // Prioritize Colony/Building/Area names
        final name = place.name ?? "";
        final subLocality = place.subLocality ?? "";
        final locality = place.locality ?? "";
        final street = place.street ?? "";

        String address = "";

        // In India, subLocality is often the Colony name
        if (subLocality.isNotEmpty) {
          address = subLocality;
          if (name.isNotEmpty &&
              name != subLocality &&
              !name.contains(subLocality)) {
            address = "$name, $address";
          }
        } else if (name.isNotEmpty) {
          address = name;
        } else if (street.isNotEmpty) {
          address = street;
        }

        // Add City
        if (locality.isNotEmpty && !address.contains(locality)) {
          if (address.isNotEmpty) address += ", ";
          address += locality;
        }

        if (address.isEmpty || address.length < 3) {
          address = locality.isNotEmpty ? locality : "Area near Indore";
        }

        // Add City/State if short
        if (!address.contains(locality) && locality.isNotEmpty) {
          address += ", $locality";
        }

        if (address.isEmpty || address.length < 3) {
          address = "Location at $locality";
        }

        emit(
          GeoFenceFormUpdated(
            latitude: latitude,
            longitude: longitude,
            radius: radius,
            selectedType: selectedType,
            address: address,
          ),
        );
      } else {
        // Fallback to coordinates if no placemarks found
        emit(
          GeoFenceFormUpdated(
            latitude: latitude,
            longitude: longitude,
            radius: radius,
            selectedType: selectedType,
            address: "Lat: ${placemarks.first.locality}",
          ),
        );
      }
    } catch (e) {
      print("Address Error ${e.toString()}");
      // On error, show coordinates so the user knows it's at least tracking
      emit(
        GeoFenceFormUpdated(
          latitude: latitude,
          longitude: longitude,
          radius: radius,
          selectedType: selectedType,
          address: "",
        ),
      );
    }
  }

  Future<void> searchLocation(
    String query,
    double radius,
    String selectedType,
  ) async {
    if (query.isEmpty) return;

    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        // After finding coordinates, update the address to a more formal one
        await updateAddress(
          latitude: loc.latitude,
          longitude: loc.longitude,
          radius: radius,
          selectedType: selectedType,
        );
      }
    } catch (e) {
      // If geocoding fails, we just keep current state or maybe emit an error
    }
  }

  Future<void> addGeoFence(GeoFenceEntity geoFence) async {
    emit(GeoFenceSubmitting());

    try {
      await _addGeoFenceUseCase(geoFence);
      emit(GeoFenceSuccess());
      // Refresh list after success
      fetchGeoFences();
    } catch (e) {
      emit(GeoFenceError(e.toString()));
    }
  }
}
