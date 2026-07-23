import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:trackify/core/widgets/loading_screen_ol.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackify/feature/record_via_phone/domain/usecase/record_via_phone_use_case.dart';
import 'package:trackify/feature/record_via_phone/presentation/cubit/record_via_phone_state.dart';

class RecordViaPhoneCubit extends Cubit<RecordViaPhoneState> {
  final RecordViaPhoneUseCase _recordViaPhoneUseCase;
  Timer? _rideTimer;
  StreamSubscription<Position>? _positionStream;

  /// 0 = online, 1 = offline
  int saveMode = 0;

  static const String _offlineRidesKey = 'offline_saved_rides';

  RecordViaPhoneCubit(this._recordViaPhoneUseCase) : super(const MapInitial());

  void startRecording({int mode = 0}) async {
    saveMode = mode;
    emit(
      MapRecordingUpdate(
        isRecording: true,
        currentRidePoints: const [],
        rideDuration: Duration.zero,
        rideDistance: 0.0,
        currentSpeed: 0.0,
        topSpeed: 0.0,
        data: state.data,
        polylines: state.polylines,
      ),
    );

    // Fetch initial location immediately
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      updateRecordingData(position);
    } catch (e) {
      debugPrint("Error getting initial location: $e");
    }

    _positionStream?.cancel();
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 2,
      ),
    ).listen((position) {
      updateRecordingData(position);
    });

    _rideTimer?.cancel();
    _rideTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.isRecording) {
        emit(
          MapRecordingUpdate(
            isRecording: true,
            currentRidePoints: state.currentRidePoints,
            rideDuration: state.rideDuration + const Duration(seconds: 1),
            rideDistance: state.rideDistance,
            currentSpeed: state.currentSpeed,
            topSpeed: state.topSpeed,
            data: state.data,
            polylines: state.polylines,
          ),
        );
      }
    });
  }

  void stopRecording() {
    _positionStream?.cancel();
    _rideTimer?.cancel();
    emit(
      MapRecordingUpdate(
        isRecording: false,
        currentRidePoints: state.currentRidePoints,
        rideDuration: state.rideDuration,
        rideDistance: state.rideDistance,
        currentSpeed: 0.0,
        topSpeed: state.topSpeed,
        data: state.data,
        polylines: state.polylines,
      ),
    );
  }

  Future<Box> _getOfflineRidesBox() async {
    return Hive.isBoxOpen(_offlineRidesKey)
        ? Hive.box(_offlineRidesKey)
        : await Hive.openBox(_offlineRidesKey);
  }

  /// Saves the completed ride locally to Hive 'offline_rides' box.
  Future<bool> saveRideOffline({
    required String tag,
    required List<LatLng> points,
    required double distanceKm,
    required Duration duration,
    required double avgSpeed,
    required double topSpeed,
  }) async {
    try {
      final box = await _getOfflineRidesBox();
      final id = 'ride_${DateTime.now().millisecondsSinceEpoch}';

      final rideMap = {
        'id': id,
        'tag': tag,
        'dateStr': DateTime.now().toIso8601String(),
        'distanceKm': distanceKm,
        'durationSeconds': duration.inSeconds,
        'avgSpeed': avgSpeed,
        'topSpeed': topSpeed,
        'points': points
            .map((p) => {'lat': p.latitude, 'lng': p.longitude})
            .toList(),
      };

      await box.put(id, jsonEncode(rideMap));
      debugPrint('✅ Offline ride saved to Hive. Key: $id | Total: ${box.length}');
      return true;
    } catch (e) {
      debugPrint('❌ Error saving offline ride to Hive: $e');
      return false;
    }
  }

  /// Saves the completed ride online to the backend.
  Future<bool> saveRideOnline({
    required String tag,
    required List<LatLng> points,
    required double distanceKm,
    required Duration duration,
    required double avgSpeed,
    required double topSpeed,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(AppPreference.KEY_USER_ID) ?? '';
      
      final body = {
        "userId": userId,
        "tag": tag,
        "date_time": DateTime.now().toIso8601String(),
        "distance_km": distanceKm,
        "duration_seconds": duration.inSeconds,
        "avg_speed": avgSpeed,
        "top_speed": topSpeed,
        "points": points.map((p) => {"lat": p.latitude, "lng": p.longitude}).toList(),
      };
      
      final res = await _recordViaPhoneUseCase.saveRideModeOnline(body);
      return res.fold(
        (failure) {
          debugPrint('❌ Error saving online ride: ${failure.message}');
          return false;
        },
        (_) {
          debugPrint('✅ Online ride saved to backend.');
          return true;
        },
      );
    } catch (e) {
      debugPrint('❌ Exception saving online ride: $e');
      return false;
    }
  }

  /// Returns all locally saved offline rides from Hive, newest first.
  Future<List<Map<String, dynamic>>> getOfflineRides() async {
    try {
      final box = await _getOfflineRidesBox();
      final rides = box.values
          .map((v) => jsonDecode(v as String) as Map<String, dynamic>)
          .toList();
      // Sort newest first by dateStr
      rides.sort((a, b) {
        final aDate = DateTime.tryParse(a['dateStr'] ?? '') ?? DateTime(0);
        final bDate = DateTime.tryParse(b['dateStr'] ?? '') ?? DateTime(0);
        return bDate.compareTo(aDate);
      });
      return rides;
    } catch (e) {
      debugPrint('❌ Error fetching offline rides: $e');
      return [];
    }
  }

  /// Returns all saved offline rides from Hive and online rides from backend, newest first.
  Future<List<Map<String, dynamic>>> getAllPastRides() async {
    List<Map<String, dynamic>> allRides = [];

    // 1. Fetch Offline Rides
    try {
      final offlineRides = await getOfflineRides();
      allRides.addAll(offlineRides);
    } catch (e) {
      debugPrint('❌ Error fetching offline rides in getAllPastRides: $e');
    }

    // 2. Fetch Online Rides
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(AppPreference.KEY_USER_ID) ?? '';
      
      if (userId.isNotEmpty) {
        final res = await _recordViaPhoneUseCase.getOnlinePastRides(userId);
        res.fold(
          (failure) => debugPrint('❌ Error fetching online rides: ${failure.message}'),
          (data) {
            if (data is Map && data['data'] is List) {
              final onlineList = data['data'] as List;
              for (var r in onlineList) {
                if (r is Map) {
                  final mappedRide = {
                    'id': r['_id'],
                    'dateStr': r['date_time'],
                    'tag': r['tag'] ?? 'Commute',
                    'isFavorite': false,
                    'distanceKm': (r['distance_km'] as num?)?.toDouble() ?? 0.0,
                    'durationSeconds': r['duration_seconds'] as int? ?? 0,
                    'avgSpeed': (r['avg_speed'] as num?)?.toDouble() ?? 0.0,
                    'points': r['points'] ?? [],
                  };
                  allRides.add(mappedRide);
                }
              }
            }
          },
        );
      }
    } catch (e) {
      debugPrint('❌ Exception fetching online rides: $e');
    }

    // 3. Sort newest first
    allRides.sort((a, b) {
      final aDate = DateTime.tryParse(a['dateStr'] ?? '') ?? DateTime(0);
      final bDate = DateTime.tryParse(b['dateStr'] ?? '') ?? DateTime(0);
      return bDate.compareTo(aDate);
    });

    return allRides;
  }

  /// Deletes a specific offline ride by its id key.
  Future<void> deleteOfflineRide(String id) async {
    try {
      final box = await _getOfflineRidesBox();
      await box.delete(id);
      debugPrint('🗑️ Offline ride deleted. Key: $id');
    } catch (e) {
      debugPrint('❌ Error deleting offline ride: $e');
    }
  }

  /// Updates tag of a specific offline ride by its id key.
  Future<bool> updateOfflineRideTag(String id, String newTag) async {
    try {
      final box = await _getOfflineRidesBox();
      final rawData = box.get(id);
      if (rawData != null) {
        final rideMap = jsonDecode(rawData as String) as Map<String, dynamic>;
        rideMap['tag'] = newTag;
        await box.put(id, jsonEncode(rideMap));
        debugPrint('🏷️ Offline ride tag updated. Key: $id | Tag: $newTag');
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('❌ Error updating offline ride tag: $e');
      return false;
    }
  }

  void updateRecordingData(Position position) {
    if (!state.isRecording) return;

    final List<LatLng> updatedPoints = List.from(state.currentRidePoints);
    final LatLng newPoint = LatLng(position.latitude, position.longitude);

    double addedDistance = 0.0;
    if (updatedPoints.isNotEmpty) {
      final lastPoint = updatedPoints.last;
      addedDistance = Geolocator.distanceBetween(
        lastPoint.latitude,
        lastPoint.longitude,
        newPoint.latitude,
        newPoint.longitude,
      );
    }

    updatedPoints.add(newPoint);

    double newCurrentSpeed = position.speed * 3.6; // m/s to km/h
    double newTopSpeed = newCurrentSpeed > state.topSpeed ? newCurrentSpeed : state.topSpeed;

    final newDistance = state.rideDistance + (addedDistance / 1000);
    emit(
      MapRecordingUpdate(
        isRecording: true,
        currentRidePoints: updatedPoints,
        rideDuration: state.rideDuration,
        rideDistance: newDistance, // Convert to km
        currentSpeed: newCurrentSpeed,
        topSpeed: newTopSpeed,
        data: state.data,
        polylines: state.polylines,
      ),
    );

  }

  Future<void> fetchDeviceDataByDate({
    required String imei,
    required String startDate,
    String? endDate,
  }) async {
    final body = {"imei": imei, "start_date": startDate, "end_date": endDate};
    LoadingScreenOL().show();
    emit(
      MapLoading(
        isRecording: state.isRecording,
        currentRidePoints: state.currentRidePoints,
        rideDuration: state.rideDuration,
        rideDistance: state.rideDistance,
        currentSpeed: state.currentSpeed,
        topSpeed: state.topSpeed,
        data: state.data,
        polylines: state.polylines,
      ),
    );

    final result = await _recordViaPhoneUseCase.fetchDeviceDataByDate(body);

    result.fold(
      (failure) {
        emit(
          MapError(
            failure.message ?? "",
            isRecording: state.isRecording,
            currentRidePoints: state.currentRidePoints,
            rideDuration: state.rideDuration,
            rideDistance: state.rideDistance,
            currentSpeed: state.currentSpeed,
            topSpeed: state.topSpeed,
            data: state.data,
            polylines: state.polylines,
          ),
        );
        LoadingScreenOL().hide();
      },
      (deviceDataByDate) {
        final list = deviceDataByDate.data ?? [];
        final List<LatLng> points = [];

        for (var item in list.reversed) {
          final lat = double.tryParse(item.lt ?? '');
          final lng = double.tryParse(item.lg ?? '');

          if (lat == null || lng == null) continue;

          final ns = (item.ns ?? '').toUpperCase();
          final ew = (item.ew ?? '').toUpperCase();

          double finalLat = ns == 'S' ? -lat.abs() : lat.abs();
          double finalLng = ew == 'W' ? -lng.abs() : lng.abs();

          if (finalLat < 10 || finalLat > 40) continue;
          if (finalLng < 60 || finalLng > 100) continue;

          if (finalLat == 0 || finalLng == 0) continue;

          points.add(LatLng(finalLat, finalLng));
        }
        print("points for the selected date range.${points.length} ");
        final Set<Polyline> polylines = {
          Polyline(
            polylineId: const PolylineId("ride_path"),
            points: points,
            color: Colors.blueAccent,
            width: 4,
          ),
        };

        emit(
          MapDataByDateLoaded(
            data: list,
            polylines: polylines,
            isRecording: state.isRecording,
            currentRidePoints: state.currentRidePoints,
            rideDuration: state.rideDuration,
            rideDistance: state.rideDistance,
            currentSpeed: state.currentSpeed,
            topSpeed: state.topSpeed,
          ),
        );
        LoadingScreenOL().hide();
      },
    );
  }

  @override
  Future<void> close() {
    _positionStream?.cancel();
    _rideTimer?.cancel();
    return super.close();
  }
}
