import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:ui' as ui;

class PolylineThumbnail extends StatefulWidget {
  final List<LatLng> points;
  final Color? color;
  final double strokeWidth;
  final String startLabel;
  final String endLabel;

  const PolylineThumbnail({
    super.key,
    required this.points,
    this.color,
    this.strokeWidth = 3.0,
    this.startLabel = 'Start',
    this.endLabel = 'End',
  });

  @override
  State<PolylineThumbnail> createState() => _PolylineThumbnailState();
}

class _PolylineThumbnailState extends State<PolylineThumbnail> {
  final Completer<GoogleMapController> _controller = Completer();
  String? _darkMapStyle;
  BitmapDescriptor? _startIcon;
  BitmapDescriptor? _endIcon;

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
    _createMarkers();
  }

  Future<void> _loadMapStyle() async {
    try {
      final style = await rootBundle.loadString('assets/map_styles/dark_map.json');
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
    // Filter out invalid (0,0) GPS points
    final validPoints = widget.points
        .where((p) => p.latitude != 0.0 || p.longitude != 0.0)
        .toList();

    if (validPoints.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1F2B),
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
        color: const Color(0xFF1A1F2B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
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
              style: _darkMapStyle, // Provide the loaded dark style
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
                  color: widget.color ?? const Color(0xFFFFC107),
                  width: widget.strokeWidth.toInt(),
                  startCap: Cap.roundCap,
                  endCap: Cap.roundCap,
                  jointType: JointType.round,
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
              onMapCreated: (GoogleMapController controller) {
                if (!_controller.isCompleted) {
                  _controller.complete(controller);
                }
                // Set the style again on controller to be absolutely safe
                if (_darkMapStyle != null) {
                  controller.setMapStyle(_darkMapStyle);
                }
                // Delay slightly to allow layout to complete
                Future.delayed(const Duration(milliseconds: 100), () {
                  if (mounted) {
                    controller.moveCamera(CameraUpdate.newLatLngBounds(bounds, 20.0));
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
