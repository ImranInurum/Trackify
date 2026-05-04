import '../../domain/entity/geo_fence_entity.dart';

class GeoFenceModel extends GeoFenceEntity {
  GeoFenceModel({
    required super.id,
    required super.imei,
    required super.name,
    required super.type,
    required super.latitude,
    required super.longitude,
    required super.radius,
    super.vehicleName,
    super.isActive = true,
  });

  factory GeoFenceModel.fromJson(Map<String, dynamic> json) {
    // Handling geofencingCoordinates list if present
    double lat = 0.0;
    double lng = 0.0;
    if (json['geofencingCoordinates'] != null &&
        (json['geofencingCoordinates'] as List).isNotEmpty) {
      final firstCoord = json['geofencingCoordinates'][0];
      lat = (firstCoord['lat'] as num).toDouble();
      lng = (firstCoord['lng'] as num).toDouble();
    } else {
      lat = (json['latitude'] as num? ?? 0.0).toDouble();
      lng = (json['longitude'] as num? ?? 0.0).toDouble();
    }

    return GeoFenceModel(
      id: json['_id'] ?? json['id'] ?? '',
      imei: json['imei'] ?? '',
      name: json['geofencName'] ?? json['name'] ?? '',
      type: json['type'] ?? 'Circle',
      latitude: lat,
      longitude: lng,
      radius: (json['radius'] as num? ?? 100.0).toDouble(),
      vehicleName: json['vehicleName'],
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imei': imei,
      'radius': radius,
      'geofencName': name,
      'geofencingCoordinates': [
        {
          'lat': latitude,
          'lng': longitude,
        }
      ],
    };
  }
}
