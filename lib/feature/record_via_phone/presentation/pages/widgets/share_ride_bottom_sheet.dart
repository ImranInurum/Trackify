import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:trackify/l10n/app_localizations.dart';

class ShareRideBottomSheet extends StatefulWidget {
  final String title;
  final DateTime date;
  final double distance;
  final Duration duration;
  final double avgSpeed;
  final List<LatLng> routePoints;

  const ShareRideBottomSheet({
    Key? key,
    required this.title,
    required this.date,
    required this.distance,
    required this.duration,
    required this.avgSpeed,
    required this.routePoints,
  }) : super(key: key);

  @override
  State<ShareRideBottomSheet> createState() => _ShareRideBottomSheetState();
}

class _ShareRideBottomSheetState extends State<ShareRideBottomSheet> {
  GoogleMapController? _mapController;
  String? _darkMapStyle;

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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
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

          // Map Card
          Container(
            height: 380,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
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
                        color: Theme.of(context).colorScheme.primary,
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
                      // Set map style to dark
                      controller.setMapStyle(
                          '[{"elementType":"geometry","stylers":[{"color":"#242f3e"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#746855"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#242f3e"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#263c3f"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#6b9a76"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#38414e"}]},{"featureType":"road","elementType":"geometry.stroke","stylers":[{"color":"#212a37"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#9ca5b3"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#746855"}]},{"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#1f2835"}]},{"featureType":"road.highway","elementType":"labels.text.fill","stylers":[{"color":"#f3d19c"}]},{"featureType":"transit","elementType":"geometry","stylers":[{"color":"#2f3948"}]},{"featureType":"transit.station","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#17263c"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#515c6d"}]},{"featureType":"water","elementType":"labels.text.stroke","stylers":[{"color":"#17263c"}]}]');
                      
                      // Calculate bounds
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
                          Colors.black.withOpacity(0.8),
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
                                '${AppLocalizations.of(context)!.rideOnLabel} ${DateFormat('d MMM').format(widget.date)}',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Trackify Logo
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
                          Colors.black.withOpacity(0.9),
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Distance
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.add_road, size: 12, color: Colors.white.withOpacity(0.7)),
                                const SizedBox(width: 4),
                                Text(AppLocalizations.of(context)!.distanceLabel, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 10)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text('${widget.distance.toStringAsFixed(1)} ${AppLocalizations.of(context)!.kmLabel}', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        
                        // Vertical Divider
                        Container(width: 1, height: 24, color: Colors.white.withOpacity(0.2)),

                        // Duration
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.timer_outlined, size: 12, color: Colors.white.withOpacity(0.7)),
                                const SizedBox(width: 4),
                                Text(AppLocalizations.of(context)!.timeLabel, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 10)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text('${widget.duration.inMinutes}${AppLocalizations.of(context)!.minutesShort} ${widget.duration.inSeconds % 60}${AppLocalizations.of(context)!.secLabel}', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),

                        // Vertical Divider
                        Container(width: 1, height: 24, color: Colors.white.withOpacity(0.2)),

                        // Avg Speed
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.speed, size: 12, color: Colors.white.withOpacity(0.7)),
                                const SizedBox(width: 4),
                                Text(AppLocalizations.of(context)!.avgSpeedLabel, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 10)),
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
          
          const SizedBox(height: 24),

          // Image and Video Link buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.image, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7), size: 16),
                  label: Text(AppLocalizations.of(context)!.imageBtn, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 14, fontWeight: FontWeight.w500)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.link, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7), size: 16),
                  label: Text(AppLocalizations.of(context)!.videoLinkBtn, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 14, fontWeight: FontWeight.w500)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Share Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // Share functionality
              },
              icon: Icon(Icons.share, color: Theme.of(context).colorScheme.onPrimary, size: 20),
              label: Text(
                AppLocalizations.of(context)!.shareRide,
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
