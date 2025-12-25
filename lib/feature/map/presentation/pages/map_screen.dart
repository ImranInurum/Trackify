import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trackify/app/cubit/app_cubit.dart';
import 'package:trackify/app/cubit/app_state.dart';
import 'package:trackify/core/widgets/custom_card.dart';
import 'package:trackify/core/widgets/option_tile.dart';
import 'package:trackify/feature/map/presentation/pages/full_screen_map.dart';

import '../../../../core/widgets/draggable_app_bar.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  bool _followUser = true;
  String? _lightMapStyle;
  String? _darkMapStyle;

  @override
  void initState() {
    super.initState();
    _loadMapStyles();
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
      // Follow system theme
      final brightness = MediaQuery.of(context).platformBrightness;
      await controller.setMapStyle(
        brightness == Brightness.dark ? _darkMapStyle : _lightMapStyle,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopDraggableAppBar(
        title: "Record Ride",
        subtitle: "Make your phone a GPS Tracking device",
      ),
        body: _body());
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: SafeArea(
        top: true,
          child: Column(children: [_mapWidget()])),
    );
  }

  Widget _mapWidget() {
    return CustomCard(
      innerPadding: 16,
      elevation: 1,
      height: MediaQuery.of(context).size.height * 0.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Record Ride",style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: 5),
          Text("Make your phone a GPS Tracking device",style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 5),
          BlocConsumer<AppCubit, AppState>(
            listenWhen: (prev, curr) =>
                prev.currentLocation != curr.currentLocation && curr.currentLocation != null,

            listener: (BuildContext context, AppState state) async {
              if (!_followUser) return;

              final pos = state.currentLocation!;
              final controller = await _controller.future;

              controller.animateCamera(CameraUpdate.newLatLng(LatLng(pos.latitude, pos.longitude)));
            },
            buildWhen: (previous, current) => previous.currentLocation != current.currentLocation,
            builder: (context, state) {
              final currentPos = state.currentLocation;

              if (currentPos == null) {
                return const Center(child: CircularProgressIndicator());
              }
              final cameraPosition = CameraPosition(
                target: LatLng(currentPos.latitude, currentPos.longitude),
                zoom: 16,
              );

              return Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(12),
                  child: GoogleMap(
                    initialCameraPosition: cameraPosition,
                    myLocationEnabled: true,
                    zoomControlsEnabled: false,
                    onMapCreated: (GoogleMapController controller) async {
                      _controller.complete(controller);
                      await _applyMapTheme(controller, state.themeMode);
                    },
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 10),
          OptionTile(
            title: "Go to Dashboard",
              showDivider: false, leading: Icon(Icons.map_outlined), subtitle: 'See full map',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => FullScreenMap(),)),
            ),
        ],
      ),
    );
  }
}
