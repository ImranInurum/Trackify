import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../data/repository/overpass_service.dart';
import 'fuel_stations_state.dart';

class FuelStationsCubit extends Cubit<FuelStationsState> {
  final OverpassService _overpassService;

  FuelStationsCubit(this._overpassService) : super(FuelStationsInitial());

  Future<void> fetchNearbyStations() async {
    print('FuelStationsCubit: fetchNearbyStations called');
    emit(FuelStationsLoading());
    try {
      // 1. Get current location
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      
      final latLng = LatLng(position.latitude, position.longitude);

      // 2. Fetch stations from Overpass
      final stations = await _overpassService.fetchNearbyFuelStations(
        position.latitude,
        position.longitude,
      );

      // 3. Create markers
      final markers = stations.map((station) {
        return Marker(
          markerId: MarkerId(station.id),
          position: LatLng(station.lat, station.lon),
          infoWindow: InfoWindow(
            title: station.name,
            snippet: station.address,
          ),
        );
      }).toSet();

      emit(FuelStationsLoaded(
        stations: stations,
        userLocation: latLng,
        markers: markers,
      ));
    } catch (e) {
      emit(FuelStationsError(e.toString()));
    }
  }
}
