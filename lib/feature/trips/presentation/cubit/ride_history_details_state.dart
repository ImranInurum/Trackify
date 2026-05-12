import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trackify/feature/trips/data/entity/ride_model.dart';

class RideHistoryDetailsState extends Equatable {
  final bool isDataProcessing;
  final List<RidePoint> validRidePoints;
  final List<double> cumulativeWeights;
  final double totalWeight;
  final List<double> cumulativeDistances;
  
  final List<LatLng> smoothPositions;
  final List<double> smoothHeadings;
  final List<double> smoothSpeeds;
  final List<String> smoothTimes;

  final LatLng? currentVehiclePosition;
  final double currentHeading;
  final double currentSpeedDisplay;
  final String? currentTimeDisplay;
  final double currentDistanceDisplay;
  final double currentAvgSpeedDisplay;

  final bool isPlaying;
  final bool isPlaybackStarted;
  final double playProgress;

  final BitmapDescriptor? startIcon;
  final BitmapDescriptor? endIcon;
  final BitmapDescriptor? vehicleIcon;
  final String? darkMapStyle;

  const RideHistoryDetailsState({
    this.isDataProcessing = true,
    this.validRidePoints = const [],
    this.cumulativeWeights = const [],
    this.totalWeight = 0.0,
    this.cumulativeDistances = const [],
    this.smoothPositions = const [],
    this.smoothHeadings = const [],
    this.smoothSpeeds = const [],
    this.smoothTimes = const [],
    this.currentVehiclePosition,
    this.currentHeading = 0.0,
    this.currentSpeedDisplay = 0.0,
    this.currentTimeDisplay = "--:--",
    this.currentDistanceDisplay = 0.0,
    this.currentAvgSpeedDisplay = 0.0,
    this.isPlaying = false,
    this.isPlaybackStarted = false,
    this.playProgress = 0.0,
    this.startIcon,
    this.endIcon,
    this.vehicleIcon,
    this.darkMapStyle,
  });

  RideHistoryDetailsState copyWith({
    bool? isDataProcessing,
    List<RidePoint>? validRidePoints,
    List<double>? cumulativeWeights,
    double? totalWeight,
    List<double>? cumulativeDistances,
    List<LatLng>? smoothPositions,
    List<double>? smoothHeadings,
    List<double>? smoothSpeeds,
    List<String>? smoothTimes,
    LatLng? currentVehiclePosition,
    double? currentHeading,
    double? currentSpeedDisplay,
    String? currentTimeDisplay,
    double? currentDistanceDisplay,
    double? currentAvgSpeedDisplay,
    bool? isPlaying,
    bool? isPlaybackStarted,
    double? playProgress,
    BitmapDescriptor? startIcon,
    BitmapDescriptor? endIcon,
    BitmapDescriptor? vehicleIcon,
    String? darkMapStyle,
  }) {
    return RideHistoryDetailsState(
      isDataProcessing: isDataProcessing ?? this.isDataProcessing,
      validRidePoints: validRidePoints ?? this.validRidePoints,
      cumulativeWeights: cumulativeWeights ?? this.cumulativeWeights,
      totalWeight: totalWeight ?? this.totalWeight,
      cumulativeDistances: cumulativeDistances ?? this.cumulativeDistances,
      smoothPositions: smoothPositions ?? this.smoothPositions,
      smoothHeadings: smoothHeadings ?? this.smoothHeadings,
      smoothSpeeds: smoothSpeeds ?? this.smoothSpeeds,
      smoothTimes: smoothTimes ?? this.smoothTimes,
      currentVehiclePosition:
          currentVehiclePosition ?? this.currentVehiclePosition,
      currentHeading: currentHeading ?? this.currentHeading,
      currentSpeedDisplay: currentSpeedDisplay ?? this.currentSpeedDisplay,
      currentTimeDisplay: currentTimeDisplay ?? this.currentTimeDisplay,
      currentDistanceDisplay:
          currentDistanceDisplay ?? this.currentDistanceDisplay,
      currentAvgSpeedDisplay:
          currentAvgSpeedDisplay ?? this.currentAvgSpeedDisplay,
      isPlaying: isPlaying ?? this.isPlaying,
      isPlaybackStarted: isPlaybackStarted ?? this.isPlaybackStarted,
      playProgress: playProgress ?? this.playProgress,
      startIcon: startIcon ?? this.startIcon,
      endIcon: endIcon ?? this.endIcon,
      vehicleIcon: vehicleIcon ?? this.vehicleIcon,
      darkMapStyle: darkMapStyle ?? this.darkMapStyle,
    );
  }

  @override
  List<Object?> get props => [
        isDataProcessing,
        validRidePoints,
        cumulativeWeights,
        totalWeight,
        cumulativeDistances,
        smoothPositions,
        smoothHeadings,
        smoothSpeeds,
        smoothTimes,
        currentVehiclePosition,
        currentHeading,
        currentSpeedDisplay,
        currentTimeDisplay,
        currentDistanceDisplay,
        currentAvgSpeedDisplay,
        isPlaying,
        isPlaybackStarted,
        playProgress,
        startIcon,
        endIcon,
        vehicleIcon,
        darkMapStyle,
      ];
}
