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
import 'package:trackify/app/cubit/app_cubit.dart';
import 'package:trackify/app/cubit/app_state.dart';
import 'package:trackify/core/theme/app_colors.dart';
import 'package:trackify/feature/record_via_phone/presentation/cubit/record_via_phone_cubit.dart';
import 'package:trackify/feature/record_via_phone/presentation/cubit/record_via_phone_state.dart';
import 'package:trackify/l10n/app_localizations_ar.dart';

import '../../../../l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:trackify/feature/record_via_phone/data/model/device_data_by_date_response.dart';

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

  @override
  void initState() {
    super.initState();
    _loadMapStyles();
    _fetchMobileDeviceName();

    // Pre-fetch today's history
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initCustomMarker();
      final now = DateTime.now();
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

  Future<void> _initCustomMarker() async {
    final appState = context.read<AppCubit>().state;
    final userName = appState.userData?.name ?? 'U';
    
    final int size = 120;
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Paint paint1 = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);

    final Paint paint2 = Paint()..color = Colors.amber;
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.15, paint2);

    TextPainter painter = TextPainter(textDirection: ui.TextDirection.ltr);
    painter.text = TextSpan(
      text: userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
      style: TextStyle(
          fontSize: size / 2.0, color: Colors.black, fontWeight: FontWeight.bold),
    );
    painter.layout();
    painter.paint(
      canvas,
      Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
    );

    final ui.Image img = await pictureRecorder.endRecording().toImage(size, size);
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
      return device['name'] ?? device['deviceName'] ?? device['vehicleNo'] ?? 'Device ${widget.imei}';
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
    } catch (e) {
      debugPrint("Error loading map styles: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
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
                // Animate History map to fit bounds (non-blocking)
                _pastMapController.future.then((controller) {
                  if (!mounted) return;
                  final bounds = _getBounds(points);
                  controller.animateCamera(
                    CameraUpdate.newLatLngBounds(bounds, 50),
                  );
                });

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
            title: Text(
              l10n.phoneTracking,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
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
              tabs: const [
                Tab(text: "Record Rides"),
                Tab(text: "Past Rides"),
                Tab(text: "Statistics"),
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
            markers.add(
              Marker(
                markerId: const MarkerId("last_api_pos"),
                position: lastPos,
                infoWindow: const InfoWindow(title: 'Your location'),
                icon: _customMarkerIcon ?? BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure,
                ),
              ),
            );
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
                              onPressed: () {},
                              child: Icon(Icons.share, color: Theme.of(context).iconTheme.color ?? Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            FloatingActionButton(
                              heroTag: 'btnGmaps',
                              mini: true,
                              backgroundColor: Theme.of(context).cardColor,
                              onPressed: () {},
                              child: Icon(Icons.pin_drop, color: Theme.of(context).iconTheme.color ?? Colors.grey),
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
                              onPressed: () {},
                              child: Icon(Icons.map_outlined, color: Theme.of(context).iconTheme.color ?? Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            FloatingActionButton(
                              heroTag: 'btnLocation',
                              mini: true,
                              backgroundColor: Theme.of(context).cardColor,
                              onPressed: () {},
                              child: Icon(Icons.my_location, color: Theme.of(context).iconTheme.color ?? Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            FloatingActionButton(
                              heroTag: 'btnFullscreen',
                              mini: true,
                              backgroundColor: Theme.of(context).cardColor,
                              onPressed: () {},
                              child: Icon(Icons.fullscreen, color: Theme.of(context).iconTheme.color ?? Colors.grey),
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
    
    String lastUpdatedText = "Last updated: Just now";
    final currentLoc = appState.currentLocation;
    if (currentLoc != null) {
        final timeFormat = DateFormat('h:mm a');
        final formattedTime = timeFormat.format(currentLoc.timestamp);
        lastUpdatedText = "Last updated: $formattedTime, Today"; 
    }

    final bool showStats = state.isRecording || state.rideDuration != Duration.zero;

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
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                    )
                  ]
                ),
                alignment: Alignment.center,
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    color: Colors.black,
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
                      'Your Phone\'s Location',
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
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
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
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              TextSpan(
                                text: ' km',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ]
                          ),
                        ),
                        Text(
                          'Distance',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
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
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(Icons.keyboard_arrow_up, size: 16, color: Theme.of(context).colorScheme.onSurface),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(Icons.keyboard_arrow_down, size: 16, color: Theme.of(context).colorScheme.onSurface),
                        ),
                      ],
                    )
                  ],
                )
            ],
          ),
          if (showStats) ...[
            const SizedBox(height: 16),
            Divider(color: Colors.grey.withOpacity(0.2)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNewStatItem('Distance', state.rideDistance.toStringAsFixed(2), 'km'),
                _buildNewStatItem('Duration', _formatDurationNew(state.rideDuration), ''),
                _buildNewStatItem('Avg Speed', state.currentSpeed.toStringAsFixed(2), 'km/hr'),
                _buildNewStatItem('Top Speed', (state.currentSpeed * 1.2).toStringAsFixed(2), 'km/hr'),
              ],
            ),
          ]
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
            ]
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
    String hours = duration.inHours > 0 ? '${duration.inHours}h ' : '';
    String minutes = '${duration.inMinutes.remainder(60)}m ';
    String seconds = '${duration.inSeconds.remainder(60)}s';
    return '$hours$minutes$seconds';
  }

  Widget _buildRecordButton(RecordViaPhoneState state) {
    final isRecording = state.isRecording;
    return GestureDetector(
      onTap: () {
        if (isRecording) {
          context.read<RecordViaPhoneCubit>().stopRecording();
        } else {
          _handleStartRecording();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
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
              isRecording ? "Stop Ride Recording" : "Start Ride Recording",
              style: TextStyle(
                color: isRecording ? Colors.red : Theme.of(context).colorScheme.primary,
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
    return Stack(
      children: [
        BlocBuilder<RecordViaPhoneCubit, RecordViaPhoneState>(
          builder: (context, state) {
            Set<Polyline> polylines = {};
            Set<Marker> markers = {};

            if (state.polylines != null && state.polylines!.isNotEmpty) {
              final originalPolyline = state.polylines!.first;
              final points = originalPolyline.points;

              if (points.isNotEmpty) {
                polylines = {
                  originalPolyline.copyWith(
                    colorParam: Theme.of(context).colorScheme.primary,
                    widthParam: 5,
                  ),
                };

                markers = {
                  Marker(
                    markerId: MarkerId(l10n.start),
                    position: points.first,
                    infoWindow: InfoWindow(title: l10n.start),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueGreen,
                    ),
                  ),
                  Marker(
                    markerId: MarkerId(l10n.end),
                    position: points.last,
                    infoWindow: InfoWindow(title: l10n.end),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed,
                    ),
                  ),
                };
              }
            }
            return _buildMap(
              controller: _pastMapController,
              polylines: polylines,
              markers: markers,
            );
          },
        ),
        _buildHistoryFilterBar(),
      ],
    );
  }

  Widget _buildHistoryFilterBar() {
    final l10n = AppLocalizations.of(context)!;

    final filters = [l10n.today, l10n.weekly, l10n.monthly, l10n.custom];
    return Positioned(
      bottom: 20,
      left: 10,
      right: 10,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withOpacity(0.95),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: filters.map((f) => _buildFilterChip(f)).toList(),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return InkWell(
      onTap: () async {
        final now = DateTime.now();
        DateTime start = now, end = now;
        if (label == l10n.today) {
          start = DateTime(now.year, now.month, now.day);
        } else if (label == l10n.weekly) {
          start = now.subtract(const Duration(days: 7));
        } else if (label == l10n.monthly) {
          start = DateTime(now.year, now.month - 1, now.day);
        } else if (label == l10n.custom) {
          final picked = await showDateRangePicker(
            context: context,
            firstDate: DateTime(2020),
            lastDate: now,
          );
          if (picked != null) {
            start = picked.start;
            end = picked.end;
          }
        }

        context.read<RecordViaPhoneCubit>().fetchDeviceDataByDate(
          imei: widget.imei,
          startDate: DateFormat('yyyy-MM-dd').format(start),
          endDate: DateFormat('yyyy-MM-dd').format(end),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  // --- Statistics View ---
  Map<String, dynamic> _calculateStats(RecordViaPhoneState state) {
    if (state.data.isEmpty) {
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

    final data = state.data;
    double totalDistance = 0.0;
    double topSpeed = 0.0;
    double sumSpeed = 0.0;
    int movingPointsCount = 0;
    int rides = 0;
    Duration drivingTime = const Duration();
    int safetyDeduction = 0;

    DataByDate? prevPoint;
    DateTime? prevTime;

    final sortedData = List<DataByDate>.from(data);
    sortedData.sort((a, b) {
      final aDt = a.dt ?? '';
      final bDt = b.dt ?? '';
      final dtCompare = aDt.compareTo(bDt);
      if (dtCompare != 0) return dtCompare;

      final aTm = a.tm ?? '';
      final bTm = b.tm ?? '';
      return aTm.compareTo(bTm);
    });

    for (var point in sortedData) {
      final lat = double.tryParse(point.lt ?? '');
      final lng = double.tryParse(point.lg ?? '');
      final speed = point.sp ?? 0.0;

      DateTime? currTime;
      if (point.dt != null && point.tm != null) {
        currTime = DateTime.tryParse('${point.dt} ${point.tm}');
      }

      if (speed > topSpeed) topSpeed = speed;

      if (speed > 80) safetyDeduction += 1;

      if (speed > 5.0) {
        sumSpeed += speed;
        movingPointsCount++;
      }

      if (lat != null && lng != null && prevPoint != null) {
        final prevLat = double.tryParse(prevPoint.lt ?? '');
        final prevLng = double.tryParse(prevPoint.lg ?? '');

        if (prevLat != null && prevLng != null) {
          final dist = Geolocator.distanceBetween(prevLat, prevLng, lat, lng);
          if (dist > 5.0 && dist < 50000) {
            totalDistance += (dist / 1000);
          }
        }
      }

      if (currTime != null && prevTime != null) {
        final diff = currTime.difference(prevTime);
        if (diff.inMinutes < 60) {
          if (speed > 5.0) {
            drivingTime += diff;
          }
        } else {
          rides++;
        }
      }

      prevPoint = point;
      prevTime = currTime;
    }

    if (rides == 0 && sortedData.isNotEmpty) rides = 1;

    double avgSpeed = movingPointsCount > 0
        ? sumSpeed / movingPointsCount
        : 0.0;
    double fuel = totalDistance * 0.08;
    int safetyScore = (100 - (safetyDeduction * 0.5)).round().clamp(0, 100);

    return {
      'distance': totalDistance,
      'drivingTime': drivingTime,
      'topSpeed': topSpeed,
      'avgSpeed': avgSpeed,
      'totalRides': rides,
      'fuel': fuel,
      'safetyScore': safetyScore,
    };
  }

  Widget _buildStatisticsView() {
    return BlocBuilder<RecordViaPhoneCubit, RecordViaPhoneState>(
      builder: (context, state) {
        final stats = _calculateStats(state);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
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
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
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
  }) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, appState) {
        final currentPos = appState.currentLocation;
        final themeMode = appState.themeMode;

        if (currentPos == null && initialTarget == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final target =
            initialTarget ?? LatLng(currentPos!.latitude, currentPos.longitude);

        return GoogleMap(
          initialCameraPosition: CameraPosition(target: target, zoom: 15),
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          mapType: MapType.normal,
          polylines: polylines,
          markers: markers,
          onMapCreated: (GoogleMapController googleMapController) async {
            if (!controller.isCompleted) {
              controller.complete(googleMapController);
            }

            // Apply theme-aware style
            final style = (themeMode == ThemeMode.dark)
                ? _darkMapStyle
                : _lightMapStyle;

            if (style != null) {
              googleMapController.setMapStyle(style);
            } else {
              // Fallback to system brightness
              final brightness = MediaQuery.of(context).platformBrightness;
              googleMapController.setMapStyle(
                brightness == Brightness.dark ? _darkMapStyle : _lightMapStyle,
              );
            }
          },
        );
      },
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
                const Text(
                  'Trackify ride recording feature only work correctly if it can access your location “all the time”',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Go to settings and select “Allow all the time”',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
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
                      const Text(
                        'Location Permissions',
                        style: TextStyle(
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
                      _buildMockOption('Allow all the time', true),
                      const SizedBox(height: 6),
                      _buildMockOption('Only while using the app', false),
                      const SizedBox(height: 6),
                      _buildMockOption('Ask every time', false),
                      const SizedBox(height: 6),
                      _buildMockOption('Don\'t allow', false),
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
                        whenInUse = await Permission.locationWhenInUse.request();
                      }
                      
                      if (whenInUse.isGranted) {
                        // Requesting 'locationAlways' opens the specific Location Permission page on Android 11+
                        final bgStatus = await Permission.locationAlways.request();
                        
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
                    child: const Text(
                      'Go to Settings',
                      style: TextStyle(
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
        int selectedMode = 0; // 0 for online, 1 for offline
        bool askEveryTime = true;

        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: const Color(0xFF2C2C2C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select ride mode',
                      style: TextStyle(
                        color: Colors.white,
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
                                const Text(
                                  'Save online',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Rides are saved online. You can login from any phone to fetch your past rides',
                                  style: TextStyle(color: Colors.white70, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            selectedMode == 0 ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                            color: selectedMode == 0 ? Colors.amber : Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Divider(color: Colors.white.withOpacity(0.2)),
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
                                const Text(
                                  'Save offline',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Rides are saved on this phone only',
                                  style: TextStyle(color: Colors.white70, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            selectedMode == 1 ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                            color: selectedMode == 1 ? Colors.amber : Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Divider(color: Colors.white.withOpacity(0.2)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Checkbox(
                          value: askEveryTime,
                          onChanged: (val) {
                            if (val != null) setState(() => askEveryTime = val);
                          },
                          activeColor: Colors.amber,
                          checkColor: Colors.black,
                        ),
                        const Text(
                          'Ask every time',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 16),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            screenContext.read<RecordViaPhoneCubit>().startRecording();
                          },
                          child: const Text(
                            'Start ride',
                            style: TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold),
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
