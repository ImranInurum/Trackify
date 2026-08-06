import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FullScreenMapUiState extends Equatable {
  final bool isAutoFollowing;
  final bool showSharedWithMe;
  final bool showCurrentLocation;
  final bool isSlidingUp;
  final int headerMetricIndex;
  final BitmapDescriptor? customMarker;
  final BitmapDescriptor? currentLocationMarker;
  final bool isInitialFocusDone;

  const FullScreenMapUiState({
    this.isAutoFollowing = true,
    this.showSharedWithMe = false,
    this.showCurrentLocation = false,
    this.isSlidingUp = true,
    this.headerMetricIndex = 0,
    this.customMarker,
    this.currentLocationMarker,
    this.isInitialFocusDone = false,
  });

  FullScreenMapUiState copyWith({
    bool? isAutoFollowing,
    bool? showSharedWithMe,
    bool? showCurrentLocation,
    bool? isSlidingUp,
    int? headerMetricIndex,
    BitmapDescriptor? customMarker,
    BitmapDescriptor? currentLocationMarker,
    bool? isInitialFocusDone,
  }) {
    return FullScreenMapUiState(
      isAutoFollowing: isAutoFollowing ?? this.isAutoFollowing,
      showSharedWithMe: showSharedWithMe ?? this.showSharedWithMe,
      showCurrentLocation: showCurrentLocation ?? this.showCurrentLocation,
      isSlidingUp: isSlidingUp ?? this.isSlidingUp,
      headerMetricIndex: headerMetricIndex ?? this.headerMetricIndex,
      customMarker: customMarker ?? this.customMarker,
      currentLocationMarker: currentLocationMarker ?? this.currentLocationMarker,
      isInitialFocusDone: isInitialFocusDone ?? this.isInitialFocusDone,
    );
  }

  @override
  List<Object?> get props => [
        isAutoFollowing,
        showSharedWithMe,
        showCurrentLocation,
        isSlidingUp,
        headerMetricIndex,
        customMarker,
        currentLocationMarker,
        isInitialFocusDone,
      ];
}

class FullScreenMapUiCubit extends Cubit<FullScreenMapUiState> {
  FullScreenMapUiCubit() : super(const FullScreenMapUiState());

  void setAutoFollowing(bool value) {
    emit(state.copyWith(isAutoFollowing: value));
  }

  void toggleSharedWithMe() {
    emit(state.copyWith(showSharedWithMe: !state.showSharedWithMe));
  }

  void toggleCurrentLocation() {
    emit(state.copyWith(
      showCurrentLocation: !state.showCurrentLocation,
      isAutoFollowing: true, // Recenter camera when toggled
    ));
  }

  void changeHeaderMetric(bool isUp) {
    int newIndex = state.headerMetricIndex;
    if (isUp) {
      newIndex = (newIndex - 1) % 4;
      if (newIndex < 0) newIndex = 3;
    } else {
      newIndex = (newIndex + 1) % 4;
    }
    emit(state.copyWith(
      isSlidingUp: isUp,
      headerMetricIndex: newIndex,
    ));
  }

  void setCustomMarker(BitmapDescriptor marker) {
    emit(state.copyWith(customMarker: marker));
  }

  void setCurrentLocationMarker(BitmapDescriptor marker) {
    emit(state.copyWith(currentLocationMarker: marker));
  }

  void setInitialFocusDone() {
    emit(state.copyWith(isInitialFocusDone: true));
  }
}
