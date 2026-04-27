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
    with SingleTickerProviderStateMixin {
  final Completer<GoogleMapController> _controller = Completer();
  String? _darkMapStyle;
  BitmapDescriptor? _startIcon;
  BitmapDescriptor? _endIcon;
  BitmapDescriptor? _vehicleIcon;

  BitmapDescriptor? _scooterIcon;

  double _currentHeading = 0.0;

  late AnimationController _playController;
  int _currentPointIndex = 0;
  bool _isPlaying = false;
  LatLng? _currentVehiclePosition;

  // Custom colors matching screenshot
  final Color _primaryColor = const Color(0xFFFFC107);
  final Color _panelColor = const Color(0xFF141A21);

  late final List<LatLng> _validPoints;
  late final List<RidePoint> _validRidePoints;
  final List<double> _cumulativeWeights = [];
  double _totalWeight = 0.0;
  double _currentSpeedDisplay = 0.0;

  @override
  void initState() {
    super.initState();

    _validPoints = widget.ride.polylinePoints
        .where((p) => p.latitude != 0.0 || p.longitude != 0.0)
        .toList();

    _validRidePoints = widget.ride.points
        .where((p) => p.location.latitude != 0.0 || p.location.longitude != 0.0)
        .toList();

    // Prefer time-based weights for realistic speed, fallback to distance
    _calculateWeights();

    _loadMapStyle();
    _createMarkers();

    // Setup animation controller for playback
    _playController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15), // Default playback duration 15s
    );

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
    }
    if (_validRidePoints.isNotEmpty) {
      _currentSpeedDisplay = _validRidePoints.first.speed;
    }
  }

  void _calculateWeights() {
    _cumulativeWeights.clear();
    _cumulativeWeights.add(0.0);

    if (_validRidePoints.length < 2) {
      _totalWeight = 0.0;
      return;
    }

    bool useTime = true;
    DateTime? firstTime;
    if (_validRidePoints[0].time != null) {
      firstTime = DateTime.tryParse(_validRidePoints[0].time!);
    }
    if (firstTime == null) useTime = false;

    // Try calculating time deltas
    if (useTime) {
      for (int i = 1; i < _validRidePoints.length; i++) {
        final tStr = _validRidePoints[i].time;
        if (tStr == null) {
          useTime = false;
          break;
        }
        final dt = DateTime.tryParse(tStr);
        if (dt == null) {
          useTime = false;
          break;
        }

        double seconds = dt.difference(firstTime!).inMilliseconds / 1000.0;
        if (seconds < _cumulativeWeights.last) {
          // Time went backwards? Fallback.
          useTime = false;
          break;
        }
        _cumulativeWeights.add(seconds);
      }
    }

    // Fallback to Euclidean distance if time is invalid
    if (!useTime) {
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
    super.dispose();
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
    final speed = p1.speed + (p2.speed - p1.speed) * fraction;

    // Calculate heading (direction of movement)
    double heading = _currentHeading;
    if (p1.location.latitude != p2.location.latitude || p1.location.longitude != p2.location.longitude) {
      final double dLng = (p2.location.longitude - p1.location.longitude) * math.pi / 180.0;
      final double lat1 = p1.location.latitude * math.pi / 180.0;
      final double lat2 = p2.location.latitude * math.pi / 180.0;
      final double y = math.sin(dLng) * math.cos(lat2);
      final double x = math.cos(lat1) * math.sin(lat2) - math.sin(lat1) * math.cos(lat2) * math.cos(dLng);
      heading = math.atan2(y, x) * 180.0 / math.pi;
    }

    setState(() {
      _currentPointIndex = baseIndex;
      _currentVehiclePosition = LatLng(lat, lng);
      _currentSpeedDisplay = speed;
      _currentHeading = heading;
    });

    // Optionally animate camera to follow vehicle
    _animateCameraToVehicle();
  }

  void _animateCameraToVehicle() async {
    if (_currentVehiclePosition == null || !_controller.isCompleted) return;
    final controller = await _controller.future;
    controller.moveCamera(CameraUpdate.newLatLng(_currentVehiclePosition!));
  }

  void _togglePlayback() {
    setState(() {
      if (_isPlaying) {
        _playController.stop();
        _isPlaying = false;
      } else {
        if (_playController.isCompleted) {
          _playController.reset();
        }
        _playController.forward();
        _isPlaying = true;
      }
    });
  }

  void _onSliderChanged(double value) {
    _playController.value = value;
    if (!_isPlaying) {
      _updateVehiclePosition();
    }
  }

  Future<void> _loadMapStyle() async {
    try {
      final style = await rootBundle.loadString(
        'assets/map_styles/dark_map.json',
      );
      if (mounted) {
        setState(() {
          _darkMapStyle = style;
        });
        final controller = await _controller.future;
        controller.setMapStyle(_darkMapStyle);
      }
    } catch (e) {
      debugPrint('Error loading map style: $e');
    }
  }

  Future<void> _createMarkers() async {
    final start = await _createStartMarker();
    final end = await _createEndMarker();
    final vehicle = await _createVehicleMarker();
    final scooter = await _createScooterMarker();
    if (mounted) {
      setState(() {
        _startIcon = start;
        _endIcon = end;
        _vehicleIcon = vehicle;
        _scooterIcon = scooter;
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
    const double size = 80;

    // Draw the navigation arrow pointing UP (0 degrees heading)
    final Paint arrowPaint = Paint()
      ..color = const Color(0xFF007AFF) // Maps blue
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

    final img = await pictureRecorder.endRecording().toImage(size.toInt(), size.toInt());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.bytes(data!.buffer.asUint8List());
  }

  Future<BitmapDescriptor> _createScooterMarker() async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    // Draw outer blue circle
    final Paint bluePaint = Paint()..color = Colors.blueAccent;
    final Paint borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    canvas.drawCircle(const Offset(30, 30), 24, bluePaint);
    canvas.drawCircle(const Offset(30, 30), 24, borderPaint);

    // Draw a simple scooter/bike shape inside
    final Paint whitePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(const Offset(22, 25), const Offset(38, 25), whitePaint);
    canvas.drawLine(const Offset(30, 25), const Offset(30, 38), whitePaint);
    canvas.drawCircle(
      const Offset(22, 38),
      5,
      whitePaint..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      const Offset(38, 38),
      5,
      whitePaint..style = PaintingStyle.fill,
    );

    final img = await pictureRecorder.endRecording().toImage(60, 60);
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

    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50.0));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final validPoints = _validPoints;
    final initialCenter = validPoints.isNotEmpty
        ? validPoints.first
        : const LatLng(0, 0);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Google Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: initialCenter,
              zoom: 14.0,
            ),
            mapType: MapType.normal,
            style: _darkMapStyle,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            compassEnabled: false,
            mapToolbarEnabled: false,
            padding: const EdgeInsets.only(bottom: 220), // Push Google logo up
            polylines: {
              if (validPoints.isNotEmpty)
                Polyline(
                  polylineId: const PolylineId('route'),
                  points: validPoints,
                  color: _primaryColor,
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
              if ((_isPlaying ? _vehicleIcon : _scooterIcon) != null && _currentVehiclePosition != null)
                Marker(
                  markerId: const MarkerId('vehicle'),
                  position: _currentVehiclePosition!,
                  icon: _isPlaying ? _vehicleIcon! : _scooterIcon!,
                  anchor: const Offset(0.5, 0.5),
                  rotation: _isPlaying ? _currentHeading : 0.0,
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

          // 2. Custom AppBar Area
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      widget.ride.date,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.video_library_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {}, // Download/Save video placeholder
                  ),
                  IconButton(
                    icon: const Icon(Icons.share, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),

          // 3. Top Floating Stats (Speed / Time)
          Positioned(
            top: MediaQuery.of(context).padding.top + 60,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo/Brand Icon Placeholder
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _primaryColor.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.two_wheeler,
                        color: _primaryColor,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Speed Data
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Speed",
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                      Text(
                        _currentSpeedDisplay.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 1,
                    height: 30,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  const SizedBox(width: 16),
                  // Time Data
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Time",
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                      Text(
                        // Extract start time logic
                        widget.ride.startTime,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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

          // 5. Playback & Stats Bottom Panel
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: _panelColor,
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
                      child: GestureDetector(
                        onTap: _togglePlayback,
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: _panelColor,
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
                    ),

                    // Header: Running Time
                    Transform.translate(
                      offset: const Offset(0, -16),
                      child: Text(
                        "Running Time: ${widget.ride.duration}",
                        style: const TextStyle(
                          color: Colors.white,
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
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: SliderTheme(
                              data: SliderThemeData(
                                activeTrackColor: _primaryColor,
                                inactiveTrackColor: Colors.white.withValues(
                                  alpha: 0.2,
                                ),
                                thumbColor: _primaryColor,
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
                            style: const TextStyle(
                              color: Colors.white,
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

  Widget _buildMapFloatingBtn(IconData icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: _panelColor.withValues(alpha: 0.9),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Center(child: Icon(icon, color: Colors.white, size: 22)),
    );
  }

  Widget _buildPanelStat(
    IconData icon,
    String value, {
    bool isHighlight = false,
  }) {
    return Row(
      children: [
        Icon(icon, color: isHighlight ? _primaryColor : Colors.grey, size: 16),
        const SizedBox(width: 6),
        Text(
          value,
          style: TextStyle(
            color: isHighlight ? _primaryColor : Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
