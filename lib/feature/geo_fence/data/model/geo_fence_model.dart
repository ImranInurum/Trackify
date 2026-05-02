import '../../domain/entity/geo_fence_entity.dart';

class GeoFenceModel extends GeoFenceEntity {
  GeoFenceModel({
    required super.id,
    required super.name,
    required super.type,
    required super.latitude,
    required super.longitude,
    required super.radius,
    super.vehicleName,
    super.isActive = true,
  });

  factory GeoFenceModel.fromJson(Map<String, dynamic> json) {
    return GeoFenceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      radius: (json['radius'] as num).toDouble(),
      vehicleName: json['vehicleName'],
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
      'vehicleName': vehicleName,
      'isActive': isActive,
    };
  }
}
