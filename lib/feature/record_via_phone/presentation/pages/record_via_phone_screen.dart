import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:trackify/feature/record_via_phone/data/model/device_data_by_date_response.dart';class RecordViaPhoneScreen extends StatefulWidget {
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
  @override
  void initState() {
    super.initState();
    _loadMapStyles();

    // Pre-fetch today's history
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final now = DateTime.now();
      final today = DateFormat('yyyy-MM-dd').format(now);
      context.read<RecordViaPhoneCubit>().fetchDeviceDataByDate(
        imei: widget.imei,
        startDate: today,
        endDate: today,
      );
    });
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
                  curr.currentRidePoints.length != prev.currentRidePoints.length),
          listener: (context, state) {
            if (state is MapDataByDateLoaded &&
                state.polylines != null &&
                state.polylines!.isNotEmpty) {
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
            } else if (state.isRecording && state.currentRidePoints.isNotEmpty) {
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
              tabs:  [
                Tab(text: l10n.liveRecord),
                Tab(text: l10n.history),
                Tab(text: l10n.state),
              ],
            ),
          ),
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildLiveRecordView(),
              _buildHistoryView(),
              _buildStatisticsView(),
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

        if (state is MapDataByDateLoaded &&
            state.polylines != null &&
            state.polylines!.isNotEmpty) {
          final points = state.polylines!.first.points;
          if (points.isNotEmpty) {
            lastPos = points.last;
            markers.add(
              Marker(
                markerId: const MarkerId("last_api_pos"),
                position: lastPos,
                infoWindow:  InfoWindow(title: l10n.lastReportedPosition),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure,
                ),
              ),
            );
          }
        }

        return Stack(
          children: [
            _buildMap(
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
            _buildRecordingOverlay(state),
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Center(child: _buildRecordButton(state)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRecordingOverlay(RecordViaPhoneState state) {
    if (!state.isRecording && state.rideDuration == Duration.zero)
      return const SizedBox.shrink();

    return Positioned(
      top: 20,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
        l10n.time,
              _formatDuration(state.rideDuration),
              Icons.timer_outlined,
            ),
            _buildStatItem(
              l10n.distance,
              "${state.rideDistance.toStringAsFixed(2)} km",
              Icons.route_outlined,
            ),
            _buildStatItem(
              l10n.speed,
              "${state.currentSpeed.toStringAsFixed(1)} km/h",
              Icons.speed,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildRecordButton(RecordViaPhoneState state) {
    final isRecording = state.isRecording;
    return GestureDetector(
      onTap: () {
        if (isRecording) {
          context.read<RecordViaPhoneCubit>().stopRecording();
        } else {
          context.read<RecordViaPhoneCubit>().startRecording();
        }
      },
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          color: isRecording
              ? Colors.red
              : Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color:
                  (isRecording
                          ? Colors.red
                          : Theme.of(context).colorScheme.primary)
                      .withOpacity(0.4),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(
          isRecording ? Icons.stop_rounded : Icons.fiber_manual_record_rounded,
          color: Colors.white,
          size: 40,
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

            if (state is MapDataByDateLoaded &&
                state.polylines != null &&
                state.polylines!.isNotEmpty) {
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
                    markerId:  MarkerId(l10n.start),
                    position: points.first,
                    infoWindow:   InfoWindow(title: l10n.start),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueGreen,
                    ),
                  ),
                  Marker(
                    markerId:  MarkerId(l10n.end),
                    position: points.last,
                    infoWindow:  InfoWindow(title: l10n.end),
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

    final filters = [
      l10n.today,
      l10n.weekly,
      l10n.monthly,
      l10n.custom,
    ];
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
        } else if (label ==l10n.monthly) {
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
          imei: '860710085959719',
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
    if (state is! MapDataByDateLoaded || state.data.isEmpty) {
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
      final aDate = '${a.dt} ${a.tm}';
      final bDate = '${b.dt} ${b.tm}';
      return aDate.compareTo(bDate);
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

    double avgSpeed = movingPointsCount > 0 ? sumSpeed / movingPointsCount : 0.0;
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

        final target = initialTarget ??
            LatLng(currentPos!.latitude, currentPos.longitude);

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
}
