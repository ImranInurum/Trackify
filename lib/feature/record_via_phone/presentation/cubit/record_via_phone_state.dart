import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trackify/feature/record_via_phone/data/model/device_data_by_date_response.dart';

abstract class RecordViaPhoneState extends Equatable {
  final bool isRecording;
  final List<LatLng> currentRidePoints;
  final Duration rideDuration;
  final double rideDistance;
  final double currentSpeed;
  final double topSpeed;
  final List<DataByDate> data;
  final Set<Polyline>? polylines;

  const RecordViaPhoneState({
    this.isRecording = false,
    this.currentRidePoints = const [],
    this.rideDuration = Duration.zero,
    this.rideDistance = 0.0,
    this.currentSpeed = 0.0,
    this.topSpeed = 0.0,
    this.data = const [],
    this.polylines,
  });

  @override
  List<Object?> get props => [
    isRecording,
    currentRidePoints,
    rideDuration,
    rideDistance,
    currentSpeed,
    topSpeed,
    data,
    polylines,
  ];
}

class MapInitial extends RecordViaPhoneState {
  const MapInitial() : super();
}

class MapLoading extends RecordViaPhoneState {
  const MapLoading({
    super.isRecording,
    super.currentRidePoints,
    super.rideDuration,
    super.rideDistance,
    super.currentSpeed,
    super.topSpeed,
    super.data,
    super.polylines,
  });
}

class MapDataByDateLoaded extends RecordViaPhoneState {
  const MapDataByDateLoaded({
    required super.data,
    required super.polylines,
    super.isRecording,
    super.currentRidePoints,
    super.rideDuration,
    super.rideDistance,
    super.currentSpeed,
    super.topSpeed,
  });
}

class MapError extends RecordViaPhoneState {
  final String message;

  const MapError(
    this.message, {
    super.isRecording,
    super.currentRidePoints,
    super.rideDuration,
    super.rideDistance,
    super.currentSpeed,
    super.topSpeed,
    super.data,
    super.polylines,
  });

  @override
  List<Object?> get props => [...super.props, message];
}

class MapRecordingUpdate extends RecordViaPhoneState {
  const MapRecordingUpdate({
    required super.isRecording,
    required super.currentRidePoints,
    required super.rideDuration,
    required super.rideDistance,
    required super.currentSpeed,
    required super.topSpeed,
    super.data,
    super.polylines,
  });
}
