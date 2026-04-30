import 'package:equatable/equatable.dart';

class FuelStation extends Equatable {
  final String id;
  final String name;
  final double lat;
  final double lon;
  final String? address;
  final double? distance;
  final String? brand;

  const FuelStation({
    required this.id,
    required this.name,
    required this.lat,
    required this.lon,
    this.address,
    this.distance,
    this.brand,
  });

  factory FuelStation.fromJson(Map<String, dynamic> json, {double? userLat, double? userLon}) {
    final tags = json['tags'] ?? {};
    final lat = (json['lat'] ?? json['center']?['lat'] ?? 0.0) as double;
    final lon = (json['lon'] ?? json['center']?['lon'] ?? 0.0) as double;
    
    return FuelStation(
      id: json['id'].toString(),
      name: tags['name'] ?? tags['operator'] ?? 'Unknown Station',
      lat: lat,
      lon: lon,
      address: tags['addr:full'] ?? _buildAddress(tags),
      brand: tags['brand'] ?? tags['operator'],
    );
  }

  static String? _buildAddress(Map<String, dynamic> tags) {
    List<String> parts = [];
    if (tags.containsKey('addr:street')) parts.add(tags['addr:street']);
    if (tags.containsKey('addr:suburb')) parts.add(tags['addr:suburb']);
    if (tags.containsKey('addr:city')) parts.add(tags['addr:city']);
    if (tags.containsKey('addr:postcode')) parts.add(tags['addr:postcode']);
    return parts.isEmpty ? null : parts.join(', ');
  }

  FuelStation copyWith({double? distance}) {
    return FuelStation(
      id: id,
      name: name,
      lat: lat,
      lon: lon,
      address: address,
      distance: distance ?? this.distance,
      brand: brand,
    );
  }

  @override
  List<Object?> get props => [id, name, lat, lon, address, distance, brand];
}
