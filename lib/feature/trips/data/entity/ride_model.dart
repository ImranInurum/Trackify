class Ride {
  final String id;
  final String date;
  final String startTime;
  final String endTime;
  final double distance;
  final String startLocation;
  final String endLocation;
  final String duration;
  final double topSpeed;
  final double avgSpeed;
  final String mapImageUrl;

  Ride({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.distance,
    required this.startLocation,
    required this.endLocation,
    required this.duration,
    required this.topSpeed,
    required this.avgSpeed,
    required this.mapImageUrl,
  });
}
