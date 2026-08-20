import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:trackify/core/widgets/location_consent_dialog.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();

  factory LocationService() => _instance;

  LocationService._internal();

  StreamSubscription<Position>? _positionSubscription;
  final StreamController<Position> _locationController = StreamController<Position>.broadcast();

  Stream<Position> get locationStream => _locationController.stream;

  Future<void> initialize({BuildContext? context}) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      if (context != null && context.mounted) {
        final bool userConsented = await LocationConsentDialog.show(context);
        if (!userConsented) {
          throw Exception('User declined location permission consent.');
        }
      }
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }
  }

  Future<Position> getCurrentLocation({LocationAccuracy accuracy = LocationAccuracy.high}) async {
    return await Geolocator.getCurrentPosition(desiredAccuracy: accuracy);
  }

  void startTracking({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int distanceFilter = 10,
  }) {
    stopTracking();

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilter,
      ),
    ).listen((Position position) {
      _locationController.add(position);
    });
  }

  void stopTracking() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  void dispose() {
    stopTracking();
    _locationController.close();
  }
}
