import 'dart:async';
import 'package:flutter/material.dart';
import 'package:trackify/core/utils/flutter_compat_extensions.dart';
import 'package:trackify/l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/app/cubit/app_cubit.dart';
import 'package:trackify/app/cubit/app_state.dart';
import 'package:trackify/core/constants/app_images.dart';

import 'widgets/share_ride_bottom_sheet.dart';

class RidePlaybackScreen extends StatefulWidget {
  final List<LatLng> points;
  final double totalDistance;
  final Duration totalDuration;
  final double topSpeed;
  final double avgSpeed;
  final DateTime startTime;

  const RidePlaybackScreen({
    super.key,
    required this.points,
    required this.totalDistance,
    required this.totalDuration,
    required this.topSpeed,
    required this.avgSpeed,
    required this.startTime,
  });

  @override
  State<RidePlaybackScreen> createState() => _RidePlaybackScreenState();
}

class _RidePlaybackScreenState extends State<RidePlaybackScreen> {
  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();
  
  bool _isPlaying = false;
  double _currentProgress = 0.0; // 0.0 to 1.0
  Timer? _playbackTimer;
  
  LatLng? _currentPosition;
  double _currentSpeed = 0.0;
  
  double _currentRotation = 0.0;
  
  BitmapDescriptor? _startIcon;
  BitmapDescriptor? _endIcon;
  BitmapDescriptor? _currentIcon;
  String? _darkMapStyle;
  String? _lightMapStyle;

  @override
  void initState() {
    super.initState();
    if (widget.points.isNotEmpty) {
      _currentPosition = widget.points.first;
      if (widget.points.length > 1) {
        _currentRotation = Geolocator.bearingBetween(
          widget.points.first.latitude,
          widget.points.first.longitude,
          widget.points[1].latitude,
          widget.points[1].longitude,
        );
      }
    }
    _initCustomMarkers();
    _loadMapStyles();
  }

  Future<void> _loadMapStyles() async {
    try {
      _darkMapStyle = await rootBundle.loadString(
        'assets/map_styles/dark_map.json',
      );
      _lightMapStyle = await rootBundle.loadString(
        'assets/map_styles/light_map.json',
      );
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint("Error loading map styles: $e");
    }
  }

  Future<void> _initCustomMarkers() async {
    _startIcon = await _buildGearMarker(Colors.green);
    _endIcon = await _buildGearMarker(Colors.red);
    _currentIcon = await _buildArrowMarker(Colors.lightBlue);
    if (mounted) setState(() {});
  }

  Future<BitmapDescriptor> _buildGearMarker(Color color) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final size = const Size(80, 100); // Taller for the pin tail

    final Paint paintOuter = Paint()..color = color;
    final Paint paintInner = Paint()..color = Colors.white;
    final Paint paintCenter = Paint()..color = color;

    final center = Offset(size.width / 2, 40);
    
    // Draw the pin tail first so it's under the circle
    final pathTail = Path();
    pathTail.moveTo(center.dx - 15, center.dy + 30);
    pathTail.lineTo(center.dx, center.dy + 55);
    pathTail.lineTo(center.dx + 15, center.dy + 30);
    pathTail.close();
    canvas.drawPath(pathTail, paintOuter);

    // Outer circle
    canvas.drawCircle(center, 40, paintOuter);
    // Inner white circle
    canvas.drawCircle(center, 30, paintInner);
    
    // Draw gear center
    canvas.drawCircle(center, 15, paintCenter);
    // Draw a small white dot in center
    canvas.drawCircle(center, 5, paintInner);

    // Gear spokes (cross)
    final Paint paintSpoke = Paint()..color = color..strokeWidth = 6;
    canvas.drawLine(Offset(center.dx, center.dy - 30), Offset(center.dx, center.dy + 30), paintSpoke);
    canvas.drawLine(Offset(center.dx - 30, center.dy), Offset(center.dx + 30, center.dy), paintSpoke);
    canvas.drawLine(Offset(center.dx - 21, center.dy - 21), Offset(center.dx + 21, center.dy + 21), paintSpoke);
    canvas.drawLine(Offset(center.dx - 21, center.dy + 21), Offset(center.dx + 21, center.dy - 21), paintSpoke);
    
    // Redraw the inner white circle over the spokes to make them look like gears
    canvas.drawCircle(center, 22, paintInner);
    // Redraw gear center
    canvas.drawCircle(center, 12, paintCenter);
    canvas.drawCircle(center, 4, paintInner);

    final img = await pictureRecorder.endRecording().toImage(size.width.toInt(), size.height.toInt());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  Future<BitmapDescriptor> _buildArrowMarker(Color color) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final size = const Size(80, 80);

    final Paint paintShadow = Paint()
      ..color = Colors.black26
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    final Paint paintOuter = Paint()..color = Colors.white;
    final Paint paintInner = Paint()..color = color;
    
    final center = Offset(size.width / 2, size.height / 2);
    
    final path = Path();
    path.moveTo(center.dx, center.dy - 30); // tip
    path.lineTo(center.dx + 25, center.dy + 30); // bottom right
    path.lineTo(center.dx, center.dy + 15); // bottom center
    path.lineTo(center.dx - 25, center.dy + 30); // bottom left
    path.close();

    canvas.drawPath(path.shift(const Offset(0, 4)), paintShadow);
    canvas.drawPath(path, paintOuter);

    final innerPath = Path();
    innerPath.moveTo(center.dx, center.dy - 22);
    innerPath.lineTo(center.dx + 18, center.dy + 24);
    innerPath.lineTo(center.dx, center.dy + 12);
    innerPath.lineTo(center.dx - 18, center.dy + 24);
    innerPath.close();
    
    canvas.drawPath(innerPath, paintInner);

    final img = await pictureRecorder.endRecording().toImage(size.width.toInt(), size.height.toInt());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  
  @override
  void dispose() {
    _playbackTimer?.cancel();
    super.dispose();
  }

  void _stopPlayback() {
    setState(() {
      _isPlaying = false;
      _currentProgress = 0.0;
      _playbackTimer?.cancel();
      _updateCurrentPosition();
    });
  }

  void _togglePlayback() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      if (_currentProgress >= 1.0) {
        _currentProgress = 0.0;
      }
      _startTimer();
    } else {
      _playbackTimer?.cancel();
    }
  }

  void _startTimer() {
    _playbackTimer?.cancel();
    // Use 30ms for smooth 30fps-like playback
    _playbackTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      setState(() {
        // Increment progress. Let's say total playback takes 10 seconds.
        _currentProgress += 0.003; 
        if (_currentProgress >= 1.0) {
          _currentProgress = 1.0;
          _isPlaying = false;
          timer.cancel();
        }
        _updateCurrentPosition();
      });
    });
  }
  
  void _updateCurrentPosition() {
    if (widget.points.isEmpty) return;
    
    int totalPoints = widget.points.length;
    double exactIndex = _currentProgress * (totalPoints - 1);
    int index1 = exactIndex.floor();
    int index2 = exactIndex.ceil();
    
    if (index1 >= totalPoints - 1) {
      _currentPosition = widget.points.last;
      _currentSpeed = 0.0;
      if (totalPoints > 1) {
        _currentRotation = Geolocator.bearingBetween(
          widget.points[totalPoints - 2].latitude,
          widget.points[totalPoints - 2].longitude,
          widget.points.last.latitude,
          widget.points.last.longitude,
        );
      }
      return;
    }
    
    double t = exactIndex - index1;
    LatLng p1 = widget.points[index1];
    LatLng p2 = widget.points[index2];
    
    double lat = p1.latitude + (p2.latitude - p1.latitude) * t;
    double lng = p1.longitude + (p2.longitude - p1.longitude) * t;
    _currentPosition = LatLng(lat, lng);
    
    // Simulate speed based on distance between points
    if (index1 != index2) {
      double dist = Geolocator.distanceBetween(
        p1.latitude, p1.longitude, p2.latitude, p2.longitude
      );
      // Rough speed estimate for UI
      _currentSpeed = dist * 3.6; // convert m/s to km/h, assume 1 sec between points for now
      _currentRotation = Geolocator.bearingBetween(
        p1.latitude, p1.longitude, p2.latitude, p2.longitude
      );
    } else {
      if (index1 < totalPoints - 1) {
        _currentRotation = Geolocator.bearingBetween(
          widget.points[index1].latitude,
          widget.points[index1].longitude,
          widget.points[index1 + 1].latitude,
          widget.points[index1 + 1].longitude,
        );
      }
    }

    // Animate map
    _mapController.future.then((controller) {
      if (_isPlaying) {
        // Cinematic drone glide zoom & tilt when playing
        controller.moveCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _currentPosition!,
            zoom: 17.5,
            tilt: 50.0,
            bearing: _currentRotation,
          )
        ));
      } else {
        // Normal flat movement when seeking manually
        controller.animateCamera(CameraUpdate.newLatLng(_currentPosition!));
      }
    });
  }

  void _onSliderChanged(double value) {
    setState(() {
      _currentProgress = value;
      _updateCurrentPosition();
    });
  }
  
  void _onSliderChangeEnd(double value) {
    if (_isPlaying) {
      _startTimer();
    }
  }
  
  void _onSliderChangeStart(double value) {
    if (_isPlaying) {
      _playbackTimer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isInitial = _currentProgress == 0.0 && !_isPlaying;
    final endTime = widget.startTime.add(widget.totalDuration);
    final currentPlaybackTime = widget.startTime.add(
      Duration(milliseconds: (widget.totalDuration.inMilliseconds * _currentProgress).toInt())
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          DateFormat('dd MMM yyyy').format(widget.startTime), ),
        actions: [
//           IconButton(
//             icon: Icon(Icons.video_library, color: Theme.of(context).colorScheme.onSurface),
//             onPressed: () => _showExportDialog(context),
//           ),
          IconButton(
            icon: Icon(Icons.share, color: Theme.of(context).colorScheme.onSurface),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (ctx) => ShareRideBottomSheet(
                  title: AppLocalizations.of(context)!.myRideOnTrackify, // Ideally from user data
                  date: widget.startTime,
                  distance: widget.totalDistance,
                  duration: widget.totalDuration,
                  avgSpeed: widget.avgSpeed,
                  routePoints: widget.points,
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map
          _buildMap(),
          
          // Top Info Box
          Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: _buildTopInfoBox(currentPlaybackTime),
          ),
          
          // Floating Action Buttons on Right
          Positioned(
            bottom: 240,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'mapType',
                  mini: true,
                  backgroundColor: Theme.of(context).cardColor,
                  onPressed: _showMapStyleBottomSheet,
                  child: Icon(Icons.map, color: Theme.of(context).iconTheme.color ?? Colors.grey),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'myLocation',
                  mini: true,
                  backgroundColor: Theme.of(context).cardColor,
                  onPressed: _moveToCurrentLocation,
                  child: Icon(Icons.my_location, color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
          ),
          
          // Bottom Panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomPanel(endTime),
          ),
          
          // Play Button Overlay
          Positioned(
            bottom: 220,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _togglePlayback,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))
                      ]
                    ),
                    child: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 32,
                      color: Colors.black87,
                    ),
                  ),
                ),
                if (!isInitial) ...[
                  const SizedBox(width: 24),
                  GestureDetector(
                    onTap: _stopPlayback,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))
                        ]
                      ),
                      child: const Icon(
                        Icons.stop,
                        size: 32,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          )
        ],
      ),
    );
  }
  
  Future<void> _moveToCurrentLocation() async {
    try {
      if (_isPlaying) {
        setState(() {
          _isPlaying = false;
          _playbackTimer?.cancel();
        });
      }

      LatLng? target = _currentPosition;
      if (target == null && widget.points.isNotEmpty) {
        target = widget.points.first;
      }

      if (target == null) {
        final status = await Permission.location.status;
        if (!status.isGranted) {
          await Permission.location.request();
        }
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        target = LatLng(position.latitude, position.longitude);
      }

      final controller = await _mapController.future;
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: target,
            zoom: 17.0,
            tilt: 0.0,
            bearing: 0.0,
          ),
        ),
      );
    } catch (e) {
      debugPrint("Error moving to current location: $e");
    }
  }

  void _showMapStyleBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      barrierColor: Colors.black45,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
      ),
      builder: (ctx) {
        return BlocBuilder<AppCubit, AppState>(
          builder: (context, appState) {
            final l10n = AppLocalizations.of(context)!;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                      _buildStyleOption(l10n.darkStyle, AppImages.darkMapStyle, appState),
                      _buildStyleOption(l10n.lightStyle, AppImages.lightMapStyle, appState),
                      _buildStyleOption(l10n.simpleStyle, AppImages.simpleMapStyle, appState),
                      _buildStyleOption(l10n.satelliteStyle, AppImages.sateLiteMapStyle, appState),
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
                        appState.isTrafficEnabled,
                        (val) => context.read<AppCubit>().updateMapConfig(
                          isTrafficEnabled: val,
                        ),
                      ),
                      const SizedBox(width: 24),
                      _buildMapOption(
                        l10n.labelsLabel,
                        AppImages.darkMapStyle,
                        appState.isLabelsEnabled,
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
      onTap: () {
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
      },
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                width: 2,
              ),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
    bool isEnabled,
    Function(bool) onChanged,
  ) {
    return GestureDetector(
      onTap: () => onChanged(!isEnabled),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isEnabled
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                width: 2,
              ),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isEnabled ? FontWeight.bold : FontWeight.normal,
              color: isEnabled
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, appState) {
        final String mapTypePref = appState.mapType;
        MapType resolvedMapType = MapType.normal;
        if (mapTypePref == 'satellite' || appState.mapStyle == 'Satellite') {
          resolvedMapType = MapType.satellite;
        }

        String? style;
        if (resolvedMapType != MapType.satellite) {
          if (appState.mapStyle == 'Dark') {
            style = _darkMapStyle;
          } else if (appState.mapStyle == 'Light') {
            style = _lightMapStyle;
          } else if (appState.mapStyle == 'Simple') {
            style = null;
          } else {
            style = (Theme.of(context).brightness == Brightness.dark)
                ? _darkMapStyle
                : _lightMapStyle;
          }
        }

        Set<Marker> markers = {};
        if (widget.points.isNotEmpty) {
          markers.add(
            Marker(
              markerId: const MarkerId('start'),
              position: widget.points.first,
              icon: _startIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            )
          );
          markers.add(
            Marker(
              markerId: const MarkerId('end'),
              position: widget.points.last,
              icon: _endIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            )
          );
        }
        
        if (_currentPosition != null) {
          markers.add(
            Marker(
              markerId: const MarkerId('current'),
              position: _currentPosition!,
              icon: _currentIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
              anchor: const Offset(0.5, 0.5),
              rotation: _currentRotation,
              flat: true,
            )
          );
        }
        
        Set<Polyline> polylines = {
          if (widget.points.length > 1)
            Polyline(
              polylineId: const PolylineId('route'),
              points: widget.points,
              color: widget.totalDistance < 0.1 ? Colors.grey : Colors.yellow,
              width: widget.totalDistance < 0.1 ? 8 : 5,
              patterns: widget.totalDistance < 0.1 ? [PatternItem.dot, PatternItem.gap(16.0)] : const <PatternItem>[],
            )
        };

        LatLng initialTarget = widget.points.isNotEmpty ? widget.points.first : const LatLng(20, 78);

        _mapController.future.then((c) {
          c.setMapStyle(style);
        });

        return GoogleMap(
          initialCameraPosition: CameraPosition(target: initialTarget, zoom: 15),
          markers: markers,
          polylines: polylines,
          mapType: resolvedMapType,
          trafficEnabled: appState.isTrafficEnabled,
          zoomControlsEnabled: false,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          onMapCreated: (controller) {
            if (!_mapController.isCompleted) {
              _mapController.complete(controller);
            }
            controller.setMapStyle(style);
          },
        );
      },
    );
  }
  
  Widget _buildTopInfoBox(DateTime currentPlaybackTime) {
    final l10n = AppLocalizations.of(context)!;
    bool isInitial = _currentProgress == 0.0 && !_isPlaying;
    String formattedTime = isInitial ? '0.0' : DateFormat('hh:mm:ss a').format(currentPlaybackTime);
    
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withOpacity( 0.95),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withOpacity( 0.5), width: 0.5),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity( 0.12), blurRadius: 10)
          ]
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Mock logo
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on, color: Theme.of(context).colorScheme.primary, size: 24),
                  Text(l10n.trackifyBrandLabel, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(width: 14),
              Container(width: 1, height: 28, color: Colors.grey.withOpacity( 0.3)),
              const SizedBox(width: 14),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(AppLocalizations.of(context)!.speedLabel, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                  Text('km/h', style: TextStyle(fontSize: 9, color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.6))),
                  Text(_currentSpeed.toStringAsFixed(1), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                ],
              ),
              const SizedBox(width: 14),
              Container(width: 1, height: 28, color: Colors.grey.withOpacity( 0.3)),
              const SizedBox(width: 14),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(AppLocalizations.of(context)!.timeLabel, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                  Text(l10n.hrMinLabel, style: TextStyle(fontSize: 9, color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.6))),
                  Text(formattedTime, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                ],
              ),
              if (!isInitial) ...[
                const SizedBox(width: 14),
                Container(width: 1, height: 28, color: Colors.grey.withOpacity( 0.3)),
                const SizedBox(width: 14),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(AppLocalizations.of(context)!.distanceLabel, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                    Text(l10n.kmLabel, style: TextStyle(fontSize: 9, color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.6))),
                    Text((widget.totalDistance * _currentProgress).toStringAsFixed(1), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                  ],
                ),
                const SizedBox(width: 14),
                Container(width: 1, height: 28, color: Colors.grey.withOpacity( 0.3)),
                const SizedBox(width: 14),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(AppLocalizations.of(context)!.avgSpeedLabel, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                    Text('km/h', style: TextStyle(fontSize: 9, color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.6))),
                    Text(widget.avgSpeed.toStringAsFixed(1), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                  ],
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomPanel(DateTime endTime) {
    bool isInitial = _currentProgress == 0.0 && !_isPlaying;
    
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withOpacity( 0.5), width: 0.5),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_road, color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.6), size: 16),
                  const SizedBox(width: 4),
                  Text('${widget.totalDistance.toStringAsFixed(1)} ${AppLocalizations.of(context)!.meterLabel}', style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface)),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.timer_outlined, color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.6), size: 16),
                  const SizedBox(width: 4),
                  Text('${widget.totalDuration.inSeconds} ${AppLocalizations.of(context)!.secLabel}', style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.speed, color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.6), size: 16),
                  const SizedBox(width: 4),
                  Text('${widget.avgSpeed.toStringAsFixed(1)} ${AppLocalizations.of(context)!.kmhLabel} ${AppLocalizations.of(context)!.avgLabel}', style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.7))),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.speed, color: Theme.of(context).colorScheme.primary, size: 16),
                  const SizedBox(width: 4),
                  Text(AppLocalizations.of(context)!.maxSpeed, style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.primary)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(DateFormat('hh:mm').format(widget.startTime), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Theme.of(context).colorScheme.onSurface)),
                  Text(DateFormat('a').format(widget.startTime), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9, color: Theme.of(context).colorScheme.onSurface)),
                ],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // The track line
                    Positioned(
                      left: 10,
                      right: 10,
                      child: Container(
                        height: 2,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    // Left dot at the start
                    Positioned(
                      left: 4,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: isInitial ? Theme.of(context).colorScheme.primary : Colors.grey[700],
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                        ),
                      ),
                    ),
                    // Right dot at the end
                    Positioned(
                      right: 4,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: isInitial ? const Color(0xFFD32F2F) : Colors.grey[700],
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                        ),
                      ),
                    ),
                    // Transparent slider on top
                    SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 2,
                        activeTrackColor: Colors.transparent,
                        inactiveTrackColor: Colors.transparent,
                        thumbColor: isInitial ? Colors.transparent : Theme.of(context).colorScheme.primary,
                        overlayColor: isInitial ? Colors.transparent : Theme.of(context).colorScheme.primary.withOpacity( 0.2),
                        thumbShape: isInitial ? const RoundSliderThumbShape(enabledThumbRadius: 0) : _CustomThumbShape(),
                      ),
                      child: Slider(
                        value: _currentProgress,
                        min: 0.0,
                        max: 1.0,
                        onChangeStart: _onSliderChangeStart,
                        onChangeEnd: _onSliderChangeEnd,
                        onChanged: _onSliderChanged,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(DateFormat('hh:mm').format(endTime), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Theme.of(context).colorScheme.onSurface)),
                  Text(DateFormat('a').format(endTime), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9, color: Theme.of(context).colorScheme.onSurface)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController(
      text: DateFormat('dd MMM yyyy').format(widget.startTime),
    );

    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.exportRide,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  AppLocalizations.of(context)!.chooseNicknameHint,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.7),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  cursorColor: Theme.of(context).colorScheme.primary,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.onSurface.withOpacity( 0.08),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.3)),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  height: 1,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.2),
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.exportRideVideoDesc,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.7),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(
                        AppLocalizations.of(context)!.cancelBtn,
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.7),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(ctx);
                        
                        // Direct mock export logic, no need for SYSTEM_ALERT_WINDOW for file export
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(AppLocalizations.of(context)!.exportingRide),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      child: Text(
                        AppLocalizations.of(context)!.exportLabel,
                        style: TextStyle(color: Theme.of(context).colorScheme.primary,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CustomThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(16, 16);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    final Paint shadowPaint = Paint()
      ..color = Colors.black26
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawCircle(center + const Offset(0, 2), 8, shadowPaint);

    final Paint borderPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, 8, borderPaint);

    final Paint thumbPaint = Paint()..color = sliderTheme.thumbColor ?? Colors.blue;
    canvas.drawCircle(center, 6, thumbPaint);
  }
}
