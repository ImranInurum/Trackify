import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/config/network/api_host.dart';
import '../../core/config/network/base_api_service.dart';
import '../../core/config/network/network_api_service.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/services/location_service.dart';
import '../../core/services/socket_service.dart';
import '../../core/utils/shared_preferences.dart';
import '../../core/theme/models/app_theme_model.dart';
import '../../core/constants/app_languages.dart';
import '../../feature/auth/data/entity/login_response_model.dart';
import 'app_state.dart';

class AppCubit extends Cubit<AppState> with WidgetsBindingObserver {
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
       super(AppState(themeMode: _getInitialThemeMode())) {
    debugPrint(
      "AppCubit: [CONSTRUCTOR] Initialized with ThemeMode: ${state.themeMode}",
    );
    WidgetsBinding.instance.addObserver(this);
  }

  static ThemeMode _getInitialThemeMode() {
    final savedTheme = AppPreference.instance.getSync(
      key: AppPreference.KEY_THEME_MODE,
    );
    debugPrint(
      "AppCubit: [STARTUP] Raw saved value from SharedPreferences: '$savedTheme'",
    );

    if (savedTheme == "dark") {
      debugPrint("AppCubit: [STARTUP] Result: ThemeMode.dark");
      return ThemeMode.dark;
    } else if (savedTheme == "light") {
      debugPrint("AppCubit: [STARTUP] Result: ThemeMode.light");
      return ThemeMode.light;
    } else if (savedTheme == "system") {
      debugPrint("AppCubit: [STARTUP] Result: ThemeMode.system");
      return ThemeMode.system;
    }

    debugPrint(
      "AppCubit: [STARTUP] No valid theme found, defaulting to ThemeMode.light",
    );
    return ThemeMode.light;
  }

  Future<void> initialize() async {
    print("initialize App Cubit");
    try {
      // await AppPreference.instance.init(); // Redundant, already done in main.dart
      // await loadSavedThemeMode(); // Redundant, handled in constructor
      await loadThemeFromCache();
      _initializeConnectivity();
      await _initializeLocation();
      await loadUserSession();
      await initializeSocket();
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

  Future<void> loadSavedThemeMode() async {
    final prefs = AppPreference.instance;
    final savedTheme = await prefs.get(key: AppPreference.KEY_THEME_MODE);
    debugPrint("AppCubit: loadSavedThemeMode - Saved theme value: $savedTheme");
    if (savedTheme.isNotEmpty) {
      try {
        final themeMode = ThemeMode.values.firstWhere(
          (e) => e.name == savedTheme,
          orElse: () => ThemeMode.light,
        );
        debugPrint("AppCubit: ThemeMode emitted by AppCubit: $themeMode");
        emit(state.copyWith(themeMode: themeMode));
      } catch (e) {
        debugPrint('AppCubit: Error loading saved theme mode: $e');
        emit(state.copyWith(themeMode: ThemeMode.light));
      }
    } else {
      emit(state.copyWith(themeMode: ThemeMode.light));
    }
  }

  Future<void> fetchTheme() async {
    try {
      final result = await _apiServices.getGetApiResponse(ApiURL.theme);

      result.fold((error) => print('Error fetching theme: ${error.message}'), (
        data,
      ) async {
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
      });
    } catch (e) {
      print('Unexpected error fetching theme: $e');
    }
  }

  void _initializeConnectivity() {
    _connectivityService.initialize();
    _connectivitySubscription = _connectivityService.connectivityStream.listen((
      isConnected,
    ) {
      print("Connectivity Changed : $isConnected");
      emit(state.copyWith(isConnected: isConnected));
      if (isConnected) {
        // When connection is restored, attempt to reconnect socket and refresh data
        _reconnectSocket();
        refreshAppData();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("AppLifecycleState changed to: $state");
    if (state == AppLifecycleState.resumed) {
      // App came to foreground - sync everything
      _handleAppResumed();
    } else if (state == AppLifecycleState.paused) {
      // Optional: Handle cleanup or background mode if needed
      print("App moved to background");
    }
  }

  Future<void> _handleAppResumed() async {
    print("Syncing data on app resume...");

    // 1. Check connectivity
    final isConnected = await _connectivityService.checkConnectivity();
    emit(state.copyWith(isConnected: isConnected));

    if (isConnected) {
      // 2. Reconnect socket if needed
      if (!_socketService.isConnected && !_socketService.isConnecting) {
        _reconnectSocket();
      }

      // 3. Refresh critical data from API (Background Sync)
      await refreshAppData();
    }
  }

  Future<void> refreshAppData() async {
    print("Refreshing app data...");
    // Fetch theme, user session, and any other critical state
    await fetchTheme();
    await loadUserSession();
    // Add other API refresh calls here if needed (e.g., active orders, notifications)
  }

  Future<void> _initializeLocation() async {
    try {
      await _locationService.initialize();
      final position = await _locationService.getCurrentLocation();
      emit(state.copyWith(currentLocation: position));
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
    final selectedLanguageKey = await prefs.get(
      key: AppPreference.KEY_SELECTED_LANGUAGE,
    );
    print("UserDetails : $userData");
    print("SelectedLanguageKey : $selectedLanguageKey");

    final token = await prefs.get(key: AppPreference.KEY_TOKEN);
    if (token.isNotEmpty) {
      ApiURL.updateAuthToken(token);
    }

    if (userData.isNotEmpty) {
      final user = User.fromJson(jsonDecode(userData));
      emit(state.copyWith(userData: user));
    }

    if (selectedLanguageKey.isNotEmpty) {
      try {
        final language = AppLanguages.languages.firstWhere(
          (lang) =>
              (lang['key'] as String).toLowerCase() ==
              selectedLanguageKey.toLowerCase(),
          orElse: () => AppLanguages.languages.first,
        );
        emit(state.copyWith(locale: language['locale'] as Locale));
      } catch (e) {
        print("Error setting initial locale: $e");
        emit(state.copyWith(locale: const Locale('en')));
      }
    }

    final distanceUnit = await prefs.get(key: AppPreference.KEY_DISTANCE_UNIT);
    if (distanceUnit.isNotEmpty) {
      emit(state.copyWith(distanceUnit: distanceUnit));
    }
  }

  Future<void> updateUserSession(User user) async {
    final prefs = AppPreference.instance;
    await prefs.set(
      key: AppPreference.KEY_USER_DETAILS,
      value: jsonEncode(user.toJson()),
    );
    emit(state.copyWith(userData: user));
  }

  Future<void> initializeSocket({String? imei}) async {
    print('initializeSocket for IMEI: $imei');

    // Ensure we start fresh on each initialization (critical for switching vehicles/IMEIs)
    _socketService.disconnect();
    await _socketSubscription?.cancel();

    try {
      await _socketService.connect(ApiURL.socketURL, imei: imei);

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
    if (state.isSocketConnected && _socketService.isConnected) return;

    print('Attempting to reconnect socket...');
    try {
      final imei = await AppPreference.instance.get(key: AppPreference.IMEI);
      if (imei.isNotEmpty) {
        await _socketService.connect(ApiURL.socketURL, imei: imei);
        emit(state.copyWith(isSocketConnected: true));
      }
    } catch (e) {
      print('Socket reconnection error: $e');
      emit(state.copyWith(isSocketConnected: false));
    }
  }

  void _handleDeviceData(Map<String, dynamic> deviceData) {
    // Update devices list with new data
    final currentDevices = List<Map<String, dynamic>>.from(state.devices);

    // Identify device by imei, _id or id
    final deviceId =
        (deviceData['imei'] ?? deviceData['_id'] ?? deviceData['id'])
            ?.toString();

    print("[AppCubit] 🔄 Data Received for IMEI: ${deviceData['imei']}");

    if (deviceId != null) {
      // Check if device already exists
      final index = currentDevices.indexWhere(
        (d) =>
            (d['imei']?.toString() == deviceId) ||
            (d['_id']?.toString() == deviceId) ||
            (d['id']?.toString() == deviceId),
      );

      if (index != -1) {
        // Update existing device
        final existingDevice = currentDevices[index];
        final oldSpeed =
            double.tryParse(
              (existingDevice['sp'] ?? existingDevice['speed'])?.toString() ??
                  '0',
            ) ??
            0.0;
        final newSpeed =
            double.tryParse(
              (deviceData['sp'] ?? deviceData['speed'])?.toString() ?? '0',
            ) ??
            0.0;

        // Track when the vehicle stopped moving
        if (newSpeed <= 5) {
          if (oldSpeed > 5 || !existingDevice.containsKey('stoppedAt')) {
            // First time it dropped below 5 in memory
            // Check if we have a persisted value from a previous session
            String persistedStoppedAt = AppPreference.instance.getSync(
              key: 'stoppedAt_$deviceId',
            );
            if (persistedStoppedAt.isNotEmpty) {
              deviceData['stoppedAt'] = persistedStoppedAt;
            } else {
              final nowStr = DateTime.now().toIso8601String();
              deviceData['stoppedAt'] = nowStr;
              AppPreference.instance.set(
                key: 'stoppedAt_$deviceId',
                value: nowStr,
              );
            }
          } else {
            deviceData['stoppedAt'] = existingDevice['stoppedAt'];
          }
        } else {
          deviceData.remove('stoppedAt');
          AppPreference.instance.clearByKey(key: 'stoppedAt_$deviceId');
        }

        currentDevices[index] = deviceData;
      } else {
        // Add new device
        final newSpeed =
            double.tryParse(
              (deviceData['sp'] ?? deviceData['speed'])?.toString() ?? '0',
            ) ??
            0.0;
        if (newSpeed <= 5) {
          // Check if we have a persisted value from a previous session
          String persistedStoppedAt = AppPreference.instance.getSync(
            key: 'stoppedAt_$deviceId',
          );
          if (persistedStoppedAt.isNotEmpty) {
            deviceData['stoppedAt'] = persistedStoppedAt;
          } else {
            final nowStr = DateTime.now().toIso8601String();
            deviceData['stoppedAt'] = nowStr;
            AppPreference.instance.set(
              key: 'stoppedAt_$deviceId',
              value: nowStr,
            );
          }
        } else {
          AppPreference.instance.clearByKey(key: 'stoppedAt_$deviceId');
        }
        currentDevices.add(deviceData);
      }

      // Extract coordinates (lt = latitude, lg = longitude)
      final lat = double.tryParse(deviceData['lt']?.toString() ?? '');
      final lng = double.tryParse(deviceData['lg']?.toString() ?? '');

      if (lat != null && lng != null) {
        // Extract bearing/heading (common keys: course, bearing, angle, dir)
        double bearing =
            double.tryParse(
              (deviceData['course'] ??
                      deviceData['bearing'] ??
                      deviceData['angle'] ??
                      deviceData['dir'] ??
                      '0')
                  .toString(),
            ) ??
            0.0;

        // Calculate actual movement bearing for accurate camera/marker rotation
        if (state.livePosition != null) {
          final double distance = Geolocator.distanceBetween(
            state.livePosition!.latitude,
            state.livePosition!.longitude,
            lat,
            lng,
          );

          // Only update bearing if the vehicle has moved at least 2 meters to avoid jitter
          if (distance > 2.0) {
            final double calculatedBearing = Geolocator.bearingBetween(
              state.livePosition!.latitude,
              state.livePosition!.longitude,
              lat,
              lng,
            );
            // bearingBetween returns -180 to +180, normalize it to 0-360
            bearing = (calculatedBearing + 360) % 360;
          } else {
            // Keep the previous bearing if not moved enough
            bearing = state.liveBearing;
          }
        }

        print(
          "[AppCubit] 📍 Updating Live Position: $lat, $lng | Bearing: $bearing",
        );
        emit(
          state.copyWith(
            devices: currentDevices,
            livePosition: LatLng(lat, lng),
            liveBearing: bearing,
          ),
        );
      } else {
        emit(state.copyWith(devices: currentDevices));
      }
    }
  }

  //--------------------------------------------------------------------
  Future<void> changeTheme(ThemeMode themeMode) async {
    debugPrint("AppCubit: [UI] Saving ThemeMode: ${themeMode.name}");
    await AppPreference.instance.set(
      key: AppPreference.KEY_THEME_MODE,
      value: themeMode.name,
    );

    emit(state.copyWith(themeMode: themeMode));
  }

  void changeDistanceUnit(String unit) async {
    emit(state.copyWith(distanceUnit: unit));
    await AppPreference.instance.set(
      key: AppPreference.KEY_DISTANCE_UNIT,
      value: unit,
    );
  }

  /// Change app locale/language
  void changeLocale(Locale locale, String languageKey) async {
    emit(state.copyWith(locale: locale));
    await AppPreference.instance.set(
      key: AppPreference.KEY_SELECTED_LANGUAGE,
      value: languageKey,
    );
  }

  /// Update Map Configuration
  void updateMapConfig({
    String? mapStyle,
    String? mapType,
    bool? isTrafficEnabled,
    bool? isLabelsEnabled,
  }) {
    emit(
      state.copyWith(
        mapStyle: mapStyle,
        mapType: mapType,
        isTrafficEnabled: isTrafficEnabled,
        isLabelsEnabled: isLabelsEnabled,
      ),
    );
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
    WidgetsBinding.instance.removeObserver(this);
    _connectivitySubscription?.cancel();
    _locationSubscription?.cancel();
    _socketSubscription?.cancel();

    _connectivityService.dispose();
    _locationService.dispose();
    _socketService.dispose();

    return super.close();
  }
}
