class GeoFenceEntity {
  final String id;
  final String name;
  final String type;
  final double latitude;
  final double longitude;
  final double radius;
  final String? vehicleName;

  final bool isActive;

  GeoFenceEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.radius,
    this.vehicleName,
    this.isActive = true,
  });
}
