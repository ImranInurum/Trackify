import 'package:flutter/material.dart';
import 'package:trackify/core/utils/flutter_compat_extensions.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:hive/hive.dart';
import 'package:trackify/core/services/connectivity_service.dart';

class PolylineThumbnail extends StatefulWidget {
  final List<LatLng> points;
  final Color? color;
  final double strokeWidth;
  final String startLabel;
  final String endLabel;
  final String? rideId;
  final bool isDotted;

  const PolylineThumbnail({
    super.key,
    required this.points,
    this.color,
    this.strokeWidth = 3.0,
    this.startLabel = 'Start',
    this.endLabel = 'End',
    this.rideId,
    this.isDotted = false,
  });

  @override
  State<PolylineThumbnail> createState() => _PolylineThumbnailState();
}

class _PolylineThumbnailState extends State<PolylineThumbnail> {
  final Completer<GoogleMapController> _controller = Completer();
  Uint8List? _cachedBytes;
  String? _darkMapStyle;
  BitmapDescriptor? _startIcon;
  BitmapDescriptor? _endIcon;

  static String? _globalDarkMapStyle;
  Brightness? _currentBrightness;

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
    _createMarkers();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final brightness = Theme.of(context).brightness;
    if (_currentBrightness != brightness) {
      _currentBrightness = brightness;
      _loadCachedSnapshot();
    }
  }

  @override
  void didUpdateWidget(covariant PolylineThumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);
    final themeKey = _currentBrightness == Brightness.dark ? 'dark' : 'light';
    final oldSignature = "${oldWidget.points.length}_${oldWidget.points.isEmpty ? '' : oldWidget.points.first.latitude}_${oldWidget.points.isEmpty ? '' : oldWidget.points.last.latitude}_${oldWidget.isDotted}_$themeKey";
    final newSignature = "${widget.points.length}_${widget.points.isEmpty ? '' : widget.points.first.latitude}_${widget.points.isEmpty ? '' : widget.points.last.latitude}_${widget.isDotted}_$themeKey";
    
    if (widget.rideId != oldWidget.rideId || oldSignature != newSignature) {
      setState(() {
        _loadCachedSnapshot();
      });
      _createMarkers();
    }
  }

  void _loadCachedSnapshot() {
    if (widget.rideId != null && _currentBrightness != null) {
      try {
        final box = Hive.box('map_cache');
        final themeKey = _currentBrightness == Brightness.dark ? 'dark' : 'light';
        final signature = "${widget.points.length}_${widget.points.isEmpty ? '' : widget.points.first.latitude}_${widget.points.isEmpty ? '' : widget.points.last.latitude}_${widget.isDotted}_$themeKey";
        final cachedSignature = box.get('map_thumbnail_v2_sig_${widget.rideId}_$themeKey');
        if (cachedSignature == signature) {
          final data = box.get('map_thumbnail_v2_${widget.rideId}_$themeKey');
          if (data is Uint8List) {
            _cachedBytes = data;
            return;
          }
        }
        _cachedBytes = null;
      } catch (e) {
        debugPrint('Error loading cached map snapshot: $e');
        _cachedBytes = null;
      }
    } else {
      _cachedBytes = null;
    }
  }

  Future<void> _loadMapStyle() async {
    if (_globalDarkMapStyle != null) {
      if (mounted) {
        setState(() {
          _darkMapStyle = _globalDarkMapStyle;
        });
      }
      return;
    }
    try {
      final style = await rootBundle.loadString('assets/map_styles/dark_map.json');
      _globalDarkMapStyle = style;
      if (mounted) {
        setState(() {
          _darkMapStyle = style;
        });
      }
    } catch (e) {
      debugPrint('Error loading dark map style: $e');
    }
  }

  Future<void> _createMarkers() async {
    final start = await _createStartMarker();
    final end = await _createEndMarker();
    if (mounted) {
      setState(() {
        _startIcon = start;
        _endIcon = end;
      });
    }
  }

  Future<BitmapDescriptor> _createStartMarker() async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = const Color(0xFF4CAF50);
    final Paint borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0;
    
    // Draw green circle with white border
    canvas.drawCircle(const Offset(30, 30), 20, paint);
    canvas.drawCircle(const Offset(30, 30), 20, borderPaint);
    
    final img = await pictureRecorder.endRecording().toImage(60, 60);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  Future<BitmapDescriptor> _createEndMarker() async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    
    final Paint redPaint = Paint()..color = Colors.red;
    final Paint whitePaint = Paint()..color = Colors.white;
    
    // Draw pin shape
    final Path path = Path();
    path.moveTo(35, 70);
    path.lineTo(15, 30);
    path.arcToPoint(const Offset(55, 30), radius: const Radius.circular(20));
    path.close();
    canvas.drawPath(path, redPaint);
    
    // Draw white wheel center
    canvas.drawCircle(const Offset(35, 25), 12, whitePaint);
    // Draw tiny red dot
    canvas.drawCircle(const Offset(35, 25), 5, redPaint);
    
    final img = await pictureRecorder.endRecording().toImage(70, 70);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    if (_cachedBytes != null) {
      return Image.memory(
        _cachedBytes!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    // Filter out invalid (0,0) GPS points
    final validPoints = widget.points
        .where((p) => p.latitude != 0.0 || p.longitude != 0.0)
        .toList();

    if (validPoints.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Icon(
            Icons.map_outlined,
            color: Colors.white.withValues(alpha: 0.2),
            size: 40,
          ),
        ),
      );
    }

    // Find the bounds of the points
    double minLat = validPoints[0].latitude;
    double maxLat = validPoints[0].latitude;
    double minLng = validPoints[0].longitude;
    double maxLng = validPoints[0].longitude;

    for (var point in validPoints) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    // Ensure bounds are not exactly zero-sized
    if (minLat == maxLat && minLng == maxLng) {
      minLat -= 0.005;
      maxLat += 0.005;
      minLng -= 0.005;
      maxLng += 0.005;
    }

    final center = LatLng(
      (minLat + maxLat) / 2,
      (minLng + maxLng) / 2,
    );

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          IgnorePointer( // Block all interactions to behave like a thumbnail
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: center,
                  zoom: 14.0,
                ),
                // Disable liteMode so the dark theme correctly applies on Android
                liteModeEnabled: false,
                mapType: MapType.normal,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                myLocationButtonEnabled: false,
                compassEnabled: false,
                rotateGesturesEnabled: false,
                scrollGesturesEnabled: false,
                tiltGesturesEnabled: false,
                zoomGesturesEnabled: false,
                polylines: {
                  Polyline(
                    polylineId: const PolylineId('route'),
                    points: validPoints,
                    color: widget.isDotted ? Colors.grey : (widget.color ?? Colors.yellow),
                    width: widget.isDotted ? 6 : widget.strokeWidth.toInt(),
                    startCap: Cap.roundCap,
                    endCap: Cap.roundCap,
                    jointType: JointType.round,
                    patterns: widget.isDotted ? [PatternItem.dot, PatternItem.gap(12.0)] : const <PatternItem>[],
                  ),
                },
                markers: {
                  if (_startIcon != null)
                    Marker(
                      markerId: const MarkerId('start'),
                      position: validPoints.first,
                      icon: _startIcon!,
                      anchor: const Offset(0.5, 0.5), // Center of circle
                    ),
                  if (_endIcon != null)
                    Marker(
                      markerId: const MarkerId('end'),
                      position: validPoints.last,
                      icon: _endIcon!,
                      anchor: const Offset(0.5, 1.0), // Bottom tip of the pin
                    ),
                },
                onMapCreated: (GoogleMapController controller) async {
                  final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
                  final currentThemeKey = isDarkTheme ? 'dark' : 'light';

                  if (!_controller.isCompleted) {
                    _controller.complete(controller);
                  }
                  // If map style is not loaded yet, wait for it
                  if (_darkMapStyle == null) {
                    await _loadMapStyle();
                  }
                  if (!mounted) return;

                  // Set the style again on controller to be absolutely safe
                  try {
                    if (isDarkTheme && _darkMapStyle != null) {
                      await controller.setMapStyle(_darkMapStyle);
                    } else {
                      await controller.setMapStyle(null);
                    }
                  } catch (e) {
                    debugPrint('Error setting map style: $e');
                  }

                  // Delay slightly to allow layout to complete
                  await Future.delayed(const Duration(milliseconds: 150));
                  if (!mounted) return;

                  try {
                    await controller.moveCamera(CameraUpdate.newLatLngBounds(bounds, 20.0));
                  } catch (e) {
                    debugPrint('Error moving camera: $e');
                  }
                  
                  // Take a snapshot after a delay to allow markers/polylines/tiles to render
                  if (widget.rideId != null) {
                    Future.delayed(const Duration(milliseconds: 3000), () async {
                      if (!mounted) return;
                      try {
                        final isConnected = await ConnectivityService().checkConnectivity();
                        if (!isConnected || !mounted) {
                          debugPrint('Device is offline, skipping caching of blank map thumbnail.');
                          return;
                        }
                        final bytes = await controller.takeSnapshot();
                        if (bytes != null && mounted) {
                          final box = Hive.box('map_cache');
                          final signature = "${widget.points.length}_${widget.points.isEmpty ? '' : widget.points.first.latitude}_${widget.points.isEmpty ? '' : widget.points.last.latitude}_${widget.isDotted}_$currentThemeKey";
                          await box.put('map_thumbnail_v2_${widget.rideId}_$currentThemeKey', bytes);
                          await box.put('map_thumbnail_v2_sig_${widget.rideId}_$currentThemeKey', signature);
                          if (mounted && _currentBrightness == (currentThemeKey == 'dark' ? Brightness.dark : Brightness.light)) {
                            setState(() {
                              _cachedBytes = bytes;
                            });
                          }
                        }
                      } catch (e) {
                        debugPrint('Error taking map snapshot: $e');
                      }
                    });
                  }
                },
              ),
          ),
        ],
      ),
    );
  }
}
