import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trackify/feature/trips/data/entity/ride_model.dart';
import 'package:trackify/feature/trips/presentation/cubit/ride_history_details_state.dart';
import 'package:flutter/foundation.dart';
import 'dart:math' as math;

class RideHistoryDetailsCubit extends Cubit<RideHistoryDetailsState> {
  final Ride ride;

  RideHistoryDetailsCubit({required this.ride})
    : super(const RideHistoryDetailsState());

  void initialize(
    BitmapDescriptor start,
    BitmapDescriptor end,
    BitmapDescriptor vehicle,
    String? mapStyle,
  ) async {
    emit(
      state.copyWith(
        startIcon: start,
        endIcon: end,
        vehicleIcon: vehicle,
        darkMapStyle: mapStyle,
      ),
    );

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
        smoothTimes: result.smoothTimes,
        currentVehiclePosition: null,
        currentHeading: initialHeading,
        currentSpeedDisplay: initialSpeed,
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
    if (state.smoothPositions.isEmpty) return;

    final int index = (progress * (state.smoothPositions.length - 1)).toInt();
    final clampedIndex = index.clamp(0, state.smoothPositions.length - 1);

    final pos = state.smoothPositions[clampedIndex];
    final heading = state.smoothHeadings[clampedIndex];
    final speed = state.smoothSpeeds[clampedIndex];
    final time = state.smoothTimes[clampedIndex];

    emit(
      state.copyWith(
        playProgress: progress,
        currentVehiclePosition: pos,
        currentSpeedDisplay: speed,
        currentHeading: heading,
        currentTimeDisplay: time,
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
      ),
    );
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
  final List<String> smoothTimes;

  _TripProcessingResult({
    required this.mergedPoints,
    required this.cumulativeWeights,
    required this.totalWeight,
    required this.cumulativeDistances,
    required this.smoothPositions,
    required this.smoothHeadings,
    required this.smoothSpeeds,
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
            double dt = t2.difference(t1).inMilliseconds.toDouble() / 1000.0;
            // High-speed Playback: Dynamic speed based on API, Max 0.5s stop
            timeWeight = dt.clamp(0.01, 0.5);
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
  }

  return _TripProcessingResult(
    mergedPoints: merged,
    cumulativeWeights: weights,
    totalWeight: smoothedTotal,
    cumulativeDistances: [],
    smoothPositions: smoothPositions,
    smoothHeadings: smoothHeadings,
    smoothSpeeds: smoothSpeeds,
    smoothTimes: smoothTimes,
  );
}

String _formatTime(DateTime time) {
  return "${time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour)}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')} ${time.hour >= 12 ? 'PM' : 'AM'}";
}
