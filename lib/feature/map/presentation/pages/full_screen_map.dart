import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
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

class FullScreenMap extends StatefulWidget {
  final Vehicles? selectedVehicle;
  const FullScreenMap({super.key, this.selectedVehicle});

  @override
  State<FullScreenMap> createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap>
    with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  String? _lightMapStyle;
  String? _darkMapStyle;
  bool _showSharedWithMe = false;
  BitmapDescriptor? _customMarker;
  BitmapDescriptor? _currentLocationMarker;

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
  double _animStartZoom = 13.0;
  double _animEndZoom = 15.0;
  double _animStartTilt = 0.0;
  double _animEndTilt = 0.0;
  double _animStartBearing = 0.0;
  double _animEndBearing = 0.0;

  bool _isInitialFocusDone = false;
  bool _isAutoFollowing = true;
  bool _showCurrentLocation =
      false; // Default OFF — turns off when leaving screen

  @override
  void initState() {
    super.initState();
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
      }
    });
  }

  @override
  void dispose() {
    _cameraAnimationController?.dispose();
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
      setState(() {
        _customMarker = BitmapDescriptor.fromBytes(markerIcon);
      });
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
      setState(() {
        _currentLocationMarker = BitmapDescriptor.fromBytes(
          byteData.buffer.asUint8List(),
        );
      });
    }
  }

  LatLng? _getBestPosition() {
    final appState = context.read<AppCubit>().state;
    final currentPos = appState.currentLocation;
    LatLng? bestPos = appState.livePosition;

    if (bestPos == null &&
        widget.selectedVehicle?.currentLocation != null &&
        widget.selectedVehicle!.currentLocation!.lat != null &&
        widget.selectedVehicle!.currentLocation!.lng != null) {
      bestPos = LatLng(
        widget.selectedVehicle!.currentLocation!.lat!,
        widget.selectedVehicle!.currentLocation!.lng!,
      );
    }

    if (bestPos == null && currentPos != null) {
      bestPos = LatLng(currentPos.latitude, currentPos.longitude);
    }
    return bestPos;
  }

  void _triggerInitialFocusAnimation() {
    LatLng? target = _getBestPosition();
    if (target == null) return;

    final appState = context.read<AppCubit>().state;

    // Glide smoothly focusing on the vehicle (drone camera zoom & rotate effect)
    // 600ms delay ensures native layout/tiles/styles are ready before animation starts
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      _animateCameraTo(
        target: target,
        zoom: 15.0,
        tilt: 0.0,
        bearing: appState.liveBearing,
        duration: const Duration(milliseconds: 4000), // slow cinematic glide
        curve: Curves.easeInOutCubic,
      );
      setState(() {
        _isInitialFocusDone = true;
      });
    });
  }

  void _recenterCamera() {
    setState(() {
      _isAutoFollowing = true;
    });
    _applyCameraForCurrentMode();
  }

  /// Builds the markers set — called from build so it always reads latest _showCurrentLocation.
  Set<Marker> _buildMarkers(
    LatLng vehiclePos,
    dynamic currentPos,
    double bearing,
  ) {
    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('vehicle_marker'),
        position: vehiclePos,
        icon: _customMarker ?? BitmapDescriptor.defaultMarker,
        anchor: const Offset(0.5, 0.5),
        rotation: bearing,
      ),
    };

    if (_showCurrentLocation && currentPos != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(currentPos.latitude, currentPos.longitude),
          icon:
              _currentLocationMarker ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          anchor: const Offset(0.5, 0.5),
          infoWindow: const InfoWindow(title: 'Your location'),
        ),
      );
    }

    return markers;
  }

  /// Applies the correct camera position based on _showCurrentLocation mode.
  void _applyCameraForCurrentMode() {
    final appState = context.read<AppCubit>().state;
    final vehiclePos = _getBestPosition();
    if (vehiclePos == null) return;

    if (_showCurrentLocation && appState.currentLocation != null) {
      final phonePos = LatLng(
        appState.currentLocation!.latitude,
        appState.currentLocation!.longitude,
      );
      _fitBothMarkersOnMap(vehiclePos, phonePos, appState.liveBearing);
    } else {
      _animateCameraTo(
        target: vehiclePos,
        zoom: 15.0,
        tilt: 0.0,
        bearing: appState.liveBearing,
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

    String? style;
    if (appConfig.mapStyle == 'Dark') {
      style = _darkMapStyle;
    } else if (appConfig.mapStyle == 'Light') {
      style = _lightMapStyle;
    } else if (appConfig.mapStyle == 'Simple') {
      style = await MapUtils.loadStyle('assets/map_styles/light_map.json');
    }

    await MapUtils.setStyle(controller, style);
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
      listenWhen: (previous, current) =>
          previous.livePosition != current.livePosition ||
          previous.liveBearing != current.liveBearing,
      listener: (context, state) {
        if (_isAutoFollowing &&
            state.livePosition != null &&
            _mapController != null) {
          if (_isInitialFocusDone) {
            if (_showCurrentLocation && state.currentLocation != null) {
              // Both markers mode: fit vehicle + phone location
              final phonePos = LatLng(
                state.currentLocation!.latitude,
                state.currentLocation!.longitude,
              );
              _fitBothMarkersOnMap(
                state.livePosition!,
                phonePos,
                state.liveBearing,
              );
            } else {
              // Vehicle only mode: focus on vehicle with rotation
              _animateCameraTo(
                target: state.livePosition!,
                zoom: 15.0,
                tilt: 0.0,
                bearing: state.liveBearing,
                duration: const Duration(milliseconds: 1500),
                curve: Curves.easeOutCubic,
              );
            }
          }
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            _buildMap(),
            _buildTopActions(),
            _buildLeftSideActions(),
            _buildRightSideActions(),
            _buildDraggableBottomCard(),
          ],
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
            widget.selectedVehicle?.currentLocation != null &&
            widget.selectedVehicle!.currentLocation!.lat != null &&
            widget.selectedVehicle!.currentLocation!.lng != null) {
          bestPos = LatLng(
            widget.selectedVehicle!.currentLocation!.lat!,
            widget.selectedVehicle!.currentLocation!.lng!,
          );
        }

        // Final fallback to phone location
        bestPos ??= LatLng(currentPos.latitude, currentPos.longitude);

        // Start with a 120-degree rotation offset for a cinematic entrance
        double startBearing = _normalizeBearing(appState.liveBearing - 120.0);

        return GoogleMap(
          key: ValueKey(widget.selectedVehicle?.id),
          initialCameraPosition: CameraPosition(
            target: bestPos,
            zoom: 13,
            bearing: startBearing,
          ),
          myLocationEnabled: false,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          mapToolbarEnabled: false,
          mapType: appState.mapType == 'satellite'
              ? MapType.satellite
              : MapType.normal,
          trafficEnabled: appState.isTrafficEnabled,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height * 0.16,
          ),
          onCameraMove: (position) {
            if (_cameraAnimationController == null ||
                !_cameraAnimationController!.isAnimating) {
              _cameraTarget = position.target;
              _cameraZoom = position.zoom;
              _cameraTilt = position.tilt;
              _cameraBearing = position.bearing;
            }
          },
          onCameraMoveStarted: () {
            if (_cameraAnimationController == null ||
                !_cameraAnimationController!.isAnimating) {
              setState(() {
                _isAutoFollowing = false;
              });
            }
          },
          markers: _buildMarkers(bestPos, currentPos, appState.liveBearing),
          onMapCreated: (controller) async {
            _mapController = controller;

            if (_darkMapStyle == null || _lightMapStyle == null) {
              await _loadMapStyles();
            }
            _updateMapStyle(controller);

            // Initialize camera state fields
            _cameraTarget = bestPos;
            _cameraZoom = 13.0;
            _cameraTilt = 0.0;
            _cameraBearing = startBearing;

            WidgetsBinding.instance.addPostFrameCallback((_) {
              _triggerInitialFocusAnimation();
            });
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildRoundButton(
                Icons.more_vert,
                onTap: () =>
                    setState(() => _showSharedWithMe = !_showSharedWithMe),
              ),
              if (_showSharedWithMe)
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
                  child: Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Theme.of(context).dividerColor),
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
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeftSideActions() {
    return Positioned(
      left: 16,
      bottom: 240, // Same level as right side actions
      child: Column(
        children: [
          _buildMapActionButton(
            Icons.share_outlined,
            onTap: () {
              final appState = context.read<AppCubit>().state;
              LatLng? pos = appState.livePosition;
              if (pos == null &&
                  widget.selectedVehicle?.currentLocation != null &&
                  widget.selectedVehicle!.currentLocation!.lat != null &&
                  widget.selectedVehicle!.currentLocation!.lng != null) {
                pos = LatLng(
                  widget.selectedVehicle!.currentLocation!.lat!,
                  widget.selectedVehicle!.currentLocation!.lng!,
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
                    content: Text('Vehicle location link copied to clipboard!'),
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
                    widget.selectedVehicle?.currentLocation != null &&
                    widget.selectedVehicle!.currentLocation!.lat != null &&
                    widget.selectedVehicle!.currentLocation!.lng != null) {
                  pos = LatLng(
                    widget.selectedVehicle!.currentLocation!.lat!,
                    widget.selectedVehicle!.currentLocation!.lng!,
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
                  widget.selectedVehicle?.vehicleMaker,
                  widget.selectedVehicle?.vehicleNumber,
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
                  await launchUrl(webUri, mode: LaunchMode.externalApplication);
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
  }

  Widget _buildRightSideActions() {
    return Positioned(
      right: 16,
      bottom: 240, // Adjusted to be above the bottom sheet
      child: Column(
        children: [
          _buildMapActionButton(Icons.motorcycle, hasNotification: true),
          _buildMapActionButton(Icons.map_outlined, onTap: _showMapStyleSheet),
          _buildMapActionButton(
            Icons.person_pin_circle_outlined,
            onTap: () {
              setState(() {
                _showCurrentLocation = !_showCurrentLocation;
                _isAutoFollowing = true;
              });
              _applyCameraForCurrentMode();
            },
            isActiveColor: _showCurrentLocation,
          ),
          _buildMapActionButton(
            Icons.my_location,
            onTap: _recenterCamera,
            isActiveColor: _isAutoFollowing,
          ),
          _buildMapActionButton(Icons.fullscreen),
        ],
      ),
    );
  }

  Widget _buildMapActionButton(
    IconData icon, {
    bool hasNotification = false,
    VoidCallback? onTap,
    bool isActiveColor = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Stack(
        children: [
          _buildRoundButton(icon, onTap: onTap, isActiveColor: isActiveColor),
          if (hasNotification)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).cardColor,
                    width: 2,
                  ),
                ),
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
    return DraggableScrollableSheet(
      initialChildSize:
          0.14, // Increased slightly to accommodate the new layout
      minChildSize: 0.14,
      maxChildSize: 0.40,
      snap: true,
      snapSizes: const [0.20, 0.40],
      builder: (context, scrollController) {
        return Container(
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
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildVehicleHeader(),
                      // Removed separate _buildStatusRow as it's now integrated in header

                      // Mid-Stop content
                      const SizedBox(height: 30),
                      _buildStatsGrid(),

                      // Fully-Expanded content
                      const SizedBox(height: 24),
                      _buildBottomInfoCards(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVehicleHeader() {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final liveDevice = state.devices.firstWhere(
          (d) =>
              d['imei']?.toString() == widget.selectedVehicle?.id,
          orElse: () => {},
        );

        final liveSpeed =
            liveDevice['sp']?.toString() ??
            widget.selectedVehicle?.currentLocation?.speed?.toString() ??
            "0";

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
                        widget.selectedVehicle?.vehicleMaker ??
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
                        widget.selectedVehicle?.vehicleNumber ??
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
                // Speed Info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          liveSpeed,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          AppLocalizations.of(context)!.kmh,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      AppLocalizations.of(
                        context,
                      )!.speedLabel, // Using "Speed" label
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
                const SizedBox(width: 12),
                // Up/Down Arrows
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildSmallArrowButton(Icons.keyboard_arrow_up),
                    const SizedBox(height: 6),
                    _buildSmallArrowButton(Icons.keyboard_arrow_down),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Parked Since Status
            Text(
              AppLocalizations.of(context)!.parkedSinceTime("11:17 AM, Today"),
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSmallArrowButton(IconData icon) {
    return Container(
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
    );
  }

  Widget _buildStatsGrid() {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        // Find current device in the live devices list to get live speed/odometer
        final liveDevice = state.devices.firstWhere(
          (d) =>
              d['imei']?.toString() == widget.selectedVehicle?.id,
          orElse: () => {},
        );

        final liveSpeed =
            liveDevice['sp']?.toString() ??
            widget.selectedVehicle?.currentLocation?.speed?.toString() ??
            "0";

        final odometer = liveDevice['odometer']?.toString() ?? "0";

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
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildGridItem(
                  "$odometer ${AppLocalizations.of(context)!.km}",
                  AppLocalizations.of(context)!.distanceLabel,
                ),
                _buildGridItem(
                  "0${AppLocalizations.of(context)!.minutesShort} 0${AppLocalizations.of(context)!.secondsShort}",
                  AppLocalizations.of(context)!.durationLabel,
                ),
                _buildGridItem(
                  "$liveSpeed ${AppLocalizations.of(context)!.kmh}",
                  AppLocalizations.of(context)!.averageSpeed,
                ),
                _buildGridItem(
                  AppLocalizations.of(context)!.plusLabel,
                  AppLocalizations.of(context)!.topSpeed,
                  isPlus: true,
                ),
              ],
            ),
          ],
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
              d['imei']?.toString() == widget.selectedVehicle?.id ||
              d['imei']?.toString() == widget.selectedVehicle?.imei?.toString(),
          orElse: () => {},
        );

        // Parse range/distance remaining
        final rangeValue = liveDevice['range'] ??
            liveDevice['kms_left'] ??
            liveDevice['fuel_range'] ??
            liveDevice['distance_remaining'] ??
            liveDevice['remaining_distance'];

        final String rangeText = rangeValue != null
            ? "$rangeValue kms more to go"
            : "-- kms more to go";

        // Parse fuel percentage for bars
        final fuelVal = liveDevice['fuel'] ??
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
        final batteryVal = liveDevice['battery'] ??
            liveDevice['batteryLevel'] ??
            liveDevice['battery_level'] ??
            liveDevice['bat'];

        final voltageVal = liveDevice['voltage'] ??
            liveDevice['volts'] ??
            liveDevice['battery_voltage'] ??
            liveDevice['v_bat'] ??
            liveDevice['power'];

        String batteryText = "--";
        Color batteryColor = Colors.green;
        IconData batteryIcon = Icons.battery_charging_full;

        if (batteryVal != null || voltageVal != null) {
          if (voltageVal != null) {
            final voltDouble = double.tryParse(voltageVal.toString().replaceAll(RegExp(r'[^0-9.]'), ''));
            if (voltDouble != null) {
              final String status = voltDouble < 11.5 ? "Low" : "Normal";
              batteryText = "$status (${voltDouble.toStringAsFixed(1)}V)";
              batteryColor = voltDouble < 11.5 ? Colors.red : Colors.green;
              batteryIcon = voltDouble < 11.5 ? Icons.battery_alert : Icons.battery_charging_full;
            } else {
              batteryText = "Normal (${voltageVal.toString()})";
            }
          } else if (batteryVal != null) {
            final batDouble = double.tryParse(batteryVal.toString().replaceAll(RegExp(r'[^0-9.]'), ''));
            if (batDouble != null) {
              final String status = batDouble < 20 ? "Low" : "Normal";
              final displayVal = batDouble <= 1.0 ? (batDouble * 100).round() : batDouble.round();
              batteryText = "$status ($displayVal%)";
              batteryColor = displayVal < 20 ? Colors.red : Colors.green;
              batteryIcon = displayVal < 20 ? Icons.battery_alert : Icons.battery_charging_full;
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
                padding: const EdgeInsets.all(12),
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
                padding: const EdgeInsets.all(12),
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
                  children: [
                    const Text(
                      "Vehicle Battery",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
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
