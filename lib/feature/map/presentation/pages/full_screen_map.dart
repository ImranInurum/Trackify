import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:geolocator/geolocator.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:trackify/app/cubit/app_cubit.dart';
import 'package:trackify/app/cubit/app_state.dart';
import 'package:trackify/core/constants/app_images.dart';
import 'package:trackify/core/utils/map_utils.dart';
import 'package:trackify/core/widgets/bouncing_widget.dart';
import 'package:trackify/feature/map/data/entity/user_vehicles.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:trackify/core/utils/distance_utils.dart';
import '../cubit/map_cubit.dart';
import '../cubit/map_state.dart';
import 'package:trackify/feature/Vehicle_control/presentation/cubit/vehicle_control_cubit.dart';
import 'package:trackify/feature/Vehicle_control/data/repositories/vehicle_control_repository_impl.dart';
import 'package:trackify/feature/Vehicle_control/presentation/widgets/vehicle_on_map_card.dart';
import 'package:trackify/feature/Vehicle_control/presentation/state/vehicle_control_state.dart';
import 'package:trackify/feature/upgrade_to_plus/presentation/pages/upgrade_to_plus.dart';
import '../cubit/full_screen_map_ui_cubit.dart';
import 'package:trackify/feature/trips/presentation/cubit/ride_history_cubit.dart';
import 'package:trackify/feature/trips/presentation/cubit/ride_history_state.dart';
import 'package:trackify/feature/trips/data/entity/ride_model.dart';
import 'package:trackify/feature/map/presentation/pages/shared_with_me_screen.dart';
import 'package:trackify/feature/geo_fence/presentation/cubit/geo_fence_cubit.dart';
import 'package:trackify/feature/geo_fence/presentation/cubit/geo_fence_state.dart';

class FullScreenMap extends StatefulWidget {
  final Vehicles? selectedVehicle;
  const FullScreenMap({super.key, this.selectedVehicle});

  @override
  State<FullScreenMap> createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap>
    with TickerProviderStateMixin {
  final bool _useDemoSimulation = false;
  Timer? _demoTimer;
  int _demoIndex = 0;
  final List<Map<String, dynamic>> _demoRouteData = [
    {"latitude": 28.7041, "longitude": 77.1025},
    {"latitude": 28.7045, "longitude": 77.1030},
    {"latitude": 28.7050, "longitude": 77.1035},
  ];

  Vehicles? _currentVehicle;
  int _statsPageIndex = 0;
  GoogleMapController? _mapController;
  String? _lightMapStyle;
  String? _darkMapStyle;

  // Animation controller for cinematic camera movements
  AnimationController? _cameraAnimationController;

  // Current camera state (tracked locally to avoid async calls)
  LatLng? _cameraTarget;
  double _cameraZoom = 13.0;
  double _cameraTilt = 0.0;
  double _cameraBearing = 0.0;

  // Animation start/end states
  LatLng? _animStartTarget;
  LatLng? _animEndTarget;
  double _animStartTargetLat = 0;
  double _animStartTargetLng = 0;
  double _animStartZoom = 16.0;
  double _animEndZoom = 18.0;
  double _animStartTilt = 0.0;
  double _animEndTilt = 0.0;
  double _animStartBearing = 0.0;
  double _animEndBearing = 0.0;

  // Animated marker state
  LatLng? _animatedMarkerPos;
  double _animatedMarkerBearing = 0.0;
  AnimationController? _markerAnimController;
  LatLng? _animEndMarkerTarget;
  double _animEndMarkerBearing = 0.0;
  LatLng? _animStartMarkerTarget;
  double _animStartMarkerBearing = 0.0;
  int _lastDataReceivedMs = 0;
  int _lastCameraUpdateMs = 0;
  int _lastMarkerRebuildMs = 0;
  final ValueNotifier<int> _mapRebuildNotifier = ValueNotifier<int>(0);
  final ValueNotifier<double> _sheetExtent = ValueNotifier<double>(0.14);

  late final FullScreenMapUiCubit _uiCubit;

  @override
  void initState() {
    super.initState();
    _uiCubit = FullScreenMapUiCubit();
    _currentVehicle = widget.selectedVehicle;
    if (_currentVehicle?.imei != null) {
      context.read<GeoFenceCubit>().fetchGeoFences(_currentVehicle!.imei!);
    }

    _markerAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(); // Runs continuously to compute physics

    if (_useDemoSimulation) {
      _startDemoSimulation();
    }

    _markerAnimController!.addListener(() {
      if (_animEndMarkerTarget != null && _animStartMarkerTarget != null) {
        final now = DateTime.now().millisecondsSinceEpoch;
        final elapsed = now - _lastDataReceivedMs;

        bool hasMoved = false;

        if (elapsed > 15000) {
          // Stop moving if no data received for 15 seconds
        } else {
          // Linear constant interpolation for steady movement
          double t = elapsed / 10000.0; // Assume 10 seconds between updates
          if (t > 1.0) t = 1.0; // Prevent overshooting

          final double lat =
              _animStartMarkerTarget!.latitude +
              (_animEndMarkerTarget!.latitude -
                      _animStartMarkerTarget!.latitude) *
                  t;
          final double lng =
              _animStartMarkerTarget!.longitude +
              (_animEndMarkerTarget!.longitude -
                      _animStartMarkerTarget!.longitude) *
                  t;
          
          if (_animatedMarkerPos?.latitude != lat || _animatedMarkerPos?.longitude != lng) {
            _animatedMarkerPos = LatLng(lat, lng);
            hasMoved = true;
          }

          double diffBearing = _animEndMarkerBearing - _animStartMarkerBearing;
          if (diffBearing > 180) diffBearing -= 360;
          if (diffBearing < -180) diffBearing += 360;

          final double newBearing = _animStartMarkerBearing + diffBearing * t;
          if (_animatedMarkerBearing != newBearing) {
            _animatedMarkerBearing = newBearing;
            hasMoved = true;
          }
        }

        if (hasMoved && now - _lastMarkerRebuildMs >= 50) {
          _lastMarkerRebuildMs = now;
          _mapRebuildNotifier.value++;
        }

        // Drone-style camera tracking (throttled to 20fps for performance)
        if (hasMoved && _uiCubit.state.isAutoFollowing &&
            mounted &&
            _mapController != null) {
          final appState = context.read<AppCubit>().state;
          if (!(_uiCubit.state.showCurrentLocation &&
              appState.currentLocation != null)) {
            if (_uiCubit.state.isInitialFocusDone) {
              final now = DateTime.now().millisecondsSinceEpoch;
              if (now - _lastCameraUpdateMs >= 50) {
                _lastCameraUpdateMs = now;

                final currentTarget = _cameraTarget ?? _animatedMarkerPos!;

                final double latDiff =
                    (_animatedMarkerPos!.latitude - currentTarget.latitude)
                        .abs();
                final double lngDiff =
                    (_animatedMarkerPos!.longitude - currentTarget.longitude)
                        .abs();
                final double distanceDiff = latDiff + lngDiff;

                double dynamicPosFactor = 0.15;
                if (distanceDiff > 0.002) {
                  dynamicPosFactor = 1.0;
                } else if (distanceDiff > 0.0006) {
                  dynamicPosFactor =
                      0.15 + (1.0 - 0.15) * ((distanceDiff - 0.0006) / 0.0014);
                }

                final double camLat =
                    currentTarget.latitude +
                    (_animatedMarkerPos!.latitude - currentTarget.latitude) *
                        dynamicPosFactor;
                final double camLng =
                    currentTarget.longitude +
                    (_animatedMarkerPos!.longitude - currentTarget.longitude) *
                        dynamicPosFactor;

                double diffBearing = _animatedMarkerBearing - _cameraBearing;
                if (diffBearing > 180) diffBearing -= 360;
                if (diffBearing < -180) diffBearing += 360;
                double newCameraBearing = _cameraBearing + diffBearing * 0.15;

                final nextPos = CameraPosition(
                  target: LatLng(camLat, camLng),
                  zoom: _cameraZoom,
                  tilt: _cameraTilt,
                  bearing: newCameraBearing,
                );

                _cameraTarget = nextPos.target;
                _cameraBearing = newCameraBearing;
                _mapController!.moveCamera(
                  CameraUpdate.newCameraPosition(nextPos),
                );
              }
            }
          }
        }
      }
    });

    _loadMapStyles();
    _loadCustomMarker();
    // Create user location marker after first frame (needs context for AppCubit)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final appState = context.read<AppCubit>().state;
        final name = appState.userData?.name ?? 'Me';
        final letter = name.isNotEmpty ? name[0].toUpperCase() : 'M';
        final primaryColor = Theme.of(context).colorScheme.primary;
        _createUserLocationMarker(letter, primaryColor);
        _loadGeoFenceIcons(primaryColor);
      }
    });
  }

  BitmapDescriptor? _homeIcon;
  BitmapDescriptor? _officeIcon;
  BitmapDescriptor? _familyIcon;
  BitmapDescriptor? _parkingIcon;
  BitmapDescriptor? _othersIcon;

  Future<void> _loadGeoFenceIcons(Color primaryColor) async {
    _homeIcon = await MapUtils.createGeoFenceMarkerIcon(
      Icons.home_outlined,
      primaryColor,
    );
    _officeIcon = await MapUtils.createGeoFenceMarkerIcon(
      Icons.apartment_outlined,
      primaryColor,
    );
    _familyIcon = await MapUtils.createGeoFenceMarkerIcon(
      Icons.person_outline,
      primaryColor,
    );
    _parkingIcon = await MapUtils.createGeoFenceMarkerIcon(
      Icons.local_parking_outlined,
      primaryColor,
    );
    _othersIcon = await MapUtils.createGeoFenceMarkerIcon(
      Icons.location_on_outlined,
      primaryColor,
    );
    _cachedGeoMarkers.clear(); // invalidate cache to apply new icons
    if (mounted) _mapRebuildNotifier.value++;
  }

  @override
  void dispose() {
    _demoTimer?.cancel();
    _uiCubit.close();
    _mapRebuildNotifier.dispose();
    _cameraAnimationController?.dispose();
    _markerAnimController?.dispose();
    super.dispose();
  }

  Future<void> _loadMapStyles() async {
    _lightMapStyle = await MapUtils.loadStyle(
      'assets/map_styles/light_map.json',
    );
    _darkMapStyle = await MapUtils.loadStyle(
      'assets/map_styles/full_map_style.json',
    );
  }

  Future<void> _loadCustomMarker() async {
    final Uint8List markerIcon = await MapUtils.getBytesFromAsset(
      AppImages.bikeImage,
      110,
    );
    if (mounted) {
      _uiCubit.setCustomMarker(BitmapDescriptor.fromBytes(markerIcon));
      _mapRebuildNotifier.value++;
    }
  }

  Future<void> _createUserLocationMarker(
    String letter,
    Color primaryColor,
  ) async {
    const int size = 120;
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    const double center = size / 2;
    const double pinBodyRadius = 36.0;
    const double tipHeight = 18.0;

    // Outer glow ring
    final Paint glowPaint = Paint()
      ..color = const Color(0xFFFFB300).withOpacity(0.22)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      const Offset(center, center - tipHeight / 2),
      pinBodyRadius + 12,
      glowPaint,
    );

    // White border
    final Paint borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      const Offset(center, center - tipHeight / 2),
      pinBodyRadius + 3.5,
      borderPaint,
    );

    // Circle body with theme primary color
    final Paint bodyPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      const Offset(center, center - tipHeight / 2),
      pinBodyRadius,
      bodyPaint,
    );

    // Draw the letter
    final ui.ParagraphBuilder pb =
        ui.ParagraphBuilder(
            ui.ParagraphStyle(
              fontSize: 38,
              fontWeight: ui.FontWeight.w700,
              textAlign: TextAlign.center,
            ),
          )
          ..pushStyle(
            ui.TextStyle(
              color: Colors.white,
              fontSize: 38,
              fontWeight: ui.FontWeight.w700,
            ),
          )
          ..addText(letter);
    final ui.Paragraph paragraph = pb.build();
    paragraph.layout(ui.ParagraphConstraints(width: size.toDouble()));
    canvas.drawParagraph(
      paragraph,
      Offset(0, center - tipHeight / 2 - paragraph.height / 2),
    );

    final ui.Image image = await recorder.endRecording().toImage(size, size);
    final ByteData? byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    if (byteData != null && mounted) {
      _uiCubit.setCurrentLocationMarker(
        BitmapDescriptor.fromBytes(byteData.buffer.asUint8List()),
      );
      _mapRebuildNotifier.value++;
    }
  }

  LatLng? _getBestPosition() {
    if (_useDemoSimulation) {
      if (_animatedMarkerPos != null) return _animatedMarkerPos;
      final firstPoint = _demoRouteData[0];
      return LatLng(firstPoint["latitude"], firstPoint["longitude"]);
    }
    final appState = context.read<AppCubit>().state;
    final currentPos = appState.currentLocation;
    LatLng? bestPos;

    // 1. Get live position specific to THIS device from socket data
    final liveData = appState.devices.firstWhere(
      (d) =>
          d['imei'] == _currentVehicle?.imei ||
          d['_id'] == _currentVehicle?.id ||
          d['id'] == _currentVehicle?.id,
      orElse: () => <String, dynamic>{},
    );

    if (liveData.isNotEmpty) {
      final lat = double.tryParse(liveData['lt']?.toString() ?? '');
      final lng = double.tryParse(liveData['lg']?.toString() ?? '');
      if (lat != null && lng != null) {
        bestPos = LatLng(lat, lng);
      }
    }

    // 2. Fallback to API static location
    if (bestPos == null &&
        _currentVehicle?.currentLocation != null &&
        _currentVehicle!.currentLocation!.lat != null &&
        _currentVehicle!.currentLocation!.lng != null) {
      bestPos = LatLng(
        _currentVehicle!.currentLocation!.lat!,
        _currentVehicle!.currentLocation!.lng!,
      );
    }

    // 3. Fallback to phone current location
    if (bestPos == null && currentPos != null) {
      bestPos = LatLng(currentPos.latitude, currentPos.longitude);
    }
    return bestPos;
  }

  void _triggerInitialFocusAnimation() {
    LatLng? target = _getBestPosition();
    if (target == null) return;

    final appState = context.read<AppCubit>().state;
    final currData = appState.devices.firstWhere(
      (d) =>
          d['imei'] == _currentVehicle?.imei ||
          d['_id'] == _currentVehicle?.id ||
          d['id'] == _currentVehicle?.id,
      orElse: () => <String, dynamic>{},
    );
    double bearing =
        double.tryParse(
          (currData['course'] ??
                  currData['bearing'] ??
                  currData['angle'] ??
                  currData['dir'] ??
                  '0')
              .toString(),
        ) ??
        0.0;

    // Glide smoothly focusing on the vehicle (drone camera zoom & rotate effect)
    // 600ms delay ensures native layout/tiles/styles are ready before animation starts
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      _animateCameraTo(
        target: target,
        zoom: 18.0,
        tilt: 0.0,
        bearing: _animatedMarkerPos != null ? _animatedMarkerBearing : bearing,
        duration: const Duration(milliseconds: 4000), // slow cinematic glide
        curve: Curves.easeInOutCubic,
      );
      _uiCubit.setInitialFocusDone();
    });
  }

  void _startDemoSimulation() {
    if (!_useDemoSimulation) return;

    final firstPoint = _demoRouteData[0];
    final initialPos = LatLng(firstPoint["latitude"], firstPoint["longitude"]);
    _animatedMarkerPos = initialPos;
    _animatedMarkerBearing = 0.0;

    _demoTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      _demoIndex = (_demoIndex + 1) % _demoRouteData.length;
      final prevPoint =
          _demoRouteData[_demoIndex == 0
              ? _demoRouteData.length - 1
              : _demoIndex - 1];
      final currPoint = _demoRouteData[_demoIndex];

      final prevPos = LatLng(prevPoint["latitude"], prevPoint["longitude"]);
      final currPos = LatLng(currPoint["latitude"], currPoint["longitude"]);

      double calculatedBearing = Geolocator.bearingBetween(
        prevPos.latitude,
        prevPos.longitude,
        currPos.latitude,
        currPos.longitude,
      );

      final bearing = (calculatedBearing + 360) % 360;

      _animStartMarkerTarget = _animatedMarkerPos ?? currPos;
      _animStartMarkerBearing = _animatedMarkerBearing;
      _animEndMarkerTarget = currPos;
      _animEndMarkerBearing = bearing;
      _lastDataReceivedMs = DateTime.now().millisecondsSinceEpoch;

      // The repeating 60fps AnimationController will automatically interpolate
      // linearly towards _animEndMarkerTarget over 10 seconds.
    });
  }

  void _recenterCamera() {
    _uiCubit.setAutoFollowing(true);
    _applyCameraForCurrentMode();
  }

  GeoFenceState? _lastGeoStateMarkers;
  Set<Marker> _cachedGeoMarkers = {};

  /// Builds the markers set — called from build so it always reads latest _showCurrentLocation.
  Set<Marker> _buildMarkers(
    LatLng vehiclePos,
    dynamic currentPos,
    double bearing,
    GeoFenceState geoState,
  ) {
    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('vehicle_marker'),
        position: vehiclePos,
        icon: _uiCubit.state.customMarker ?? BitmapDescriptor.defaultMarker,
        anchor: const Offset(0.5, 0.5),
        flat: true,
        rotation: bearing % 360,
      ),
    };

    if (_uiCubit.state.showCurrentLocation && currentPos != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(currentPos.latitude, currentPos.longitude),
          icon:
              _uiCubit.state.currentLocationMarker ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          anchor: const Offset(0.5, 0.5),
          infoWindow: const InfoWindow(title: 'Your location'),
        ),
      );
    }

    if (_lastGeoStateMarkers == geoState && _cachedGeoMarkers.isNotEmpty) {
      markers.addAll(_cachedGeoMarkers);
    } else {
      _lastGeoStateMarkers = geoState;
      _cachedGeoMarkers.clear();
      if (geoState is GeoFenceLoaded) {
        for (var fence in geoState.geoFences) {
          if (!fence.isActive) continue;

          BitmapDescriptor markerIcon =
              _othersIcon ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan);
          final typeStr = '${fence.type} ${fence.name}'.toLowerCase();

          if (typeStr.contains('home') ||
              typeStr.contains('घर') ||
              typeStr.contains('ಮನೆ') ||
              typeStr.contains('வீடு') ||
              typeStr.contains('منزل')) {
            markerIcon = _homeIcon ?? markerIcon;
          } else if (typeStr.contains('office') ||
              typeStr.contains('कार्यालय') ||
              typeStr.contains('ಕಚೇರಿ') ||
              typeStr.contains('அலுவலகம்') ||
              typeStr.contains('مكتب')) {
            markerIcon = _officeIcon ?? markerIcon;
          } else if (typeStr.contains('family') ||
              typeStr.contains('परिवार') ||
              typeStr.contains('कुटुंब') ||
              typeStr.contains('ಕುಟುಂಬ') ||
              typeStr.contains('குடும்பம்') ||
              typeStr.contains('عائلة')) {
            markerIcon = _familyIcon ?? markerIcon;
          } else if (typeStr.contains('parking') ||
              typeStr.contains('पार्किंग') ||
              typeStr.contains('ಪಾರ್ಕಿಂಗ್') ||
              typeStr.contains('பார்க்கிங்') ||
              typeStr.contains('موقف')) {
            markerIcon = _parkingIcon ?? markerIcon;
          }

          _cachedGeoMarkers.add(
            Marker(
              markerId: MarkerId('geo_${fence.id}'),
              position: LatLng(fence.latitude, fence.longitude),
              icon: markerIcon,
              infoWindow: InfoWindow(title: fence.name),
            ),
          );
        }
      }
      markers.addAll(_cachedGeoMarkers);
    }

    return markers;
  }

  GeoFenceState? _lastGeoStateCircles;
  Set<Circle> _cachedGeoCircles = {};

  Set<Circle> _buildCircles(GeoFenceState geoState) {
    if (_lastGeoStateCircles == geoState && _cachedGeoCircles.isNotEmpty) {
      return _cachedGeoCircles;
    }
    _lastGeoStateCircles = geoState;
    final circles = <Circle>{};
    if (geoState is GeoFenceLoaded) {
      for (var fence in geoState.geoFences) {
        if (!fence.isActive) continue;
        circles.add(
          Circle(
            circleId: CircleId('geo_circle_${fence.id}_${fence.latitude}'),
            center: LatLng(fence.latitude, fence.longitude),
            radius: fence.radius > 10 ? fence.radius : 500.0,
            fillColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            strokeColor: Theme.of(context).colorScheme.primary,
            strokeWidth: 2,
          ),
        );
      }
    }
    _cachedGeoCircles = circles;
    return circles;
  }

  /// Applies the correct camera position based on _showCurrentLocation mode.
  void _applyCameraForCurrentMode() {
    final appState = context.read<AppCubit>().state;
    final vehiclePos = _getBestPosition();
    if (vehiclePos == null) return;

    final currData = appState.devices.firstWhere(
      (d) =>
          d['imei'] == _currentVehicle?.imei ||
          d['_id'] == _currentVehicle?.id ||
          d['id'] == _currentVehicle?.id,
      orElse: () => <String, dynamic>{},
    );
    double bearing =
        double.tryParse(
          (currData['course'] ??
                  currData['bearing'] ??
                  currData['angle'] ??
                  currData['dir'] ??
                  '0')
              .toString(),
        ) ??
        0.0;
    final animBearing = _animatedMarkerPos != null
        ? _animatedMarkerBearing
        : bearing;

    if (_uiCubit.state.showCurrentLocation &&
        appState.currentLocation != null) {
      final phonePos = LatLng(
        appState.currentLocation!.latitude,
        appState.currentLocation!.longitude,
      );
      _fitBothMarkersOnMap(vehiclePos, phonePos, animBearing);
    } else {
      _animateCameraTo(
        target: _animatedMarkerPos ?? vehiclePos,
        zoom: 18.0,
        tilt: 0.0,
        bearing: animBearing,
        duration: const Duration(milliseconds: 1200),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  /// Calculates midpoint + zoom to fit both points on screen.
  void _fitBothMarkersOnMap(
    LatLng vehiclePos,
    LatLng phonePos,
    double bearing,
  ) {
    final double midLat = (vehiclePos.latitude + phonePos.latitude) / 2;
    final double midLng = (vehiclePos.longitude + phonePos.longitude) / 2;
    final LatLng midpoint = LatLng(midLat, midLng);

    // Calculate distance between points to determine zoom
    final double latDiff = (vehiclePos.latitude - phonePos.latitude).abs();
    final double lngDiff = (vehiclePos.longitude - phonePos.longitude).abs();
    final double maxDiff = latDiff > lngDiff ? latDiff : lngDiff;

    // Map degree difference to zoom level (approximate)
    double zoom = 15.0;
    if (maxDiff > 0.5) {
      zoom = 10.0;
    } else if (maxDiff > 0.2) {
      zoom = 11.5;
    } else if (maxDiff > 0.1) {
      zoom = 12.5;
    } else if (maxDiff > 0.05) {
      zoom = 13.5;
    } else if (maxDiff > 0.01) {
      zoom = 14.5;
    }

    _animateCameraTo(
      target: midpoint,
      zoom: zoom,
      tilt: 0.0,
      bearing: bearing,
      duration: const Duration(milliseconds: 1400),
      curve: Curves.easeInOutCubic,
    );
  }

  void _animateCameraTo({
    required LatLng target,
    required double zoom,
    required double tilt,
    required double bearing,
    required Duration duration,
    Curve curve = Curves.easeInOutCubic,
  }) {
    if (_mapController == null) return;

    _cameraAnimationController?.stop();

    _animStartTarget = _cameraTarget ?? target;
    _animStartZoom = _cameraZoom;
    _animStartTilt = _cameraTilt;
    _animStartBearing = _cameraBearing;

    _animEndTarget = target;
    _animEndZoom = zoom;
    _animEndTilt = tilt;

    _animStartBearing = _normalizeBearing(_animStartBearing);
    double endBearingNormalized = _normalizeBearing(bearing);

    double diff = endBearingNormalized - _animStartBearing;
    if (diff > 180) {
      diff -= 360;
    } else if (diff < -180) {
      diff += 360;
    }
    _animEndBearing = _animStartBearing + diff;

    _cameraAnimationController?.dispose();
    _cameraAnimationController = AnimationController(
      vsync: this,
      duration: duration,
    );

    final curvedAnimation = CurvedAnimation(
      parent: _cameraAnimationController!,
      curve: curve,
    );

    _cameraAnimationController!.addListener(() {
      final t = curvedAnimation.value;
      if (_animStartTarget == null || _animEndTarget == null) return;

      double lat =
          _animStartTarget!.latitude +
          (_animEndTarget!.latitude - _animStartTarget!.latitude) * t;
      double lng =
          _animStartTarget!.longitude +
          (_animEndTarget!.longitude - _animStartTarget!.longitude) * t;
      LatLng newTarget = LatLng(lat, lng);

      double newZoom = _animStartZoom + (_animEndZoom - _animStartZoom) * t;
      double newTilt = _animStartTilt + (_animEndTilt - _animStartTilt) * t;
      double newBearing =
          _animStartBearing + (_animEndBearing - _animStartBearing) * t;

      _cameraTarget = newTarget;
      _cameraZoom = newZoom;
      _cameraTilt = newTilt;
      _cameraBearing = newBearing;

      _mapController?.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: newTarget,
            zoom: newZoom,
            tilt: newTilt,
            bearing: newBearing,
          ),
        ),
      );
    });

    _cameraAnimationController!.forward();
  }

  double _normalizeBearing(double bearing) {
    double b = bearing % 360;
    if (b < 0) b += 360;
    return b;
  }

  Future<void> _updateMapStyle(GoogleMapController controller) async {
    final appConfig = context.read<AppCubit>().state;

    if (appConfig.mapType == 'satellite') {
      await MapUtils.setStyle(controller, null);
      return;
    }

    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    await MapUtils.setStyle(controller, isDarkTheme ? _darkMapStyle : _lightMapStyle);
  }

  void _showMapStyleSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      barrierColor: Colors.black45,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36)),
      builder: (context) {
        return BlocBuilder<AppCubit, AppState>(
          builder: (context, state) {
            final l10n = AppLocalizations.of(context)!;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.mapStyleLabel,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStyleOption(
                        l10n.darkStyle,
                        AppImages.darkMapStyle,
                        state,
                      ),
                      _buildStyleOption(
                        l10n.lightStyle,
                        AppImages.lightMapStyle,
                        state,
                      ),
                      _buildStyleOption(
                        l10n.simpleStyle,
                        AppImages.simpleMapStyle,
                        state,
                      ),
                      _buildStyleOption(
                        l10n.satelliteStyle,
                        AppImages.sateLiteMapStyle,
                        state,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    l10n.mapOptionsLabel,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _buildMapOption(
                        l10n.trafficLabel,
                        AppImages.trafficMapStyle,
                        state.isTrafficEnabled,
                        (val) => context.read<AppCubit>().updateMapConfig(
                          isTrafficEnabled: val,
                        ),
                      ),
                      const SizedBox(width: 24),
                      _buildMapOption(
                        l10n.labelsLabel,
                        AppImages.darkMapStyle,
                        state.isLabelsEnabled,
                        (val) => context.read<AppCubit>().updateMapConfig(
                          isLabelsEnabled: val,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStyleOption(String name, String imagePath, AppState appState) {
    final bool isSelected =
        appState.mapStyle == name ||
        (appState.mapType == 'satellite' && name == "Satellite");
    return GestureDetector(
      onTap: () async {
        if (name == "Satellite") {
          context.read<AppCubit>().updateMapConfig(
            mapType: 'satellite',
            mapStyle: 'Satellite',
          );
        } else {
          context.read<AppCubit>().updateMapConfig(
            mapType: 'normal',
            mapStyle: name,
          );
        }

        if (_mapController != null) {
          _updateMapStyle(_mapController!);
        }
      },
      child: Column(
        children: [
          Container(
            height: 68,
            width: 68,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(16),
              border: isSelected
                  ? Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2.5,
                    )
                  : Border.all(color: Theme.of(context).dividerColor),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapOption(
    String name,
    String imagePath,
    bool isActive,
    Function(bool) onChanged,
  ) {
    return GestureDetector(
      onTap: () => onChanged(!isActive),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 68,
                width: 68,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: isActive
                      ? Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        )
                      : Border.all(color: Colors.transparent),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              if (isActive)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppCubit, AppState>(
      listenWhen: (previous, current) {
        if (_useDemoSimulation) return false;
        // Find previous position for this specific device
        final prevData = previous.devices.firstWhere(
          (d) =>
              d['imei'] == _currentVehicle?.imei ||
              d['_id'] == _currentVehicle?.id ||
              d['id'] == _currentVehicle?.id,
          orElse: () => <String, dynamic>{},
        );

        // Find current position for this specific device
        final currData = current.devices.firstWhere(
          (d) =>
              d['imei'] == _currentVehicle?.imei ||
              d['_id'] == _currentVehicle?.id ||
              d['id'] == _currentVehicle?.id,
          orElse: () => <String, dynamic>{},
        );

        return prevData['lt'] != currData['lt'] ||
            prevData['lg'] != currData['lg'] ||
            prevData['course'] != currData['course'] ||
            prevData['bearing'] != currData['bearing'];
      },
      listener: (context, state) {
        final target = _getBestPosition();
        if (target != null) {
          // Extract bearing for this specific device
          final currData = state.devices.firstWhere(
            (d) =>
                d['imei'] == _currentVehicle?.imei ||
                d['_id'] == _currentVehicle?.id ||
                d['id'] == _currentVehicle?.id,
            orElse: () => <String, dynamic>{},
          );

          double rawCourse =
              double.tryParse(
                (currData['course'] ??
                        currData['bearing'] ??
                        currData['angle'] ??
                        currData['dir'] ??
                        '-1')
                    .toString(),
              ) ??
              -1.0;

          double bearing = _animatedMarkerPos != null
              ? _animatedMarkerBearing
              : (rawCourse >= 0 ? rawCourse : 0.0);

          if (_animatedMarkerPos != null) {
            double dist = Geolocator.distanceBetween(
              _animatedMarkerPos!.latitude,
              _animatedMarkerPos!.longitude,
              target.latitude,
              target.longitude,
            );

            double speed =
                double.tryParse(
                  (currData['sp'] ?? currData['speed'] ?? '0').toString(),
                ) ??
                0.0;

            if (dist > 1.0) {
              double calcB = Geolocator.bearingBetween(
                _animatedMarkerPos!.latitude,
                _animatedMarkerPos!.longitude,
                target.latitude,
                target.longitude,
              );
              bearing = (calcB + 360) % 360;
            } else if (speed > 2.0 && rawCourse >= 0) {
              bearing = rawCourse;
            }
          }
          _animStartMarkerTarget = _animatedMarkerPos ?? target;
          _animStartMarkerBearing = _animatedMarkerPos != null
              ? _animatedMarkerBearing
              : bearing;
          _animEndMarkerTarget = target;
          _animEndMarkerBearing = bearing;
          _lastDataReceivedMs = DateTime.now().millisecondsSinceEpoch;

          if (_uiCubit.state.isAutoFollowing &&
              _mapController != null &&
              _uiCubit.state.isInitialFocusDone) {
            if (_uiCubit.state.showCurrentLocation &&
                state.currentLocation != null) {
              // Both markers mode: fit vehicle + phone location
              final phonePos = LatLng(
                state.currentLocation!.latitude,
                state.currentLocation!.longitude,
              );
              _fitBothMarkersOnMap(target, phonePos, bearing);
            }
          }
        }
      },
      child: Scaffold(
        body: NotificationListener<DraggableScrollableNotification>(
          onNotification: (notification) {
            _sheetExtent.value = notification.extent;
            return false;
          },
          child: Stack(
            children: [
              _buildMap(),
              _buildTopActions(),
              _buildLeftSideActions(),
              _buildRightSideActions(),
              _buildDraggableBottomCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMap() {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, appState) {
        final currentPos = appState.currentLocation;
        if (currentPos == null) {
          return const Center(child: CircularProgressIndicator());
        }

        // Prioritize Live Position from Socket
        LatLng? bestPos = appState.livePosition;

        // Fallback to selected vehicle's static location
        if (bestPos == null &&
            _currentVehicle?.currentLocation != null &&
            _currentVehicle!.currentLocation!.lat != null &&
            _currentVehicle!.currentLocation!.lng != null) {
          bestPos = LatLng(
            _currentVehicle!.currentLocation!.lat!,
            _currentVehicle!.currentLocation!.lng!,
          );
        }

        // Final fallback to phone location
        bestPos ??= LatLng(currentPos.latitude, currentPos.longitude);

        // 1. Get live position specific to THIS device from socket data
        final liveData = appState.devices.firstWhere(
          (d) =>
              d['imei'] == _currentVehicle?.imei ||
              d['_id'] == _currentVehicle?.id ||
              d['id'] == _currentVehicle?.id,
          orElse: () => <String, dynamic>{},
        );

        double bearing = 0.0;
        if (liveData.isNotEmpty) {
          bearing =
              double.tryParse(
                (liveData['course'] ??
                        liveData['bearing'] ??
                        liveData['angle'] ??
                        liveData['dir'] ??
                        '0')
                    .toString(),
              ) ??
              0.0;
        }

        double startBearing = _normalizeBearing(bearing - 120.0);

        return ValueListenableBuilder<int>(
          valueListenable: _mapRebuildNotifier,
          builder: (context, _, child) {
            final animPos = _animatedMarkerPos ?? bestPos!;
            final animBearing = _animatedMarkerPos != null
                ? _animatedMarkerBearing
                : bearing;

            return BlocBuilder<GeoFenceCubit, GeoFenceState>(
              builder: (context, geoState) {
                return BlocBuilder<FullScreenMapUiCubit, FullScreenMapUiState>(
                  bloc: _uiCubit,
                  builder: (context, uiState) {
                    return Listener(
                      onPointerMove: (_) {
                        if (_uiCubit.state.isAutoFollowing) {
                          _uiCubit.setAutoFollowing(false);
                        }
                      },
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: bestPos!,
                          zoom: 16.0,
                          bearing: 0.0,
                        ),
                    myLocationEnabled: false,
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    mapToolbarEnabled: false,
                    buildingsEnabled: false,
                    style: appState.mapType == 'satellite'
                        ? null
                        : (Theme.of(context).brightness == Brightness.dark
                            ? _darkMapStyle
                            : _lightMapStyle),
                    mapType: appState.mapType == 'satellite'
                        ? MapType.satellite
                        : MapType.normal,
                    trafficEnabled: appState.isTrafficEnabled,
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.16,
                    ),
                    onCameraMove: (position) {
                      if (_uiCubit.state.isAutoFollowing) return;
                      if (_cameraAnimationController != null &&
                          _cameraAnimationController!.isAnimating)
                        return;

                      _cameraTarget = position.target;
                      _cameraZoom = position.zoom;
                      _cameraTilt = position.tilt;
                      _cameraBearing = position.bearing;
                    },
                    onCameraMoveStarted: () {},
                    markers: _buildMarkers(
                      animPos,
                      currentPos,
                      animBearing,
                      geoState,
                    ),
                    circles: _buildCircles(geoState),
                    onMapCreated: (controller) async {
                      _mapController = controller;

                      if (_darkMapStyle == null || _lightMapStyle == null) {
                        await _loadMapStyles();
                      }
                      _updateMapStyle(controller);

                      // Initialize camera state fields
                      _cameraTarget = bestPos;
                      _cameraZoom = 16.0;
                      _cameraTilt = 0.0;
                      _cameraBearing = 0.0;

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _triggerInitialFocusAnimation();
                      });
                    },
                  ),
                );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildTopActions() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 10,
      right: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRoundButton(
            Icons.arrow_back_ios_new,
            onTap: () => Navigator.pop(context),
          ),
          BlocBuilder<FullScreenMapUiCubit, FullScreenMapUiState>(
            bloc: _uiCubit,
            builder: (context, uiState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildRoundButton(
                    Icons.more_vert,
                    onTap: () => _uiCubit.toggleSharedWithMe(),
                  ),
                  if (uiState.showSharedWithMe)
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 200),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 10 * value - 10),
                            child: child,
                          ),
                        );
                      },
                      child: GestureDetector(
                        onTap: () {
                          _uiCubit.toggleSharedWithMe(); // Close the menu
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SharedWithMeScreen(),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).cardColor.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Theme.of(context).dividerColor,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.sharedWithMe,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLeftSideActions() {
    return ValueListenableBuilder<double>(
      valueListenable: _sheetExtent,
      builder: (context, extent, child) {
        final screenHeight = MediaQuery.of(context).size.height;
        final bottomMargin = (extent * screenHeight) + 16.0;
        return Positioned(
          left: 16,
          bottom: bottomMargin,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildMapActionButton(
                Icons.share_outlined,
                onTap: () {
                  final appState = context.read<AppCubit>().state;
                  LatLng? pos = appState.livePosition;
                  if (pos == null &&
                      _currentVehicle?.currentLocation != null &&
                      _currentVehicle!.currentLocation!.lat != null &&
                      _currentVehicle!.currentLocation!.lng != null) {
                    pos = LatLng(
                      _currentVehicle!.currentLocation!.lat!,
                      _currentVehicle!.currentLocation!.lng!,
                    );
                  }
                  pos ??= appState.currentLocation != null
                      ? LatLng(
                          appState.currentLocation!.latitude,
                          appState.currentLocation!.longitude,
                        )
                      : null;

                  if (pos != null) {
                    final url =
                        'https://maps.google.com/?q=${pos.latitude},${pos.longitude}';
                    // Share via platform share sheet / Clipboard
                    Clipboard.setData(ClipboardData(text: url));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Vehicle location link copied to clipboard!',
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
              // Google Maps open button with custom asset icon
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: BouncingWidget(
                  onTap: () async {
                    final appState = context.read<AppCubit>().state;
                    LatLng? pos = appState.livePosition;
                    if (pos == null &&
                        _currentVehicle?.currentLocation != null &&
                        _currentVehicle!.currentLocation!.lat != null &&
                        _currentVehicle!.currentLocation!.lng != null) {
                      pos = LatLng(
                        _currentVehicle!.currentLocation!.lat!,
                        _currentVehicle!.currentLocation!.lng!,
                      );
                    }
                    pos ??= appState.currentLocation != null
                        ? LatLng(
                            appState.currentLocation!.latitude,
                            appState.currentLocation!.longitude,
                          )
                        : null;

                    if (pos == null) return;
                    final vehicleNameParts = [
                      _currentVehicle?.vehicleMaker,
                      _currentVehicle?.vehicleNumber,
                    ].where((e) => e != null && e.isNotEmpty).toList();
                    final label = vehicleNameParts.isEmpty
                        ? 'Vehicle'
                        : vehicleNameParts.join(' - ');
                    final encodedLabel = Uri.encodeComponent(label);

                    final geoUri = Uri.parse(
                      'geo:${pos.latitude},${pos.longitude}?q=${pos.latitude},${pos.longitude}($encodedLabel)',
                    );
                    final webUri = Uri.parse(
                      'https://www.google.com/maps/search/?api=1&query=${pos.latitude},${pos.longitude}',
                    );
                    if (await canLaunchUrl(geoUri)) {
                      await launchUrl(geoUri);
                    } else {
                      await launchUrl(
                        webUri,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Theme.of(context).dividerColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Stack(
                        children: [
                          Center(
                            child: Image.asset(
                              'assets/icons/map_icon.png',
                              height: 28,
                              width: 28,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Positioned.fill(
                            child: ClipOval(
                              child: Container(
                                color: Colors.grey.withValues(alpha: 0.15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRightSideActions() {
    return ValueListenableBuilder<double>(
      valueListenable: _sheetExtent,
      builder: (context, extent, child) {
        final screenHeight = MediaQuery.of(context).size.height;
        final bottomMargin = (extent * screenHeight) + 16.0;
        return Positioned(
          right: 16,
          bottom: bottomMargin,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildMapActionButton(
                Icons.motorcycle,
                badgeIcon: Icons.edit,
                onTap: _showVehicleIconPicker,
              ),
              _buildMapActionButton(
                Icons.map_outlined,
                onTap: _showMapStyleSheet,
              ),
              BlocBuilder<FullScreenMapUiCubit, FullScreenMapUiState>(
                bloc: _uiCubit,
                builder: (context, uiState) {
                  return Column(
                    children: [
                      _buildMapActionButton(
                        Icons.person_pin_circle_outlined,
                        onTap: () {
                          _uiCubit.toggleCurrentLocation();
                          _applyCameraForCurrentMode();
                        },
                        isActiveColor: uiState.showCurrentLocation,
                      ),
                      _buildMapActionButton(
                        Icons.my_location,
                        onTap: _recenterCamera,
                        isActiveColor: uiState.isAutoFollowing,
                      ),
                    ],
                  );
                },
              ),
              _buildMapActionButton(Icons.fullscreen, onTap: _focusOnBike),
            ],
          ),
        );
      },
    );
  }

  void _showVehicleIconPicker() {
    if (_currentVehicle?.imei == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) {
        return BlocProvider(
          create: (context) =>
              VehicleControlCubit(VehicleControlRepositoryImpl())
                ..loadVehicleDetails(_currentVehicle!.imei),
          child: Builder(
            builder: (context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BlocBuilder<VehicleControlCubit, VehicleControlState>(
                    builder: (context, state) {
                      if (state is VehicleControlLoading) {
                        return Container(
                          margin: EdgeInsets.zero,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          height: 200,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (state is VehicleControlLoaded) {
                        return VehicleOnMapCard(
                          cardColor: Theme.of(context).cardColor,
                          primaryTextColor: Theme.of(
                            context,
                          ).colorScheme.onSurface,
                          secondaryTextColor: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.6),
                          accentColor: Theme.of(context).colorScheme.primary,
                          selectedIcon: state.tempIcon,
                          selectedColor: state.tempColor,
                          margin: EdgeInsets.zero,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          onIconChanged: (icon) {
                            context.read<VehicleControlCubit>().updateLocalIcon(
                              icon,
                            );
                            context.read<VehicleControlCubit>().saveChanges(
                              _currentVehicle!.imei!,
                            );
                          },
                          onColorChanged: (color) {
                            context
                                .read<VehicleControlCubit>()
                                .updateLocalColor(color);
                            context.read<VehicleControlCubit>().saveChanges(
                              _currentVehicle!.imei!,
                            );
                          },
                          onSave: () {
                            context.read<VehicleControlCubit>().saveChanges(
                              _currentVehicle!.imei!,
                            );
                            Navigator.pop(context);
                          },
                          onUpgrade: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const UpgradeToPlusScreen(),
                              ),
                            );
                          },
                          showSaveButton: false,
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _focusOnBike() {
    final vehiclePos = _getBestPosition();
    if (vehiclePos == null) return;

    final appState = context.read<AppCubit>().state;
    final currData = appState.devices.firstWhere(
      (d) =>
          d['imei'] == _currentVehicle?.imei ||
          d['_id'] == _currentVehicle?.id ||
          d['id'] == _currentVehicle?.id,
      orElse: () => <String, dynamic>{},
    );

    double bearing =
        double.tryParse(
          (currData['course'] ??
                  currData['bearing'] ??
                  currData['angle'] ??
                  currData['dir'] ??
                  '0')
              .toString(),
        ) ??
        0.0;

    _uiCubit.setAutoFollowing(true);

    _animateCameraTo(
      target: vehiclePos,
      zoom: 15.0, // balanced zoom level, not too close
      tilt: 0.0,
      bearing: _animatedMarkerPos != null ? _animatedMarkerBearing : bearing,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutCubic,
    );
  }

  Widget _buildMapActionButton(
    IconData icon, {
    bool hasNotification = false,
    IconData? badgeIcon,
    VoidCallback? onTap,
    bool isActiveColor = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Stack(
        children: [
          _buildRoundButton(icon, onTap: onTap, isActiveColor: isActiveColor),
          if (hasNotification || badgeIcon != null)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                height: 18,
                width: 18,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).cardColor,
                    width: 2,
                  ),
                ),
                child: badgeIcon != null
                    ? Icon(
                        badgeIcon,
                        size: 10,
                        color: Theme.of(context).colorScheme.onPrimary,
                      )
                    : null,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRoundButton(
    IconData icon, {
    VoidCallback? onTap,
    bool isActiveColor = false,
  }) {
    final theme = Theme.of(context);
    return BouncingWidget(
      onTap: onTap ?? () {},
      child: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: isActiveColor ? theme.colorScheme.primary : theme.cardColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: isActiveColor
                ? theme.colorScheme.primary
                : theme.dividerColor,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: isActiveColor
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.onSurface.withOpacity(0.85),
          size: 24,
        ),
      ),
    );
  }

  Widget _buildDraggableBottomCard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenHeight = constraints.maxHeight;
        // Consistent initial and max heights across all devices
        final double initialExtent = (115.0 / screenHeight).clamp(0.05, 0.50);
        final double maxExtent = (310.0 / screenHeight).clamp(0.15, 0.85);

        final double maxPixels = maxExtent * screenHeight;

        return DraggableScrollableSheet(
          initialChildSize: initialExtent,
          minChildSize: initialExtent,
          maxChildSize: maxExtent,
          snap: true,
          snapSizes: [initialExtent, maxExtent],
          builder: (context, scrollController) {
            return GestureDetector(
              onTap: () {},
              onHorizontalDragUpdate: (_) {},
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(36),
                    topRight: Radius.circular(36),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(overscroll: false),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        Container(
                          width: 44,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Theme.of(context).dividerColor,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildVehicleHeader(),
                              const SizedBox(height: 8),
                              _buildStatsGrid(),
                              const SizedBox(height: 12),
                              _buildBottomInfoCards(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildVehicleHeader() {
    return BlocBuilder<RideHistoryCubit, RideHistoryState>(
      builder: (context, rideState) {
        return BlocBuilder<AppCubit, AppState>(
          builder: (context, state) {
            Ride? lastRide;
            if (rideState is RideHistorySuccess && rideState.rides.isNotEmpty) {
              lastRide = rideState.rides.last;
            }

            final liveDevice = state.devices.firstWhere(
              (d) =>
                  d['imei']?.toString() == _currentVehicle?.imei ||
                  d['_id']?.toString() == _currentVehicle?.id ||
                  d['id']?.toString() == _currentVehicle?.id,
              orElse: () => <String, dynamic>{},
            );

            bool isLastRideToday = false;
            if (lastRide != null) {
              try {
                if (lastRide.rawStartTime.isNotEmpty) {
                  final date = DateTime.parse(lastRide.rawStartTime).toLocal();
                  final now = DateTime.now();
                  if (date.year == now.year && date.month == now.month && date.day == now.day) {
                    isLastRideToday = true;
                  }
                } else {
                  final now = DateTime.now();
                  final format1 = "${now.day}/${now.month}/${now.year}";
                  final format2 = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
                  if (lastRide.date == format1 || lastRide.date == format2) {
                    isLastRideToday = true;
                  }
                }
              } catch (_) {}
            }

            String liveSpeed =
                liveDevice['sp']?.toString() ??
                _currentVehicle?.currentLocation?.speed?.toString() ??
                "0";
                
            if (!isLastRideToday) {
              liveSpeed = "0";
            }

        // Use time from socket data or fallback to API's currentLocation time
        final stoppedAtStr =
            liveDevice['time']?.toString() ??
            liveDevice['deviceTime']?.toString() ??
            liveDevice['dt']?.toString() ??
            _currentVehicle?.currentLocation?.time ??
            _currentVehicle?.updatedAt?.toIso8601String();

        String parkedSince = "";
        final speedVal = double.tryParse(liveSpeed) ?? 0.0;

        if (speedVal <= 5 && stoppedAtStr != null && stoppedAtStr.isNotEmpty) {
          try {
            DateTime stoppedAt;
            int? unixTime = int.tryParse(stoppedAtStr);
            if (unixTime != null && unixTime > 1000000000) {
              if (unixTime > 1000000000000) {
                stoppedAt = DateTime.fromMillisecondsSinceEpoch(
                  unixTime,
                ).toLocal();
              } else {
                stoppedAt = DateTime.fromMillisecondsSinceEpoch(
                  unixTime * 1000,
                ).toLocal();
              }
            } else {
              stoppedAt = DateTime.parse(stoppedAtStr).toLocal();
            }

            final now = DateTime.now();
            final isToday =
                stoppedAt.year == now.year &&
                stoppedAt.month == now.month &&
                stoppedAt.day == now.day;

            final timeFormat = DateFormat('hh:mm a');
            if (isToday) {
              parkedSince = '${timeFormat.format(stoppedAt)}, Today';
            } else {
              final dateFormat = DateFormat('MMM dd');
              parkedSince =
                  '${timeFormat.format(stoppedAt)}, ${dateFormat.format(stoppedAt)}';
            }
          } catch (e) {
            debugPrint(
              'Failed to parse parked since time: $stoppedAtStr. Error: $e',
            );
            parkedSince = "";
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Vehicle Icon
                Image.asset(
                  AppImages.bikeImage,
                  height: 48,
                  width: 48,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 12),
                // Vehicle Name and Number
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _currentVehicle?.vehicleMaker ??
                            AppLocalizations.of(
                              context,
                            )!.vehicleNamePlaceholder,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        _currentVehicle?.vehicleNumber ??
                            AppLocalizations.of(
                              context,
                            )!.vehicleNumberPlaceholder,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(
                            0xFF4A90A4,
                          ), // Matched blue from screenshot
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                // Speed Info with Animated Switcher
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  layoutBuilder:
                      (Widget? currentChild, List<Widget> previousChildren) {
                        return Stack(
                          alignment: Alignment.centerRight,
                          children: <Widget>[
                            ...previousChildren,
                            if (currentChild != null) currentChild,
                          ],
                        );
                      },
                  switchInCurve: Curves.easeOutBack,
                  switchOutCurve: Curves.easeInQuint,
                  transitionBuilder: (child, animation) {
                    final offsetAnimation = Tween<Offset>(
                      begin: Offset(
                        0.0,
                        _uiCubit.state.isSlidingUp ? -0.5 : 0.5,
                      ),
                      end: Offset.zero,
                    ).animate(animation);
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      ),
                    );
                  },
                  child: _buildHeaderMetric(liveDevice, liveSpeed),
                ),
                const SizedBox(width: 12),
                // Up/Down Arrows
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildSmallArrowButton(
                      Icons.keyboard_arrow_up,
                      onTap: () => _changeHeaderMetric(context, true),
                    ),
                    const SizedBox(height: 12),
                    _buildSmallArrowButton(
                      Icons.keyboard_arrow_down,
                      onTap: () => _changeHeaderMetric(context, false),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Parked Since Status
            if (parkedSince.isNotEmpty)
              Text(
                AppLocalizations.of(context)!.parkedSinceTime(parkedSince),
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.5),
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        );
      },
    );
      },
    );
  }

  Widget _buildHeaderMetric(Map<String, dynamic> liveDevice, String liveSpeed) {
    return BlocBuilder<FullScreenMapUiCubit, FullScreenMapUiState>(
      bloc: _uiCubit,
      builder: (context, uiState) {
        String value = liveSpeed;
        String unit = context.displayKmh;
        String label = AppLocalizations.of(context)!.speedLabel;

        if (uiState.headerMetricIndex == 1) {
          value = liveDevice['odometer']?.toString() ?? "0";
          unit = context.displayKm;
          label = AppLocalizations.of(context)!.distanceLabel;
        } else if (uiState.headerMetricIndex == 2) {
          final rangeValue =
              liveDevice['range'] ??
              liveDevice['kms_left'] ??
              liveDevice['fuel_range'] ??
              liveDevice['distance_remaining'] ??
              liveDevice['remaining_distance'] ??
              "0";
          value = rangeValue.toString();
          unit = context.displayKm;
          label = "Range";
        }

        return Column(
          key: ValueKey<int>(uiState.headerMetricIndex),
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 2),
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      },
    );
  }

  void _changeHeaderMetric(BuildContext context, bool isUp) {
    _uiCubit.changeHeaderMetric(isUp);
  }

  Widget _buildSmallArrowButton(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: Theme.of(context).dividerColor.withOpacity(0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return BlocBuilder<RideHistoryCubit, RideHistoryState>(
      builder: (context, rideState) {
        return BlocBuilder<AppCubit, AppState>(
          builder: (context, state) {
            Ride? lastRide;
            if (rideState is RideHistorySuccess && rideState.rides.isNotEmpty) {
              lastRide = rideState.rides.last;
            }

            // Find current device in the live devices list to get live speed/odometer
            final liveDevice = state.devices.firstWhere(
              (d) =>
                  d['imei']?.toString() == _currentVehicle?.imei ||
                  d['_id']?.toString() == _currentVehicle?.id ||
                  d['id']?.toString() == _currentVehicle?.id,
              orElse: () => <String, dynamic>{},
            );

            String liveSpeed =
                liveDevice['sp']?.toString() ??
                _currentVehicle?.currentLocation?.speed?.toString() ??
                "0";

            final odometer = liveDevice['odometer']?.toString() ?? "0";

            dynamic attrs = liveDevice['attributes'];
            if (attrs is String) {
              try {
                attrs = jsonDecode(attrs);
              } catch (_) {}
            }

            String todayDistanceStr = "0.0";
            String durationStr =
                "0${AppLocalizations.of(context)!.minutesShort} 0${AppLocalizations.of(context)!.secondsShort}";
            String topSpeedStr = "0 ${context.displayKmh}";

            bool isLastRideToday = false;
            if (lastRide != null) {
              try {
                if (lastRide.rawStartTime.isNotEmpty) {
                  final date = DateTime.parse(lastRide.rawStartTime).toLocal();
                  final now = DateTime.now();
                  if (date.year == now.year && date.month == now.month && date.day == now.day) {
                    isLastRideToday = true;
                  }
                } else {
                  final now = DateTime.now();
                  final format1 = "${now.day}/${now.month}/${now.year}";
                  final format2 = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
                  if (lastRide.date == format1 || lastRide.date == format2) {
                    isLastRideToday = true;
                  }
                }
              } catch (_) {}
            }
            
            if (!isLastRideToday) {
              liveSpeed = "0";
            }

            if (isLastRideToday && lastRide != null) {
              todayDistanceStr = lastRide.distance.toStringAsFixed(2);
              durationStr = lastRide.duration;
              topSpeedStr =
                  "${lastRide.topSpeed.toStringAsFixed(1)} ${context.displayKmh}";
            } else {
              final todayDistanceRaw =
                  liveDevice['todayDistance'] ??
                  liveDevice['td'];
              if (todayDistanceRaw != null &&
                  todayDistanceRaw.toString().isNotEmpty) {
                double val =
                    double.tryParse(todayDistanceRaw.toString()) ?? 0.0;
                todayDistanceStr = val.toStringAsFixed(2);
              } else {
                todayDistanceStr = "0.00";
              }

              final todayDurationRaw =
                  liveDevice['todayDuration'] ??
                  liveDevice['dur'] ??
                  liveDevice['duration'] ??
                  "0";
              if (todayDurationRaw != null &&
                  todayDurationRaw.toString().isNotEmpty &&
                  todayDurationRaw.toString() != "0") {
                final rawStr = todayDurationRaw.toString();
                if (rawStr.contains('m') ||
                    rawStr.contains('h') ||
                    rawStr.contains(':')) {
                  durationStr = rawStr;
                } else {
                  final double? numVal = double.tryParse(rawStr);
                  if (numVal != null && numVal > 0) {
                    int totalSeconds = numVal.round();
                    if (numVal > 100000) {
                      totalSeconds = (numVal / 1000).round();
                    } else if (numVal < 1440) {
                      totalSeconds = (numVal * 60).round();
                    }
                    final int h = totalSeconds ~/ 3600;
                    final int m = (totalSeconds % 3600) ~/ 60;
                    final int s = totalSeconds % 60;
                    if (h > 0) {
                      durationStr =
                          "${h}h ${m}${AppLocalizations.of(context)!.minutesShort}";
                    } else {
                      durationStr =
                          "${m}${AppLocalizations.of(context)!.minutesShort} ${s}${AppLocalizations.of(context)!.secondsShort}";
                    }
                  }
                }
              }
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.todaysStats,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildGridItem(
                      "$todayDistanceStr ${context.displayKm}",
                      AppLocalizations.of(context)!.distanceLabel,
                    ),
                    _buildGridItem(
                      durationStr,
                      AppLocalizations.of(context)!.durationLabel,
                    ),
                    _buildGridItem(
                      "$liveSpeed ${context.displayKmh}",
                      AppLocalizations.of(context)!.speedLabel,
                    ),
                    _buildGridItem(
                      topSpeedStr,
                      AppLocalizations.of(context)!.topSpeed,
                      isPlus: topSpeedStr == "Plus",
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildGridItem(String value, String label, {bool isPlus = false}) {
    return Column(
      children: [
        if (isPlus)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE6BE75), Color(0xFFD4AF37)],
              ),
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD4AF37).withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              AppLocalizations.of(context)!.plusLabel,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          )
        else
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomInfoCards() {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final liveDevice = state.devices.firstWhere(
          (d) =>
              d['imei']?.toString() == _currentVehicle?.imei ||
              d['_id']?.toString() == _currentVehicle?.id ||
              d['id']?.toString() == _currentVehicle?.id,
          orElse: () => {},
        );

        // Parse range/distance remaining
        final rangeValue =
            liveDevice['range'] ??
            liveDevice['kms_left'] ??
            liveDevice['fuel_range'] ??
            liveDevice['distance_remaining'] ??
            liveDevice['remaining_distance'];

        final String rangeText = rangeValue != null
            ? "$rangeValue kms more to go"
            : "-- kms more to go";

        // Parse fuel percentage for bars
        final fuelVal =
            liveDevice['fuel'] ??
            liveDevice['fuelLevel'] ??
            liveDevice['fuel_level'] ??
            liveDevice['fuel_percentage'];

        double? fuelPercentage;
        if (fuelVal != null) {
          final parsed = double.tryParse(fuelVal.toString());
          if (parsed != null) {
            if (parsed <= 1.0) {
              fuelPercentage = parsed * 100;
            } else {
              fuelPercentage = parsed;
            }
          }
        }
        final int fuelBars = fuelPercentage != null
            ? (fuelPercentage / 20).round().clamp(0, 5)
            : 3; // Default to 3 bars if not available

        // Parse battery/voltage details
        final batteryVal =
            liveDevice['battery'] ??
            liveDevice['batteryLevel'] ??
            liveDevice['battery_level'] ??
            liveDevice['bat'];

        final voltageVal =
            liveDevice['voltage'] ??
            liveDevice['volts'] ??
            liveDevice['battery_voltage'] ??
            liveDevice['v_bat'] ??
            liveDevice['power'];

        String batteryText = "--";
        Color batteryColor = Colors.green;
        IconData batteryIcon = Icons.battery_charging_full;

        if (batteryVal != null || voltageVal != null) {
          if (voltageVal != null) {
            final voltDouble = double.tryParse(
              voltageVal.toString().replaceAll(RegExp(r'[^0-9.]'), ''),
            );
            if (voltDouble != null) {
              final String status = voltDouble < 11.5 ? "Low" : "Normal";
              batteryText = "$status (${voltDouble.toStringAsFixed(1)}V)";
              batteryColor = voltDouble < 11.5 ? Colors.red : Colors.green;
              batteryIcon = voltDouble < 11.5
                  ? Icons.battery_alert
                  : Icons.battery_charging_full;
            } else {
              batteryText = "Normal (${voltageVal.toString()})";
            }
          } else if (batteryVal != null) {
            final batDouble = double.tryParse(
              batteryVal.toString().replaceAll(RegExp(r'[^0-9.]'), ''),
            );
            if (batDouble != null) {
              final String status = batDouble < 20 ? "Low" : "Normal";
              final displayVal = batDouble <= 1.0
                  ? (batDouble * 100).round()
                  : batDouble.round();
              batteryText = "$status ($displayVal%)";
              batteryColor = displayVal < 20 ? Colors.red : Colors.green;
              batteryIcon = displayVal < 20
                  ? Icons.battery_alert
                  : Icons.battery_charging_full;
            } else {
              batteryText = "Normal (${batteryVal.toString()})";
            }
          }
        }

        return Row(
          children: [
            // Fuel Card
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).dividerColor.withOpacity(0.5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_gas_station,
                          size: 18,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "E",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Row(
                          children: List.generate(
                            5,
                            (i) => Container(
                              width: 8,
                              height: 12,
                              margin: const EdgeInsets.symmetric(horizontal: 1),
                              decoration: BoxDecoration(
                                color: i < fuelBars
                                    ? const Color(0xFF3498DB)
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          "F",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      rangeText,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.4),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Battery Card
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).dividerColor.withOpacity(0.5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Vehicle Battery",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: batteryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            batteryIcon,
                            size: 14,
                            color: batteryColor,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          batteryText,
                          style: TextStyle(
                            fontSize: 12,
                            color: batteryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomNavIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildNavIcon(Icons.home_outlined, isSelected: true),
        _buildNavIcon(Icons.route_outlined),
        _buildNavIcon(Icons.bar_chart_outlined),
        _buildNavIcon(Icons.person_outline),
      ],
    );
  }

  Widget _buildNavIcon(IconData icon, {bool isSelected = false}) {
    return Icon(
      icon,
      color: isSelected
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      size: 28,
    );
  }
}

final List<Map<String, dynamic>> _demoRouteData = [
  {
    "latitude": 22.7347,
    "longitude": 75.895313,
    "speed": 5.5,
    "time": "2026-06-23T07:01:42.714Z",
  },
  {
    "latitude": 22.7347,
    "longitude": 75.895313,
    "speed": 8.1,
    "time": "2026-06-23T07:07:20.614Z",
  },
  {
    "latitude": 22.7347,
    "longitude": 75.895313,
    "speed": 5.1,
    "time": "2026-06-23T07:08:06.918Z",
  },
  {
    "latitude": 22.7347,
    "longitude": 75.895313,
    "speed": 5.9,
    "time": "2026-06-23T07:08:06.932Z",
  },
  {
    "latitude": 22.734806,
    "longitude": 75.895329,
    "speed": 12.6,
    "time": "2026-06-23T07:08:18.709Z",
  },
  {
    "latitude": 22.734839,
    "longitude": 75.895337,
    "speed": 13.4,
    "time": "2026-06-23T07:08:18.719Z",
  },
  {
    "latitude": 22.734912,
    "longitude": 75.895361,
    "speed": 14.8,
    "time": "2026-06-23T07:08:18.733Z",
  },
  {
    "latitude": 22.734953,
    "longitude": 75.89537,
    "speed": 17.6,
    "time": "2026-06-23T07:08:18.742Z",
  },
  {
    "latitude": 22.734994,
    "longitude": 75.895394,
    "speed": 18.2,
    "time": "2026-06-23T07:08:18.752Z",
  },
  {
    "latitude": 22.735038,
    "longitude": 75.89541,
    "speed": 16.9,
    "time": "2026-06-23T07:08:18.765Z",
  },
  {
    "latitude": 22.7361,
    "longitude": 75.89471,
    "speed": 15.5,
    "time": "2026-06-23T07:09:05.163Z",
  },
  {
    "latitude": 22.73621,
    "longitude": 75.894393,
    "speed": 18.5,
    "time": "2026-06-23T07:09:05.174Z",
  },
  {
    "latitude": 22.736218,
    "longitude": 75.894344,
    "speed": 18.0,
    "time": "2026-06-23T07:09:05.185Z",
  },
  {
    "latitude": 22.736226,
    "longitude": 75.894287,
    "speed": 18.0,
    "time": "2026-06-23T07:09:05.194Z",
  },
  {
    "latitude": 22.736247,
    "longitude": 75.894198,
    "speed": 16.0,
    "time": "2026-06-23T07:09:05.207Z",
  },
  {
    "latitude": 22.736251,
    "longitude": 75.894157,
    "speed": 13.6,
    "time": "2026-06-23T07:09:05.217Z",
  },
  {
    "latitude": 22.736316,
    "longitude": 75.893734,
    "speed": 27.5,
    "time": "2026-06-23T07:09:19.754Z",
  },
  {
    "latitude": 22.736332,
    "longitude": 75.893644,
    "speed": 25.8,
    "time": "2026-06-23T07:09:19.764Z",
  },
  {
    "latitude": 22.736369,
    "longitude": 75.893482,
    "speed": 21.4,
    "time": "2026-06-23T07:09:19.774Z",
  },
  {
    "latitude": 22.736381,
    "longitude": 75.893425,
    "speed": 18.2,
    "time": "2026-06-23T07:09:19.784Z",
  },
  {
    "latitude": 22.736409,
    "longitude": 75.893368,
    "speed": 19.3,
    "time": "2026-06-23T07:09:19.793Z",
  },
  {
    "latitude": 22.736479,
    "longitude": 75.893262,
    "speed": 21.1,
    "time": "2026-06-23T07:09:19.805Z",
  },
  {
    "latitude": 22.737646,
    "longitude": 75.893213,
    "speed": 27.0,
    "time": "2026-06-23T07:09:54.350Z",
  },
  {
    "latitude": 22.737789,
    "longitude": 75.892838,
    "speed": 23.0,
    "time": "2026-06-23T07:09:54.363Z",
  },
  {
    "latitude": 22.737805,
    "longitude": 75.892774,
    "speed": 25.9,
    "time": "2026-06-23T07:09:54.372Z",
  },
  {
    "latitude": 22.73783,
    "longitude": 75.892627,
    "speed": 22.5,
    "time": "2026-06-23T07:09:54.385Z",
  },
  {
    "latitude": 22.737846,
    "longitude": 75.892562,
    "speed": 22.7,
    "time": "2026-06-23T07:09:54.398Z",
  },
  {
    "latitude": 22.737866,
    "longitude": 75.892497,
    "speed": 23.8,
    "time": "2026-06-23T07:09:54.414Z",
  },
  {
    "latitude": 22.738774,
    "longitude": 75.891895,
    "speed": 31.5,
    "time": "2026-06-23T07:10:26.062Z",
  },
  {
    "latitude": 22.739274,
    "longitude": 75.892057,
    "speed": 28.1,
    "time": "2026-06-23T07:10:26.072Z",
  },
  {
    "latitude": 22.739347,
    "longitude": 75.892073,
    "speed": 25.6,
    "time": "2026-06-23T07:10:26.084Z",
  },
  {
    "latitude": 22.739408,
    "longitude": 75.892106,
    "speed": 25.8,
    "time": "2026-06-23T07:10:26.096Z",
  },
  {
    "latitude": 22.739543,
    "longitude": 75.892139,
    "speed": 22.1,
    "time": "2026-06-23T07:10:26.109Z",
  },
  {
    "latitude": 22.7396,
    "longitude": 75.892163,
    "speed": 21.6,
    "time": "2026-06-23T07:10:26.126Z",
  },
  {
    "latitude": 22.739828,
    "longitude": 75.892261,
    "speed": 15.0,
    "time": "2026-06-23T07:10:37.857Z",
  },
  {
    "latitude": 22.73986,
    "longitude": 75.892277,
    "speed": 14.4,
    "time": "2026-06-23T07:10:37.868Z",
  },
  {
    "latitude": 22.739929,
    "longitude": 75.892269,
    "speed": 11.3,
    "time": "2026-06-23T07:10:37.883Z",
  },
  {
    "latitude": 22.739937,
    "longitude": 75.892269,
    "speed": 9.6,
    "time": "2026-06-23T07:10:37.892Z",
  },
  {
    "latitude": 22.739994,
    "longitude": 75.892293,
    "speed": 12.4,
    "time": "2026-06-23T07:10:37.903Z",
  },
  {
    "latitude": 22.740072,
    "longitude": 75.892342,
    "speed": 18.1,
    "time": "2026-06-23T07:10:37.913Z",
  },
  {
    "latitude": 22.742037,
    "longitude": 75.89292,
    "speed": 19.5,
    "time": "2026-06-23T07:11:24.340Z",
  },
  {
    "latitude": 22.742245,
    "longitude": 75.892985,
    "speed": 12.3,
    "time": "2026-06-23T07:11:24.352Z",
  },
  {
    "latitude": 22.742277,
    "longitude": 75.892993,
    "speed": 13.1,
    "time": "2026-06-23T07:11:24.362Z",
  },
  {
    "latitude": 22.742301,
    "longitude": 75.89301,
    "speed": 10.5,
    "time": "2026-06-23T07:11:24.377Z",
  },
  {
    "latitude": 22.742314,
    "longitude": 75.89301,
    "speed": 7.3,
    "time": "2026-06-23T07:11:24.391Z",
  },
  {
    "latitude": 22.743355,
    "longitude": 75.893327,
    "speed": 17.5,
    "time": "2026-06-23T07:12:22.536Z",
  },
  {
    "latitude": 22.743579,
    "longitude": 75.893384,
    "speed": 15.0,
    "time": "2026-06-23T07:12:22.550Z",
  },
  {
    "latitude": 22.743624,
    "longitude": 75.8934,
    "speed": 14.6,
    "time": "2026-06-23T07:12:22.559Z",
  },
  {
    "latitude": 22.743697,
    "longitude": 75.893425,
    "speed": 14.4,
    "time": "2026-06-23T07:12:22.568Z",
  },
  {
    "latitude": 22.743742,
    "longitude": 75.893433,
    "speed": 21.2,
    "time": "2026-06-23T07:12:22.580Z",
  },
  {
    "latitude": 22.743803,
    "longitude": 75.893441,
    "speed": 27.0,
    "time": "2026-06-23T07:12:22.588Z",
  },
  {
    "latitude": 22.74423,
    "longitude": 75.893579,
    "speed": 25.0,
    "time": "2026-06-23T07:12:34.268Z",
  },
  {
    "latitude": 22.744287,
    "longitude": 75.893595,
    "speed": 24.8,
    "time": "2026-06-23T07:12:34.276Z",
  },
  {
    "latitude": 22.744356,
    "longitude": 75.89362,
    "speed": 22.5,
    "time": "2026-06-23T07:12:34.284Z",
  },
  {
    "latitude": 22.744413,
    "longitude": 75.893636,
    "speed": 20.7,
    "time": "2026-06-23T07:12:34.290Z",
  },
  {
    "latitude": 22.744507,
    "longitude": 75.893677,
    "speed": 16.1,
    "time": "2026-06-23T07:12:34.299Z",
  },
  {
    "latitude": 22.744535,
    "longitude": 75.893701,
    "speed": 12.9,
    "time": "2026-06-23T07:12:34.308Z",
  },
  {
    "latitude": 22.744958,
    "longitude": 75.894922,
    "speed": 27.1,
    "time": "2026-06-23T07:13:20.730Z",
  },
  {
    "latitude": 22.745252,
    "longitude": 75.895158,
    "speed": 20.3,
    "time": "2026-06-23T07:13:20.739Z",
  },
  {
    "latitude": 22.745361,
    "longitude": 75.895272,
    "speed": 21.0,
    "time": "2026-06-23T07:13:20.746Z",
  },
  {
    "latitude": 22.745418,
    "longitude": 75.895329,
    "speed": 23.2,
    "time": "2026-06-23T07:13:20.758Z",
  },
  {
    "latitude": 22.745492,
    "longitude": 75.895386,
    "speed": 27.1,
    "time": "2026-06-23T07:13:20.770Z",
  },
  {
    "latitude": 22.745581,
    "longitude": 75.895443,
    "speed": 31.6,
    "time": "2026-06-23T07:13:20.781Z",
  },
  {
    "latitude": 22.746024,
    "longitude": 75.895638,
    "speed": 28.9,
    "time": "2026-06-23T07:13:32.794Z",
  },
  {
    "latitude": 22.746081,
    "longitude": 75.895671,
    "speed": 29.4,
    "time": "2026-06-23T07:13:32.803Z",
  },
  {
    "latitude": 22.746155,
    "longitude": 75.895695,
    "speed": 29.1,
    "time": "2026-06-23T07:13:32.812Z",
  },
  {
    "latitude": 22.746305,
    "longitude": 75.895736,
    "speed": 27.6,
    "time": "2026-06-23T07:13:32.823Z",
  },
  {
    "latitude": 22.746366,
    "longitude": 75.895752,
    "speed": 27.6,
    "time": "2026-06-23T07:13:32.832Z",
  },
  {
    "latitude": 22.746427,
    "longitude": 75.895768,
    "speed": 25.4,
    "time": "2026-06-23T07:13:32.842Z",
  },
  {
    "latitude": 22.747746,
    "longitude": 75.896387,
    "speed": 7.6,
    "time": "2026-06-23T07:14:18.974Z",
  },
  {
    "latitude": 22.74775,
    "longitude": 75.896379,
    "speed": 8.0,
    "time": "2026-06-23T07:14:18.985Z",
  },
  {
    "latitude": 22.747754,
    "longitude": 75.896371,
    "speed": 6.3,
    "time": "2026-06-23T07:14:18.994Z",
  },
  {
    "latitude": 22.747754,
    "longitude": 75.896354,
    "speed": 6.8,
    "time": "2026-06-23T07:14:30.800Z",
  },
  {
    "latitude": 22.747803,
    "longitude": 75.89624,
    "speed": 5.2,
    "time": "2026-06-23T07:15:29.007Z",
  },
  {
    "latitude": 22.747803,
    "longitude": 75.89624,
    "speed": 5.3,
    "time": "2026-06-23T07:15:29.028Z",
  },
  {
    "latitude": 22.747774,
    "longitude": 75.896167,
    "speed": 5.5,
    "time": "2026-06-23T07:26:44.462Z",
  },
  {
    "latitude": 22.747701,
    "longitude": 75.896199,
    "speed": 10.5,
    "time": "2026-06-23T07:32:17.937Z",
  },
  {
    "latitude": 22.747758,
    "longitude": 75.896313,
    "speed": 7.9,
    "time": "2026-06-23T07:37:00.042Z",
  },
  {
    "latitude": 22.74777,
    "longitude": 75.896313,
    "speed": 9.6,
    "time": "2026-06-23T07:37:00.058Z",
  },
  {
    "latitude": 22.747831,
    "longitude": 75.896265,
    "speed": 13.5,
    "time": "2026-06-23T07:37:00.080Z",
  },
  {
    "latitude": 22.747852,
    "longitude": 75.896216,
    "speed": 17.0,
    "time": "2026-06-23T07:37:00.113Z",
  },
  {
    "latitude": 22.748108,
    "longitude": 75.895093,
    "speed": 5.8,
    "time": "2026-06-23T07:37:31.896Z",
  },
  {
    "latitude": 22.748161,
    "longitude": 75.895093,
    "speed": 10.0,
    "time": "2026-06-23T07:37:31.916Z",
  },
  {
    "latitude": 22.748385,
    "longitude": 75.894759,
    "speed": 15.7,
    "time": "2026-06-23T07:38:30.069Z",
  },
  {
    "latitude": 22.748572,
    "longitude": 75.894783,
    "speed": 9.8,
    "time": "2026-06-23T07:38:30.095Z",
  },
  {
    "latitude": 22.748576,
    "longitude": 75.894783,
    "speed": 7.6,
    "time": "2026-06-23T07:38:30.110Z",
  },
  {
    "latitude": 22.748588,
    "longitude": 75.894783,
    "speed": 5.1,
    "time": "2026-06-23T07:38:30.141Z",
  },
  {
    "latitude": 22.749284,
    "longitude": 75.893335,
    "speed": 36.6,
    "time": "2026-06-23T07:39:28.594Z",
  },
  {
    "latitude": 22.749377,
    "longitude": 75.892855,
    "speed": 37.3,
    "time": "2026-06-23T07:39:28.612Z",
  },
  {
    "latitude": 22.749398,
    "longitude": 75.892757,
    "speed": 39.8,
    "time": "2026-06-23T07:39:28.640Z",
  },
  {
    "latitude": 22.749451,
    "longitude": 75.892521,
    "speed": 41.8,
    "time": "2026-06-23T07:39:28.658Z",
  },
  {
    "latitude": 22.749475,
    "longitude": 75.892407,
    "speed": 43.6,
    "time": "2026-06-23T07:39:28.674Z",
  },
  {
    "latitude": 22.7495,
    "longitude": 75.892293,
    "speed": 39.2,
    "time": "2026-06-23T07:39:28.693Z",
  },
  {
    "latitude": 22.749609,
    "longitude": 75.891805,
    "speed": 12.6,
    "time": "2026-06-23T07:39:40.331Z",
  },
  {
    "latitude": 22.749597,
    "longitude": 75.891772,
    "speed": 5.8,
    "time": "2026-06-23T07:39:40.374Z",
  },
  {
    "latitude": 22.749585,
    "longitude": 75.891756,
    "speed": 5.3,
    "time": "2026-06-23T07:39:40.401Z",
  },
  {
    "latitude": 22.749528,
    "longitude": 75.89165,
    "speed": 7.2,
    "time": "2026-06-23T07:41:25.098Z",
  },
  {
    "latitude": 22.749626,
    "longitude": 75.891626,
    "speed": 7.2,
    "time": "2026-06-23T07:42:35.411Z",
  },
  {
    "latitude": 22.749626,
    "longitude": 75.891626,
    "speed": 6.2,
    "time": "2026-06-23T07:43:21.793Z",
  },
  {
    "latitude": 22.749626,
    "longitude": 75.891626,
    "speed": 8.8,
    "time": "2026-06-23T07:44:31.828Z",
  },
  {
    "latitude": 22.749626,
    "longitude": 75.891626,
    "speed": 5.2,
    "time": "2026-06-23T07:45:18.371Z",
  },
  {
    "latitude": 22.749626,
    "longitude": 75.891626,
    "speed": 7.2,
    "time": "2026-06-23T07:46:16.558Z",
  },
  {
    "latitude": 22.749614,
    "longitude": 75.891496,
    "speed": 7.7,
    "time": "2026-06-23T07:49:11.171Z",
  },
  {
    "latitude": 22.749678,
    "longitude": 75.891325,
    "speed": 8.3,
    "time": "2026-06-23T07:49:11.187Z",
  },
  {
    "latitude": 22.749678,
    "longitude": 75.891325,
    "speed": 6.9,
    "time": "2026-06-23T07:49:11.203Z",
  },
  {
    "latitude": 22.749683,
    "longitude": 75.891309,
    "speed": 8.6,
    "time": "2026-06-23T07:49:11.216Z",
  },
  {
    "latitude": 22.749715,
    "longitude": 75.891227,
    "speed": 16.3,
    "time": "2026-06-23T07:49:11.231Z",
  },
  {
    "latitude": 22.749731,
    "longitude": 75.891178,
    "speed": 20.9,
    "time": "2026-06-23T07:49:11.246Z",
  },
  {
    "latitude": 22.749748,
    "longitude": 75.890918,
    "speed": 19.9,
    "time": "2026-06-23T07:49:23.042Z",
  },
  {
    "latitude": 22.749748,
    "longitude": 75.890804,
    "speed": 13.6,
    "time": "2026-06-23T07:49:23.053Z",
  },
  {
    "latitude": 22.749756,
    "longitude": 75.890763,
    "speed": 11.3,
    "time": "2026-06-23T07:49:23.074Z",
  },
  {
    "latitude": 22.749764,
    "longitude": 75.890715,
    "speed": 10.9,
    "time": "2026-06-23T07:49:23.094Z",
  },
  {
    "latitude": 22.749772,
    "longitude": 75.890682,
    "speed": 10.2,
    "time": "2026-06-23T07:49:23.120Z",
  },
  {
    "latitude": 22.74978,
    "longitude": 75.890674,
    "speed": 5.8,
    "time": "2026-06-23T07:49:23.135Z",
  },
  {
    "latitude": 22.749809,
    "longitude": 75.890641,
    "speed": 8.7,
    "time": "2026-06-23T07:51:07.784Z",
  },
  {
    "latitude": 22.749902,
    "longitude": 75.89034,
    "speed": 11.4,
    "time": "2026-06-23T07:51:19.552Z",
  },
  {
    "latitude": 22.749902,
    "longitude": 75.890332,
    "speed": 7.4,
    "time": "2026-06-23T07:51:19.566Z",
  },
  {
    "latitude": 22.749894,
    "longitude": 75.890259,
    "speed": 11.1,
    "time": "2026-06-23T07:51:19.597Z",
  },
  {
    "latitude": 22.749902,
    "longitude": 75.890226,
    "speed": 14.6,
    "time": "2026-06-23T07:51:19.617Z",
  },
  {
    "latitude": 22.749923,
    "longitude": 75.890202,
    "speed": 14.5,
    "time": "2026-06-23T07:51:19.642Z",
  },
  {
    "latitude": 22.751668,
    "longitude": 75.890397,
    "speed": 12.5,
    "time": "2026-06-23T07:52:05.974Z",
  },
  {
    "latitude": 22.751847,
    "longitude": 75.890348,
    "speed": 12.3,
    "time": "2026-06-23T07:52:05.983Z",
  },
  {
    "latitude": 22.751876,
    "longitude": 75.890316,
    "speed": 14.4,
    "time": "2026-06-23T07:52:05.996Z",
  },
  {
    "latitude": 22.751896,
    "longitude": 75.890283,
    "speed": 16.7,
    "time": "2026-06-23T07:52:06.013Z",
  },
  {
    "latitude": 22.751917,
    "longitude": 75.890251,
    "speed": 16.4,
    "time": "2026-06-23T07:52:06.032Z",
  },
  {
    "latitude": 22.751957,
    "longitude": 75.890177,
    "speed": 14.1,
    "time": "2026-06-23T07:52:06.054Z",
  },
  {
    "latitude": 22.751998,
    "longitude": 75.890023,
    "speed": 6.6,
    "time": "2026-06-23T07:52:17.649Z",
  },
  {
    "latitude": 22.752014,
    "longitude": 75.890006,
    "speed": 10.6,
    "time": "2026-06-23T07:52:17.665Z",
  },
  {
    "latitude": 22.752067,
    "longitude": 75.889958,
    "speed": 15.1,
    "time": "2026-06-23T07:52:17.678Z",
  },
  {
    "latitude": 22.752096,
    "longitude": 75.889925,
    "speed": 18.7,
    "time": "2026-06-23T07:52:17.692Z",
  },
  {
    "latitude": 22.752132,
    "longitude": 75.889885,
    "speed": 17.9,
    "time": "2026-06-23T07:52:17.710Z",
  },
  {
    "latitude": 22.752169,
    "longitude": 75.889844,
    "speed": 19.5,
    "time": "2026-06-23T07:52:17.720Z",
  },
  {
    "latitude": 22.752962,
    "longitude": 75.887687,
    "speed": 13.8,
    "time": "2026-06-23T07:53:04.339Z",
  },
  {
    "latitude": 22.753178,
    "longitude": 75.887679,
    "speed": 15.6,
    "time": "2026-06-23T07:53:04.349Z",
  },
  {
    "latitude": 22.753227,
    "longitude": 75.887704,
    "speed": 18.3,
    "time": "2026-06-23T07:53:04.358Z",
  },
  {
    "latitude": 22.753284,
    "longitude": 75.88772,
    "speed": 19.5,
    "time": "2026-06-23T07:53:04.370Z",
  },
  {
    "latitude": 22.753373,
    "longitude": 75.887736,
    "speed": 15.3,
    "time": "2026-06-23T07:53:04.382Z",
  },
  {
    "latitude": 22.753414,
    "longitude": 75.887736,
    "speed": 15.6,
    "time": "2026-06-23T07:53:04.394Z",
  },
  {
    "latitude": 22.753613,
    "longitude": 75.887768,
    "speed": 15.5,
    "time": "2026-06-23T07:53:15.953Z",
  },
  {
    "latitude": 22.753674,
    "longitude": 75.887801,
    "speed": 13.6,
    "time": "2026-06-23T07:53:15.966Z",
  },
  {
    "latitude": 22.753711,
    "longitude": 75.887809,
    "speed": 13.1,
    "time": "2026-06-23T07:53:15.982Z",
  },
  {
    "latitude": 22.753735,
    "longitude": 75.887809,
    "speed": 10.8,
    "time": "2026-06-23T07:53:16.006Z",
  },
  {
    "latitude": 22.753764,
    "longitude": 75.887825,
    "speed": 12.2,
    "time": "2026-06-23T07:53:16.035Z",
  },
  {
    "latitude": 22.753837,
    "longitude": 75.887842,
    "speed": 10.0,
    "time": "2026-06-23T07:53:16.063Z",
  },
  {
    "latitude": 22.755448,
    "longitude": 75.888273,
    "speed": 27.8,
    "time": "2026-06-23T07:54:02.384Z",
  },
  {
    "latitude": 22.755697,
    "longitude": 75.888379,
    "speed": 8.8,
    "time": "2026-06-23T07:54:02.405Z",
  },
  {
    "latitude": 22.755729,
    "longitude": 75.888387,
    "speed": 11.8,
    "time": "2026-06-23T07:54:02.420Z",
  },
  {
    "latitude": 22.755823,
    "longitude": 75.888387,
    "speed": 19.8,
    "time": "2026-06-23T07:54:02.440Z",
  },
  {
    "latitude": 22.75588,
    "longitude": 75.888387,
    "speed": 23.6,
    "time": "2026-06-23T07:54:02.454Z",
  },
  {
    "latitude": 22.755945,
    "longitude": 75.888387,
    "speed": 24.9,
    "time": "2026-06-23T07:54:02.471Z",
  },
  {
    "latitude": 22.756246,
    "longitude": 75.888476,
    "speed": 20.9,
    "time": "2026-06-23T07:54:14.224Z",
  },
  {
    "latitude": 22.756348,
    "longitude": 75.888501,
    "speed": 16.8,
    "time": "2026-06-23T07:54:14.243Z",
  },
  {
    "latitude": 22.756396,
    "longitude": 75.888517,
    "speed": 15.3,
    "time": "2026-06-23T07:54:14.258Z",
  },
  {
    "latitude": 22.756437,
    "longitude": 75.888509,
    "speed": 12.6,
    "time": "2026-06-23T07:54:14.279Z",
  },
  {
    "latitude": 22.756498,
    "longitude": 75.888525,
    "speed": 12.6,
    "time": "2026-06-23T07:54:14.296Z",
  },
  {
    "latitude": 22.756531,
    "longitude": 75.888542,
    "speed": 14.3,
    "time": "2026-06-23T07:54:14.307Z",
  },
  {
    "latitude": 22.756527,
    "longitude": 75.889062,
    "speed": 12.8,
    "time": "2026-06-23T07:59:05.251Z",
  },
  {
    "latitude": 22.75651,
    "longitude": 75.889103,
    "speed": 14.5,
    "time": "2026-06-23T07:59:05.261Z",
  },
  {
    "latitude": 22.75649,
    "longitude": 75.889144,
    "speed": 11.7,
    "time": "2026-06-23T07:59:05.271Z",
  },
  {
    "latitude": 22.756478,
    "longitude": 75.889168,
    "speed": 10.4,
    "time": "2026-06-23T07:59:05.283Z",
  },
  {
    "latitude": 22.75647,
    "longitude": 75.889233,
    "speed": 12.0,
    "time": "2026-06-23T07:59:05.293Z",
  },
  {
    "latitude": 22.756462,
    "longitude": 75.889274,
    "speed": 12.3,
    "time": "2026-06-23T07:59:05.315Z",
  },
  {
    "latitude": 22.756071,
    "longitude": 75.89091,
    "speed": 19.1,
    "time": "2026-06-23T07:59:51.758Z",
  },
  {
    "latitude": 22.756034,
    "longitude": 75.89113,
    "speed": 10.4,
    "time": "2026-06-23T07:59:51.780Z",
  },
  {
    "latitude": 22.756034,
    "longitude": 75.891138,
    "speed": 5.9,
    "time": "2026-06-23T07:59:51.796Z",
  },
  {
    "latitude": 22.756014,
    "longitude": 75.891178,
    "speed": 10.3,
    "time": "2026-06-23T07:59:51.814Z",
  },
  {
    "latitude": 22.75599,
    "longitude": 75.891203,
    "speed": 12.0,
    "time": "2026-06-23T07:59:51.837Z",
  },
  {
    "latitude": 22.755957,
    "longitude": 75.891211,
    "speed": 12.8,
    "time": "2026-06-23T07:59:51.855Z",
  },
  {
    "latitude": 22.756201,
    "longitude": 75.890438,
    "speed": 11.7,
    "time": "2026-06-23T08:05:17.439Z",
  },
  {
    "latitude": 22.756242,
    "longitude": 75.890234,
    "speed": 20.4,
    "time": "2026-06-23T08:05:17.454Z",
  },
  {
    "latitude": 22.75625,
    "longitude": 75.890169,
    "speed": 19.4,
    "time": "2026-06-23T08:05:17.467Z",
  },
  {
    "latitude": 22.756279,
    "longitude": 75.890072,
    "speed": 16.7,
    "time": "2026-06-23T08:05:17.478Z",
  },
  {
    "latitude": 22.756299,
    "longitude": 75.890031,
    "speed": 15.4,
    "time": "2026-06-23T08:05:17.495Z",
  },
  {
    "latitude": 22.756307,
    "longitude": 75.889998,
    "speed": 16.1,
    "time": "2026-06-23T08:05:17.511Z",
  },
  {
    "latitude": 22.756376,
    "longitude": 75.889722,
    "speed": 19.2,
    "time": "2026-06-23T08:05:29.184Z",
  },
  {
    "latitude": 22.756388,
    "longitude": 75.889665,
    "speed": 23.1,
    "time": "2026-06-23T08:05:29.202Z",
  },
  {
    "latitude": 22.756405,
    "longitude": 75.889608,
    "speed": 22.3,
    "time": "2026-06-23T08:05:29.222Z",
  },
  {
    "latitude": 22.756413,
    "longitude": 75.889551,
    "speed": 17.7,
    "time": "2026-06-23T08:05:29.242Z",
  },
  {
    "latitude": 22.756429,
    "longitude": 75.889453,
    "speed": 17.0,
    "time": "2026-06-23T08:05:29.258Z",
  },
  {
    "latitude": 22.756445,
    "longitude": 75.889396,
    "speed": 18.7,
    "time": "2026-06-23T08:05:29.276Z",
  },
  {
    "latitude": 22.752913,
    "longitude": 75.887882,
    "speed": 22.0,
    "time": "2026-06-23T08:08:13.912Z",
  },
  {
    "latitude": 22.75284,
    "longitude": 75.888314,
    "speed": 26.9,
    "time": "2026-06-23T08:08:13.928Z",
  },
  {
    "latitude": 22.752795,
    "longitude": 75.888395,
    "speed": 28.2,
    "time": "2026-06-23T08:08:13.941Z",
  },
  {
    "latitude": 22.752775,
    "longitude": 75.888485,
    "speed": 26.1,
    "time": "2026-06-23T08:08:13.955Z",
  },
  {
    "latitude": 22.752746,
    "longitude": 75.888566,
    "speed": 24.7,
    "time": "2026-06-23T08:08:13.968Z",
  },
  {
    "latitude": 22.75273,
    "longitude": 75.888713,
    "speed": 21.9,
    "time": "2026-06-23T08:08:13.980Z",
  },
  {
    "latitude": 22.752653,
    "longitude": 75.889022,
    "speed": 21.9,
    "time": "2026-06-23T08:08:25.733Z",
  },
  {
    "latitude": 22.752641,
    "longitude": 75.889103,
    "speed": 22.5,
    "time": "2026-06-23T08:08:25.750Z",
  },
  {
    "latitude": 22.752604,
    "longitude": 75.889241,
    "speed": 24.2,
    "time": "2026-06-23T08:08:25.761Z",
  },
  {
    "latitude": 22.752559,
    "longitude": 75.889331,
    "speed": 26.9,
    "time": "2026-06-23T08:08:25.772Z",
  },
  {
    "latitude": 22.752551,
    "longitude": 75.889429,
    "speed": 26.4,
    "time": "2026-06-23T08:08:25.785Z",
  },
  {
    "latitude": 22.752523,
    "longitude": 75.889494,
    "speed": 26.7,
    "time": "2026-06-23T08:08:25.804Z",
  },
  {
    "latitude": 22.752311,
    "longitude": 75.889982,
    "speed": 7.2,
    "time": "2026-06-23T08:09:12.207Z",
  },
  {
    "latitude": 22.752311,
    "longitude": 75.889982,
    "speed": 6.1,
    "time": "2026-06-23T08:09:12.215Z",
  },
  {
    "latitude": 22.750688,
    "longitude": 75.890283,
    "speed": 19.4,
    "time": "2026-06-23T08:10:49.434Z",
  },
  {
    "latitude": 22.750525,
    "longitude": 75.89021,
    "speed": 10.2,
    "time": "2026-06-23T08:10:49.448Z",
  },
  {
    "latitude": 22.750492,
    "longitude": 75.890202,
    "speed": 10.8,
    "time": "2026-06-23T08:10:49.463Z",
  },
  {
    "latitude": 22.75044,
    "longitude": 75.890194,
    "speed": 11.1,
    "time": "2026-06-23T08:10:49.499Z",
  },
  {
    "latitude": 22.750411,
    "longitude": 75.890186,
    "speed": 13.5,
    "time": "2026-06-23T08:10:49.518Z",
  },
  {
    "latitude": 22.750383,
    "longitude": 75.890177,
    "speed": 11.3,
    "time": "2026-06-23T08:10:49.533Z",
  },
  {
    "latitude": 22.750265,
    "longitude": 75.890177,
    "speed": 11.3,
    "time": "2026-06-23T08:11:01.115Z",
  },
  {
    "latitude": 22.750208,
    "longitude": 75.890194,
    "speed": 13.0,
    "time": "2026-06-23T08:11:01.125Z",
  },
  {
    "latitude": 22.750175,
    "longitude": 75.890202,
    "speed": 10.9,
    "time": "2026-06-23T08:11:01.136Z",
  },
  {
    "latitude": 22.750167,
    "longitude": 75.89021,
    "speed": 9.3,
    "time": "2026-06-23T08:11:01.145Z",
  },
  {
    "latitude": 22.750086,
    "longitude": 75.890275,
    "speed": 14.2,
    "time": "2026-06-23T08:11:01.156Z",
  },
  {
    "latitude": 22.750049,
    "longitude": 75.890308,
    "speed": 17.6,
    "time": "2026-06-23T08:11:01.165Z",
  },
  {
    "latitude": 22.749512,
    "longitude": 75.892302,
    "speed": 32.3,
    "time": "2026-06-23T08:11:47.660Z",
  },
  {
    "latitude": 22.749406,
    "longitude": 75.8927,
    "speed": 22.2,
    "time": "2026-06-23T08:11:47.677Z",
  },
  {
    "latitude": 22.749398,
    "longitude": 75.892765,
    "speed": 21.2,
    "time": "2026-06-23T08:11:47.689Z",
  },
  {
    "latitude": 22.749398,
    "longitude": 75.892887,
    "speed": 24.0,
    "time": "2026-06-23T08:11:47.698Z",
  },
  {
    "latitude": 22.749377,
    "longitude": 75.892969,
    "speed": 26.6,
    "time": "2026-06-23T08:11:47.709Z",
  },
  {
    "latitude": 22.749353,
    "longitude": 75.893042,
    "speed": 27.6,
    "time": "2026-06-23T08:11:47.719Z",
  },
  {
    "latitude": 22.749227,
    "longitude": 75.89353,
    "speed": 29.3,
    "time": "2026-06-23T08:11:59.322Z",
  },
  {
    "latitude": 22.749215,
    "longitude": 75.893612,
    "speed": 29.5,
    "time": "2026-06-23T08:11:59.333Z",
  },
  {
    "latitude": 22.749206,
    "longitude": 75.893693,
    "speed": 29.9,
    "time": "2026-06-23T08:11:59.344Z",
  },
  {
    "latitude": 22.74917,
    "longitude": 75.893848,
    "speed": 29.7,
    "time": "2026-06-23T08:11:59.351Z",
  },
  {
    "latitude": 22.749154,
    "longitude": 75.893929,
    "speed": 25.1,
    "time": "2026-06-23T08:11:59.360Z",
  },
  {
    "latitude": 22.749137,
    "longitude": 75.893986,
    "speed": 23.4,
    "time": "2026-06-23T08:11:59.369Z",
  },
  {
    "latitude": 22.748173,
    "longitude": 75.894702,
    "speed": 12.2,
    "time": "2026-06-23T08:12:46.088Z",
  },
  {
    "latitude": 22.748083,
    "longitude": 75.894857,
    "speed": 18.9,
    "time": "2026-06-23T08:12:46.102Z",
  },
  {
    "latitude": 22.74808,
    "longitude": 75.894906,
    "speed": 19.4,
    "time": "2026-06-23T08:12:46.112Z",
  },
  {
    "latitude": 22.748067,
    "longitude": 75.894954,
    "speed": 17.3,
    "time": "2026-06-23T08:12:46.123Z",
  },
  {
    "latitude": 22.748051,
    "longitude": 75.895003,
    "speed": 18.7,
    "time": "2026-06-23T08:12:46.138Z",
  },
  {
    "latitude": 22.748039,
    "longitude": 75.895125,
    "speed": 24.3,
    "time": "2026-06-23T08:12:46.148Z",
  },
  {
    "latitude": 22.74799,
    "longitude": 75.895418,
    "speed": 20.2,
    "time": "2026-06-23T08:12:57.780Z",
  },
  {
    "latitude": 22.74799,
    "longitude": 75.895475,
    "speed": 22.0,
    "time": "2026-06-23T08:12:57.791Z",
  },
  {
    "latitude": 22.747998,
    "longitude": 75.895573,
    "speed": 18.9,
    "time": "2026-06-23T08:12:57.804Z",
  },
  {
    "latitude": 22.747994,
    "longitude": 75.895638,
    "speed": 24.2,
    "time": "2026-06-23T08:12:57.818Z",
  },
  {
    "latitude": 22.747982,
    "longitude": 75.895719,
    "speed": 26.3,
    "time": "2026-06-23T08:12:57.827Z",
  },
  {
    "latitude": 22.747933,
    "longitude": 75.89585,
    "speed": 27.3,
    "time": "2026-06-23T08:12:57.839Z",
  },
  {
    "latitude": 22.747766,
    "longitude": 75.896322,
    "speed": 5.7,
    "time": "2026-06-23T08:19:33.576Z",
  },
  {
    "latitude": 22.747713,
    "longitude": 75.896232,
    "speed": 5.3,
    "time": "2026-06-23T08:25:57.209Z",
  },
  {
    "latitude": 22.747713,
    "longitude": 75.896256,
    "speed": 5.0,
    "time": "2026-06-23T10:44:25.456Z",
  },
  {
    "latitude": 22.747733,
    "longitude": 75.896248,
    "speed": 5.6,
    "time": "2026-06-23T10:46:21.836Z",
  },
  {
    "latitude": 22.747733,
    "longitude": 75.896248,
    "speed": 8.3,
    "time": "2026-06-23T10:46:21.922Z",
  },
  {
    "latitude": 22.747733,
    "longitude": 75.896248,
    "speed": 5.5,
    "time": "2026-06-23T10:46:33.713Z",
  },
  {
    "latitude": 22.747689,
    "longitude": 75.896224,
    "speed": 7.4,
    "time": "2026-06-23T10:50:14.761Z",
  },
  {
    "latitude": 22.74777,
    "longitude": 75.896248,
    "speed": 7.0,
    "time": "2026-06-23T10:51:12.883Z",
  },
  {
    "latitude": 22.74777,
    "longitude": 75.896248,
    "speed": 5.2,
    "time": "2026-06-23T10:52:23.035Z",
  },
  {
    "latitude": 22.74777,
    "longitude": 75.896248,
    "speed": 5.6,
    "time": "2026-06-23T10:53:21.422Z",
  },
  {
    "latitude": 22.74777,
    "longitude": 75.896248,
    "speed": 6.8,
    "time": "2026-06-23T10:57:14.137Z",
  },
  {
    "latitude": 22.74777,
    "longitude": 75.896265,
    "speed": 12.0,
    "time": "2026-06-23T11:04:26.915Z",
  },
  {
    "latitude": 22.74777,
    "longitude": 75.896265,
    "speed": 5.7,
    "time": "2026-06-23T11:04:26.930Z",
  },
  {
    "latitude": 22.747782,
    "longitude": 75.896256,
    "speed": 5.7,
    "time": "2026-06-23T11:15:42.163Z",
  },
];
