import 'dart:async';
import 'dart:io' show Platform;
import 'dart:ui' as ui;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:trackify/app/cubit/app_cubit.dart';
import 'package:trackify/app/cubit/app_state.dart';
import 'package:trackify/core/theme/app_colors.dart';
import 'package:trackify/core/constants/app_images.dart';
import 'package:trackify/feature/map/presentation/pages/full_screen_map.dart';
import 'package:trackify/feature/record_via_phone/presentation/cubit/record_via_phone_cubit.dart';
import 'package:trackify/feature/record_via_phone/presentation/cubit/record_via_phone_state.dart';
import 'package:trackify/l10n/app_localizations_ar.dart';

import '../../../../l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:trackify/feature/record_via_phone/data/model/device_data_by_date_response.dart';
import 'package:trackify/feature/record_via_phone/presentation/pages/ride_playback_screen.dart';

import 'package:trackify/feature/record_via_phone/presentation/pages/widgets/share_ride_bottom_sheet.dart';
import 'package:trackify/feature/map/presentation/pages/shared_with_me_screen.dart';
import 'package:trackify/feature/record_via_phone/presentation/pages/shared_rides_screen.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';
import 'package:trackify/feature/location_sharing/presentation/pages/location_sharing_screen.dart';

class RecordViaPhoneScreen extends StatefulWidget {
  final String imei;
  const RecordViaPhoneScreen({super.key, required this.imei});

  @override
  State<RecordViaPhoneScreen> createState() => _RecordViaPhoneScreenState();
}

class _RecordViaPhoneScreenState extends State<RecordViaPhoneScreen> {
  final Completer<GoogleMapController> _rideMapController =
      Completer<GoogleMapController>();
  final Completer<GoogleMapController> _pastMapController =
      Completer<GoogleMapController>();
  String? _lightMapStyle;
  String? _darkMapStyle;
  BitmapDescriptor? _customMarkerIcon;
  String? _mobileDeviceName;

  String _activeDateFilter = "Today";
  String? _selectedFilterTag;
  final Map<int, String> _rideTags = {};
  DateTime _selectedStatsDate = DateTime.now();
  late DateTime _statsStartDate;
  late DateTime _statsEndDate;
  final Set<int> _favoriteRides = {};
  BitmapDescriptor? _startMarkerIcon;
  BitmapDescriptor? _endMarkerIcon;

  @override
  void initState() {
    super.initState();
    _loadMapStyles();
    _fetchMobileDeviceName();
    _initStartEndMarkers();

    final now = DateTime.now();
    _statsStartDate = DateTime(now.year, now.month, now.day);
    _statsEndDate = DateTime(now.year, now.month, now.day, 23, 59, 59);

    // Pre-fetch today's history
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initCustomMarker();
      final today = DateFormat('yyyy-MM-dd').format(now);
      context.read<RecordViaPhoneCubit>().fetchDeviceDataByDate(
        imei: widget.imei,
        startDate: today,
        endDate: today,
      );
    });
  }

  Future<void> _fetchMobileDeviceName() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      String name = 'Unknown Device';
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        name = androidInfo.brand;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        name = iosInfo.name;
      }
      if (mounted) {
        setState(() {
          _mobileDeviceName = name;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _mobileDeviceName = 'Phone';
        });
      }
    }
  }

  String _formatStatsDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final checkDate = DateTime(date.year, date.month, date.day);

    final dateStr = DateFormat('MMMM d').format(date);
    if (checkDate == today) {
      return "$dateStr (Today)";
    } else if (checkDate == yesterday) {
      return "$dateStr (Yesterday)";
    } else {
      final dayName = DateFormat('EEEE').format(date);
      return "$dateStr ($dayName)";
    }
  }

  String _getStatsDateText() {
    if (_activeDateFilter == "Today") {
      return "${DateFormat('MMMM d').format(DateTime.now())} (Today)";
    } else if (_activeDateFilter == "Yesterday") {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      return "${DateFormat('MMMM d').format(yesterday)} (Yesterday)";
    } else if (_activeDateFilter == "This week" || 
               _activeDateFilter == "Last week" || 
               _activeDateFilter == "Last 7 days" ||
               _activeDateFilter == "This month" ||
               _activeDateFilter == "Last month" ||
               _activeDateFilter == "Last 30 days") {
      final startStr = DateFormat('MMM d').format(_statsStartDate);
      final endStr = DateFormat('MMM d').format(_statsEndDate);
      return "$_activeDateFilter ($startStr - $endStr)";
    } else if (_activeDateFilter.contains(" - ")) {
      return _activeDateFilter;
    } else {
      return _formatStatsDate(_selectedStatsDate);
    }
  }

  void _changeStatsDate(int days) {
    final newDate = _selectedStatsDate.add(Duration(days: days));
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (newDate.isAfter(today)) return;

    setState(() {
      _selectedStatsDate = newDate;
      _statsStartDate = DateTime(newDate.year, newDate.month, newDate.day);
      _statsEndDate = DateTime(newDate.year, newDate.month, newDate.day, 23, 59, 59);
      
      final checkDate = DateTime(newDate.year, newDate.month, newDate.day);
      if (checkDate == today) {
        _activeDateFilter = "Today";
      } else if (checkDate == today.subtract(const Duration(days: 1))) {
        _activeDateFilter = "Yesterday";
      } else {
        _activeDateFilter = DateFormat('dd/MM').format(newDate);
      }
    });

    final dateStr = DateFormat('yyyy-MM-dd').format(newDate);
    context.read<RecordViaPhoneCubit>().fetchDeviceDataByDate(
      imei: widget.imei,
      startDate: dateStr,
      endDate: dateStr,
    );
  }

  Future<void> _initStartEndMarkers() async {
    try {
      final startIcon = await _createMarkerImageFromIcon(Colors.green, Icons.radio_button_checked);
      final endIcon = await _createMarkerImageFromIcon(Colors.red, Icons.radio_button_checked);
      if (mounted) {
        setState(() {
          _startMarkerIcon = startIcon;
          _endMarkerIcon = endIcon;
        });
      }
    } catch (e) {
      debugPrint("Error initializing custom markers: $e");
    }
  }

  Future<BitmapDescriptor> _createMarkerImageFromIcon(Color color, IconData iconData) async {
    final int size = 90;
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final double center = size / 2;

    // Draw background pin circle
    final Paint circlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    // Draw outer white border
    final Paint borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(center, center), center, borderPaint);
    canvas.drawCircle(Offset(center, center), center - 4, circlePaint);

    // Draw inner icon
    TextPainter painter = TextPainter(textDirection: ui.TextDirection.ltr);
    painter.text = TextSpan(
      text: String.fromCharCode(iconData.codePoint),
      style: TextStyle(
        fontSize: size * 0.5,
        fontFamily: iconData.fontFamily,
        package: iconData.fontPackage,
        color: Colors.white,
      ),
    );
    painter.layout();
    painter.paint(
      canvas,
      Offset(center - painter.width / 2, center - painter.height / 2),
    );

    final ui.Image img = await pictureRecorder.endRecording().toImage(size, size);
    final ByteData? data = await img.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  LatLng _getCenterLatLng(List<LatLng> points) {
    if (points.isEmpty) return const LatLng(0, 0);
    double sumLat = 0.0;
    double sumLng = 0.0;
    for (final p in points) {
      sumLat += p.latitude;
      sumLng += p.longitude;
    }
    return LatLng(sumLat / points.length, sumLng / points.length);
  }

  double _getFitZoom(List<LatLng> points) {
    if (points.length < 2) return 15.0;
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;
    for (final p in points) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }
    final latDiff = maxLat - minLat;
    final lngDiff = maxLng - minLng;
    final maxDiff = latDiff > lngDiff ? latDiff : lngDiff;
    
    if (maxDiff == 0) return 15.0;
    
    if (maxDiff < 0.005) return 16.0;
    if (maxDiff < 0.01) return 15.0;
    if (maxDiff < 0.02) return 14.0;
    if (maxDiff < 0.05) return 13.0;
    if (maxDiff < 0.1) return 12.0;
    return 11.0;
  }

  String _formatRideDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    final minStr = minutes.toString().padLeft(2, '0');
    final secStr = seconds.toString().padLeft(2, '0');
    
    if (hours > 0) {
      final hrStr = hours.toString().padLeft(2, '0');
      return "${hrStr}h ${minStr}m ${secStr}s";
    } else {
      return "${minStr}m ${secStr}s";
    }
  }

  List<PastRide> _groupDataIntoRides(List<DataByDate> rawData) {
    if (rawData.isEmpty) return [];

    final sortedData = List<DataByDate>.from(rawData);
    sortedData.sort((a, b) {
      final aDt = a.dt ?? '';
      final bDt = b.dt ?? '';
      final dtCompare = aDt.compareTo(bDt);
      if (dtCompare != 0) return dtCompare;

      final aTm = a.tm ?? '';
      final bTm = b.tm ?? '';
      return aTm.compareTo(bTm);
    });

    List<List<DataByDate>> groups = [];
    List<DataByDate> currentGroup = [];

    for (var point in sortedData) {
      if (currentGroup.isEmpty) {
        currentGroup.add(point);
        continue;
      }

      final prevPoint = currentGroup.last;
      DateTime? prevTime;
      if (prevPoint.dt != null && prevPoint.tm != null) {
        prevTime = DateTime.tryParse('${prevPoint.dt} ${prevPoint.tm}');
      }

      DateTime? currTime;
      if (point.dt != null && point.tm != null) {
        currTime = DateTime.tryParse('${point.dt} ${point.tm}');
      }

      bool isNewSegment = false;
      if (prevTime != null && currTime != null) {
        final diff = currTime.difference(prevTime).inMinutes;
        if (diff.abs() > 30) {
          isNewSegment = true;
        }
      } else {
        isNewSegment = true;
      }

      if (isNewSegment) {
        if (currentGroup.length >= 2) {
          groups.add(currentGroup);
        }
        currentGroup = [point];
      } else {
        currentGroup.add(point);
      }
    }
    if (currentGroup.length >= 2) {
      groups.add(currentGroup);
    } else if (groups.isEmpty && currentGroup.isNotEmpty) {
      groups.add(currentGroup);
    }

    List<PastRide> ridesList = [];
    for (int index = 0; index < groups.length; index++) {
      final group = groups[index];
      
      final List<LatLng> routePoints = [];
      double totalDist = 0.0;
      double speedSum = 0.0;
      int speedCount = 0;
      
      LatLng? lastLatLng;
      for (var item in group) {
        final lat = double.tryParse(item.lt ?? '');
        final lng = double.tryParse(item.lg ?? '');
        if (lat == null || lng == null) continue;

        final ns = (item.ns ?? '').toUpperCase();
        final ew = (item.ew ?? '').toUpperCase();

        double finalLat = ns == 'S' ? -lat.abs() : lat.abs();
        double finalLng = ew == 'W' ? -lng.abs() : lng.abs();

        if (finalLat < 10 || finalLat > 40) continue;
        if (finalLng < 60 || finalLng > 100) continue;
        if (finalLat == 0 || finalLng == 0) continue;

        final currentLatLng = LatLng(finalLat, finalLng);
        routePoints.add(currentLatLng);

        if (lastLatLng != null) {
          final d = Geolocator.distanceBetween(
            lastLatLng.latitude,
            lastLatLng.longitude,
            currentLatLng.latitude,
            currentLatLng.longitude,
          );
          if (d > 5.0 && d < 50000) {
            totalDist += (d / 1000.0);
          }
        }
        lastLatLng = currentLatLng;

        final sp = item.sp ?? 0.0;
        if (sp > 0) {
          speedSum += sp;
          speedCount++;
        }
      }

      if (routePoints.isEmpty) continue;

      DateTime? firstTime;
      if (group.first.dt != null && group.first.tm != null) {
        firstTime = DateTime.tryParse('${group.first.dt} ${group.first.tm}');
      }
      DateTime? lastTime;
      if (group.last.dt != null && group.last.tm != null) {
        lastTime = DateTime.tryParse('${group.last.dt} ${group.last.tm}');
      }

      final duration = (firstTime != null && lastTime != null)
          ? lastTime.difference(firstTime)
          : const Duration(seconds: 6);

      final avgSpeed = speedCount > 0 ? (speedSum / speedCount) : 0.0;

      String dateLabel = "Today";
      if (firstTime != null) {
        final now = DateTime.now();
        if (firstTime.year == now.year &&
            firstTime.month == now.month &&
            firstTime.day == now.day) {
          dateLabel = "Today";
        } else {
          dateLabel = DateFormat('dd MMM yyyy').format(firstTime);
        }
      }

      final tag = _rideTags[index] ?? "Walk";
      final isFavorite = _favoriteRides.contains(index);

      ridesList.add(PastRide(
        dateStr: dateLabel,
        tag: tag,
        isFavorite: isFavorite,
        distanceKm: totalDist,
        duration: duration,
        avgSpeed: avgSpeed,
        points: routePoints,
      ));
    }

    return ridesList;
  }

  List<PastRide> _getMockRides(LatLng? userLocation) {
    final center = userLocation ?? const LatLng(28.6139, 77.2090);
    
    final mockPoints1 = [
      LatLng(center.latitude - 0.002, center.longitude - 0.001),
      LatLng(center.latitude - 0.001, center.longitude - 0.0005),
      LatLng(center.latitude, center.longitude),
      LatLng(center.latitude + 0.001, center.longitude + 0.0005),
      LatLng(center.latitude + 0.002, center.longitude + 0.001),
    ];
    
    final mockPoints2 = [
      LatLng(center.latitude + 0.002, center.longitude - 0.002),
      LatLng(center.latitude + 0.001, center.longitude - 0.001),
      LatLng(center.latitude, center.longitude),
      LatLng(center.latitude - 0.001, center.longitude + 0.001),
      LatLng(center.latitude - 0.002, center.longitude + 0.002),
    ];

    return [
      PastRide(
        dateStr: "Today",
        tag: _rideTags[0] ?? "Walk",
        isFavorite: _favoriteRides.contains(0),
        distanceKm: 0.0,
        duration: const Duration(seconds: 6),
        avgSpeed: 2.4,
        points: mockPoints1,
      ),
      PastRide(
        dateStr: "Yesterday",
        tag: _rideTags[1] ?? "Car",
        isFavorite: _favoriteRides.contains(1),
        distanceKm: 12.4,
        duration: const Duration(hours: 0, minutes: 24, seconds: 12),
        avgSpeed: 31.0,
        points: mockPoints2,
      ),
    ];
  }

  void _showEditTagDialog(int index, String currentTag) {
    final l10n = AppLocalizations.of(context)!;
    final textController = TextEditingController(text: currentTag);
    final tags = ["Walk", "Car", "Bike", "Train", "Bus", "Auto", "Cab", "Cycle", "Others"];

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(
                "Edit Tag", ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: l10n.enterCustomTag,
                      hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).dividerColor),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: tags.map((tag) {
                      final isSelected = textController.text.toLowerCase() == tag.toLowerCase();
                      return GestureDetector(
                        onTap: () {
                          setDialogState(() {
                            textController.text = tag;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                                : Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.transparent,
                            ),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _rideTags[index] = textController.text.trim();
                    });
                    Navigator.pop(ctx);
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showTagFilterBottomSheet() {
    final tags = ["All", "Walk", "Car", "Bike", "Train", "Bus", "Auto", "Cab", "Cycle", "Others"];
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Filter by tags",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: tags.map((tag) {
                  final isSelected = (tag == "All" && _selectedFilterTag == null) ||
                      (_selectedFilterTag != null && _selectedFilterTag!.toLowerCase() == tag.toLowerCase());
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFilterTag = tag == "All" ? null : tag;
                      });
                      Navigator.pop(ctx);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                            : Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                        ),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  void _showDateFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      isScrollControlled: true,
      builder: (ctx) {
        return _DateRangePickerBottomSheet(
          initialActiveFilter: _activeDateFilter,
          initialStartDate: _statsStartDate,
          initialEndDate: _statsEndDate,
          onFilterSelected: (label, start, end) {
            setState(() {
              _activeDateFilter = label;
              _statsStartDate = start;
              _statsEndDate = end;
              _selectedStatsDate = start;
            });
            context.read<RecordViaPhoneCubit>().fetchDeviceDataByDate(
              imei: widget.imei,
              startDate: DateFormat('yyyy-MM-dd').format(start),
              endDate: DateFormat('yyyy-MM-dd').format(end),
            );
          },
        );
      },
    );
  }

  Widget _buildRideCard(PastRide ride, int index) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final Set<Polyline> polylines = {
      Polyline(
        polylineId: PolylineId("preview_polyline_$index"),
        points: ride.points,
        color: Colors.amber,
        width: 4,
        jointType: JointType.round,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      ),
    };

    final Set<Marker> markers = {
      Marker(
        markerId: MarkerId("preview_start_$index"),
        position: ride.points.first,
        icon: _startMarkerIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
      Marker(
        markerId: MarkerId("preview_end_$index"),
        position: ride.points.last,
        icon: _endMarkerIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    };

    final centerLatLng = _getCenterLatLng(ride.points);
    final fitZoom = _getFitZoom(ride.points);
    final String durationText = _formatRideDuration(ride.duration);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.onSurface.withOpacity(0.05),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
            child: Row(
              children: [
                Text(
                  ride.dateStr,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _showEditTagDialog(index, ride.tag),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 11,
                      color: Colors.black,
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_favoriteRides.contains(index)) {
                        _favoriteRides.remove(index);
                      } else {
                        _favoriteRides.add(index);
                      }
                    });
                  },
                  child: Icon(
                    ride.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: ride.isFavorite ? Colors.red : (isDark ? Colors.white.withOpacity(0.6) : Colors.black54),
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                ride.tag,
                style: TextStyle(color: isDark ? Colors.white.withOpacity(0.7) : Colors.black54,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 12),

          Container(
            height: 200,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: centerLatLng,
                      zoom: fitZoom,
                    ),
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    compassEnabled: false,
                    mapToolbarEnabled: false,
                    scrollGesturesEnabled: false,
                    zoomGesturesEnabled: false,
                    tiltGesturesEnabled: false,
                    rotateGesturesEnabled: false,
                    polylines: polylines,
                    markers: markers,
                    style: isDark ? _darkMapStyle : _lightMapStyle,
                  ),
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RidePlaybackScreen(
                              points: ride.points,
                              totalDistance: ride.distanceKm,
                              totalDuration: ride.duration,
                              topSpeed: ride.avgSpeed * 1.5,
                              avgSpeed: ride.avgSpeed,
                              startTime: DateTime.now().subtract(ride.duration),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF131A26) : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.amber, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${index + 1} ",
                            style: const TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const Text(
                            "⇆",
                            style: TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCardStatItem(
                  "${ride.distanceKm.toStringAsFixed(1)} km",
                  "Distance",
                  isDark,
                ),
                _buildCardStatItem(
                  durationText,
                  "Ride Duration",
                  isDark,
                ),
                _buildCardStatItem(
                  "${ride.avgSpeed.toStringAsFixed(1)} km/h",
                  "Avg. Speed",
                  isDark,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCardStatItem(String value, String label, bool isDark) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: isDark ? Colors.white.withOpacity(0.5) : Colors.black45,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Future<void> _initCustomMarker() async {
    final appState = context.read<AppCubit>().state;
    final userName = appState.userData?.name ?? 'U';
    final Color primaryColor = Theme.of(context).colorScheme.primary;

    final int size = 120;
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final double center = size / 2;

    // Outer glow ring
    final Paint glowPaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(center, center), center, glowPaint);

    // White border
    final Paint borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(center, center), center - 4, borderPaint);

    // Inner circle with primary theme color
    final Paint bodyPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(center, center), center - 8, bodyPaint);

    TextPainter painter = TextPainter(textDirection: ui.TextDirection.ltr);
    painter.text = TextSpan(
      text: userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
      style: TextStyle(
        fontSize: size * 0.45,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
    painter.layout();
    painter.paint(
      canvas,
      Offset(center - painter.width / 2, center - painter.height / 2),
    );

    final ui.Image img = await pictureRecorder.endRecording().toImage(
      size,
      size,
    );
    final ByteData? data = await img.toByteData(format: ui.ImageByteFormat.png);
    final icon = BitmapDescriptor.fromBytes(data!.buffer.asUint8List());

    if (mounted) {
      setState(() {
        _customMarkerIcon = icon;
      });
    }
  }

  String _getDeviceName() {
    if (_mobileDeviceName != null) {
      return _mobileDeviceName!;
    }
    try {
      final appState = context.read<AppCubit>().state;
      final device = appState.devices.firstWhere(
        (d) => d['imei'] == widget.imei,
      );
      return device['name'] ??
          device['deviceName'] ??
          device['vehicleNo'] ??
          'Device ${widget.imei}';
    } catch (e) {
      return 'Device ${widget.imei}';
    }
  }

  late final l10n = AppLocalizations.of(context)!;
  Future<void> _loadMapStyles() async {
    try {
      _lightMapStyle = await rootBundle.loadString(
        'assets/map_styles/light_map.json',
      );
      _darkMapStyle = await rootBundle.loadString(
        'assets/map_styles/dark_map.json',
      );
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint("Error loading map styles: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return MultiBlocListener(
      listeners: [
        BlocListener<AppCubit, AppState>(
          listenWhen: (prev, curr) =>
              prev.currentLocation != curr.currentLocation,
          listener: (context, appState) {
            if (appState.currentLocation != null) {
              context.read<RecordViaPhoneCubit>().updateRecordingData(
                appState.currentLocation!,
              );
            }
          },
        ),
        BlocListener<RecordViaPhoneCubit, RecordViaPhoneState>(
          listenWhen: (prev, curr) =>
              curr is MapDataByDateLoaded ||
              (curr.isRecording &&
                  curr.currentRidePoints.length !=
                      prev.currentRidePoints.length),
          listener: (context, state) {
            if (state.polylines != null && state.polylines!.isNotEmpty) {
              final points = state.polylines!.first.points;
              if (points.isNotEmpty) {
                // Animate History map to fit bounds (non-blocking) if controller is completed
                if (_pastMapController.isCompleted) {
                  _pastMapController.future.then((controller) {
                    if (!mounted) return;
                    final bounds = _getBounds(points);
                    controller.animateCamera(
                      CameraUpdate.newLatLngBounds(bounds, 50),
                    );
                  });
                }

                // Jump live map to the last known position (non-blocking)
                if (!state.isRecording) {
                  _rideMapController.future.then((controller) {
                    if (!mounted) return;
                    controller.animateCamera(
                      CameraUpdate.newLatLngZoom(points.last, 15),
                    );
                  });
                }
              }
            } else if (state.isRecording &&
                state.currentRidePoints.isNotEmpty) {
              // Follow the current recording path
              _rideMapController.future.then((controller) {
                if (!mounted) return;
                controller.animateCamera(
                  CameraUpdate.newLatLng(state.currentRidePoints.last),
                );
              });
            }
          },
        ),
      ],
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: color.onSurface,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(AppLocalizations.of(context)!.recordViaPhoneTitle),
            actions: [
              if (widget.imei.isEmpty || context.read<AppCubit>().state.devices.isEmpty)
                PopupMenuButton<String>(
                  elevation: 8,
                  color: Theme.of(context).cardColor,
                  surfaceTintColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  icon: Icon(
                    Icons.more_vert,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  onSelected: (value) {
                    if (value == 'Shared Locations') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SharedWithMeScreen(),
                        ),
                      );
                    } else if (value == 'Shared Rides') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SharedRidesScreen(),
                        ),
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'Shared Locations',
                      child: Text(
                        'Shared Locations',
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'Shared Rides',
                      child: Text(
                        'Shared Rides',
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
            bottom: TabBar(
              indicatorColor: Theme.of(context).colorScheme.primary,
              indicatorWeight: 3,
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Theme.of(
                context,
              ).colorScheme.onSurface.withOpacity(0.5),
              labelStyle: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              tabs: [
                Tab(text: AppLocalizations.of(context)!.recordRidesTab),
                Tab(text: AppLocalizations.of(context)!.pastRidesTab),
                Tab(text: AppLocalizations.of(context)!.statisticsTab),
              ],
            ),
          ),
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _KeepAliveWrapper(child: _buildLiveRecordView()),
              _KeepAliveWrapper(child: _buildHistoryView()),
              _KeepAliveWrapper(child: _buildStatisticsView()),
            ],
          ),
        ),
      ),
    );
  }

  // --- Live Record View ---
  Widget _buildLiveRecordView() {
    return BlocBuilder<RecordViaPhoneCubit, RecordViaPhoneState>(
      builder: (context, state) {
        Set<Marker> markers = {};
        LatLng? lastPos;

        if (state.polylines != null && state.polylines!.isNotEmpty) {
          final points = state.polylines!.first.points;
          if (points.isNotEmpty) {
            lastPos = points.last;
          }
        }

        return Stack(
          children: [
            Positioned.fill(
              bottom: 80,
              child: _buildMap(
                controller: _rideMapController,
                markers: markers,
                initialTarget: lastPos,
                polylines: {
                  if (state.currentRidePoints.isNotEmpty)
                    Polyline(
                      polylineId: const PolylineId("live_ride"),
                      points: state.currentRidePoints,
                      color: Theme.of(context).colorScheme.primary,
                      width: 5,
                      jointType: JointType.round,
                      startCap: Cap.roundCap,
                      endCap: Cap.roundCap,
                    ),
                },
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FloatingActionButton(
                              heroTag: 'btnShare',
                              mini: true,
                              backgroundColor: Theme.of(context).cardColor,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LocationSharingScreen(),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.share,
                                color:
                                    Theme.of(context).iconTheme.color ??
                                    Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            FloatingActionButton(
                              heroTag: 'btnGmaps',
                              mini: true,
                              backgroundColor: Theme.of(context).cardColor,
                              onPressed: () async {
                                final appState = context.read<AppCubit>().state;
                                final pos = appState.currentLocation;
                                if (pos != null) {
                                  final webUri = Uri.parse(
                                    'https://www.google.com/maps/search/?api=1&query=${pos.latitude},${pos.longitude}',
                                  );
                                  if (await canLaunchUrl(webUri)) {
                                    await launchUrl(
                                      webUri,
                                      mode: LaunchMode.externalApplication,
                                    );
                                  }
                                }
                              },
                              child: Image.asset(
                                'assets/icons/map_icon.png',
                                height: 24,
                                width: 24,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: _buildRecordButton(state),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FloatingActionButton(
                              heroTag: 'btnMapType',
                              mini: true,
                              backgroundColor: Theme.of(context).cardColor,
                              onPressed: () => _showMapStyleBottomSheet(),
                              child: Icon(
                                Icons.map_outlined,
                                color:
                                    Theme.of(context).iconTheme.color ??
                                    Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            FloatingActionButton(
                              heroTag: 'btnLocation',
                              mini: true,
                              backgroundColor: Theme.of(context).cardColor,
                              onPressed: () async {
                                // Try AppCubit location first
                                final appState = context.read<AppCubit>().state;
                                var pos = appState.currentLocation;

                                // Fallback to device GPS if AppCubit hasn't updated yet
                                if (pos == null) {
                                  try {
                                    pos =
                                        await Geolocator.getLastKnownPosition();
                                  } catch (_) {}
                                }

                                if (pos != null) {
                                  _rideMapController.future.then((c) {
                                    c.animateCamera(
                                      CameraUpdate.newLatLngZoom(
                                        LatLng(pos!.latitude, pos.longitude),
                                        16,
                                      ),
                                    );
                                  });
                                } else {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          l10n.locationNotAvailable,
                                        ),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                }
                              },
                              child: Icon(
                                Icons.my_location,
                                color:
                                    Theme.of(context).iconTheme.color ??
                                    Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            FloatingActionButton(
                              heroTag: 'btnFullscreen',
                              mini: true,
                              backgroundColor: Theme.of(context).cardColor,
                              onPressed: () async {
                                final appState = context.read<AppCubit>().state;
                                var pos = appState.currentLocation;
                                if (pos == null) {
                                  try {
                                    pos =
                                        await Geolocator.getLastKnownPosition();
                                  } catch (_) {}
                                }
                                if (pos != null) {
                                  _rideMapController.future.then((c) {
                                    c.animateCamera(
                                      CameraUpdate.newLatLngZoom(
                                        LatLng(pos!.latitude, pos.longitude),
                                        16,
                                      ),
                                    );
                                  });
                                }
                              },
                              child: Icon(
                                Icons.fullscreen,
                                color:
                                    Theme.of(context).iconTheme.color ??
                                    Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _buildBottomSheet(state),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomSheet(RecordViaPhoneState state) {
    final appState = context.read<AppCubit>().state;
    final userName = appState.userData?.name ?? 'U';

    String lastUpdatedText =
        "${AppLocalizations.of(context)!.lastUpdated} ${AppLocalizations.of(context)!.justNow}";
    final currentLoc = appState.currentLocation;
    if (currentLoc != null) {
      final timeFormat = DateFormat('h:mm a');
      final formattedTime = timeFormat.format(currentLoc.timestamp);
      lastUpdatedText =
          "${AppLocalizations.of(context)!.lastUpdated} $formattedTime, ${AppLocalizations.of(context)!.today}";
    }

    final bool showStats =
        state.isRecording || state.rideDuration != Duration.zero;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 47,
                height: 47,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                  style: TextStyle(color: Colors.black.withOpacity(0.7),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.yourPhonesLocation,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _getDeviceName(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      lastUpdatedText,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
              if (showStats)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: state.rideDistance.toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                              TextSpan(
                                text: ' km',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.distanceLabel,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            Icons.keyboard_arrow_up,
                            size: 16,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            size: 16,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
          if (showStats) ...[
            const SizedBox(height: 16),
            Divider(color: Colors.grey.withOpacity(0.2)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNewStatItem(
                  AppLocalizations.of(context)!.distanceLabel,
                  state.rideDistance.toStringAsFixed(2),
                  AppLocalizations.of(context)!.kmLabel,
                ),
                _buildNewStatItem(
                  AppLocalizations.of(context)!.durationLabel,
                  _formatDurationNew(state.rideDuration),
                  '',
                ),
                Builder(
                  builder: (context) {
                    double avgSpeed = 0.0;
                    if (state.rideDuration.inSeconds > 0) {
                      avgSpeed =
                          state.rideDistance /
                          (state.rideDuration.inSeconds / 3600.0);
                    }
                    return _buildNewStatItem(
                      AppLocalizations.of(context)!.avgSpeedLabel,
                      avgSpeed.toStringAsFixed(2),
                      AppLocalizations.of(context)!.kmhLabel,
                    );
                  },
                ),
                _buildNewStatItem(
                  AppLocalizations.of(context)!.topSpeedLabel,
                  state.topSpeed.toStringAsFixed(2),
                  AppLocalizations.of(context)!.kmhLabel,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNewStatItem(String label, String value, String unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              if (unit.isNotEmpty)
                TextSpan(
                  text: ' $unit',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  String _formatDurationNew(Duration duration) {
    String hours = duration.inHours > 0
        ? '${duration.inHours}${AppLocalizations.of(context)!.hoursShort} '
        : '';
    String minutes =
        '${duration.inMinutes.remainder(60)}${AppLocalizations.of(context)!.minutesShort} ';
    String seconds =
        '${duration.inSeconds.remainder(60)}${AppLocalizations.of(context)!.secondsShort}';
    return '$hours$minutes$seconds';
  }

  Widget _buildRecordButton(RecordViaPhoneState state) {
    final isRecording = state.isRecording;
    return GestureDetector(
      onTap: () {
        if (isRecording) {
          _showStopRecordingDialog(context);
        } else {
          _handleStartRecording();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isRecording ? Icons.stop : Icons.play_arrow_rounded,
              color: isRecording
                  ? Colors.red
                  : Theme.of(context).colorScheme.primary,
              size: 28,
            ),
            const SizedBox(width: 8),
            Text(
              isRecording
                  ? AppLocalizations.of(context)!.stopRideRecording
                  : AppLocalizations.of(context)!.startRideRecording,
              style: TextStyle(color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- History View ---
  Widget _buildHistoryView() {
    return BlocBuilder<RecordViaPhoneCubit, RecordViaPhoneState>(
      builder: (context, state) {
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: context.read<RecordViaPhoneCubit>().getOfflineRides(),
          builder: (context, snapshot) {
            final offlineRidesRaw = snapshot.data ?? [];
            final List<PastRide> offlineRides = offlineRidesRaw.map((r) {
              final List<dynamic> ptsRaw = r['points'] ?? [];
              final List<LatLng> pts = ptsRaw
                  .map((p) => LatLng(
                        (p['lat'] as num?)?.toDouble() ?? 0.0,
                        (p['lng'] as num?)?.toDouble() ?? 0.0,
                      ))
                  .toList();

              // Parse dateStr to a nice format
              String displayDate = r['dateStr'] ?? '';
              if (displayDate.isNotEmpty) {
                try {
                  final dt = DateTime.parse(displayDate);
                  displayDate = "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
                } catch (_) {}
              }

              return PastRide(
                dateStr: displayDate,
                tag: r['tag'] ?? 'Offline',
                isFavorite: false,
                distanceKm: (r['distanceKm'] as num?)?.toDouble() ?? 0.0,
                duration: Duration(
                  seconds: (r['durationSeconds'] as num?)?.toInt() ?? 0,
                ),
                avgSpeed: (r['avgSpeed'] as num?)?.toDouble() ?? 0.0,
                points: pts,
              );
            }).toList();

            List<PastRide> rides = _groupDataIntoRides(state.data);
            
            // Merge both offline and online rides
            rides = [...offlineRides, ...rides];

            // Sort by date Str descending so newest rides are always at the top
            rides.sort((a, b) {
              final aDate = DateTime.tryParse(a.dateStr) ?? DateTime(0);
              final bDate = DateTime.tryParse(b.dateStr) ?? DateTime(0);
              return bDate.compareTo(aDate);
            });
            
            if (_selectedFilterTag != null) {
              rides = rides.where((r) => r.tag.toLowerCase() == _selectedFilterTag!.toLowerCase()).toList();
            }
            
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => _showTagFilterBottomSheet(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _selectedFilterTag != null
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).dividerColor,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.tune,
                                size: 16,
                                color: _selectedFilterTag != null
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _selectedFilterTag != null ? 'Tag: $_selectedFilterTag' : 'Filter by tags',
                                style: TextStyle(color: _selectedFilterTag != null
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => _showDateFilterBottomSheet(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _activeDateFilter != "Today"
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).dividerColor,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: _activeDateFilter != "Today"
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Date: $_activeDateFilter',
                                style: TextStyle(color: _activeDateFilter != "Today"
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                Expanded(
                  child: rides.isEmpty
                      ? Center(
                          child: Text(
                            "No past rides found",
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: rides.length,
                          padding: const EdgeInsets.only(bottom: 24),
                          itemBuilder: (context, index) {
                            return _buildRideCard(rides[index], index);
                          },
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // --- Statistics View ---
  Map<String, dynamic> _calculateStats(RecordViaPhoneState state, List<PastRide> offlineRides) {
    final appState = context.read<AppCubit>().state;
    final userLoc = appState.currentLocation != null 
        ? LatLng(appState.currentLocation!.latitude, appState.currentLocation!.longitude) 
        : null;

    // Filter offline rides by currently selected date range
    final startOfDay = DateTime(_statsStartDate.year, _statsStartDate.month, _statsStartDate.day);
    final endOfDay = DateTime(_statsEndDate.year, _statsEndDate.month, _statsEndDate.day, 23, 59, 59, 999);

    final filteredOfflineRides = offlineRides.where((r) {
      final rideDate = DateTime.tryParse(r.dateStr);
      if (rideDate == null) return false;
      return rideDate.isAfter(startOfDay.subtract(const Duration(milliseconds: 1))) &&
             rideDate.isBefore(endOfDay.add(const Duration(milliseconds: 1)));
    }).toList();

    List<PastRide> rides = _groupDataIntoRides(state.data);
    
    // Merge both offline and online rides
    rides = [...filteredOfflineRides, ...rides];

    if (_selectedFilterTag != null) {
      rides = rides.where((r) => r.tag.toLowerCase() == _selectedFilterTag!.toLowerCase()).toList();
    }

    if (rides.isEmpty) {
      return {
        'distance': 0.0,
        'drivingTime': const Duration(),
        'topSpeed': 0.0,
        'avgSpeed': 0.0,
        'totalRides': 0,
        'fuel': 0.0,
        'safetyScore': 100,
      };
    }

    // Calculate from the filtered rides list (works for both offline & online)
    double totalDistance = 0.0;
    double topSpeed = 0.0;
    double speedSum = 0.0;
    int speedCount = 0;
    Duration drivingTime = const Duration();
    double safetyScoreSum = 0.0;

    for (var ride in rides) {
      totalDistance += ride.distanceKm;
      drivingTime += ride.duration;
      if (ride.avgSpeed > 0) {
        speedSum += ride.avgSpeed;
        speedCount++;
      }
      final estimatedTopSpeed = ride.avgSpeed * 1.35;
      if (estimatedTopSpeed > topSpeed) {
        topSpeed = estimatedTopSpeed;
      }

      double score = 100.0;
      if (ride.avgSpeed > 80) {
        score = 65.0;
      } else if (ride.avgSpeed > 60) {
        score = 80.0;
      } else if (ride.avgSpeed > 40) {
        score = 90.0;
      } else if (ride.avgSpeed > 0) {
        score = 98.0;
      }
      safetyScoreSum += score;
    }

    double avgSpeed = speedCount > 0 ? speedSum / speedCount : 0.0;
    double fuel = totalDistance * 0.08;
    int safetyScore = (safetyScoreSum / rides.length).round().clamp(0, 100);

    return {
      'distance': totalDistance,
      'drivingTime': drivingTime,
      'topSpeed': topSpeed,
      'avgSpeed': avgSpeed,
      'totalRides': rides.length,
      'fuel': fuel,
      'safetyScore': safetyScore,
    };
  }

  Widget _buildStatisticsView() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<RecordViaPhoneCubit, RecordViaPhoneState>(
      builder: (context, state) {
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: context.read<RecordViaPhoneCubit>().getOfflineRides(),
          builder: (context, snapshot) {
            final offlineRidesRaw = snapshot.data ?? [];
            final List<PastRide> offlineRides = offlineRidesRaw.map((r) {
              final List<dynamic> ptsRaw = r['points'] ?? [];
              final List<LatLng> pts = ptsRaw
                  .map((p) => LatLng(
                        (p['lat'] as num?)?.toDouble() ?? 0.0,
                        (p['lng'] as num?)?.toDouble() ?? 0.0,
                      ))
                  .toList();

              String displayDate = r['dateStr'] ?? '';
              if (displayDate.isNotEmpty) {
                try {
                  final dt = DateTime.parse(displayDate);
                  displayDate = "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
                } catch (_) {}
              }

              return PastRide(
                dateStr: displayDate,
                tag: r['tag'] ?? 'Offline',
                isFavorite: false,
                distanceKm: (r['distanceKm'] as num?)?.toDouble() ?? 0.0,
                duration: Duration(
                  seconds: (r['durationSeconds'] as num?)?.toInt() ?? 0,
                ),
                avgSpeed: (r['avgSpeed'] as num?)?.toDouble() ?? 0.0,
                points: pts,
              );
            }).toList();

            final stats = _calculateStats(state, offlineRides);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Selector Card
                  InkWell(
                    onTap: () => _showDateFilterBottomSheet(),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.dividerColor.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _getStatsDateText(),
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Left Chevron Button
                          InkWell(
                            onTap: () => _changeStatsDate(-1),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                Icons.chevron_left,
                                color: colorScheme.onSurface,
                                size: 24,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Right Chevron Button (disabled if today)
                          Builder(
                            builder: (context) {
                              final now = DateTime.now();
                              final isToday = DateTime(
                                    _selectedStatsDate.year,
                                    _selectedStatsDate.month,
                                    _selectedStatsDate.day,
                                  ).isAtSameMomentAs(
                                    DateTime(now.year, now.month, now.day),
                                  );
                              return InkWell(
                                onTap: isToday ? null : () => _changeStatsDate(1),
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Icon(
                                    Icons.chevron_right,
                                    color: isToday
                                        ? colorScheme.onSurface.withValues(alpha: 0.25)
                                        : colorScheme.onSurface,
                                    size: 24,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Tag Filter Chip
                  Row(
                    children: [
                      InkWell(
                        onTap: () => _showTagFilterBottomSheet(),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _selectedFilterTag != null
                                  ? colorScheme.primary
                                  : theme.dividerColor.withValues(alpha: 0.1),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.tune,
                                size: 16,
                                color: _selectedFilterTag != null
                                    ? colorScheme.primary
                                    : colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _selectedFilterTag != null ? 'Tag: $_selectedFilterTag' : 'Filter by tags',
                                style: TextStyle(color: _selectedFilterTag != null
                                      ? colorScheme.primary
                                      : colorScheme.onSurface.withValues(alpha: 0.6),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildSummaryCard(stats),
                  const SizedBox(height: 25),
                  Text(
                    l10n.quickStats,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 15),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 1.2,
                    children: [
                      _buildStatCard(
                        l10n.totalRides,
                        "${stats['totalRides']}",
                        Icons.directions_car,
                        Colors.blue,
                      ),
                      _buildStatCard(
                        l10n.averageSpeed,
                        "${(stats['avgSpeed'] as double).toStringAsFixed(0)} km/h",
                        Icons.speed,
                        Colors.orange,
                      ),
                      _buildStatCard(
                        l10n.topSpeed,
                        "${(stats['topSpeed'] as double).toStringAsFixed(0)} km/h",
                        Icons.bolt,
                        Colors.purple,
                      ),
                      _buildStatCard(
                        l10n.totalFuel,
                        "${(stats['fuel'] as double).toStringAsFixed(1)} L",
                        Icons.local_gas_station,
                        Colors.green,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSummaryCard(Map<String, dynamic> stats) {
    String formattedTime = "";
    final dur = stats['drivingTime'] as Duration;
    if (dur.inHours > 0) {
      formattedTime += "${dur.inHours}h ";
    }
    formattedTime += "${dur.inMinutes.remainder(60)}m";
    if (dur.inMinutes == 0 && dur.inHours == 0) formattedTime = "0m";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.overallDistance,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            "${(stats['distance'] as double).toStringAsFixed(2)} km",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildSimpleInfo(formattedTime, l10n.drivingTime),
              const SizedBox(width: 30),
              _buildSimpleInfo("${stats['safetyScore']}%", l10n.safetyScore),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleInfo(String val, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          val,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white60, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Text(
            label,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // --- Common Widgets ---
  Widget _buildMap({
    required Completer<GoogleMapController> controller,
    Set<Polyline> polylines = const {},
    Set<Marker> markers = const {},
    LatLng? initialTarget,
    bool showCurrentLocationMarker = true,
  }) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, appState) {
        final currentPos = appState.currentLocation;
        final themeMode = appState.themeMode;

        if (currentPos == null && initialTarget == null) {
          return const Center(child: TrackifyLoader());
        }

        final target =
            initialTarget ?? LatLng(currentPos!.latitude, currentPos.longitude);

        Set<Marker> allMarkers = Set.from(markers);

        if (showCurrentLocationMarker && currentPos != null) {
          final l10n = AppLocalizations.of(context)!;
          allMarkers.add(
            Marker(
              markerId: const MarkerId("current_device_location"),
              position: LatLng(currentPos.latitude, currentPos.longitude),
              infoWindow: InfoWindow(title: l10n.yourLocationLabel),
              icon:
                  _customMarkerIcon ??
                  BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueAzure,
                  ),
              zIndex: 99,
            ),
          );
        }

        // Resolve map style based on user selection (mirrors full_screen_map logic)
        final String? mapStylePref = appState.mapStyle;
        final String? mapTypePref = appState.mapType;
        final l10n = AppLocalizations.of(context);

        String? style;
        MapType resolvedMapType = MapType.normal;

        if (mapTypePref == 'satellite' ||
            mapStylePref == 'Satellite' ||
            mapStylePref == l10n?.satelliteStyle) {
          style = null;
          resolvedMapType = MapType.satellite;
        } else if (mapStylePref == 'Dark' || mapStylePref == l10n?.darkStyle) {
          style = _darkMapStyle;
        } else if (mapStylePref == 'Light' ||
            mapStylePref == l10n?.lightStyle) {
          style = _lightMapStyle;
        } else if (mapStylePref == 'Simple' ||
            mapStylePref == l10n?.simpleStyle) {
          style = _lightMapStyle;
        } else {
          // Fall back to theme
          final isDark =
              themeMode == ThemeMode.dark ||
              (themeMode == ThemeMode.system &&
                  MediaQuery.of(context).platformBrightness == Brightness.dark);
          style = isDark ? _darkMapStyle : _lightMapStyle;
        }

        // Apply style whenever state rebuilds
        controller.future.then((c) {
          c.setMapStyle(style);
        });

        return GoogleMap(
          initialCameraPosition: CameraPosition(target: target, zoom: 15),
          myLocationEnabled: !showCurrentLocationMarker,
          zoomControlsEnabled: false,
          mapType: resolvedMapType,
          polylines: polylines,
          markers: allMarkers,
          style: style,
          onMapCreated: (GoogleMapController googleMapController) async {
            if (!controller.isCompleted) {
              controller.complete(googleMapController);
            }
            googleMapController.setMapStyle(style);
          },
        );
      },
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
                      _buildStyleOption(
                        l10n.darkStyle,
                        AppImages.darkMapStyle,
                        appState,
                      ),
                      _buildStyleOption(
                        l10n.lightStyle,
                        AppImages.lightMapStyle,
                        appState,
                      ),
                      _buildStyleOption(
                        l10n.simpleStyle,
                        AppImages.simpleMapStyle,
                        appState,
                      ),
                      _buildStyleOption(
                        l10n.satelliteStyle,
                        AppImages.sateLiteMapStyle,
                        appState,
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
        // BlocBuilder on _buildMap will rebuild and apply the correct style
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
                ),
              ),
              if (isActive)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 12,
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
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  LatLngBounds _getBounds(List<LatLng> points) {
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final p in points) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  Future<void> _handleStartRecording() async {
    final status = await Permission.locationAlways.status;
    if (status.isGranted) {
      if (mounted) _showRideModeDialog(context);
    } else {
      if (mounted) _showLocationAlwaysDialog(context);
    }
  }

  void _showLocationAlwaysDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.warning_rounded, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.locationAlwaysAccessWarning,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(
                    context,
                  )!.goToSettingsAndSelectAllowAllTheTime,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                Container(
                  width: 140,
                  height: 190,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.black, width: 4),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context)!.locationPermissions,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Icon(
                        Icons.location_on,
                        color: Colors.amber,
                        size: 16,
                      ),
                      const Text(
                        'Trackify',
                        style: TextStyle(color: Colors.white, fontSize: 8),
                      ),
                      const SizedBox(height: 12),
                      _buildMockOption(
                        AppLocalizations.of(context)!.allowAllTheTime,
                        true,
                      ),
                      const SizedBox(height: 6),
                      _buildMockOption(
                        AppLocalizations.of(context)!.onlyWhileUsingTheApp,
                        false,
                      ),
                      const SizedBox(height: 6),
                      _buildMockOption(
                        AppLocalizations.of(context)!.askEveryTime,
                        false,
                      ),
                      const SizedBox(height: 6),
                      _buildMockOption(
                        AppLocalizations.of(context)!.dontAllow,
                        false,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () async {
                      Navigator.pop(ctx);

                      var whenInUse = await Permission.locationWhenInUse.status;
                      if (!whenInUse.isGranted) {
                        whenInUse = await Permission.locationWhenInUse
                            .request();
                      }

                      if (whenInUse.isGranted) {
                        // Requesting 'locationAlways' opens the specific Location Permission page on Android 11+
                        final bgStatus = await Permission.locationAlways
                            .request();

                        // Fallback: If permanently denied, Android blocks the popup/redirect, so we open App Info
                        if (bgStatus.isPermanentlyDenied) {
                          bool opened = await openAppSettings();
                          if (!opened) await Geolocator.openAppSettings();
                        }
                      } else {
                        // Fallback if they deny foreground permission
                        bool opened = await openAppSettings();
                        if (!opened) await Geolocator.openAppSettings();
                      }
                    },
                    child: Text(
                      AppLocalizations.of(context)!.goToSettings,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMockOption(String text, bool isSelected) {
    return Row(
      children: [
        Icon(
          isSelected
              ? Icons.radio_button_checked
              : Icons.radio_button_unchecked,
          color: isSelected ? Colors.amber : Colors.grey,
          size: 10,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.amber : Colors.grey,
              fontSize: 8,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  void _showRideModeDialog(BuildContext screenContext) {
    showDialog(
      context: screenContext,
      builder: (ctx) {
        int selectedMode = 1; // 0 for online, 1 for offline
        bool askEveryTime = true;

        return StatefulBuilder(
          builder: (context, setState) {
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
                      AppLocalizations.of(context)!.selectRideMode,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () => setState(() => selectedMode = 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.saveOnline,
                                  style: TextStyle(color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  AppLocalizations.of(context)!.saveOnlineDesc,
                                  style: TextStyle(color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withOpacity(0.7),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            selectedMode == 0
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: selectedMode == 0
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Divider(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.2),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => setState(() => selectedMode = 1),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.saveOffline,
                                  style: TextStyle(color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  AppLocalizations.of(context)!.saveOfflineDesc,
                                  style: TextStyle(color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withOpacity(0.7),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            selectedMode == 1
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: selectedMode == 1
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Divider(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.2),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Checkbox(
                          value: askEveryTime,
                          onChanged: (val) {
                            if (val != null) setState(() => askEveryTime = val);
                          },
                          activeColor: Theme.of(context).colorScheme.primary,
                          checkColor: Theme.of(context).colorScheme.onPrimary,
                        ),
                        Text(
                          AppLocalizations.of(context)!.askEveryTime,
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: Text(
                            AppLocalizations.of(context)!.cancelBtn,
                            style: TextStyle(color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.7),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            screenContext
                                .read<RecordViaPhoneCubit>()
                                .startRecording(mode: selectedMode);
                          },
                          child: Text(
                            AppLocalizations.of(context)!.startRide,
                            style: TextStyle(color: Theme.of(context).colorScheme.primary,
                              fontSize: 16,
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
      },
    );
  }

  void _showStopRecordingDialog(BuildContext screenContext) {
    showDialog(
      context: screenContext,
      builder: (ctx) {
        String selectedLabel = AppLocalizations.of(screenContext)!.walk;
        final labels = [
          AppLocalizations.of(screenContext)!.friendsVehicle,
          AppLocalizations.of(screenContext)!.train,
          AppLocalizations.of(screenContext)!.bus,
          AppLocalizations.of(screenContext)!.auto,
          AppLocalizations.of(screenContext)!.cab,
          AppLocalizations.of(screenContext)!.cycle,
          AppLocalizations.of(screenContext)!.walk,
          AppLocalizations.of(screenContext)!.others,
        ];

        final appState = screenContext.read<AppCubit>().state;
        final deviceLabels = appState.devices
            .map(
              (d) => d['vehicleNo']?.toString() ?? d['name']?.toString() ?? '',
            )
            .where((name) => name.isNotEmpty)
            .toList();

        return StatefulBuilder(
          builder: (context, setState) {
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
                      AppLocalizations.of(context)!.selectRideLabel,
                      style: TextStyle(color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.7),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [...labels, ...deviceLabels].map((label) {
                        final isSelected = selectedLabel == label;
                        return GestureDetector(
                          onTap: () => setState(() => selectedLabel = label),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.transparent,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              label,
                              style: TextStyle(color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(
                                        context,
                                      ).colorScheme.onSurface.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(ctx);

                            final cubit = screenContext
                                .read<RecordViaPhoneCubit>();
                            final rideState = cubit.state;

                            final points = rideState.currentRidePoints;
                            final distance = rideState.rideDistance;
                            final duration = rideState.rideDuration;
                            final topSpd = rideState.topSpeed;
                            final avgSpd = duration.inSeconds > 0
                                ? (distance / (duration.inSeconds / 3600))
                                : 0.0;

                            // ── OFFLINE MODE ──
                            if (cubit.saveMode == 1) {
                              final success = await cubit.saveRideOffline(
                                tag: selectedLabel,
                                points: points,
                                distanceKm: distance,
                                duration: duration,
                                avgSpeed: avgSpd,
                                topSpeed: topSpd,
                              );

                              if (screenContext.mounted) {
                                ScaffoldMessenger.of(screenContext).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      success
                                          ? '✅ Ride saved offline successfully!'
                                          : '❌ Failed to save ride offline.',
                                    ),
                                    backgroundColor:
                                        success ? Colors.green : Colors.red,
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                              }

                              cubit.stopRecording();
                              return;
                            }

                            // ── ONLINE MODE — open playback then stop ──
                            Navigator.push(
                              screenContext,
                              MaterialPageRoute(
                                builder: (_) => RidePlaybackScreen(
                                  points: points,
                                  totalDistance: distance,
                                  totalDuration: duration,
                                  topSpeed: topSpd > 0
                                      ? topSpd
                                      : (duration.inSeconds > 0
                                            ? (distance /
                                                  (duration.inSeconds / 3600))
                                            : 0.0),
                                  avgSpeed: avgSpd,
                                  startTime: DateTime.now().subtract(
                                    duration,
                                  ),
                                ),
                              ),
                            );

                            cubit.stopRecording();
                          },
                          child: Text(
                            AppLocalizations.of(context)!.saveBtn,
                            style: TextStyle(color: Theme.of(context).colorScheme.primary,
                              fontSize: 16,
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
      },
    );
  }
}

class _KeepAliveWrapper extends StatefulWidget {
  final Widget child;
  const _KeepAliveWrapper({required this.child});

  @override
  State<_KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<_KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

class PastRide {
  final String dateStr;
  final String tag;
  final bool isFavorite;
  final double distanceKm;
  final Duration duration;
  final double avgSpeed;
  final List<LatLng> points;
  
  PastRide({
    required this.dateStr,
    required this.tag,
    required this.isFavorite,
    required this.distanceKm,
    required this.duration,
    required this.avgSpeed,
    required this.points,
  });
}

class _DateRangePickerBottomSheet extends StatefulWidget {
  final String initialActiveFilter;
  final DateTime initialStartDate;
  final DateTime initialEndDate;
  final Function(String label, DateTime start, DateTime end) onFilterSelected;

  const _DateRangePickerBottomSheet({
    required this.initialActiveFilter,
    required this.initialStartDate,
    required this.initialEndDate,
    required this.onFilterSelected,
  });

  @override
  State<_DateRangePickerBottomSheet> createState() => _DateRangePickerBottomSheetState();
}

class _DateRangePickerBottomSheetState extends State<_DateRangePickerBottomSheet> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String _activeFilter;

  @override
  void initState() {
    super.initState();
    _activeFilter = widget.initialActiveFilter;
    
    int initialIndex = 0; // "Day" tab
    if (_activeFilter == "This week" || _activeFilter == "Last week" || _activeFilter == "Last 7 days") {
      initialIndex = 1; // "Week" tab
    } else if (_activeFilter == "This month" || _activeFilter == "Last month" || _activeFilter == "Last 30 days") {
      initialIndex = 2; // "Month" tab
    } else if (_activeFilter.contains(" - ") || _activeFilter == "Custom") {
      initialIndex = 3; // "Other" tab
    }
    
    _tabController = TabController(length: 4, vsync: this, initialIndex: initialIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _selectFilter(String label, DateTime start, DateTime end) {
    widget.onFilterSelected(label, start, end);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    // Week dates
    final daysToSubtract = today.weekday - 1;
    final thisWeekStart = today.subtract(Duration(days: daysToSubtract));
    final thisWeekEnd = thisWeekStart.add(const Duration(days: 6));

    final lastWeekStart = thisWeekStart.subtract(const Duration(days: 7));
    final lastWeekEnd = lastWeekStart.add(const Duration(days: 6));

    final last7DaysStart = today.subtract(const Duration(days: 7));

    // Month dates
    final thisMonthStart = DateTime(today.year, today.month, 1);
    final thisMonthEnd = DateTime(today.year, today.month + 1, 0);

    final lastMonthStart = DateTime(today.year, today.month - 1, 1);
    final lastMonthEnd = DateTime(today.year, today.month, 0);

    final last30DaysStart = today.subtract(const Duration(days: 30));

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.only(top: 16, bottom: 24),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: theme.dividerColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TabBar(
              controller: _tabController,
              labelColor: colorScheme.primary,
              unselectedLabelColor: colorScheme.onSurface.withOpacity(0.6),
              indicatorColor: colorScheme.primary,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: "Day"),
                Tab(text: "Week"),
                Tab(text: "Month"),
                Tab(text: "Other"),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Day Tab
                  ListView(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    children: [
                      _buildOption(
                        title: "Today",
                        subtitle: DateFormat('MMM d, yyyy').format(today),
                        isSelected: _activeFilter == "Today",
                        onTap: () => _selectFilter(
                          "Today",
                          today,
                          DateTime(today.year, today.month, today.day, 23, 59, 59),
                        ),
                      ),
                      _buildOption(
                        title: "Yesterday",
                        subtitle: DateFormat('MMM d, yyyy').format(yesterday),
                        isSelected: _activeFilter == "Yesterday",
                        onTap: () => _selectFilter(
                          "Yesterday",
                          yesterday,
                          DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59),
                        ),
                      ),
                      _buildOption(
                        title: "Select custom day",
                        subtitle: "Pick a specific single date",
                        isSelected: false,
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: today,
                            firstDate: DateTime(2020),
                            lastDate: today,
                          );
                          if (picked != null) {
                            final checkDate = DateTime(picked.year, picked.month, picked.day);
                            String label = DateFormat('dd/MM').format(picked);
                            if (checkDate == today) {
                              label = "Today";
                            } else if (checkDate == yesterday) {
                              label = "Yesterday";
                            }
                            _selectFilter(
                              label,
                              picked,
                              DateTime(picked.year, picked.month, picked.day, 23, 59, 59),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  // Week Tab
                  ListView(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    children: [
                      _buildOption(
                        title: "This week",
                        subtitle: "${DateFormat('MMM d').format(thisWeekStart)} - ${DateFormat('MMM d').format(thisWeekEnd)}",
                        isSelected: _activeFilter == "This week",
                        onTap: () => _selectFilter(
                          "This week",
                          thisWeekStart,
                          thisWeekEnd,
                        ),
                      ),
                      _buildOption(
                        title: "Last week",
                        subtitle: "${DateFormat('MMM d').format(lastWeekStart)} - ${DateFormat('MMM d').format(lastWeekEnd)}",
                        isSelected: _activeFilter == "Last week",
                        onTap: () => _selectFilter(
                          "Last week",
                          lastWeekStart,
                          lastWeekEnd,
                        ),
                      ),
                      _buildOption(
                        title: "Last 7 days",
                        subtitle: "${DateFormat('MMM d').format(last7DaysStart)} - ${DateFormat('MMM d').format(today)}",
                        isSelected: _activeFilter == "Last 7 days",
                        onTap: () => _selectFilter(
                          "Last 7 days",
                          last7DaysStart,
                          today,
                        ),
                      ),
                    ],
                  ),
                  // Month Tab
                  ListView(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    children: [
                      _buildOption(
                        title: "This month",
                        subtitle: "${DateFormat('MMM d').format(thisMonthStart)} - ${DateFormat('MMM d').format(thisMonthEnd)}",
                        isSelected: _activeFilter == "This month",
                        onTap: () => _selectFilter(
                          "This month",
                          thisMonthStart,
                          thisMonthEnd,
                        ),
                      ),
                      _buildOption(
                        title: "Last month",
                        subtitle: "${DateFormat('MMM d').format(lastMonthStart)} - ${DateFormat('MMM d').format(lastMonthEnd)}",
                        isSelected: _activeFilter == "Last month",
                        onTap: () => _selectFilter(
                          "Last month",
                          lastMonthStart,
                          lastMonthEnd,
                        ),
                      ),
                      _buildOption(
                        title: "Last 30 days",
                        subtitle: "${DateFormat('MMM d').format(last30DaysStart)} - ${DateFormat('MMM d').format(today)}",
                        isSelected: _activeFilter == "Last 30 days",
                        onTap: () => _selectFilter(
                          "Last 30 days",
                          last30DaysStart,
                          today,
                        ),
                      ),
                    ],
                  ),
                  // Other Tab
                  ListView(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    children: [
                      _buildOption(
                        title: "Custom date range",
                        subtitle: _activeFilter.contains(" - ") ? _activeFilter : "Select start and end dates",
                        isSelected: _activeFilter.contains(" - "),
                        onTap: () async {
                          final picked = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime(2020),
                            lastDate: today,
                          );
                          if (picked != null) {
                            final label = "${DateFormat('dd/MM').format(picked.start)} - ${DateFormat('dd/MM').format(picked.end)}";
                            _selectFilter(
                              label,
                              picked.start,
                              picked.end,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      title: Text(
        title, ),
      subtitle: Text(
        subtitle, ),
      trailing: isSelected
          ? Icon(Icons.check, color: colorScheme.primary)
          : null,
      onTap: onTap,
    );
  }
}
