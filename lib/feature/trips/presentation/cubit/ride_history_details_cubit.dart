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

    if (!isClosed) {
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

  if (polylinePoints.isEmpty) {
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
  }

  // 1. Decoupled Speed Points (Use all available ride points for speed interpolation)
  final List<RidePoint> validSpeedPoints = ridePoints;

  // 2. Decoupled Time Points (Filter to keep only ones with valid parseable times)
  final List<RidePoint> validTimePoints = [];
  final List<DateTime> parsedTimes = [];
  for (var rp in ridePoints) {
    final t = _parseDateTime(rp.time);
    if (t != null) {
      validTimePoints.add(rp);
      parsedTimes.add(t);
    }
  }

  final int N = polylinePoints.length;
  List<RidePoint> merged = [];
  List<double> segmentWeights = List.filled(N - 1, 0.01);
  List<double> speeds = List.filled(N, 0.0);
  List<DateTime> times = List.filled(N, parsedTimes.isNotEmpty ? parsedTimes.first : DateTime.now());

  // Calculate cumulative distances along polylinePoints
  List<double> polylineDistances = [0.0];
  double totalDist = 0.0;
  for (int i = 1; i < N; i++) {
    totalDist += _calculateDistance(polylinePoints[i - 1], polylinePoints[i]);
    polylineDistances.add(totalDist);
  }

  // 3. Interpolate Speeds across all polyline points
  if (validSpeedPoints.length >= 2) {
    List<int> closestSpeedIndices = [];
    int prevIdx = 0;
    for (var rp in validSpeedPoints) {
      double minDist = double.infinity;
      int closestIdx = prevIdx;
      for (int i = prevIdx; i < N; i++) {
        double d = _calculateDistance(rp.location, polylinePoints[i]);
        if (d < minDist) {
          minDist = d;
          closestIdx = i;
        }
      }
      closestSpeedIndices.add(closestIdx);
      prevIdx = closestIdx;
    }

    // Prefix speeds
    final firstSpeedIdx = closestSpeedIndices.first;
    for (int i = 0; i <= firstSpeedIdx; i++) {
      speeds[i] = validSpeedPoints.first.speed;
    }

    // Interval speeds
    for (int k = 0; k < validSpeedPoints.length - 1; k++) {
      int startIdx = closestSpeedIndices[k];
      int endIdx = closestSpeedIndices[k + 1];
      double speed1 = validSpeedPoints[k].speed;
      double speed2 = validSpeedPoints[k + 1].speed;

      if (endIdx > startIdx) {
        double intervalDist = polylineDistances[endIdx] - polylineDistances[startIdx];
        for (int i = startIdx; i <= endIdx; i++) {
          double ratio = 0.0;
          if (intervalDist > 0.00001) {
            ratio = (polylineDistances[i] - polylineDistances[startIdx]) / intervalDist;
          }
          speeds[i] = speed1 + (speed2 - speed1) * ratio;
        }
      } else {
        speeds[startIdx] = speed2;
      }
    }

    // Suffix speeds
    final lastSpeedIdx = closestSpeedIndices.last;
    for (int i = lastSpeedIdx; i < N; i++) {
      speeds[i] = validSpeedPoints.last.speed;
    }
  } else if (validSpeedPoints.isNotEmpty) {
    double baseSpeed = validSpeedPoints.first.speed;
    for (int i = 0; i < N; i++) {
      speeds[i] = baseSpeed;
    }
  }

  // 4. Interpolate Times across all polyline points
  if (validTimePoints.length >= 2) {
    List<int> closestTimeIndices = [];
    int prevIdx = 0;
    for (var rp in validTimePoints) {
      double minDist = double.infinity;
      int closestIdx = prevIdx;
      for (int i = prevIdx; i < N; i++) {
        double d = _calculateDistance(rp.location, polylinePoints[i]);
        if (d < minDist) {
          minDist = d;
          closestIdx = i;
        }
      }
      closestTimeIndices.add(closestIdx);
      prevIdx = closestIdx;
    }

    // Prefix times
    final firstTimeIdx = closestTimeIndices.first;
    for (int i = 0; i <= firstTimeIdx; i++) {
      times[i] = parsedTimes.first;
    }

    // Interval times
    for (int k = 0; k < validTimePoints.length - 1; k++) {
      int startIdx = closestTimeIndices[k];
      int endIdx = closestTimeIndices[k + 1];
      DateTime t1 = parsedTimes[k];
      DateTime t2 = parsedTimes[k + 1];

      if (endIdx > startIdx) {
        double intervalDist = polylineDistances[endIdx] - polylineDistances[startIdx];
        double dt = t2.difference(t1).inMilliseconds.toDouble() / 1000.0;
        for (int i = startIdx; i <= endIdx; i++) {
          double ratio = 0.0;
          if (intervalDist > 0.00001) {
            ratio = (polylineDistances[i] - polylineDistances[startIdx]) / intervalDist;
          }
          times[i] = t1.add(Duration(milliseconds: (dt * ratio * 1000).toInt()));
        }
      } else {
        times[startIdx] = t2;
      }
    }

    // Suffix times
    final lastTimeIdx = closestTimeIndices.last;
    for (int i = lastTimeIdx; i < N; i++) {
      times[i] = parsedTimes.last;
    }
  } else if (parsedTimes.isNotEmpty) {
    DateTime baseTime = parsedTimes.first;
    for (int i = 0; i < N; i++) {
      times[i] = baseTime.add(Duration(seconds: i));
    }
  } else {
    DateTime baseTime = DateTime.now();
    for (int i = 0; i < N; i++) {
      times[i] = baseTime.add(Duration(seconds: i));
    }
  }

  // 5. Calculate segmentWeights using the fully interpolated speeds
  for (int i = 0; i < N - 1; i++) {
    double segDist = polylineDistances[i + 1] - polylineDistances[i];
    double segSpeed = (speeds[i] + speeds[i + 1]) / 2.0;
    double segWeight = 3600.0 * segDist / math.max(5.0, segSpeed);
    segmentWeights[i] = math.max(0.001, segWeight);
  }

  // Generate merged points list
  for (int i = 0; i < N; i++) {
    merged.add(
      RidePoint(
        location: polylinePoints[i],
        speed: speeds[i],
        time: _formatTime(times[i]),
      ),
    );
  }

  // Calculate cumulative weights
  List<double> weights = [0.0];
  double currentTotalWeight = 0.0;
  for (int i = 0; i < N - 1; i++) {
    currentTotalWeight += segmentWeights[i];
    weights.add(currentTotalWeight);
  }

  List<LatLng> smoothPositions = [];
  List<double> smoothHeadings = [];
  List<double> smoothSpeeds = [];
  List<String> smoothTimes = [];

  if (merged.length >= 2) {
    const double resolution = 0.016; // 60 points per logical second (16ms)

    // Initialize starting heading to the heading of the first segment
    double currentHeading = 0.0;
    final firstP1 = merged[0];
    final firstP2 = merged[1];
    if (firstP1.location != firstP2.location) {
      currentHeading = math.atan2(
            firstP2.location.longitude - firstP1.location.longitude,
            firstP2.location.latitude - firstP1.location.latitude,
          ) *
          180 /
          math.pi;
    }

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

      final DateTime t1 = times[i];
      final DateTime t2 = times[i + 1];

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

        // Smooth Heading using responsive filter (0.35)
        double diff = (targetHeading - currentHeading) % 360;
        if (diff > 180) diff -= 360;
        if (diff < -180) diff += 360;
        currentHeading = (currentHeading + diff * 0.35) % 360;
        smoothHeadings.add(currentHeading);

        // Smooth Time Display using raw DateTime interpolation directly
        final interpTime = t1.add(
          Duration(
            milliseconds: (t2.difference(t1).inMilliseconds * t).toInt(),
          ),
        );
        smoothTimes.add(_formatTime(interpTime));
      }
    }
    smoothPositions.add(merged.last.location);
    smoothHeadings.add(currentHeading);
    smoothSpeeds.add(merged.last.speed);
    smoothTimes.add(_formatTime(times.last));

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
      totalWeight: currentTotalWeight,
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
    totalWeight: currentTotalWeight,
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

DateTime? _parseDateTime(String? timeStr) {
  if (timeStr == null || timeStr.trim().isEmpty) return null;
  
  final cleanStr = timeStr.trim();
  
  // 1. Try ISO parsing directly
  DateTime? dt = DateTime.tryParse(cleanStr);
  if (dt != null) return dt.toLocal();
  
  // 2. Try replacing spaces with 'T' (e.g. "2026-05-23 15:41:10")
  dt = DateTime.tryParse(cleanStr.replaceAll(' ', 'T'));
  if (dt != null) return dt.toLocal();

  // 3. Try parsing Unix timestamp
  final isDigitsOnly = RegExp(r'^\d+$').hasMatch(cleanStr);
  if (isDigitsOnly) {
    final val = int.tryParse(cleanStr);
    if (val != null) {
      if (cleanStr.length == 10) {
        return DateTime.fromMillisecondsSinceEpoch(val * 1000);
      } else if (cleanStr.length >= 13) {
        return DateTime.fromMillisecondsSinceEpoch(val);
      }
    }
  }

  // 4. Try parsing time-only formats (e.g., "15:41:10" or "15:41:10.123")
  if (RegExp(r'^\d{2}:\d{2}:\d{2}(\.\d+)?$').hasMatch(cleanStr)) {
    final today = DateTime.now();
    final datePrefix = "${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
    dt = DateTime.tryParse("${datePrefix}T$cleanStr");
    if (dt != null) return dt;
  }

  // 5. Try parsing 12-hour formats (e.g. "03:41:10 PM" or "3:41:10 PM" or "03:41 PM")
  final amPmMatch = RegExp(r'^(\d{1,2}):(\d{2})(?::(\d{2}))?\s*(AM|PM|am|pm)$').firstMatch(cleanStr);
  if (amPmMatch != null) {
    int hour = int.parse(amPmMatch.group(1)!);
    final int minute = int.parse(amPmMatch.group(2)!);
    final int second = amPmMatch.group(3) != null ? int.parse(amPmMatch.group(3)!) : 0;
    final String amPm = amPmMatch.group(4)!.toUpperCase();
    if (amPm == 'PM' && hour < 12) hour += 12;
    if (amPm == 'AM' && hour == 12) hour = 0;
    
    final today = DateTime.now();
    return DateTime(today.year, today.month, today.day, hour, minute, second);
  }

  return null;
}
