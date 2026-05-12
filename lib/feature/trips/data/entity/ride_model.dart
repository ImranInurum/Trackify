import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'ride_history_response_model.dart';

class RidePoint {
  final LatLng location;
  final double speed;
  final String? time;

  RidePoint({required this.location, required this.speed, this.time});
}

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
  final List<LatLng> polylinePoints;
  final List<RidePoint> points;

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
    required this.polylinePoints,
    required this.points,
  });

  Ride copyWith({
    String? id,
    String? date,
    String? startTime,
    String? endTime,
    double? distance,
    String? startLocation,
    String? endLocation,
    String? duration,
    double? topSpeed,
    double? avgSpeed,
    String? mapImageUrl,
    List<LatLng>? polylinePoints,
    List<RidePoint>? points,
  }) {
    return Ride(
      id: id ?? this.id,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      distance: distance ?? this.distance,
      startLocation: startLocation ?? this.startLocation,
      endLocation: endLocation ?? this.endLocation,
      duration: duration ?? this.duration,
      topSpeed: topSpeed ?? this.topSpeed,
      avgSpeed: avgSpeed ?? this.avgSpeed,
      mapImageUrl: mapImageUrl ?? this.mapImageUrl,
      polylinePoints: polylinePoints ?? this.polylinePoints,
      points: points ?? this.points,
    );
  }

  static Ride mergeRides(List<Ride> rides) {
    if (rides.isEmpty) {
      return Ride(
        id: "empty",
        date: "",
        startTime: "",
        endTime: "",
        distance: 0,
        startLocation: "",
        endLocation: "",
        duration: "",
        topSpeed: 0,
        avgSpeed: 0,
        mapImageUrl: "",
        polylinePoints: [],
        points: [],
      );
    }

    final totalDistance = double.parse(
      rides.fold(0.0, (sum, r) => sum + r.distance).toStringAsFixed(2),
    );
    final topSpeed = rides.fold(
      0.0,
      (max, r) => r.topSpeed > max ? r.topSpeed : max,
    );
    final avgSpeed =
        rides.fold(0.0, (sum, r) => sum + r.avgSpeed) / rides.length;

    // Calculate total duration from duration strings (e.g. "20 min")
    int totalMinutes = 0;
    for (var r in rides) {
      final parts = r.duration.split(' ');
      if (parts.isNotEmpty) {
        totalMinutes += int.tryParse(parts[0]) ?? 0;
      }
    }

    final allPolylinePoints = rides.expand((r) => r.polylinePoints).toList();
    final allPoints = rides.expand((r) => r.points).toList();

    return Ride(
      id: "trip_${rides.first.id}",
      date: rides.first.date,
      startTime: rides.first.startTime,
      endTime: rides.last.endTime,
      distance: totalDistance,
      startLocation: rides.first.startLocation,
      endLocation: rides.last.endLocation,
      duration: "$totalMinutes min",
      topSpeed: topSpeed,
      avgSpeed: avgSpeed,
      mapImageUrl: rides.first.mapImageUrl,
      polylinePoints: allPolylinePoints,
      points: allPoints,
    );
  }

  factory Ride.fromTripModel(String id, RideTripModel trip) {
    final summary = trip.summary;

    // Helper to format ISO date to readable date
    String formatDate(String? isoString) {
      if (isoString == null) return "Unknown Date";
      try {
        final date = DateTime.parse(isoString);
        return "${date.day}/${date.month}/${date.year}";
      } catch (e) {
        return isoString;
      }
    }

    String formatTime(String? isoString) {
      if (isoString == null) return "--:--";
      try {
        final date = DateTime.parse(isoString);
        return "${date.hour}:${date.minute.toString().padLeft(2, '0')}";
      } catch (e) {
        return isoString;
      }
    }

    List<LatLng> polylinePoints = [];
    List<RidePoint> ridePoints = [];

    // 2. Use trip.points (populated from routeData)
    if (trip.points != null && trip.points!.isNotEmpty) {
      final parsedPoints = trip.points!
          .map((p) {
            double parseCoord(dynamic value) {
              if (value == null) return 0.0;
              if (value is num) return value.toDouble();
              return double.tryParse(value.toString()) ?? 0.0;
            }

            final lat = parseCoord(p.latitude);
            final lng = parseCoord(p.longitude);

            if (lat == 0.0 && lng == 0.0) return null;

            return RidePoint(
              location: LatLng(lat, lng),
              speed: p.speed ?? 0.0,
              time: p.time,
            );
          })
          .whereType<RidePoint>()
          .toList();

      if (parsedPoints.isNotEmpty) {
        ridePoints = parsedPoints;
        polylinePoints = parsedPoints.map((p) => p.location).toList();
      }
    }

    // 3. Remove consecutive identical points to simplify drawing and avoid straight-line artifacts
    if (polylinePoints.length > 1) {
      final filtered = <LatLng>[polylinePoints.first];
      for (int i = 1; i < polylinePoints.length; i++) {
        if (polylinePoints[i].latitude != polylinePoints[i - 1].latitude ||
            polylinePoints[i].longitude != polylinePoints[i - 1].longitude) {
          filtered.add(polylinePoints[i]);
        }
      }
      polylinePoints = filtered;
    }

    // Determine start and end locations from polyline points if available
    String startLoc = "N/A";
    String endLoc = "N/A";
    if (polylinePoints.isNotEmpty) {
      final start = polylinePoints.first;
      final end = polylinePoints.last;
      startLoc =
          "${start.latitude.toStringAsFixed(4)}, ${start.longitude.toStringAsFixed(4)}";
      endLoc =
          "${end.latitude.toStringAsFixed(4)}, ${end.longitude.toStringAsFixed(4)}";
    }

    return Ride(
      id: id,
      date:
          trip.date ??
          (summary != null ? formatDate(summary.startTime) : "N/A"),
      startTime: summary != null ? formatTime(summary.startTime) : "--:--",
      endTime: summary != null ? formatTime(summary.endTime) : "--:--",
      distance: summary?.totalDistanceKm ?? 0.0,
      startLocation: startLoc,
      endLocation: endLoc,
      duration: "${summary?.durationMinutes ?? 0}m",
      topSpeed: summary?.topSpeed ?? 0.0,
      avgSpeed: summary?.avgSpeed ?? 0.0,
      mapImageUrl: "",
      polylinePoints: polylinePoints,
      points: ridePoints,
    );
  }
}
