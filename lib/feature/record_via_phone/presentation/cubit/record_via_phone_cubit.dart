import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trackify/core/widgets/loading_screen_ol.dart';
import 'package:trackify/feature/record_via_phone/domain/usecase/record_via_phone_use_case.dart';
import 'package:trackify/feature/record_via_phone/presentation/cubit/record_via_phone_state.dart';

class RecordViaPhoneCubit extends Cubit<RecordViaPhoneState> {
  final RecordViaPhoneUseCase _recordViaPhoneUseCase;
  Timer? _rideTimer;

  RecordViaPhoneCubit(this._recordViaPhoneUseCase) : super(const MapInitial());

  void startRecording() {
    emit(
      MapRecordingUpdate(
        isRecording: true,
        currentRidePoints: const [],
        rideDuration: Duration.zero,
        rideDistance: 0.0,
        currentSpeed: 0.0,
        data: state.data,
        polylines: state.polylines,
      ),
    );

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
            data: state.data,
            polylines: state.polylines,
          ),
        );
      }
    });
  }

  void stopRecording() {
    _rideTimer?.cancel();
    emit(
      MapRecordingUpdate(
        isRecording: false,
        currentRidePoints: state.currentRidePoints,
        rideDuration: state.rideDuration,
        rideDistance: state.rideDistance,
        currentSpeed: 0.0,
        data: state.data,
        polylines: state.polylines,
      ),
    );
    // Here you could also save the ride to a database or API
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

    emit(
      MapRecordingUpdate(
        isRecording: true,
        currentRidePoints: updatedPoints,
        rideDuration: state.rideDuration,
        rideDistance:
            state.rideDistance + (addedDistance / 1000), // Convert to km
        currentSpeed: position.speed * 3.6, // m/s to km/h
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
          ),
        );
        LoadingScreenOL().hide();
      },
    );
  }

  @override
  Future<void> close() {
    _rideTimer?.cancel();
    return super.close();
  }
}
