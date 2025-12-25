import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class AppState extends Equatable {
  final ThemeMode themeMode;
  final Locale locale;
  final bool isConnected;
  final Position? currentLocation;
  final Map<String, dynamic>? userData;
  final bool isSocketConnected;
  final List<Map<String, dynamic>> devices;

  const AppState({
    this.themeMode = ThemeMode.dark,
    this.locale = const Locale('en'),
    this.isConnected = true,
    this.currentLocation,
    this.userData,
    this.isSocketConnected = false,
    this.devices = const [],
  });

  AppState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    bool? isConnected,
    Position? currentLocation,
    Map<String, dynamic>? userData,
    bool? isSocketConnected,
    List<Map<String, dynamic>>? devices,
  }) {
    return AppState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      isConnected: isConnected ?? this.isConnected,
      currentLocation: currentLocation ?? this.currentLocation,
      userData: userData ?? this.userData,
      isSocketConnected: isSocketConnected ?? this.isSocketConnected,
      devices: devices ?? this.devices,
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
  ];
}