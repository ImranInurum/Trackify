import 'ride_history_response_model.dart';

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

  factory Ride.fromSummary(String id, RideSummaryModel summary) {
    // Helper to format ISO date to readable date
    String formatDate(String? isoString) {
      if (isoString == null) return "Unknown Date";
      try {
        final date = DateTime.parse(isoString);
        // Simple formatting, could use intl package if available
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

    return Ride(
      id: id,
      date: formatDate(summary.startTime),
      startTime: formatTime(summary.startTime),
      endTime: formatTime(summary.endTime),
      distance: summary.totalDistanceKm ?? 0.0,
      startLocation: "N/A", // API doesn't provide address
      endLocation: "N/A",   // API doesn't provide address
      duration: "${summary.durationMinutes ?? 0}m",
      topSpeed: summary.topSpeed ?? 0.0,
      avgSpeed: summary.avgSpeed ?? 0.0,
      mapImageUrl: "https://api.placeholder.com/400/200", // Default placeholder
    );
  }
}
