class GeoFenceEntity {
  final String id;
  final String imei;
  final String name;
  final String type;
  final double latitude;
  final double longitude;
  final double radius;
  final String? vehicleName;

  final bool isActive;

  GeoFenceEntity({
    required this.id,
    required this.imei,
    required this.name,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.radius,
    this.vehicleName,
    this.isActive = true,
  });
  GeoFenceEntity copyWith({
    String? id,
    String? imei,
    String? name,
    String? type,
    double? latitude,
    double? longitude,
    double? radius,
    String? vehicleName,
    bool? isActive,
  }) {
    return GeoFenceEntity(
      id: id ?? this.id,
      imei: imei ?? this.imei,
      name: name ?? this.name,
      type: type ?? this.type,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radius: radius ?? this.radius,
      vehicleName: vehicleName ?? this.vehicleName,
      isActive: isActive ?? this.isActive,
    );
  }
}
