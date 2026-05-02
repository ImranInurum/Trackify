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
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final address = "${place.name ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}".replaceAll(RegExp(r'^, |, $'), '').trim();

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
    } catch (e) {
      print("Address Error ${e.toString()}");
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
        await updateAddress(
          latitude: loc.latitude,
          longitude: loc.longitude,
          radius: radius,
          selectedType: selectedType,
        );
      }
    } catch (e) {
      // If geocoding fails
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
