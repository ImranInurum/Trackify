import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/theme/models/app_theme_model.dart';
import '../../feature/auth/data/entity/login_response_model.dart';

class AppState extends Equatable {
  final ThemeMode themeMode;
  final Locale locale;
  final bool isConnected;
  final Position? currentLocation;
  final User? userData;
  final bool isSocketConnected;
  final List<Map<String, dynamic>> devices;
  final AppThemeModel? dynamicTheme;

  final String mapStyle; // 'Dark', 'Light', 'Simple'
  final String mapType; // 'normal', 'satellite'
  final bool isTrafficEnabled;
  final bool isLabelsEnabled;
  final LatLng? livePosition;
  final double liveBearing;
  final String distanceUnit;

  const AppState({
    this.themeMode = ThemeMode.light,
    this.locale = const Locale('en'),
    this.isConnected = true,
    this.currentLocation,
    this.userData,
    this.isSocketConnected = false,
    this.devices = const [],
    this.dynamicTheme,
    this.mapStyle = 'Dark',
    this.mapType = 'normal',
    this.isTrafficEnabled = false,
    this.isLabelsEnabled = true,
    this.livePosition,
    this.liveBearing = 0.0,
    this.distanceUnit = 'km',
  });

  AppState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    bool? isConnected,
    Position? currentLocation,
    User? userData,
    bool? isSocketConnected,
    List<Map<String, dynamic>>? devices,
    AppThemeModel? dynamicTheme,
    String? mapStyle,
    String? mapType,
    bool? isTrafficEnabled,
    bool? isLabelsEnabled,
    LatLng? livePosition,
    double? liveBearing,
    String? distanceUnit,
  }) {
    return AppState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      isConnected: isConnected ?? this.isConnected,
      currentLocation: currentLocation ?? this.currentLocation,
      userData: userData ?? this.userData,
      isSocketConnected: isSocketConnected ?? this.isSocketConnected,
      devices: devices ?? this.devices,
      dynamicTheme: dynamicTheme ?? this.dynamicTheme,
      mapStyle: mapStyle ?? this.mapStyle,
      mapType: mapType ?? this.mapType,
      isTrafficEnabled: isTrafficEnabled ?? this.isTrafficEnabled,
      isLabelsEnabled: isLabelsEnabled ?? this.isLabelsEnabled,
      livePosition: livePosition ?? this.livePosition,
      liveBearing: liveBearing ?? this.liveBearing,
      distanceUnit: distanceUnit ?? this.distanceUnit,
    );
  }

  @override
  List<Object?> get props => [
    themeMode,
    locale,
    isConnected,
    currentLocation,
    userData,
    isSocketConnected,
    devices,
    dynamicTheme,
    mapStyle,
    mapType,
    isTrafficEnabled,
    isLabelsEnabled,
    livePosition,
    liveBearing,
    distanceUnit,
  ];
}
