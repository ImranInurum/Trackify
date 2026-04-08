import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trackify/feature/record_via_phone/data/model/device_data_by_date_response.dart';

abstract class RecordViaPhoneState extends Equatable {
  final bool isRecording;
  final List<LatLng> currentRidePoints;
  final Duration rideDuration;
  final double rideDistance;
  final double currentSpeed;

  const RecordViaPhoneState({
    this.isRecording = false,
    this.currentRidePoints = const [],
    this.rideDuration = Duration.zero,
    this.rideDistance = 0.0,
    this.currentSpeed = 0.0,
  });

  @override
  List<Object?> get props => [
    isRecording,
    currentRidePoints,
    rideDuration,
    rideDistance,
    currentSpeed,
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
  });
}

class MapDataByDateLoaded extends RecordViaPhoneState {
  final List<DataByDate> data;
  final Set<Polyline>? polylines;

  const MapDataByDateLoaded({
    required this.data,
    required this.polylines,
    super.isRecording,
    super.currentRidePoints,
    super.rideDuration,
    super.rideDistance,
    super.currentSpeed,
  });

  @override
  List<Object?> get props => [...super.props, data, polylines];
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
  });
}
