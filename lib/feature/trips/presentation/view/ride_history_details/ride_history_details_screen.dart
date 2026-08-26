import 'package:flutter/material.dart';
import 'package:trackify/core/utils/flutter_compat_extensions.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:trackify/feature/trips/data/entity/ride_model.dart';
import 'package:trackify/feature/trips/presentation/cubit/ride_history_details_cubit.dart';
import 'package:trackify/feature/trips/presentation/cubit/ride_history_details_state.dart';
import 'package:trackify/l10n/app_localizations.dart';
import 'package:trackify/core/utils/distance_utils.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';
import 'package:trackify/app/cubit/app_cubit.dart';
import 'package:trackify/app/cubit/app_state.dart';
import 'package:trackify/core/constants/app_images.dart';
import 'package:trackify/core/utils/map_utils.dart';

class RideHistoryDetailsScreen extends StatefulWidget {
  final Ride ride;

  const RideHistoryDetailsScreen({super.key, required this.ride});

  @override
  State<RideHistoryDetailsScreen> createState() =>
      _RideHistoryDetailsScreenState();
}

class _RideHistoryDetailsScreenState extends State<RideHistoryDetailsScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RideHistoryDetailsCubit(ride: widget.ride),
      child: _RideHistoryDetailsView(ride: widget.ride),
    );
  }
}

class _RideHistoryDetailsView extends StatefulWidget {
  final Ride ride;
  const _RideHistoryDetailsView({required this.ride});

  @override
  State<_RideHistoryDetailsView> createState() =>
      __RideHistoryDetailsViewState();
}

class __RideHistoryDetailsViewState extends State<_RideHistoryDetailsView>
    with TickerProviderStateMixin {
  final Completer<GoogleMapController> _controller = Completer();

  late AnimationController _playController;
  late AnimationController _orbitController;
  bool _isOrbiting = false;
  bool _hasZoomedToRoute = false;
  CameraPosition? _lastCameraPosition;
  bool _isGliding = false;
  late Color _primaryColor;
  bool _wasPlayingBeforeDrag = false;
  bool _isDraggingSlider = false;
  bool _isDirectionMode = false;

  String? _lightMapStyle;
  String? _darkMapStyle;

  Future<void> _loadMapStyles() async {
    _lightMapStyle = await MapUtils.loadStyle(
      'assets/map_styles/light_map.json',
    );
    _darkMapStyle = await MapUtils.loadStyle('assets/map_styles/dark_map.json');
    if (mounted && _lastCameraPosition != null) {
      // Just to ensure if it loads late, we might need to update the controller.
    }
  }

  double _getSpeedMultiplier(int speed) {
    switch (speed) {
      case 2:
        return 3.0; // Play at 3x speed for 2x label
      case 3:
        return 6.0; // Play at 6x speed for 3x label
      case 4:
        return 10.0; // Play at 10x speed for 4x label
      default:
        return 1.0;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _primaryColor = Theme.of(context).colorScheme.primary;
  }

  @override
  void initState() {
    super.initState();
    _loadMapStyles();

    _playController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );

    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    int lastUpdateMs = 0;
    _playController.addListener(() {
      final now = DateTime.now().millisecondsSinceEpoch;
      // Throttle BLoC emissions to 20 FPS (approx. every 50ms) to completely eliminate
      // native thread congestion, ensuring butter-smooth marker movement and zero stutters!
      if (now - lastUpdateMs >= 50 ||
          _playController.value == 0.0 ||
          _playController.value == 1.0) {
        lastUpdateMs = now;
        final cubit = context.read<RideHistoryDetailsCubit>();
        cubit.updateProgress(_playController.value);
      }
    });

    _playController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        context.read<RideHistoryDetailsCubit>().updatePlaybackStatus(false);
        if (mounted) {
          final icon = await _createVehicleMarker(context);
          if (mounted) {
            context.read<RideHistoryDetailsCubit>().updateVehicleIcon(icon);
          }
        }
      }
    });

    _initializeAssets();
  }

  Future<void> _updateVehicleIcon() async {
    if (mounted) {
      final icon = await _createVehicleMarker(context);
      if (mounted) {
        context.read<RideHistoryDetailsCubit>().updateVehicleIcon(icon);
      }
    }
  }

  void _initializeAssets() async {
    try {
      final start = await _createStartMarker();
      final end = await _createEndMarker();
      if (!mounted) return;
      final vehicle = await _createVehicleMarker(context);
      String? mapStyle;
      try {
        mapStyle = await rootBundle.loadString(
          'assets/map_styles/dark_map.json',
        );
      } catch (e) {
        debugPrint('Error loading map style: $e');
      }

      if (mounted) {
        context.read<RideHistoryDetailsCubit>().initialize(
          start,
          end,
          vehicle,
          mapStyle,
        );
      }
    } catch (e) {
      debugPrint('Error initializing map assets: $e');
      if (mounted) {
        context.read<RideHistoryDetailsCubit>().initialize(
          BitmapDescriptor.defaultMarker,
          BitmapDescriptor.defaultMarker,
          BitmapDescriptor.defaultMarker,
          null,
        );
      }
    }
  }

  void _animateCameraToVehicle(
    RideHistoryDetailsState state, {
    bool force = false,
  }) async {
    if (_isGliding) {
      return; // Ignore regular updates during dynamic cinematic glides
    }
    if (state.currentVehiclePosition != null) {
      final controller = await _controller.future;

      final targetTarget = state.currentVehiclePosition!;
      final targetZoom = 17.5;
      final targetTilt = 45.0;
      final double targetBearing = _isDirectionMode
          ? state.currentHeading
          : 0.0;

      // Dynamic navigation view offset: Keep marker slightly below center (approx 65% down)
      // by placing the camera target slightly North of the vehicle for constant North stability.
      final double offsetDist = 0.00015 * math.pow(2.0, 17.5 - targetZoom);

      final LatLng adjustedTarget;
      if (_isDirectionMode) {
        final double bearingRad = state.currentHeading * math.pi / 180.0;
        adjustedTarget = LatLng(
          targetTarget.latitude + offsetDist * math.cos(bearingRad),
          targetTarget.longitude + offsetDist * math.sin(bearingRad),
        );
      } else {
        adjustedTarget = LatLng(
          targetTarget.latitude + offsetDist,
          targetTarget.longitude,
        );
      }

      if (force) {
        final targetPos = CameraPosition(
          target: adjustedTarget,
          zoom: targetZoom,
          tilt: targetTilt,
          bearing: targetBearing,
        );
        _lastCameraPosition = targetPos;
        controller.animateCamera(CameraUpdate.newCameraPosition(targetPos));
        return;
      }

      if (state.isPlaying || _isDraggingSlider) {
        // Fetch the actual current position or default to target
        final currentPos =
            _lastCameraPosition ??
            CameraPosition(
              target: state.currentVehiclePosition!,
              zoom: 17.5,
              tilt: 45.0,
              bearing: state.currentHeading,
            );

        final currentTarget = currentPos.target;
        final currentZoom = currentPos.zoom;
        final currentTilt = currentPos.tilt;
        final currentBearing = currentPos.bearing;

        // Premium Drone-style physics damping factors:
        // Optimized for 20 FPS updates to keep tracking snappy yet incredibly smooth
        const double posFactor = 0.15; // Base follow factor
        const double zoomFactor = 0.10; // Gradual altitude adjustment
        const double tiltFactor = 0.10; // Smooth perspective changes
        const double bearingFactor =
            0.08; // Immersive camera swivel around turns

        // Calculate distance difference in degrees to prevent the marker from drifting off-screen
        final double latDiff =
            (adjustedTarget.latitude - currentTarget.latitude).abs();
        final double lngDiff =
            (adjustedTarget.longitude - currentTarget.longitude).abs();
        final double distanceDiff = latDiff + lngDiff;

        // Dynamic catch-up acceleration: Automatically increases camera speed
        // if the vehicle starts moving fast or drifts towards the screen edge!
        double dynamicPosFactor = posFactor;
        if (distanceDiff > 0.002) {
          dynamicPosFactor =
              1.0; // Snap instantly if too far (prevents off-screen drifting)
        } else if (distanceDiff > 0.0006) {
          // Gradual speed boost to catch up smoothly
          dynamicPosFactor =
              posFactor +
              (1.0 - posFactor) * ((distanceDiff - 0.0006) / 0.0014);
        }

        // Coordinate linear interpolation (smooth glide-follow using dynamicPosFactor)
        final double lat =
            currentTarget.latitude +
            (adjustedTarget.latitude - currentTarget.latitude) *
                dynamicPosFactor;
        final double lng =
            currentTarget.longitude +
            (adjustedTarget.longitude - currentTarget.longitude) *
                dynamicPosFactor;

        // Zoom & Tilt linear interpolation
        final double zoom =
            currentZoom + (targetZoom - currentZoom) * zoomFactor;
        final double tilt =
            currentTilt + (targetTilt - currentTilt) * tiltFactor;

        // Bearing circular interpolation (shortest angle wrap-around to prevent spin stutters)
        double diffBearing = targetBearing - currentBearing;
        if (diffBearing > 180) diffBearing -= 360;
        if (diffBearing < -180) diffBearing += 360;
        final double bearing = currentBearing + diffBearing * bearingFactor;

        final nextPos = CameraPosition(
          target: LatLng(lat, lng),
          zoom: zoom,
          tilt: tilt,
          bearing: bearing,
        );

        // Save instantly so the next tick interpolates starting from this new frame
        _lastCameraPosition = nextPos;

        controller.moveCamera(CameraUpdate.newCameraPosition(nextPos));
      }
    }
  }

  double _getBoundsZoomLevel(
    LatLngBounds bounds,
    double mapWidth,
    double mapHeight,
  ) {
    final northeast = bounds.northeast;
    final southwest = bounds.southwest;

    final lngFraction =
        (southwest.longitude - northeast.longitude).abs() / 360.0;

    final double latRadSW = southwest.latitude * math.pi / 180.0;
    final double latRadNE = northeast.latitude * math.pi / 180.0;
    final double latFractionMercator =
        (math.log(math.tan(latRadSW / 2 + math.pi / 4)) -
                math.log(math.tan(latRadNE / 2 + math.pi / 4)))
            .abs() /
        (2 * math.pi);

    final double latZoom =
        (math.log(mapHeight / 256.0 / latFractionMercator) / math.log(2.0));
    final double lngZoom =
        (math.log(mapWidth / 256.0 / lngFraction) / math.log(2.0));

    if (latZoom.isNaN ||
        latZoom.isInfinite ||
        lngZoom.isNaN ||
        lngZoom.isInfinite) {
      return 12.0; // safe fallback
    }

    // Choose the lower zoom to ensure everything fits, minus a small padding
    return math.min(latZoom, lngZoom) - 1.2;
  }

  Future<void> _runCinematicGlide({
    required LatLng targetLatLng,
    required double targetZoom,
    required double targetTilt,
    required double targetBearing,
    required Duration duration,
  }) async {
    _isGliding = true;
    try {
      final controller = await _controller.future;

      final startPos =
          _lastCameraPosition ??
          const CameraPosition(
            target: LatLng(20.5937, 78.9629),
            zoom: 4.2,
            tilt: 0.0,
            bearing: 0.0,
          );

      final startTarget = startPos.target;
      final startZoom = startPos.zoom;
      final startTilt = startPos.tilt;
      final startBearing = startPos.bearing;

      final endTarget = targetLatLng;
      final endZoom = targetZoom;
      final endTilt = targetTilt;
      final endBearing = targetBearing;

      const int totalSteps = 45;
      final delayPerStep = duration.inMilliseconds ~/ totalSteps;

      for (int i = 0; i <= totalSteps; i++) {
        if (!mounted) return;
        final double t = i / totalSteps;

        // Eased curves:
        // 1. Pan (LatLng): Snaps/glides to center on the target location within the first 25% of the flight duration
        final double panProgress = math.min(1.0, t / 0.25);
        final double panT = (1 - math.pow(1 - panProgress, 3))
            .toDouble(); // Ease-out cubic

        // 2. Zoom & Tilt: Gradual ease-in-out to peak smoothly after centering is fully complete
        final double zoomT =
            (t < 0.5 ? 4 * t * t * t : 1 - math.pow(-2 * t + 2, 3) / 2)
                .toDouble(); // Ease-in-out cubic

        // Coordinate linear interpolation using panT (centers instantly)
        final double lat =
            startTarget.latitude +
            (endTarget.latitude - startTarget.latitude) * panT;
        final double lng =
            startTarget.longitude +
            (endTarget.longitude - startTarget.longitude) * panT;

        // Zoom & Tilt interpolation using zoomT (zooms smoothly)
        final double zoom = startZoom + (endZoom - startZoom) * zoomT;
        final double tilt = startTilt + (endTilt - startTilt) * zoomT;

        // Bearing circular interpolation (shortest angle) using zoomT
        double diffBearing = endBearing - startBearing;
        if (diffBearing > 180) diffBearing -= 360;
        if (diffBearing < -180) diffBearing += 360;
        final double bearing = startBearing + diffBearing * zoomT;

        final nextGlidePos = CameraPosition(
          target: LatLng(lat, lng),
          zoom: zoom,
          tilt: tilt,
          bearing: bearing,
        );
        _lastCameraPosition = nextGlidePos;

        controller.moveCamera(CameraUpdate.newCameraPosition(nextGlidePos));

        await Future.delayed(Duration(milliseconds: delayPerStep));
      }
    } finally {
      _isGliding = false;
    }
  }

  void _togglePlayback() async {
    final cubit = context.read<RideHistoryDetailsCubit>();
    if (cubit.state.isPlaying) {
      _playController.stop();
      _stopOrbitAnimation();
      cubit.updatePlaybackStatus(false);
      // Keep _isPlaybackActive = true during pause to maintain size
      _updateVehicleIcon();
    } else {
      if (_playController.isCompleted) {
        _playController.reset();
      }

      // Playback duration matches the actual trip duration (totalWeight) in real-time at 1x speed!
      final double baseSeconds = math.max(5.0, cubit.state.totalWeight);
      final targetSeconds =
          baseSeconds / _getSpeedMultiplier(cubit.state.playbackSpeed);
      _playController.duration = Duration(
        milliseconds: (targetSeconds * 1000).toInt(),
      );

      cubit.updatePlaybackStatus(true);
      _updateVehicleIcon();

      // Cinematic drone glide zoom & tilt onto the vehicle
      if (cubit.state.currentVehiclePosition != null) {
        final double offsetDist = 0.00015;
        final LatLng targetCoords;
        final double targetBearingVal;
        if (_isDirectionMode) {
          targetBearingVal = cubit.state.currentHeading;
          final double bearingRad = targetBearingVal * math.pi / 180.0;
          targetCoords = LatLng(
            cubit.state.currentVehiclePosition!.latitude +
                offsetDist * math.cos(bearingRad),
            cubit.state.currentVehiclePosition!.longitude +
                offsetDist * math.sin(bearingRad),
          );
        } else {
          targetBearingVal = 0.0;
          targetCoords = LatLng(
            cubit.state.currentVehiclePosition!.latitude + offsetDist,
            cubit.state.currentVehiclePosition!.longitude,
          );
        }
        await _runCinematicGlide(
          targetLatLng: targetCoords,
          targetZoom: 17.5,
          targetTilt: 45.0,
          targetBearing: targetBearingVal,
          duration: const Duration(milliseconds: 1800),
        );
      }

      // Add a tiny delay for a premium settling feel before starting the playback
      await Future.delayed(const Duration(milliseconds: 300));

      if (mounted && cubit.state.isPlaying) {
        _playController.forward();
      }
    }
  }

  void _stopPlayback() {
    final cubit = context.read<RideHistoryDetailsCubit>();
    _playController.stop();
    _playController.value = 0.0;
    _stopOrbitAnimation();
    _updateVehicleIcon();
    cubit.resetPlayback();
    _fitMapToBounds();
  }

  void _onSliderChanged(double value) {
    _playController.value = value;
    context.read<RideHistoryDetailsCubit>().updateProgress(value);
  }

  void _onSliderChangeStart(double value) {
    final cubit = context.read<RideHistoryDetailsCubit>();
    _wasPlayingBeforeDrag = cubit.state.isPlaying;
    _isDraggingSlider = true;
    if (_wasPlayingBeforeDrag) {
      _playController.stop();
      cubit.updatePlaybackStatus(false);
    }
  }

  void _onSliderChangeEnd(double value) {
    _isDraggingSlider = false;
    final cubit = context.read<RideHistoryDetailsCubit>();
    if (_wasPlayingBeforeDrag) {
      if (value >= 1.0) {
        _playController.value = 1.0;
        cubit.updatePlaybackStatus(false);
        _updateVehicleIcon();
      } else {
        final double baseSeconds = math.max(5.0, cubit.state.totalWeight);
        final targetSeconds =
            baseSeconds / _getSpeedMultiplier(cubit.state.playbackSpeed);
        _playController.duration = Duration(
          milliseconds: (targetSeconds * 1000).toInt(),
        );
        cubit.updatePlaybackStatus(true);
        _playController.forward(from: value);
      }
    } else {
      cubit.updateProgress(value);
      _animateCameraToVehicle(cubit.state, force: true);
    }
  }

  void _updatePlaybackSpeed(int speed) {
    final cubit = context.read<RideHistoryDetailsCubit>();
    cubit.updatePlaybackSpeed(speed);

    if (cubit.state.isPlaying) {
      final currentProgress = _playController.value;
      final double baseSeconds = math.max(5.0, cubit.state.totalWeight);
      final targetSeconds = baseSeconds / _getSpeedMultiplier(speed);
      _playController.duration = Duration(
        milliseconds: (targetSeconds * 1000).toInt(),
      );
      _playController.forward(from: currentProgress);
    }
  }

  @override
  void dispose() {
    _playController.dispose();
    _orbitController.dispose();
    super.dispose();
  }

  void _stopOrbitAnimation() {
    if (!_isOrbiting) return;
    _orbitController.stop();
    setState(() {
      _isOrbiting = false;
    });
  }

  void _checkAndFitMapBounds() {
    if (_hasZoomedToRoute) return;
    final cubit = context.read<RideHistoryDetailsCubit>();
    if (!cubit.state.isDataProcessing &&
        cubit.state.validRidePoints.isNotEmpty &&
        _controller.isCompleted) {
      _hasZoomedToRoute = true;
      _fitMapToBounds();
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    if (!_controller.isCompleted) {
      _controller.complete(controller);
    }
    _checkAndFitMapBounds();
  }

  Future<BitmapDescriptor> _createStartMarker() async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = const Color(0xFF4CAF50);
    final Paint borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0;
    canvas.drawCircle(const Offset(22.5, 22.5), 15, paint);
    canvas.drawCircle(const Offset(22.5, 22.5), 15, borderPaint);
    final img = await pictureRecorder.endRecording().toImage(45, 45);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  Future<BitmapDescriptor> _createEndMarker() async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint redPaint = Paint()..color = Colors.red;
    final Paint whitePaint = Paint()..color = Colors.white;
    final Path path = Path();
    path.moveTo(26, 52);
    path.lineTo(11, 22);
    path.arcToPoint(const Offset(41, 22), radius: const Radius.circular(15));
    path.close();
    canvas.drawPath(path, redPaint);
    canvas.drawCircle(const Offset(26, 18), 9, whitePaint);
    canvas.drawCircle(const Offset(26, 18), 4, redPaint);
    final img = await pictureRecorder.endRecording().toImage(52, 52);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  Future<BitmapDescriptor> _createVehicleMarker(BuildContext context) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    const double size = 50.0; // Reduced size for a smaller marker
    final Paint arrowPaint = Paint()
      ..color = Theme.of(context)
          .colorScheme
          .primary // Use theme's primary color
      ..style = PaintingStyle.fill;
    final Paint borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth =
          2.0 // Reduced border width
      ..strokeJoin = StrokeJoin.round;

    final Path path = Path();
    // Start at top tip
    path.moveTo(size / 2, 4);
    // Draw to right wing tip
    path.lineTo(size - 9, size - 11);
    // Draw to bottom center indentation
    path.lineTo(size / 2, size - 20);
    // Draw to left wing tip
    path.lineTo(9, size - 11);
    path.close();

    // Add a slightly larger, softer drop shadow
    canvas.drawShadow(path, Colors.black, 4.0, false);
    canvas.drawPath(path, arrowPaint);
    canvas.drawPath(path, borderPaint);

    final img = await pictureRecorder.endRecording().toImage(
      size.toInt(),
      size.toInt(),
    );
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  void _fitMapToBounds() async {
    final cubit = context.read<RideHistoryDetailsCubit>();
    final validPoints = cubit.state.validRidePoints;
    if (validPoints.isEmpty) return;
    final size = MediaQuery.sizeOf(
      context,
    ); // Get size synchronously BEFORE async gap!

    double minLat = validPoints[0].location.latitude,
        maxLat = validPoints[0].location.latitude;
    double minLng = validPoints[0].location.longitude,
        maxLng = validPoints[0].location.longitude;

    for (var point in validPoints) {
      if (point.location.latitude < minLat) minLat = point.location.latitude;
      if (point.location.latitude > maxLat) maxLat = point.location.latitude;
      if (point.location.longitude < minLng) minLng = point.location.longitude;
      if (point.location.longitude > maxLng) maxLng = point.location.longitude;
    }

    final center = LatLng((minLat + maxLat) / 2, (minLng + maxLng) / 2);
    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    final double targetZoom = _getBoundsZoomLevel(
      bounds,
      size.width,
      size.height,
    );

    await _runCinematicGlide(
      targetLatLng: center,
      targetZoom: targetZoom,
      targetTilt: 0.0,
      targetBearing: 0.0,
      duration: const Duration(
        milliseconds: 2200,
      ), // Highly elegant 2.2s drone flight on load
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final double fuelRate = widget.ride.avgSpeed > 0
        ? (2.1 * (1.0 + 0.005 * (widget.ride.avgSpeed - 35.0).abs())).clamp(
            1.5,
            3.5,
          )
        : 2.1;
    return BlocListener<RideHistoryDetailsCubit, RideHistoryDetailsState>(
      listenWhen: (previous, current) {
        return previous.isDataProcessing != current.isDataProcessing ||
            previous.isPlaying != current.isPlaying ||
            previous.currentVehiclePosition != current.currentVehiclePosition ||
            previous.validRidePoints.length != current.validRidePoints.length;
      },
      listener: (context, state) {
        _checkAndFitMapBounds();
        _animateCameraToVehicle(state);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Stack(
          children: [
            // High-performance isolated Google Map view using RepaintBoundary and builder filtering
            BlocBuilder<RideHistoryDetailsCubit, RideHistoryDetailsState>(
              buildWhen: (previous, current) {
                return previous.currentVehiclePosition !=
                        current.currentVehiclePosition ||
                    previous.currentHeading != current.currentHeading ||
                    previous.isPlaybackStarted != current.isPlaybackStarted ||
                    previous.darkMapStyle != current.darkMapStyle ||
                    previous.startIcon != current.startIcon ||
                    previous.endIcon != current.endIcon ||
                    previous.vehicleIcon != current.vehicleIcon ||
                    previous.validRidePoints.length !=
                        current.validRidePoints.length;
              },
              builder: (context, mapState) {
                return BlocBuilder<AppCubit, AppState>(
                  builder: (context, appState) {
                    return GoogleMap(
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(20.5937, 78.9629), // Start at India
                        zoom: 4.2,
                      ),
                      mapType: appState.mapType == 'satellite'
                          ? MapType.satellite
                          : MapType.normal,
                      trafficEnabled: appState.isTrafficEnabled,
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                      compassEnabled: false,
                      mapToolbarEnabled: false,
                      padding: const EdgeInsets.only(bottom: 220),
                      polylines: {
                        if (mapState.validRidePoints.isNotEmpty)
                          Polyline(
                            polylineId: const PolylineId('route'),
                            points: mapState.validRidePoints
                                .map((p) => p.location)
                                .toList(),
                            color: widget.ride.distance < 0.1 ? Colors.grey : Colors.yellow,
                            width: widget.ride.distance < 0.1 ? 8 : 5,
                            startCap: Cap.roundCap,
                            endCap: Cap.roundCap,
                            jointType: JointType.round,
                            patterns: widget.ride.distance < 0.1 ? [PatternItem.dot, PatternItem.gap(16.0)] : const <PatternItem>[],
                          ),
                      },
                      markers: {
                        if (mapState.startIcon != null &&
                            mapState.validRidePoints.isNotEmpty)
                          Marker(
                            markerId: const MarkerId('start'),
                            position: mapState.validRidePoints.first.location,
                            icon: mapState.startIcon!,
                            anchor: const Offset(0.5, 0.5),
                          ),
                        if (mapState.endIcon != null &&
                            mapState.validRidePoints.isNotEmpty)
                          Marker(
                            markerId: const MarkerId('end'),
                            position: mapState.validRidePoints.last.location,
                            icon: mapState.endIcon!,
                            anchor: const Offset(0.5, 1.0),
                          ),
                        if (mapState.vehicleIcon != null &&
                            mapState.currentVehiclePosition != null &&
                            mapState.isPlaybackStarted)
                          Marker(
                            markerId: const MarkerId('vehicle'),
                            position: mapState.currentVehiclePosition!,
                            icon: mapState.vehicleIcon!,
                            anchor: const Offset(0.5, 0.5),
                            rotation: mapState.currentHeading,
                            flat: true,
                            zIndex: 2.0,
                          ),
                      },
                      onMapCreated: _onMapCreated,
                      onCameraMove: (position) {
                        if (_isGliding ||
                            (mounted &&
                                context
                                    .read<RideHistoryDetailsCubit>()
                                    .state
                                    .isPlaying)) {
                          return; // Ignore laggy async native updates during active programmatic tracking/glides
                        }
                        _lastCameraPosition = position;
                      },
                    );
                  },
                );
              },
            ),

            // Custom AppBar (Static back button layer)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                  left: 8.0,
                  right: 8.0,
                  bottom: 8.0,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withValues(alpha: 0.8),
                  border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5), width: 0.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Builder(
                      builder: (context) {
                        String displayDate = widget.ride.date;
                        try {
                          DateTime? parsedDate;
                          if (widget.ride.rawStartTime.isNotEmpty) {
                            parsedDate = DateTime.parse(
                              widget.ride.rawStartTime,
                            ).toLocal();
                          } else {
                            try {
                              parsedDate = DateFormat(
                                'dd/MM/yyyy',
                              ).parse(widget.ride.date);
                            } catch (_) {
                              try {
                                parsedDate = DateTime.parse(widget.ride.date);
                              } catch (_) {}
                            }
                          }
                          if (parsedDate != null) {
                            final now = DateTime.now();
                            if (parsedDate.year == now.year &&
                                parsedDate.month == now.month &&
                                parsedDate.day == now.day) {
                              displayDate = AppLocalizations.of(context)!.today;
                            } else {
                              displayDate = DateFormat(
                                'dd/MM/yyyy',
                              ).format(parsedDate);
                            }
                          } else {
                            final now = DateTime.now();
                            final format1 =
                                "${now.day}/${now.month}/${now.year}";
                            final format2 = DateFormat(
                              'dd/MM/yyyy',
                            ).format(now);
                            if (widget.ride.date == format1 ||
                                widget.ride.date == format2) {
                              displayDate = AppLocalizations.of(context)!.today;
                            }
                          }
                        } catch (_) {}
                        return Text(
                          displayDate,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Top Floating Live Stats Card (Granular BlocBuilder to isolate text updates)
            BlocBuilder<RideHistoryDetailsCubit, RideHistoryDetailsState>(
              buildWhen: (previous, current) {
                return previous.currentSpeedDisplay !=
                        current.currentSpeedDisplay ||
                    previous.currentTimeDisplay != current.currentTimeDisplay ||
                    previous.currentDistanceDisplay !=
                        current.currentDistanceDisplay ||
                    previous.currentAvgSpeedDisplay !=
                        current.currentAvgSpeedDisplay ||
                    previous.isPlaying != current.isPlaying ||
                    previous.playProgress != current.playProgress;
              },
              builder: (context, statsState) {
                if (!statsState.isPlaying && statsState.playProgress == 0.0) {
                  return Positioned(
                    top: MediaQuery.of(context).padding.top + 60,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).cardColor.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.two_wheeler,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    size: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Trackify",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                l10n.speed,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              ),
                              Text(
                                context.displayKmh,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontSize: 7,
                                ),
                              ),
                              Text(
                                statsState.currentSpeedDisplay.toStringAsFixed(
                                  1,
                                ),
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 1,
                            height: 30,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.2),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                l10n.timeLabel,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              ),
                              Text(
                                l10n.hrMin,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontSize: 7,
                                ),
                              ),
                              Text(
                                statsState.currentTimeDisplay ??
                                    widget.ride.startTime,
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Positioned(
                    top: MediaQuery.of(context).padding.top + 80,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).cardColor.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildLiveStatColumn(
                              l10n.speed,
                              "${statsState.currentSpeedDisplay.toStringAsFixed(1)} ${context.displayKmh}",
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 30,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.2),
                          ),
                          Expanded(
                            child: _buildLiveStatColumn(
                              l10n.timeLabel,
                              statsState.currentTimeDisplay ??
                                  widget.ride.startTime,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 30,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.2),
                          ),
                          Expanded(
                            child: _buildLiveStatColumn(
                              l10n.distanceLabel,
                              "${statsState.currentDistanceDisplay.toStringAsFixed(2)} ${context.displayKm}",
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 30,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.2),
                          ),
                          Expanded(
                            child: _buildLiveStatColumn(
                              l10n.averageSpeed,
                              "${statsState.currentAvgSpeedDisplay.toStringAsFixed(1)} ${context.displayKmh}",
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),

            // Map Control Buttons (Static layers)
            Positioned(
              right: 16,
              bottom: 240,
              child: Column(
                children: [
                  _buildMapFloatingBtn(
                    Icons.layers_outlined,
                    onTap: () {
                      _showMapStyleBottomSheet();
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildMapFloatingBtn(
                    _isDirectionMode ? Icons.navigation : Icons.my_location,
                    isActive: _isDirectionMode,
                    onTap: () {
                      setState(() {
                        _isDirectionMode = !_isDirectionMode;
                      });
                      final cubit = context.read<RideHistoryDetailsCubit>();
                      if (cubit.state.currentVehiclePosition != null) {
                        _animateCameraToVehicle(cubit.state);
                      }
                    },
                  ),
                ],
              ),
            ),

            // Bottom Panel Container sheet
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5), width: 0.5),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Isolated Bottom Controls (Play/Pause, Speed controls)
                      BlocBuilder<
                        RideHistoryDetailsCubit,
                        RideHistoryDetailsState
                      >(
                        buildWhen: (previous, current) {
                          return previous.isPlaying != current.isPlaying ||
                              previous.isPlaybackStarted !=
                                  current.isPlaybackStarted ||
                              previous.playbackSpeed != current.playbackSpeed;
                        },
                        builder: (context, controlState) {
                          return Transform.translate(
                            offset: const Offset(0, -24),
                            child: Container(
                              height: 60,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Row(
                                children: [
                                  const Expanded(child: SizedBox()),
                                  // Play Button strictly in the center
                                  GestureDetector(
                                    onTap: _togglePlayback,
                                    child: Container(
                                      width: 56,
                                      height: 56,
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.4,
                                            ),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        controlState.isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                    ),
                                  ),

                                  // Right-side controls (Close & Playback Speed selectors)
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerRight,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (controlState
                                                .isPlaybackStarted) ...[
                                              GestureDetector(
                                                onTap: _stopPlayback,
                                                child: Container(
                                                  width: 38,
                                                  height: 38,
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .cardColor
                                                        .withValues(alpha: 0.9),
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
                                                      width: 0.5,
                                                    ),
                                                  ),
                                                  child: Icon(
                                                    Icons.close,
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.onSurface,
                                                    size: 18,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                            ],
                                            Container(
                                              padding: const EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .cardColor
                                                    .withValues(alpha: 0.95),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
                                                  width: 0.5,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [1, 2, 3, 4].map((
                                                  speed,
                                                ) {
                                                  final isSelected =
                                                      controlState
                                                          .playbackSpeed ==
                                                      speed;
                                                  return GestureDetector(
                                                    onTap: () =>
                                                        _updatePlaybackSpeed(
                                                          speed,
                                                        ),
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 4,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: isSelected
                                                            ? Theme.of(context)
                                                                  .colorScheme
                                                                  .primary
                                                            : Colors
                                                                  .transparent,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              16,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        "${speed}x",
                                                        style: TextStyle(
                                                          color: isSelected
                                                              ? Colors.white
                                                              : Theme.of(
                                                                      context,
                                                                    )
                                                                    .colorScheme
                                                                    .onSurface,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      Transform.translate(
                        offset: const Offset(0, -16),
                        child: Text(
                          "${l10n.rideDuration}: ${widget.ride.duration}",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildPanelStat(
                                    Icons.route_rounded,
                                    "${widget.ride.distance.toStringAsFixed(1)} ${context.displayKm}",
                                    l10n.distanceLabel,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildPanelStat(
                                    Icons.timer_rounded,
                                    widget.ride.duration,
                                    l10n.durationLabel,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildPanelStat(
                                    Icons.currency_rupee_rounded,
                                    "${l10n.currencySymbol}${(widget.ride.distance * fuelRate).toStringAsFixed(0)}",
                                    "Fuel Cost",
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildPanelStat(
                                    Icons.speed_rounded,
                                    "${widget.ride.avgSpeed.toStringAsFixed(1)} ${context.displayKmh}",
                                    l10n.averageSpeed,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildPanelStat(
                                    Icons.bolt_rounded,
                                    "${widget.ride.topSpeed.toStringAsFixed(1)} ${context.displayKmh}",
                                    l10n.topSpeed,
                                    isHighlight: true,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildPanelStat(
                                    Icons.local_gas_station_rounded,
                                    "${l10n.currencySymbol}${fuelRate.toStringAsFixed(1)}/${context.displayKm}",
                                    "Cost / ${context.displayKm}",
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Isolated Bottom Slider driven locally by AnimatedBuilder (Buttery 60 FPS slider movement)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Text(
                              widget.ride.startTime,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: SliderTheme(
                                data: SliderThemeData(
                                  activeTrackColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  inactiveTrackColor: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.2),
                                  thumbColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  trackHeight: 4.0,
                                  thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 6.0,
                                  ),
                                ),
                                child: AnimatedBuilder(
                                  animation: _playController,
                                  builder: (context, child) {
                                    return Slider(
                                      value: _playController.value,
                                      onChanged: _onSliderChanged,
                                      onChangeStart: _onSliderChangeStart,
                                      onChangeEnd: _onSliderChangeEnd,
                                    );
                                  },
                                ),
                              ),
                            ),
                            Text(
                              widget.ride.endTime,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
            BlocBuilder<RideHistoryDetailsCubit, RideHistoryDetailsState>(
              buildWhen: (previous, current) =>
                  previous.isDataProcessing != current.isDataProcessing,
              builder: (context, state) {
                if (state.isDataProcessing) {
                  return Container(
                    color: Theme.of(
                      context,
                    ).colorScheme.surface.withValues(alpha: 0.7),
                    child: const Center(child: TrackifyLoader()),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveStatColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 10),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMapFloatingBtn(
    IconData icon, {
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          border: Border.all(
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
            width: isActive ? 2 : 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            icon,
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface,
            size: 22,
          ),
        ),
      ),
    );
  }

  Widget _buildPanelStat(
    IconData icon,
    String value,
    String label, {
    bool isHighlight = false,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.onSurface.withOpacity(0.05)
            : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlight
              ? const Color(0xFF0284C7).withOpacity(0.4)
              : (isDark
                  ? theme.colorScheme.outline.withOpacity(0.15)
                  : const Color(0xFFE2E8F0)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isHighlight
                      ? const Color(0xFF0284C7).withOpacity(0.15)
                      : const Color(0xFFE0F2FE),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF0284C7),
                  size: 13,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    color: isHighlight
                        ? const Color(0xFF0284C7)
                        : theme.colorScheme.onSurface,
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.55),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showMapStyleBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      barrierColor: Colors.black45,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
      ),
      builder: (context) {
        return BlocBuilder<AppCubit, AppState>(
          builder: (context, state) {
            final l10n = AppLocalizations.of(context)!;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
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

        if (mounted) {
          final controller = await _controller.future;
          _updateMapStyle(controller);
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
                    ).colorScheme.primary.withValues(alpha: 0.2),
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
                      color: Colors.black.withValues(alpha: 0.05),
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

  Future<void> _updateMapStyle(GoogleMapController controller) async {
    final appConfig = context.read<AppCubit>().state;
    final l10n = AppLocalizations.of(context);

    if (appConfig.mapType == 'satellite' ||
        appConfig.mapStyle == 'Satellite' ||
        appConfig.mapStyle == l10n?.satelliteStyle) {
      await MapUtils.setStyle(controller, null);
      return;
    }

    String? style;
    if (appConfig.mapStyle == 'Dark' || appConfig.mapStyle == l10n?.darkStyle) {
      style = _darkMapStyle;
    } else if (appConfig.mapStyle == 'Light' ||
        appConfig.mapStyle == l10n?.lightStyle) {
      style = _lightMapStyle;
    } else if (appConfig.mapStyle == 'Simple' ||
        appConfig.mapStyle == l10n?.simpleStyle) {
      style = _lightMapStyle;
    } else {
      final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
      style = isDarkTheme ? _darkMapStyle : _lightMapStyle;
    }

    await MapUtils.setStyle(controller, style);
  }
}
