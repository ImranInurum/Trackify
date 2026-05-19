import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trackify/feature/trips/data/entity/ride_model.dart';
import 'package:trackify/feature/trips/presentation/cubit/ride_history_details_state.dart';
import 'package:flutter/foundation.dart';
import 'dart:math' as math;

class RideHistoryDetailsCubit extends Cubit<RideHistoryDetailsState> {
  final Ride ride;

  RideHistoryDetailsCubit({required this.ride})
      : super(const RideHistoryDetailsState()) {
    _processTripData();
  }

  void initialize(
    BitmapDescriptor start,
    BitmapDescriptor end,
    BitmapDescriptor vehicle,
    String? mapStyle,
  ) {
    emit(
      state.copyWith(
        startIcon: start,
        endIcon: end,
        vehicleIcon: vehicle,
        darkMapStyle: mapStyle,
      ),
    );
  }

  void _processTripData() async {
    final validPoints = ride.polylinePoints
        .where((p) => p.latitude != 0.0 || p.longitude != 0.0)
        .toList();

    final validRidePoints = ride.points
        .where((p) => p.location.latitude != 0.0 || p.location.longitude != 0.0)
        .toList();

    final params = _TripProcessingParams(
      polylinePoints: validPoints,
      ridePoints: validRidePoints,
    );

    final result = await compute(_processTripDataInBackground, params)
        .catchError((e) {
          debugPrint("Trip processing error: $e");
          return _TripProcessingResult(
            mergedPoints: [],
            cumulativeWeights: [],
            totalWeight: 0,
            cumulativeDistances: [],
            smoothPositions: [],
            smoothHeadings: [],
            smoothSpeeds: [],
            smoothAvgSpeeds: [],
            smoothTimes: [],
          );
        });

    double initialHeading = 0.0;
    double initialSpeed = 0.0;
    String initialTime = "--:--";

    if (result.mergedPoints.isNotEmpty) {
      initialSpeed = result.mergedPoints.first.speed;
      initialTime = result.smoothTimes.isNotEmpty
          ? result.smoothTimes.first
          : "--:--";
    }

    emit(
      state.copyWith(
        isDataProcessing: false,
        validRidePoints: result.mergedPoints,
        cumulativeWeights: result.cumulativeWeights,
        totalWeight: result.totalWeight,
        cumulativeDistances: result.cumulativeDistances,
        smoothPositions: result.smoothPositions,
        smoothHeadings: result.smoothHeadings,
        smoothSpeeds: result.smoothSpeeds,
        smoothAvgSpeeds: result.smoothAvgSpeeds,
        smoothTimes: result.smoothTimes,
        currentVehiclePosition: null,
        currentHeading: initialHeading,
        currentSpeedDisplay: initialSpeed,
        currentAvgSpeedDisplay: initialSpeed,
        currentTimeDisplay: initialTime,
      ),
    );
  }

  void updateVehicleIcon(BitmapDescriptor icon) {
    emit(state.copyWith(vehicleIcon: icon));
  }

  void updatePlaybackStatus(bool isPlaying) {
    if (isPlaying) {
      if (state.currentVehiclePosition == null &&
          state.smoothPositions.isNotEmpty) {
        emit(
          state.copyWith(
            isPlaying: isPlaying,
            isPlaybackStarted: true,
            currentVehiclePosition: state.smoothPositions.first,
          ),
        );
      } else {
        emit(state.copyWith(isPlaying: isPlaying, isPlaybackStarted: true));
      }
    } else {
      emit(state.copyWith(isPlaying: isPlaying));
    }
  }

  void updateProgress(double progress) {
    if (state.isDataProcessing || state.smoothPositions.isEmpty) return;
    


    // 1. Calculate fractional index for ultra-smooth sub-coordinate mathematical LERP
    final double exactIndex = progress * (state.smoothPositions.length - 1);
    final int index1 = exactIndex.floor().clamp(0, state.smoothPositions.length - 1);
    final int index2 = exactIndex.ceil().clamp(0, state.smoothPositions.length - 1);
    final double t = exactIndex - exactIndex.floor();

    // 2. Continuous LatLng LERP (infinitely smooth frame-by-frame coordinate movement)
    final pos1 = state.smoothPositions[index1];
    final pos2 = state.smoothPositions[index2];
    final double lat = pos1.latitude + (pos2.latitude - pos1.latitude) * t;
    final double lng = pos1.longitude + (pos2.longitude - pos1.longitude) * t;
    final pos = LatLng(lat, lng);

    // 3. Continuous Heading LERP (circular shortest-path to prevent snap stutters)
    final double heading1 = state.smoothHeadings[index1];
    final double heading2 = state.smoothHeadings[index2];
    double diffHeading = heading2 - heading1;
    if (diffHeading > 180) diffHeading -= 360;
    if (diffHeading < -180) diffHeading += 360;
    final double heading = (heading1 + diffHeading * t) % 360;

    // 4. Continuous Speed & Average Speed LERP
    final double speed1 = state.smoothSpeeds[index1];
    final double speed2 = state.smoothSpeeds[index2];
    final double speed = speed1 + (speed2 - speed1) * t;

    final double avgSpeed1 = state.smoothAvgSpeeds.isNotEmpty ? state.smoothAvgSpeeds[index1] : 0.0;
    final double avgSpeed2 = state.smoothAvgSpeeds.isNotEmpty ? state.smoothAvgSpeeds[index2] : 0.0;
    final double avgSpeed = avgSpeed1 + (avgSpeed2 - avgSpeed1) * t;

    // 5. Continuous Distance LERP
    final double dist1 = state.cumulativeDistances.isNotEmpty ? state.cumulativeDistances[index1] : 0.0;
    final double dist2 = state.cumulativeDistances.isNotEmpty ? state.cumulativeDistances[index2] : 0.0;
    final double distance = dist1 + (dist2 - dist1) * t;

    // 6. Closest point's time display
    final String time = t < 0.5 ? state.smoothTimes[index1] : state.smoothTimes[index2];

    emit(
      state.copyWith(
        playProgress: progress,
        currentVehiclePosition: pos,
        currentSpeedDisplay: speed,
        currentHeading: heading,
        currentTimeDisplay: time,
        currentDistanceDisplay: distance,
        currentAvgSpeedDisplay: avgSpeed,
        isPlaybackStarted: true,
      ),
    );


  }

  void resetPlayback() {
    emit(
      state.copyWith(
        isPlaying: false,
        isPlaybackStarted: false,
        currentVehiclePosition: null,
        currentDistanceDisplay: 0.0,
        currentAvgSpeedDisplay: 0.0,
        playbackSpeed: 1,
      ),
    );
  }

  void updatePlaybackSpeed(int speed) {
    emit(state.copyWith(playbackSpeed: speed));
  }
}

class _TripProcessingParams {
  final List<LatLng> polylinePoints;
  final List<RidePoint> ridePoints;
  _TripProcessingParams({
    required this.polylinePoints,
    required this.ridePoints,
  });
}

class _TripProcessingResult {
  final List<RidePoint> mergedPoints;
  final List<double> cumulativeWeights;
  final double totalWeight;
  final List<double> cumulativeDistances;
  final List<LatLng> smoothPositions;
  final List<double> smoothHeadings;
  final List<double> smoothSpeeds;
  final List<double> smoothAvgSpeeds;
  final List<String> smoothTimes;

  _TripProcessingResult({
    required this.mergedPoints,
    required this.cumulativeWeights,
    required this.totalWeight,
    required this.cumulativeDistances,
    required this.smoothPositions,
    required this.smoothHeadings,
    required this.smoothSpeeds,
    required this.smoothAvgSpeeds,
    required this.smoothTimes,
  });
}

_TripProcessingResult _processTripDataInBackground(
  _TripProcessingParams params,
) {
  final polylinePoints = params.polylinePoints;
  final ridePoints = params.ridePoints;
  List<RidePoint> merged = [];

  if (ridePoints.isEmpty) {
    merged = polylinePoints
        .map((p) => RidePoint(location: p, speed: 0.0))
        .toList();
  } else {
    for (var latLng in polylinePoints) {
      RidePoint nearest = ridePoints.first;
      double minDist = double.infinity;
      for (var sampled in ridePoints) {
        double d = math.sqrt(
          math.pow(latLng.latitude - sampled.location.latitude, 2) +
              math.pow(latLng.longitude - sampled.location.longitude, 2),
        );
        if (d < minDist) {
          minDist = d;
          nearest = sampled;
        }
      }
      merged.add(
        RidePoint(location: latLng, speed: nearest.speed, time: nearest.time),
      );
    }
  }

  List<double> rawWeights = [0.0];
  double currentWeightTotal = 0.0;

  if (merged.length >= 2) {
    for (int i = 1; i < merged.length; i++) {
      final p1 = merged[i - 1];
      final p2 = merged[i];
      double timeWeight = 1.0;
      if (p1.time != null && p2.time != null) {
        try {
          final t1 =
              DateTime.tryParse(p1.time!) ??
              DateTime.tryParse(p1.time!.replaceAll(' ', 'T'));
          final t2 =
              DateTime.tryParse(p2.time!) ??
              DateTime.tryParse(p2.time!.replaceAll(' ', 'T'));
          if (t1 != null && t2 != null) {
            final double dt = t2.difference(t1).inMilliseconds.toDouble() / 1000.0;
            // Compress stops longer than 5.0 seconds to keep the animation engaging,
            // otherwise use actual real-time dt for exact 1x speed matching!
            timeWeight = dt.clamp(0.01, 5.0);
          }
        } catch (_) {}
      }
      currentWeightTotal += timeWeight;
      rawWeights.add(currentWeightTotal);
    }
  }

  // SMOOTH WEIGHTS
  List<double> weights = [0.0];
  double smoothedTotal = 0.0;
  for (int i = 1; i < rawWeights.length; i++) {
    double w = rawWeights[i] - rawWeights[i - 1];
    smoothedTotal += w;
    weights.add(smoothedTotal);
  }

  List<LatLng> smoothPositions = [];
  List<double> smoothHeadings = [];
  List<double> smoothSpeeds = [];
  List<String> smoothTimes = [];

  if (merged.length >= 2) {
    const double resolution = 0.016; // 60 points per logical second (16ms)
    double currentHeading = 0.0;

    for (int i = 0; i < merged.length - 1; i++) {
      final p1 = merged[i];
      final p2 = merged[i + 1];
      final double segmentWeight = weights[i + 1] - weights[i];
      final int steps = (segmentWeight / resolution).ceil();

      double targetHeading = currentHeading;
      if (p1.location != p2.location) {
        targetHeading =
            math.atan2(
              p2.location.longitude - p1.location.longitude,
              p2.location.latitude - p1.location.latitude,
            ) *
            180 /
            math.pi;
      }

      DateTime? t1 = p1.time != null
          ? (DateTime.tryParse(p1.time!) ??
                DateTime.tryParse(p1.time!.replaceAll(' ', 'T')))
          : null;
      DateTime? t2 = p2.time != null
          ? (DateTime.tryParse(p2.time!) ??
                DateTime.tryParse(p2.time!.replaceAll(' ', 'T')))
          : null;

      for (int s = 0; s < steps; s++) {
        double t = s / steps;
        smoothPositions.add(
          LatLng(
            p1.location.latitude +
                (p2.location.latitude - p1.location.latitude) * t,
            p1.location.longitude +
                (p2.location.longitude - p1.location.longitude) * t,
          ),
        );
        smoothSpeeds.add(p1.speed + (p2.speed - p1.speed) * t);

        // Smooth Heading
        double diff = (targetHeading - currentHeading) % 360;
        if (diff > 180) diff -= 360;
        if (diff < -180) diff += 360;
        currentHeading = (currentHeading + diff * 0.1) % 360;
        smoothHeadings.add(currentHeading);

        // Smooth Time Display
        if (t1 != null && t2 != null) {
          final interpTime = t1.add(
            Duration(
              milliseconds: (t2.difference(t1).inMilliseconds * t).toInt(),
            ),
          );
          smoothTimes.add(_formatTime(interpTime));
        } else {
          smoothTimes.add("--:--");
        }
      }
    }
    smoothPositions.add(merged.last.location);
    smoothHeadings.add(currentHeading);
    smoothSpeeds.add(merged.last.speed);
    if (merged.last.time != null) {
      final finalTime =
          DateTime.tryParse(merged.last.time!) ??
          DateTime.tryParse(merged.last.time!.replaceAll(' ', 'T'));
      smoothTimes.add(finalTime != null ? _formatTime(finalTime) : "--:--");
    } else {
      smoothTimes.add("--:--");
    }

    // Calculate cumulative distances for smooth positions
    List<double> smoothDistances = [0.0];
    double currentTotalDist = 0.0;
    for (int i = 1; i < smoothPositions.length; i++) {
      currentTotalDist += _calculateDistance(
        smoothPositions[i - 1],
        smoothPositions[i],
      );
      smoothDistances.add(currentTotalDist);
    }

    // Calculate running average speeds
    List<double> smoothAvgSpeeds = [];
    double sumSpeeds = 0.0;
    for (int i = 0; i < smoothSpeeds.length; i++) {
      sumSpeeds += smoothSpeeds[i];
      smoothAvgSpeeds.add(sumSpeeds / (i + 1));
    }

    return _TripProcessingResult(
      mergedPoints: merged,
      cumulativeWeights: weights,
      totalWeight: smoothedTotal,
      cumulativeDistances: smoothDistances,
      smoothPositions: smoothPositions,
      smoothHeadings: smoothHeadings,
      smoothSpeeds: smoothSpeeds,
      smoothAvgSpeeds: smoothAvgSpeeds,
      smoothTimes: smoothTimes,
    );
  }

  return _TripProcessingResult(
    mergedPoints: merged,
    cumulativeWeights: weights,
    totalWeight: smoothedTotal,
    cumulativeDistances: [],
    smoothPositions: smoothPositions,
    smoothHeadings: smoothHeadings,
    smoothSpeeds: smoothSpeeds,
    smoothAvgSpeeds: [],
    smoothTimes: smoothTimes,
  );
}

double _calculateDistance(LatLng p1, LatLng p2) {
  const double R = 6371; // Earth's radius in km
  final double dLat = (p2.latitude - p1.latitude) * math.pi / 180;
  final double dLon = (p2.longitude - p1.longitude) * math.pi / 180;
  final double a =
      math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(p1.latitude * math.pi / 180) *
          math.cos(p2.latitude * math.pi / 180) *
          math.sin(dLon / 2) *
          math.sin(dLon / 2);
  final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  return R * c;
}

String _formatTime(DateTime time) {
  return "${time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour)}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')} ${time.hour >= 12 ? 'PM' : 'AM'}";
}
