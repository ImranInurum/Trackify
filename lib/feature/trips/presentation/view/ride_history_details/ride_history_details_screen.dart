import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:trackify/feature/trips/data/entity/ride_model.dart';
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
  final Completer<GoogleMapController> _controller = Completer();
  String? _darkMapStyle;
  BitmapDescriptor? _startIcon;
  BitmapDescriptor? _endIcon;
  BitmapDescriptor? _vehicleIcon;

  double _currentHeading = 0.0;

  late AnimationController _playController;
  int _currentPointIndex = 0;
  bool _isPlaying = false;
  LatLng? _currentVehiclePosition = null;

  late List<LatLng> _validPoints;
  late List<RidePoint> _validRidePoints;
  final List<double> _cumulativeWeights = [];
  double _totalWeight = 0.0;
  bool _useTimeForWeights = false;
  bool _isPlaybackActive = false;
  double _currentSpeedDisplay = 0.0;
  String _currentTimeDisplay = "--:--";
  double _currentDistanceDisplay = 0.0;
  double _currentAvgSpeedDisplay = 0.0;
  final List<double> _cumulativeDistances = [];
  DateTime? _rideStartTime;
  DateTime? _rideEndTime;
  List<RidePoint> _interpolatedPoints = [];

  late AnimationController _orbitController;
  bool _isOrbiting = false;

  @override
  void initState() {
    super.initState();

    _validPoints = widget.ride.polylinePoints
        .where((p) => p.latitude != 0.0 || p.longitude != 0.0)
        .toList();

    _validRidePoints = widget.ride.points
        .where((p) => p.location.latitude != 0.0 || p.location.longitude != 0.0)
        .toList();

    // INTERPOLATION: Map sampled speed/time onto the high-res polyline
    _mergePolylineWithSpeedData();

    // Prefer time-based weights for realistic speed, fallback to distance
    _calculateWeights();
    _calculateCumulativeDistances();

    _loadMapStyle();
    _createMarkers();

    // Setup animation controller for playback
    _playController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );

    // Setup animation controller for orbit effect
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    _orbitController.addListener(() {
      if (_isPlaying) {
        _animateCameraToVehicle();
      }
    });

    _playController.addListener(() {
      _updateVehiclePosition();
    });

    _playController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isPlaying = false;
        });
      }
    });

    if (_validPoints.isNotEmpty) {
      _currentVehiclePosition = _validPoints.first;

      // Calculate initial heading if we have at least 2 points
      if (_validRidePoints.length > 1) {
        final p1 = _validRidePoints[0];
        final p2 = _validRidePoints[1];
        if (p1.location.latitude != p2.location.latitude ||
            p1.location.longitude != p2.location.longitude) {
          final double dLng =
              (p2.location.longitude - p1.location.longitude) * math.pi / 180.0;
          final double lat1 = p1.location.latitude * math.pi / 180.0;
          final double lat2 = p2.location.latitude * math.pi / 180.0;
          final double y = math.sin(dLng) * math.cos(lat2);
          final double x =
              math.cos(lat1) * math.sin(lat2) -
              math.sin(lat1) * math.cos(lat2) * math.cos(dLng);
          _currentHeading = (math.atan2(y, x) * 180.0 / math.pi + 360) % 360;
        }
      }
    }
    if (_validRidePoints.isNotEmpty) {
      _currentSpeedDisplay = _validRidePoints.first.speed;
      final firstTimeStr = _validRidePoints.first.time;
      if (firstTimeStr != null) {
        _rideStartTime = _parseDateTime(firstTimeStr);
      }
      final lastTimeStr = _validRidePoints.last.time;
      if (lastTimeStr != null) {
        _rideEndTime = _parseDateTime(lastTimeStr);
      }
      _currentTimeDisplay = _formatLiveTime(_rideStartTime);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadMapStyle();
    _createMarkers();
  }

  void _mergePolylineWithSpeedData() {
    if (_validPoints.isEmpty) return;
    if (_validRidePoints.isEmpty) {
      _validRidePoints = _validPoints
          .map((p) => RidePoint(location: p, speed: 0.0))
          .toList();
      return;
    }

    // Create a new set of points that follows the smooth polyline
    // but carries the speed data from the nearest original points
    List<RidePoint> merged = [];
    for (var latLng in _validPoints) {
      // Find the nearest sampled point to get speed/time
      RidePoint nearest = _validRidePoints.first;
      double minDist = double.infinity;
      for (var sampled in _validRidePoints) {
        double d = _calculateSimpleDist(latLng, sampled.location);
        if (d < minDist) {
          minDist = d;
          nearest = sampled;
        }
      }
      debugPrint("Interpolating speed: ${nearest.speed} for $latLng");
      merged.add(
        RidePoint(location: latLng, speed: nearest.speed, time: nearest.time),
      );
    }
    _validRidePoints = merged;
  }

  double _calculateSimpleDist(LatLng p1, LatLng p2) {
    return math.sqrt(
      math.pow(p1.latitude - p2.latitude, 2) +
          math.pow(p1.longitude - p2.longitude, 2),
    );
  }

  DateTime? _parseDateTime(String? str) {
    if (str == null || str.isEmpty) return null;
    try {
      // Try ISO format first, then replace space with T
      return DateTime.tryParse(str) ??
          DateTime.tryParse(str.replaceAll(' ', 'T'));
    } catch (_) {
      return null;
    }
  }

  String _formatLiveTime(DateTime? time) {
    if (time == null) return widget.ride.startTime;
    return "${time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour)}:${time.minute.toString().padLeft(2, '0')} ${time.hour >= 12 ? 'PM' : 'AM'}";
  }

  void _calculateCumulativeDistances() {
    _cumulativeDistances.clear();
    _cumulativeDistances.add(0.0);
    double currentDist = 0.0;
    if (_validRidePoints.length < 2) return;
    for (int i = 1; i < _validRidePoints.length; i++) {
      final p1 = _validRidePoints[i - 1].location;
      final p2 = _validRidePoints[i].location;

      final lat1 = p1.latitude * math.pi / 180.0;
      final lon1 = p1.longitude * math.pi / 180.0;
      final lat2 = p2.latitude * math.pi / 180.0;
      final lon2 = p2.longitude * math.pi / 180.0;

      final dLat = lat2 - lat1;
      final dLon = lon2 - lon1;

      final a =
          math.sin(dLat / 2) * math.sin(dLat / 2) +
          math.cos(lat1) *
              math.cos(lat2) *
              math.sin(dLon / 2) *
              math.sin(dLon / 2);
      final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
      final d = 6371.0 * c; // Earth radius in km

      currentDist += d;
      _cumulativeDistances.add(currentDist);
    }
  }

  void _calculateWeights() {
    _cumulativeWeights.clear();
    _cumulativeWeights.add(0.0);

    if (_validRidePoints.length < 2) {
      _totalWeight = 0.0;
      return;
    }

    _useTimeForWeights = true;
    DateTime? firstTime;
    if (_validRidePoints[0].time != null) {
      firstTime = _parseDateTime(_validRidePoints[0].time!);
    }
    if (firstTime == null) _useTimeForWeights = false;

    // Try calculating time deltas
    if (_useTimeForWeights) {
      for (int i = 1; i < _validRidePoints.length; i++) {
        final tStr = _validRidePoints[i].time;
        if (tStr == null) {
          _useTimeForWeights = false;
          break;
        }
        final dt = _parseDateTime(tStr);
        if (dt == null) {
          _useTimeForWeights = false;
          break;
        }

        double seconds = dt.difference(firstTime!).inMilliseconds / 1000.0;
        if (seconds < _cumulativeWeights.last) {
          // Time went backwards? Fallback.
          _useTimeForWeights = false;
          break;
        }
        _cumulativeWeights.add(seconds);
      }
    }

    // Fallback to Euclidean distance if time is invalid
    if (!_useTimeForWeights) {
      _cumulativeWeights.clear();
      _cumulativeWeights.add(0.0);
      double currentDist = 0.0;
      for (int i = 1; i < _validRidePoints.length; i++) {
        final p1 = _validRidePoints[i - 1].location;
        final p2 = _validRidePoints[i].location;
        final dx = p2.longitude - p1.longitude;
        final dy = p2.latitude - p1.latitude;
        currentDist += math.sqrt(dx * dx + dy * dy);
        _cumulativeWeights.add(currentDist);
      }
    }

    _totalWeight = _cumulativeWeights.last;
  }

  @override
  void dispose() {
    _playController.dispose();
    _orbitController.dispose();
    super.dispose();
  }

  void _startOrbitAnimation() {
    if (_isOrbiting) return;

    setState(() {
      _isOrbiting = true;
    });

    _orbitController.repeat();
  }

  void _stopOrbitAnimation() {
    if (!_isOrbiting) return;
    _orbitController.stop();
    setState(() {
      _isOrbiting = false;
    });
  }

  void _updateVehiclePosition() {
    if (_validRidePoints.isEmpty) return;

    final progress = _playController.value;
    final totalPoints = _validRidePoints.length;
    if (totalPoints < 2 || _totalWeight == 0) return;

    final targetWeight = progress * _totalWeight;

    // Find the segment where targetWeight falls
    int baseIndex = 0;
    for (int i = 0; i < _cumulativeWeights.length - 1; i++) {
      if (targetWeight <= _cumulativeWeights[i + 1]) {
        baseIndex = i;
        break;
      }
    }

    if (baseIndex >= totalPoints - 1) {
      setState(() {
        _currentPointIndex = totalPoints - 1;
        _currentVehiclePosition = _validRidePoints.last.location;
        _currentSpeedDisplay = _validRidePoints.last.speed;

        if (_cumulativeDistances.isNotEmpty) {
          _currentDistanceDisplay = _cumulativeDistances.last;
        }
        if (_rideEndTime != null) {
          _currentTimeDisplay = _formatLiveTime(_rideEndTime);
        }

        if (_rideEndTime != null && _rideStartTime != null) {
          final elapsedHours =
              _rideEndTime!.difference(_rideStartTime!).inSeconds / 3600.0;
          if (elapsedHours > 0 && _cumulativeDistances.isNotEmpty) {
            _currentAvgSpeedDisplay = _cumulativeDistances.last / elapsedHours;
          }
        }
      });
      return;
    }

    int nextIndex = baseIndex + 1;
    double startW = _cumulativeWeights[baseIndex];
    double endW = _cumulativeWeights[nextIndex];

    // Calculate fraction within the specific segment
    double segmentLength = endW - startW;
    double fraction = segmentLength > 0
        ? (targetWeight - startW) / segmentLength
        : 0.0;

    final p1 = _validRidePoints[baseIndex];
    final p2 = _validRidePoints[nextIndex];

    final lat =
        p1.location.latitude +
        (p2.location.latitude - p1.location.latitude) * fraction;
    final lng =
        p1.location.longitude +
        (p2.location.longitude - p1.location.longitude) * fraction;

    // Direct Speed: Using the raw speed from the API point instead of calculating interpolation
    double speed = p1.speed;

    // DEBUG: Monitor raw speed in terminal
    debugPrint(
      ">>> RAW API SPEED: ${speed.toStringAsFixed(2)} km/h | Point Index: $baseIndex",
    );

    // Calculate distance
    double dist = 0.0;
    if (_cumulativeDistances.length > nextIndex) {
      final d1 = _cumulativeDistances[baseIndex];
      final d2 = _cumulativeDistances[nextIndex];
      dist = d1 + (d2 - d1) * fraction;
    }

    // Calculate time
    DateTime? liveTime;
    if (p1.time != null) {
      liveTime = _parseDateTime(p1.time);
    }

    if (liveTime == null && _rideStartTime != null && _rideEndTime != null) {
      final totalMs = _rideEndTime!.difference(_rideStartTime!).inMilliseconds;
      final elapsedMs = (totalMs * progress).toInt();
      liveTime = _rideStartTime!.add(Duration(milliseconds: elapsedMs));
    }

    // Calculate avg speed using the reliable targetWeight
    double avgSpd = 0.0;
    double elapsedHours = 0.0;
    if (_useTimeForWeights) {
      elapsedHours = targetWeight / 3600.0;
    }

    if (elapsedHours > 0) {
      avgSpd = dist / elapsedHours;
    } else if (dist > 0 && progress > 0) {
      // Fallback if no timestamps: use the ride's overall avg speed from data
      avgSpd = widget.ride.avgSpeed;
    }

    // Calculate heading (direction of movement)
    double heading = _currentHeading;
    if (p1.location.latitude != p2.location.latitude ||
        p1.location.longitude != p2.location.longitude) {
      final double dLng =
          (p2.location.longitude - p1.location.longitude) * math.pi / 180.0;
      final double lat1 = p1.location.latitude * math.pi / 180.0;
      final double lat2 = p2.location.latitude * math.pi / 180.0;
      final double y = math.sin(dLng) * math.cos(lat2);
      final double x =
          math.cos(lat1) * math.sin(lat2) -
          math.sin(lat1) * math.cos(lat2) * math.cos(dLng);
      heading = (math.atan2(y, x) * 180.0 / math.pi + 360) % 360;
    }

    setState(() {
      _currentPointIndex = baseIndex;
      _currentVehiclePosition = LatLng(lat, lng);
      _currentSpeedDisplay = speed;
      _currentHeading = heading;
      _currentDistanceDisplay = dist;
      if (liveTime != null) {
        _currentTimeDisplay = _formatLiveTime(liveTime);
      }
      _currentAvgSpeedDisplay = avgSpd;
    });

    // Optionally animate camera to follow vehicle
    _animateCameraToVehicle();
  }

  void _animateCameraToVehicle() async {
    if (_currentVehiclePosition == null || !_controller.isCompleted) return;
    final controller = await _controller.future;

    if (_isPlaying) {
      // Calculate bearing: combined heading + orbit offset
      double bearing = _currentHeading;
      if (_isOrbiting) {
        final double curvedValue = Curves.easeInOut.transform(
          _orbitController.value,
        );
        bearing = (bearing + (curvedValue * 360)) % 360;
      }

      controller.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _currentVehiclePosition!,
            zoom: 17.5,
            tilt: 60.0,
            bearing: bearing,
          ),
        ),
      );
    }
  }

  void _togglePlayback() async {
    if (_isPlaying) {
      setState(() {
        _playController.stop();
        _stopOrbitAnimation(); // Stop orbit when paused
        _isPlaying = false;
      });
    } else {
      if (_playController.isCompleted) {
        _playController.reset();
      }

      setState(() {
        _isPlaying = true;
        _isPlaybackActive = true;
        _playController.duration = const Duration(seconds: 30);
        _startOrbitAnimation(); // Start orbit when playback begins
      });
      _createMarkers(); // Update marker size for playback

      if (_currentVehiclePosition != null && _controller.isCompleted) {
        final controller = await _controller.future;
        await controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: _currentVehiclePosition!,
              zoom: 17.5,
              tilt: 60.0,
              bearing: _currentHeading,
            ),
          ),
        );
      }

      if (mounted && _isPlaying) {
        _playController.forward();
      }
    }
  }

  void _stopPlayback() {
    setState(() {
      _playController.stop();
      _playController.value = 0.0;
      _stopOrbitAnimation(); // Stop orbit on stop
      _isPlaying = false;
      _isPlaybackActive = false;
      _updateVehiclePosition();
    });
    _createMarkers(); // Update marker size for preview
    _fitMapToBounds();
  }

  void _onSliderChanged(double value) {
    _playController.value = value;
    if (!_isPlaying) {
      _updateVehiclePosition();
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    _loadMapStyle();

    // Zoom transition: Start with India view, then fly to the trip route
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (_validPoints.isNotEmpty && mounted) {
        _fitMapToBounds();
      }
    });
  }

  Future<void> _loadMapStyle() async {
    try {
      final controller = await _controller.future;
      // Force dark map style by default as per user request
      if (_darkMapStyle == null) {
        _darkMapStyle = await rootBundle.loadString(
          'assets/map_styles/dark_map.json',
        );
      }
      controller.setMapStyle(_darkMapStyle);
    } catch (e) {
      debugPrint('Error loading map style: $e');
    }
  }

  Future<void> _createMarkers() async {
    final start = await _createStartMarker();
    final end = await _createEndMarker();
    final vehicle = await _createVehicleMarker();
    if (mounted) {
      setState(() {
        _startIcon = start;
        _endIcon = end;
        _vehicleIcon = vehicle;
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
    final Path path = Path();
    path.moveTo(35, 70);
    path.lineTo(15, 30);
    path.arcToPoint(const Offset(55, 30), radius: const Radius.circular(20));
    path.close();
    canvas.drawPath(path, redPaint);
    canvas.drawCircle(const Offset(35, 25), 12, whitePaint);
    canvas.drawCircle(const Offset(35, 25), 5, redPaint);
    final img = await pictureRecorder.endRecording().toImage(70, 70);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  Future<BitmapDescriptor> _createVehicleMarker() async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final double size = _isPlaybackActive ? 65.0 : 50.0;

    // Draw the navigation arrow pointing UP (0 degrees heading)
    final Paint arrowPaint = Paint()
      ..color = Theme.of(context).colorScheme.primary
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final Path path = Path();
    path.moveTo(size / 2, 10); // Top tip
    path.lineTo(size - 20, size - 10); // Bottom right
    path.lineTo(size / 2, size - 20); // Bottom center cutout
    path.lineTo(20, size - 10); // Bottom left
    path.close();

    // Subtle drop shadow
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
    if (_validPoints.isEmpty) return;

    final controller = await _controller.future;
    double minLat = _validPoints[0].latitude;
    double maxLat = _validPoints[0].latitude;
    double minLng = _validPoints[0].longitude;
    double maxLng = _validPoints[0].longitude;

    for (var point in _validPoints) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    if (minLat == maxLat && minLng == maxLng) {
      minLat -= 0.005;
      maxLat += 0.005;
      minLng -= 0.005;
      maxLng += 0.005;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100.0));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final validPoints = _validPoints;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Google Map
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(20.5937, 78.9629), // Center of India
              zoom: 4.2,
            ),
            mapType: MapType.normal,
            style: _darkMapStyle,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            compassEnabled: false,
            mapToolbarEnabled: false,
            onCameraMoveStarted: () {
              // Optionally stop orbit on user interaction
              // _stopOrbitAnimation();
            },
            padding: const EdgeInsets.only(bottom: 220), // Push Google logo up
            polylines: {
              if (validPoints.isNotEmpty)
                Polyline(
                  polylineId: const PolylineId('route'),
                  points: validPoints,
                  color: Theme.of(context).colorScheme.primary,
                  width: 4,
                  startCap: Cap.roundCap,
                  endCap: Cap.roundCap,
                  jointType: JointType.round,
                ),
            },
            markers: {
              if (_startIcon != null && validPoints.isNotEmpty)
                Marker(
                  markerId: const MarkerId('start'),
                  position: validPoints.first,
                  icon: _startIcon!,
                  anchor: const Offset(0.5, 0.5),
                ),
              if (_endIcon != null && validPoints.isNotEmpty)
                Marker(
                  markerId: const MarkerId('end'),
                  position: validPoints.last,
                  icon: _endIcon!,
                  anchor: const Offset(0.5, 1.0),
                ),
              if (_vehicleIcon != null && _currentVehiclePosition != null)
                Marker(
                  markerId: const MarkerId('vehicle'),
                  position: _currentVehiclePosition!,
                  icon: _vehicleIcon!,
                  anchor: const Offset(0.5, 0.5),
                  rotation: _currentHeading,
                  flat: true,
                  zIndex: 2, // Ensure vehicle is drawn above start/end markers
                ),
            },
            onMapCreated: (controller) {
              _controller.complete(controller);
              if (_darkMapStyle != null) {
                controller.setMapStyle(_darkMapStyle);
              }
              Future.delayed(const Duration(milliseconds: 300), () {
                _fitMapToBounds();
              });
            },
          ),

          // 1.5 Floating Speed Label that stays centered at the top of the map area
          // during playback to give a "HUD" feel.

          // 2. Custom AppBar Area
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
                  IconButton(
                    icon: Icon(
                      Icons.video_library_outlined,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    onPressed: () {}, // Download/Save video placeholder
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.share,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),

          // 3. Top Floating Stats
          if (!_isPlaying && _playController.value == 0.0)
            Positioned(
              top: MediaQuery.of(context).padding.top + 60,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withValues(alpha: 0.85),
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
                    // Logo/Brand Icon Placeholder
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
                    // Speed Data
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
                          _currentSpeedDisplay.toStringAsFixed(1),
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
                    // Time Data
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
                          _currentTimeDisplay,
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
              top:
                  MediaQuery.of(context).padding.top +
                  80, // Moved down slightly to avoid overlap
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withValues(alpha: 0.85),
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
                        "${_currentSpeedDisplay.toStringAsFixed(1)} ${l10n.kmh}",
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
                        _currentTimeDisplay,
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
                        "${_currentDistanceDisplay.toStringAsFixed(2)} ${l10n.km}",
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
                        "${_currentAvgSpeedDisplay.toStringAsFixed(1)} ${l10n.kmh}",
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // 4. Map Control Buttons (Layers, Current Location)
          Positioned(
            right: 16,
            bottom: 240, // Above bottom panel
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
                    // Play/Pause Floating Over Header
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
                                color: Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: Icon(
                                _isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          if (_isPlaying || _playController.value > 0)
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

                    // Header: Running Time
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

                    // Stats Rows
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildPanelStat(
                                Icons.route_outlined,
                                "${widget.ride.distance} ${l10n.km}",
                              ),
                              _buildPanelStat(
                                Icons.timer_outlined,
                                widget.ride.duration,
                              ),
                              _buildPanelStat(
                                Icons.currency_rupee,
                                "49",
                              ), // Mock Price
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildPanelStat(
                                Icons.speed,
                                "${widget.ride.avgSpeed} ${l10n.kmh} AVG",
                              ),
                              _buildPanelStat(
                                Icons.bolt,
                                "${widget.ride.topSpeed} Top Speed",
                                isHighlight: true,
                              ),
                              _buildPanelStat(
                                Icons.water_drop_outlined,
                                "₹ 2.1/km",
                              ), // Mock mileage/cost
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Slider & Times
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
                                inactiveTrackColor: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.2),
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
        ],
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
      children: [
        Icon(
          icon,
          color: isHighlight
              ? Theme.of(context).colorScheme.primary
              : Colors.grey,
          size: 16,
        ),
        const SizedBox(width: 6),
        Text(
          value,
          style: TextStyle(
            color: isHighlight
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
