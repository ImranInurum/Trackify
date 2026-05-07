class TripModel {
  final String id;
  final String name;
  final double distance;
  final int rideCount;
  final String? imageUrl;

  TripModel({
    required this.id,
    required this.name,
    required this.distance,
    required this.rideCount,
    this.imageUrl,
  });
}
