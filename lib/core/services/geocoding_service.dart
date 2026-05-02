import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class GeocodingService {
  GeocodingService._();
  static final GeocodingService instance = GeocodingService._();

  // Simple in-memory cache to avoid repeated API calls for the same coords
  final Map<String, String> _cache = {};

  /// Returns a short human-readable location name for the given [latLng].
  /// Falls back gracefully if the request fails.
  Future<String> reverseGeocode(LatLng latLng) async {
    // Round to 4 decimal places for cache key (~11m precision)
    final key =
        '${latLng.latitude.toStringAsFixed(4)},${latLng.longitude.toStringAsFixed(4)}';

    if (_cache.containsKey(key)) return _cache[key]!;

    try {
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse'
        '?lat=${latLng.latitude}&lon=${latLng.longitude}'
        '&format=json&zoom=16&addressdetails=1',
      );

      final response = await http
          .get(uri, headers: {'User-Agent': 'Trackify-App/1.0'})
          .timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final address = data['address'] as Map<String, dynamic>?;

        // Pick the most useful short name available
        final name = address?['road'] ??
            address?['neighbourhood'] ??
            address?['suburb'] ??
            address?['village'] ??
            address?['town'] ??
            address?['city_district'] ??
            address?['city'] ??
            address?['county'] ??
            data['display_name']?.toString().split(',').first;

        final result = (name as String?)?.trim() ?? key;
        _cache[key] = result;
        return result;
      }
    } catch (e) {
      debugPrint('[GeocodingService] reverseGeocode error: $e');
    }

    // Fallback to short coordinate string
    final fallback =
        '${latLng.latitude.toStringAsFixed(3)}, ${latLng.longitude.toStringAsFixed(3)}';
    _cache[key] = fallback;
    return fallback;
  }
  /// Returns a list of [LatLng] for the given [address] query.
  Future<List<LatLng>> searchLocation(String address) async {
    try {
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/search'
        '?q=${Uri.encodeComponent(address)}'
        '&format=json&limit=5',
      );

      final response = await http
          .get(uri, headers: {'User-Agent': 'Trackify-App/1.0'})
          .timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data.map((item) {
          final lat = double.parse(item['lat'].toString());
          final lon = double.parse(item['lon'].toString());
          return LatLng(lat, lon);
        }).toList();
      }
    } catch (e) {
      debugPrint('[GeocodingService] searchLocation error: $e');
    }
    return [];
  }
}
