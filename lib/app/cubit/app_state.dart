import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

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

  const AppState({
    this.themeMode = ThemeMode.light,
    this.locale = const Locale('en'),
    this.isConnected = true,
    this.currentLocation,
    this.userData,
    this.isSocketConnected = false,
    this.devices = const [],
    this.dynamicTheme,
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
  ];
}
