import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/config/network/api_host.dart';
import '../../core/config/network/base_api_service.dart';
import '../../core/config/network/network_api_service.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/services/location_service.dart';
import '../../core/services/socket_service.dart';
import '../../core/utils/shared_preferences.dart';
import '../../core/theme/models/app_theme_model.dart';
import '../../feature/auth/data/entity/login_response_model.dart';
import 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  final ConnectivityService _connectivityService;
  final LocationService _locationService;
  final SocketService _socketService;
  final BaseApiServices _apiServices = NetworkApiService();

  StreamSubscription<bool>? _connectivitySubscription;
  StreamSubscription<Position>? _locationSubscription;
  StreamSubscription<Map<String, dynamic>>? _socketSubscription;

  AppCubit({
    required ConnectivityService connectivityService,
    required LocationService locationService,
    required SocketService socketService,
  }) : _connectivityService = connectivityService,
       _locationService = locationService,
       _socketService = socketService,
       super(const AppState()) {
    print("AppCubit constructed");
  }

  Future<void> initialize() async {
    print("initialize App Cubit");
    try {
      await AppPreference.instance.init();
      await loadThemeFromCache();
      _initializeConnectivity();
      await _initializeLocation();
      await loadUserSession();
      // await _initializeSocket();
    } catch (e) {
      print('Initialization error: $e');
    }
  }

  Future<void> loadThemeFromCache() async {
    final prefs = AppPreference.instance;
    final themeData = await prefs.get(key: AppPreference.KEY_DYNAMIC_THEME);
    if (themeData.isNotEmpty) {
      try {
        final theme = AppThemeModel.fromJson(jsonDecode(themeData));
        emit(state.copyWith(dynamicTheme: theme));
      } catch (e) {
        print('Error parsing cached theme: $e');
      }
    }
  }

  Future<void> fetchTheme() async {
    try {
      final result = await _apiServices.getGetApiResponse(ApiURL.theme);
      
      result.fold(
        (error) => print('Error fetching theme: ${error.message}'),
        (data) async {
          try {
            final theme = AppThemeModel.fromJson(data);
            
            // Update state
            emit(state.copyWith(dynamicTheme: theme));
            
            // Cache theme
            await AppPreference.instance.set(
              key: AppPreference.KEY_DYNAMIC_THEME,
              value: jsonEncode(data),
            );
            print('Theme fetched and updated successfully from API');
          } catch (e) {
            print('Error parsing theme JSON: $e');
          }
        },
      );
    } catch (e) {
      print('Unexpected error fetching theme: $e');
    }
  }

  void _initializeConnectivity() {
    _connectivityService.initialize();
    _connectivitySubscription = _connectivityService.connectivityStream.listen((
      isConnected,
    ) {
      print("IsConnected : $isConnected");
      emit(state.copyWith(isConnected: isConnected));

      // if (isConnected && !_socketService.isConnected) {
      //   _reconnectSocket();
      // }
    });
  }

  Future<void> _initializeLocation() async {
    try {
      await _locationService.initialize();
      _locationService.startTracking();
      _locationSubscription = _locationService.locationStream.listen(
        (position) {
          print("Positions : ${position.latitude}_${position.longitude}");
          emit(state.copyWith(currentLocation: position));
        },
        onError: (error) {
          print('Location error: $error');
        },
      );
    } catch (e) {
      print('Location initialization error: $e');
    }
  }

  Future<void> loadUserSession() async {
    final prefs = AppPreference.instance;
    final userData = await prefs.get(key: AppPreference.KEY_USER_DETAILS);
    final selectedLanguageKey =
        await prefs.get(key: AppPreference.KEY_SELECTED_LANGUAGE);
    print("UserDetails : $userData");
    print("SelectedLanguageKey : $selectedLanguageKey");

    if (userData.isNotEmpty) {
      final user = User.fromJson(jsonDecode(userData));
      emit(state.copyWith(userData: user));
    }

    if (selectedLanguageKey.isNotEmpty) {
      Locale? locale;
      if (selectedLanguageKey == 'Hindi') {
        locale = const Locale('hi');
      } else if (selectedLanguageKey == 'Arabic') {
        locale = const Locale('ar');
      } else if (selectedLanguageKey == 'Marathi') {
        locale = const Locale('mr');
      } else if (selectedLanguageKey == 'Tamil') {
        locale = const Locale('ta');
      } else if (selectedLanguageKey == 'Kannada') {
        locale = const Locale('kn');
      } else {
        locale = const Locale('en');
      }
      emit(state.copyWith(locale: locale));
    }
  }

  Future<void> _initializeSocket() async {
    print('_initializeSocket');

    try {
      const socketUrl = 'ws://139.59.1.109:4000';
      await _socketService.connect(socketUrl);

      emit(state.copyWith(isSocketConnected: true));

      _socketSubscription = _socketService.deviceDataStream.listen(
        (deviceData) {
          print("DATAAA : ${deviceData}");
          _handleDeviceData(deviceData);
        },
        onError: (error) {
          print('Socket error: $error');
          emit(state.copyWith(isSocketConnected: false));
        },
      );
    } catch (e) {
      print('Socket initialization error: $e');
      emit(state.copyWith(isSocketConnected: false));
    }
  }

  void _reconnectSocket() async {
    try {
      const socketUrl = 'ws://139.59.1.109:4000';
      await _socketService.connect(socketUrl);
      emit(state.copyWith(isSocketConnected: true));
    } catch (e) {
      print('Socket reconnection error: $e');
    }
  }

  void _handleDeviceData(Map<String, dynamic> deviceData) {
    // Update devices list with new data
    final currentDevices = List<Map<String, dynamic>>.from(state.devices);

    // Example: deviceData = {id: 'device1', lat: 23.45, lng: 78.90, name: 'Device 1'}
    final deviceId = deviceData['id'] as String?;

    if (deviceId != null) {
      // Check if device already exists
      final index = currentDevices.indexWhere((d) => d['id'] == deviceId);

      if (index != -1) {
        // Update existing device
        currentDevices[index] = deviceData;
      } else {
        // Add new device
        currentDevices.add(deviceData);
      }

      emit(state.copyWith(devices: currentDevices));
    }
  }

  void changeTheme(ThemeMode themeMode) {
    emit(state.copyWith(themeMode: themeMode));
    // Optional: Save to local storage
  }

  /// Change app locale/language
  void changeLocale(Locale locale) {
    emit(state.copyWith(locale: locale));
    // Optional: Save to local storage
  }

  /// Get current location once
  Future<Position?> getCurrentLocation() async {
    try {
      return await _locationService.getCurrentLocation();
    } catch (e) {
      print('Error getting current location: $e');
      return null;
    }
  }

  /// Start location tracking
  void startLocationTracking() {
    _locationService.startTracking();
  }

  /// Stop location tracking
  void stopLocationTracking() {
    _locationService.stopTracking();
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    _locationSubscription?.cancel();
    _socketSubscription?.cancel();

    _connectivityService.dispose();
    _locationService.dispose();
    _socketService.dispose();

    return super.close();
  }
}
