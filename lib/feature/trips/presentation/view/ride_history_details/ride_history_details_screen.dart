import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:trackify/feature/trips/data/entity/ride_model.dart';
import 'package:trackify/feature/trips/presentation/cubit/ride_history_details_cubit.dart';
import 'package:trackify/feature/trips/presentation/cubit/ride_history_details_state.dart';
import 'package:trackify/l10n/app_localizations.dart';

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
  late List<LatLng> _validPoints;
  bool _isOrbiting = false;
  bool _isPlaybackActive = false;
  bool _hasZoomedToRoute = false;

  @override
  void initState() {
    super.initState();

    _validPoints = widget.ride.polylinePoints
        .where((p) => p.latitude != 0.0 || p.longitude != 0.0)
        .toList();

    _playController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );

    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    _playController.addListener(() {
      final cubit = context.read<RideHistoryDetailsCubit>();
      cubit.updateProgress(_playController.value);
      _animateCameraToVehicle(cubit.state);
    });

    _playController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        context.read<RideHistoryDetailsCubit>().updatePlaybackStatus(false);
        _isPlaybackActive = false;
        final icon = await _createVehicleMarker();
        if (mounted) {
          context.read<RideHistoryDetailsCubit>().updateVehicleIcon(icon);
        }
      }
    });

    _initializeAssets();
  }

  Future<void> _updateVehicleIcon() async {
    final icon = await _createVehicleMarker();
    if (mounted) {
      context.read<RideHistoryDetailsCubit>().updateVehicleIcon(icon);
    }
  }

  void _initializeAssets() async {
    final start = await _createStartMarker();
    final end = await _createEndMarker();
    final vehicle = await _createVehicleMarker();
    String? mapStyle;
    try {
      mapStyle = await rootBundle.loadString('assets/map_styles/dark_map.json');
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
  }

  void _animateCameraToVehicle(RideHistoryDetailsState state) async {
    if (state.currentVehiclePosition == null || !_controller.isCompleted)
      return;
    final controller = await _controller.future;

    if (state.isPlaying) {
      controller.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: state.currentVehiclePosition!,
            zoom: 20.0,
            tilt: 60.0,
            bearing: 0.0, // Fixed North-up
          ),
        ),
      );
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

      final targetSeconds = math.max(
        15,
        (cubit.state.totalWeight / 5).toDouble(),
      );
      _playController.duration = Duration(seconds: targetSeconds.toInt());

      cubit.updatePlaybackStatus(true);
      _isPlaybackActive = true;
      _updateVehicleIcon();

      if (cubit.state.currentVehiclePosition != null &&
          _controller.isCompleted) {
        final controller = await _controller.future;
        // STAGE 1: Glide & Approach
        await controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: cubit.state.currentVehiclePosition!,
              zoom: 15.0,
              tilt: 45.0,
              bearing: 0.0,
            ),
          ),
        );
        // STAGE 2: Tight Close-up Focus
        await controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: cubit.state.currentVehiclePosition!,
              zoom: 20.0,
              tilt: 60.0,
              bearing: 0.0,
            ),
          ),
        );
      }

      _playController.forward();
    }
  }

  void _stopPlayback() {
    final cubit = context.read<RideHistoryDetailsCubit>();
    _playController.stop();
    _playController.value = 0.0;
    _stopOrbitAnimation();
    _isPlaybackActive = false;
    _updateVehicleIcon();
    cubit.resetPlayback();
    _fitMapToBounds();
  }

  void _onSliderChanged(double value) {
    _playController.value = value;
    context.read<RideHistoryDetailsCubit>().updateProgress(value);
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

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        _fitMapToBounds();
      }
    });
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
    return BitmapDescriptor.bytes(data!.buffer.asUint8List());
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
    return BitmapDescriptor.bytes(data!.buffer.asUint8List());
  }

  Future<BitmapDescriptor> _createVehicleMarker() async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final double size = _isPlaybackActive ? 65.0 : 60.0;
    final Paint arrowPaint = Paint()
      ..color = Theme.of(context).colorScheme.primary
      ..style = PaintingStyle.fill;
    final Paint borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    final Path path = Path();
    path.moveTo(size / 2, 10);
    path.lineTo(size - 20, size - 10);
    path.lineTo(size / 2, size - 20);
    path.lineTo(20, size - 10);
    path.close();
    canvas.drawShadow(path, Colors.black, 4.0, false);
    canvas.drawPath(path, arrowPaint);
    canvas.drawPath(path, borderPaint);
    final img = await pictureRecorder.endRecording().toImage(
      size.toInt(),
      size.toInt(),
    );
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.bytes(data!.buffer.asUint8List());
  }

  void _fitMapToBounds() async {
    final cubit = context.read<RideHistoryDetailsCubit>();
    final validPoints = cubit.state.validRidePoints;
    if (validPoints.isEmpty) return;
    final controller = await _controller.future;

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

    // STEP 1: Fly to center at medium altitude
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: center, zoom: 8.0, tilt: 25.0),
      ),
    );

    // STEP 2: Smoothly fit bounds
    await controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 110.0));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocConsumer<RideHistoryDetailsCubit, RideHistoryDetailsState>(
      listener: (context, state) {
        if (!state.isDataProcessing &&
            state.validRidePoints.isNotEmpty &&
            !_hasZoomedToRoute) {
          _hasZoomedToRoute = true;
          _fitMapToBounds();
        }
        _animateCameraToVehicle(state);
      },
      builder: (context, state) {
        final validPoints = _validPoints;
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(20.5937, 78.9629), // Start at India
                  zoom: 4.2,
                ),
                mapType: MapType.normal,
                style: state.darkMapStyle,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
                compassEnabled: false,
                mapToolbarEnabled: false,
                padding: const EdgeInsets.only(bottom: 220),
                polylines: {
                  if (state.validRidePoints.isNotEmpty)
                    Polyline(
                      polylineId: const PolylineId('route'),
                      points: state.validRidePoints
                          .map((p) => p.location)
                          .toList(),
                      color: Theme.of(context).colorScheme.primary,
                      width: 5,
                      startCap: Cap.roundCap,
                      endCap: Cap.roundCap,
                      jointType: JointType.round,
                    ),
                },
                markers: {
                  if (state.startIcon != null &&
                      state.validRidePoints.isNotEmpty)
                    Marker(
                      markerId: const MarkerId('start'),
                      position: state.validRidePoints.first.location,
                      icon: state.startIcon!,
                      anchor: const Offset(0.5, 0.5),
                    ),
                  if (state.endIcon != null && state.validRidePoints.isNotEmpty)
                    Marker(
                      markerId: const MarkerId('end'),
                      position: state.validRidePoints.last.location,
                      icon: state.endIcon!,
                      anchor: const Offset(0.5, 1.0),
                    ),
                  if (state.vehicleIcon != null &&
                      state.currentVehiclePosition != null &&
                      state.isPlaybackStarted)
                    Marker(
                      markerId: const MarkerId('vehicle'),
                      position: state.currentVehiclePosition!,
                      icon: state.vehicleIcon!,
                      anchor: const Offset(0.5, 0.5),
                      rotation: state.currentHeading,
                      flat: true,
                      zIndex: 2,
                    ),
                },
                onMapCreated: _onMapCreated,
              ),

              // Custom AppBar
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
                          Icons.arrow_back,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          widget.ride.date,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Top Floating Stats
              if (!state.isPlaying && state.playProgress == 0.0)
                Positioned(
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
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.1),
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
                                  color: Theme.of(context).colorScheme.primary,
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
                              l10n.kmh,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 7,
                              ),
                            ),
                            Text(
                              state.currentSpeedDisplay.toStringAsFixed(1),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
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
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 7,
                              ),
                            ),
                            Text(
                              state.currentTimeDisplay ?? widget.ride.startTime,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              else
                Positioned(
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
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildLiveStatColumn(
                            l10n.speed,
                            "${state.currentSpeedDisplay.toStringAsFixed(1)} ${l10n.kmh}",
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
                            state.currentTimeDisplay ?? widget.ride.startTime,
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
                            "${state.currentDistanceDisplay.toStringAsFixed(2)} ${l10n.km}",
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
                            "${state.currentAvgSpeedDisplay.toStringAsFixed(1)} ${l10n.kmh}",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Map Control Buttons
              Positioned(
                right: 16,
                bottom: 240,
                child: Column(
                  children: [
                    _buildMapFloatingBtn(Icons.layers_outlined),
                    const SizedBox(height: 12),
                    _buildMapFloatingBtn(Icons.my_location),
                  ],
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
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
                        Transform.translate(
                          offset: const Offset(0, -24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: _togglePlayback,
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.5,
                                        ),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    state.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              if (state.isPlaying || _playController.value > 0)
                                GestureDetector(
                                  onTap: _stopPlayback,
                                  child: Container(
                                    width: 45,
                                    height: 45,
                                    margin: const EdgeInsets.only(right: 16),
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).cardColor.withValues(alpha: 0.8),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withValues(alpha: 0.2),
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                      size: 20,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        Transform.translate(
                          offset: const Offset(0, -16),
                          child: Text(
                            "Running Time: ${widget.ride.duration}",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildPanelStat(
                                      Icons.route_outlined,
                                      "${widget.ride.distance.toStringAsFixed(1)} ${l10n.km}",
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildPanelStat(
                                      Icons.timer_outlined,
                                      widget.ride.duration,
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildPanelStat(
                                      Icons.currency_rupee,
                                      "49",
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildPanelStat(
                                      Icons.speed,
                                      "${widget.ride.avgSpeed.toStringAsFixed(1)} ${l10n.kmh} AVG",
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildPanelStat(
                                      Icons.bolt,
                                      "${widget.ride.topSpeed.toStringAsFixed(1)} Top",
                                      isHighlight: true,
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildPanelStat(
                                      Icons.water_drop_outlined,
                                      "₹ 2.1/km",
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              Text(
                                widget.ride.startTime,
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
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
                                  child: Slider(
                                    value: _playController.value,
                                    onChanged: _onSliderChanged,
                                  ),
                                ),
                              ),
                              Text(
                                widget.ride.endTime,
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
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
            ],
          ),
        );
      },
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

  Widget _buildMapFloatingBtn(IconData icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withValues(alpha: 0.9),
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.onSurface,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildPanelStat(
    IconData icon,
    String value, {
    bool isHighlight = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isHighlight
              ? Theme.of(context).colorScheme.primary
              : Colors.grey,
          size: 16,
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              color: isHighlight
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
