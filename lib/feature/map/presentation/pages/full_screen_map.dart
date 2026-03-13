import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trackify/core/theme/app_colors.dart';

import '../../../../app/cubit/app_cubit.dart';
import '../cubit/map_cubit.dart';
import '../cubit/map_state.dart';

class FullScreenMap extends StatefulWidget {
  const FullScreenMap({super.key});

  @override
  State<FullScreenMap> createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  String? _lightMapStyle;
  String? _darkMapStyle;

  @override
  void initState() {
    super.initState();
    _loadMapStyles();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          context.read<MapCubit>().fetchDeviceDataByDate(
            imei: '860710085959719',
            startDate: DateTime.now().toIso8601String(),
            endDate: DateTime.now().toIso8601String(),
          );
        }
      });
    });
  }

  Future<void> _loadMapStyles() async {
    _lightMapStyle = await rootBundle.loadString('assets/map_styles/light_map.json');
    _darkMapStyle = await rootBundle.loadString('assets/map_styles/dark_map.json');
  }

  Future<void> _applyMapTheme(GoogleMapController controller, ThemeMode themeMode) async {
    if (themeMode == ThemeMode.dark) {
      await controller.setMapStyle(_darkMapStyle);
    } else if (themeMode == ThemeMode.light) {
      await controller.setMapStyle(_lightMapStyle);
    } else {
      final brightness = MediaQuery.of(context).platformBrightness;
      await controller.setMapStyle(
        brightness == Brightness.dark ? _darkMapStyle : _lightMapStyle,
      );
    }
  }

  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    double x0 = list.first.latitude,
        x1 = list.first.latitude,
        y0 = list.first.longitude,
        y1 = list.first.longitude;
    for (LatLng latLng in list) {
      if (latLng.latitude > x1) x1 = latLng.latitude;
      if (latLng.latitude < x0) x0 = latLng.latitude;
      if (latLng.longitude > y1) y1 = latLng.longitude;
      if (latLng.longitude < y0) y0 = latLng.longitude;
    }
    return LatLngBounds(northeast: LatLng(x1, y1), southwest: LatLng(x0, y0));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Record via Phone"),
          centerTitle: false,
          bottom:  TabBar(
            labelColor: Theme.of(context).colorScheme.primaryContainer,
            tabs: [
              Tab(text: "Ride Records"),
              Tab(text: "Past Rides"),
              Tab(text: "Statistics"),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _recordRides(),
            _pastRides(),
            Center(child: Text("Placeholder for Settings")),
          ],
        ),
      ),
    );
  }

  Widget _recordRides() {
    return Stack(children: [_mapWidget()]);
  }

  Widget _pastRides() {
    return Stack(children: [_mapWidget(), _filterChipBar()]);
  }

  Widget _mapWidget() {
    return BlocConsumer<MapCubit, MapState>(
      listener: (BuildContext context, MapState mapState) async {},
      builder: (context, mapState) {
        final currentPos = context.read<AppCubit>().state.currentLocation;
        if (currentPos == null) {
          return const Center(child: CircularProgressIndicator());
        }
        Set<Polyline> polylines = {};
        if (mapState is MapDataByDateLoaded && mapState.polylines != null) {
          polylines = mapState.polylines!;
        }

        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(currentPos.latitude, currentPos.longitude),
            zoom: 16,
          ),
          myLocationEnabled: true,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: false,
          polylines: polylines,
          onMapCreated: (GoogleMapController controller) async {
            _controller.complete(controller);
            if (mapState is MapDataByDateLoaded && mapState.polylines != null) {
              final polyline = mapState.polylines?.first;
              if (polyline?.points != null) {
                controller.animateCamera(
                  CameraUpdate.newLatLngBounds(
                    _boundsFromLatLngList(polyline!.points),
                    50,
                  ),
                );
              }
            }
          },
        );
      },
    );
  }

  Widget _filterChipBar() {
    final filters = ['Today', 'Weekly', 'Monthly', 'Custom'];
    String selectedFilter = 'Today';
    DateTimeRange? customRange;

    return StatefulBuilder(
      builder: (context, setState) {
        Future<void> _onSelect(String label) async {
          setState(() => selectedFilter = label);

          final now = DateTime.now();
          DateTime start, end;

          switch (label) {
            case 'Today':
              start = DateTime(now.year, now.month, now.day);
              end = now;
              break;
            case 'Weekly':
              start = now.subtract(const Duration(days: 7));
              end = now;
              break;
            case 'Monthly':
              start = DateTime(now.year, now.month - 1, now.day);
              end = now;
              break;
            case 'Custom':
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(now.year - 1),
                lastDate: now,
                initialDateRange:
                    customRange ??
                    DateTimeRange(start: now.subtract(const Duration(days: 7)), end: now),
                // builder: (context,child){
                //   return Theme(
                //     data: Theme.of(context).copyWith(
                //       secondaryHeaderColor: Colors.white,
                //       colorScheme: ColorScheme.dark(
                //           primary: AppColors.cardDark,        // Header + selected range
                //           onPrimary: Colors.white,     // Text on header
                //           surface: Colors.black,       // Calendar background
                //           onSurface: Colors.white,     // Calendar text  primary: primary,
                //       )
                //       ,dialogBackgroundColor: Theme.of(context).colorScheme.background,
                //     ),
                //     child: child!,
                //   );
                // }
              );
              if (picked == null) return;
              start = picked.start;

              end = picked.end;
              customRange = picked;
              break;
            default:
              return;
          }

          // Trigger your cubit fetch
          context.read<MapCubit>().fetchDeviceDataByDate(
            imei: '860710085959719',
            startDate: start.toIso8601String(),
            endDate: end.toIso8601String(),
          );
        }

        return Align(
          alignment: AlignmentGeometry.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: filters.map((label) {
              final isSelected = selectedFilter == label;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                child: ChoiceChip(
                  label: Text(label),
                  selected: isSelected,
                  onSelected: (_) => _onSelect(label),
                  selectedColor: Theme.of(context).colorScheme.primaryContainer,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? Theme.of(context).colorScheme.surface
                        : Theme.of(context).colorScheme.primaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
