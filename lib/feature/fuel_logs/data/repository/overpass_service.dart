import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/fuel_station_model.dart';
import 'package:geolocator/geolocator.dart';

class OverpassService {
  static const String _baseUrl = 'https://overpass-api.de/api/interpreter';

  Future<List<FuelStation>> fetchNearbyFuelStations(
    double lat,
    double lon, {
    double radius = 5000,
  }) async {
    final query =
        '''
[out:json][timeout:25];
node["amenity"="fuel"](around:$radius,$lat,$lon);
out;
    ''';

    try {
      final uri = Uri.parse('$_baseUrl?data=${Uri.encodeComponent(query)}');
      final response = await http
          .get(
            uri,
            headers: {
              'User-Agent': 'Trackify/1.0 (https://trackify.com)',
            },
          )
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final elements = data['elements'] as List;

        List<FuelStation> stations = elements.map((e) {
          final station = FuelStation.fromJson(e);
          final distance = Geolocator.distanceBetween(
            lat,
            lon,
            station.lat,
            station.lon,
          );
          return station.copyWith(distance: distance / 1000); // km
        }).toList();

        // Sort by distance
        stations.sort((a, b) => (a.distance ?? 0).compareTo(b.distance ?? 0));
        return stations;
      } else {
        print('Overpass API Error Status: ${response.statusCode}');
        print('Overpass API Error Body: ${response.body}');
        throw Exception(
          'Failed to fetch fuel stations: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Overpass Service Exception: $e');
      throw Exception('Overpass API Error: $e');
    }
  }
}
