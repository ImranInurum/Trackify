import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:trackify/l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

class ShareRideBottomSheet extends StatefulWidget {
  final String title;
  final DateTime date;
  final double distance;
  final Duration duration;
  final double avgSpeed;
  final List<LatLng> routePoints;

  const ShareRideBottomSheet({
    super.key,
    required this.title,
    required this.date,
    required this.distance,
    required this.duration,
    required this.avgSpeed,
    required this.routePoints,
  });

  @override
  State<ShareRideBottomSheet> createState() => _ShareRideBottomSheetState();
}

class _ShareRideBottomSheetState extends State<ShareRideBottomSheet> {
  GoogleMapController? _mapController;
  String? _darkMapStyle;
  final GlobalKey _repaintKey = GlobalKey();
  bool _isGeneratingImage = false;

  @override
  void initState() {
    super.initState();
    _loadMapStyles();
  }

  Future<void> _loadMapStyles() async {
    try {
      _darkMapStyle = await rootBundle.loadString(
        'assets/map_styles/dark_map.json',
      );
    } catch (e) {
      debugPrint("Error loading map styles: $e");
    }
  }

  Future<void> _createAndShareImage() async {
    setState(() {
      _isGeneratingImage = true;
    });

    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final boundary = _repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary != null) {
        final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        
        if (byteData != null) {
          final Uint8List pngBytes = byteData.buffer.asUint8List();
          if (mounted) {
            setState(() {
              _isGeneratingImage = false;
            });
            _showCreatedImagePreviewDialog(pngBytes);
          }
          return;
        }
      }
    } catch (e) {
      debugPrint("Error generating image: $e");
    }

    if (mounted) {
      setState(() {
        _isGeneratingImage = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to generate ride card image")),
      );
    }
  }

  Future<bool> _saveImageToGallery(Uint8List pngBytes) async {
    try {
      final tempDir = Directory.systemTemp;
      final file = File('${tempDir.path}/trackify_ride_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(pngBytes);
      await Share.shareXFiles([XFile(file.path)], text: 'Trackify Ride Card');
      return true;
    } catch (e) {
      debugPrint("❌ Error saving image to gallery: $e");
      return false;
    }
  }

  void _showCreatedImagePreviewDialog(Uint8List pngBytes) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Ride Card Created",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    pngBytes,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final success = await _saveImageToGallery(pngBytes);
                          if (mounted) {
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  success
                                      ? "Ride card image saved to Gallery (Pictures/Trackify)!"
                                      : "Failed to save image to Gallery.",
                                ),
                                backgroundColor: success ? Colors.green : Colors.red,
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.download_done_rounded, size: 18),
                        label: const Text("Save Image"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          Navigator.pop(ctx);
                          try {
                            final tempDir = Directory.systemTemp;
                            final file = File('${tempDir.path}/shared_ride_image.png');
                            await file.writeAsBytes(pngBytes);
                            await Share.shareXFiles(
                              [XFile(file.path)],
                              text: 'Check out my ride on Trackify!',
                            );
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error sharing image: $e')),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.share, size: 18),
                        label: const Text("Share Image"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5), width: 0.5),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // Map Card with RepaintBoundary
          RepaintBoundary(
            key: _repaintKey,
            child: Container(
              height: 380,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                color: Colors.black, // fallback
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  // Map Background
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: widget.routePoints.isNotEmpty
                          ? widget.routePoints.first
                          : const LatLng(0, 0),
                      zoom: 14,
                    ),
                    polylines: {
                      if (widget.routePoints.isNotEmpty)
                        Polyline(
                          polylineId: const PolylineId('route'),
                          points: widget.routePoints,
                          color: Colors.yellow,
                          width: 4,
                        ),
                    },
                    markers: {
                      if (widget.routePoints.isNotEmpty)
                        Marker(
                          markerId: const MarkerId('start'),
                          position: widget.routePoints.first,
                          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                        ),
                      if (widget.routePoints.length > 1)
                        Marker(
                          markerId: const MarkerId('end'),
                          position: widget.routePoints.last,
                          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                        ),
                    },
                    liteModeEnabled: false,
                    zoomControlsEnabled: false,
                    mapToolbarEnabled: false,
                    myLocationButtonEnabled: false,
                    onMapCreated: (controller) {
                      _mapController = controller;
                      if (widget.routePoints.isNotEmpty) {
                        controller.setMapStyle(
                            '[{"elementType":"geometry","stylers":[{"color":"#242f3e"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#746855"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#242f3e"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#263c3f"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#6b9a76"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#38414e"}]},{"featureType":"road","elementType":"geometry.stroke","stylers":[{"color":"#212a37"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#9ca5b3"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#746855"}]},{"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#1f2835"}]},{"featureType":"road.highway","elementType":"labels.text.fill","stylers":[{"color":"#f3d19c"}]},{"featureType":"transit","elementType":"geometry","stylers":[{"color":"#2f3948"}]},{"featureType":"transit.station","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#17263c"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#515c6d"}]},{"featureType":"water","elementType":"labels.text.stroke","stylers":[{"color":"#17263c"}]}]');
                        
                        double minLat = widget.routePoints.first.latitude;
                        double maxLat = widget.routePoints.first.latitude;
                        double minLng = widget.routePoints.first.longitude;
                        double maxLng = widget.routePoints.first.longitude;
                        
                        for (var point in widget.routePoints) {
                          if (point.latitude < minLat) minLat = point.latitude;
                          if (point.latitude > maxLat) maxLat = point.latitude;
                          if (point.longitude < minLng) minLng = point.longitude;
                          if (point.longitude > maxLng) maxLng = point.longitude;
                        }
                        if (minLat >= maxLat) {
                          minLat -= 0.001;
                          maxLat += 0.001;
                        }
                        if (minLng >= maxLng) {
                          minLng -= 0.001;
                          maxLng += 0.001;
                        }
                        
                        Future.delayed(const Duration(milliseconds: 300), () {
                          if (mounted) {
                            _mapController?.animateCamera(
                              CameraUpdate.newLatLngBounds(
                                LatLngBounds(
                                  southwest: LatLng(minLat, minLng),
                                  northeast: LatLng(maxLat, maxLng),
                                ),
                                40,
                              ),
                            );
                          }
                        });
                      }
                    },
                  ),

                  // Top Gradient & Title
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.8),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${AppLocalizations.of(context)!.rideOnLabel} ${DateFormat('dd MMM yyyy').format(widget.date)}',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Image.asset(
                                'assets/icons/appLogo.png',
                                height: 18,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'TRACKIFY',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Gradient & Stats
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.9),
                            Colors.black.withValues(alpha: 0.6),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.add_road, size: 12, color: Colors.white.withValues(alpha: 0.7)),
                                  const SizedBox(width: 4),
                                  Text(AppLocalizations.of(context)!.distanceLabel, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 10)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text('${widget.distance.toStringAsFixed(1)} ${AppLocalizations.of(context)!.kmLabel}', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Container(width: 1, height: 24, color: Colors.white.withValues(alpha: 0.2)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.timer_outlined, size: 12, color: Colors.white.withValues(alpha: 0.7)),
                                  const SizedBox(width: 4),
                                  Text(AppLocalizations.of(context)!.timeLabel, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 10)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text('${widget.duration.inMinutes}${AppLocalizations.of(context)!.minutesShort} ${widget.duration.inSeconds % 60}${AppLocalizations.of(context)!.secLabel}', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Container(width: 1, height: 24, color: Colors.white.withValues(alpha: 0.2)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.speed, size: 12, color: Colors.white.withValues(alpha: 0.7)),
                                  const SizedBox(width: 4),
                                  Text(AppLocalizations.of(context)!.avgSpeedLabel, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 10)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text('${widget.avgSpeed.toStringAsFixed(1)} ${AppLocalizations.of(context)!.kmhLabel}', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),

          // Image Creation & Share Buttons
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isGeneratingImage ? null : _createAndShareImage,
              icon: _isGeneratingImage
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Icon(Icons.image, color: Theme.of(context).colorScheme.onPrimary, size: 20),
              label: Text(
                _isGeneratingImage ? "Creating Image..." : "Create & Share Ride Image",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
