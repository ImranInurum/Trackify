import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trackify/app/cubit/app_cubit.dart';
import 'package:trackify/app/cubit/app_state.dart';
import 'package:trackify/core/widgets/custom_card.dart';

import '../../../../core/config/style_manager.dart';
import '../../../../core/widgets/draggable_app_bar.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../cubit/map_cubit.dart';
import '../cubit/map_state.dart';
import 'full_screen_map.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          context.read<MapCubit>().fetchDevices({
            'user_id': context.read<AppCubit>().state.userData?.id,
          });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(children: [appBarWidget(), _body()]));
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Column(children: [_mapWidget(), _exploreMoreWidget()]),
    );
  }

  Widget appBarWidget() {
    return BlocBuilder<MapCubit, MapState>(
      builder: (context, mapState) {
        return DraggableAppBar(
          devices: mapState is MapLoaded ? mapState.deviceList.devices : null,
        );
      },
    );
  }

  Widget _mapWidget() {
    return CustomCard(
      innerPadding: 10,
      elevation: 0.7,
      height: MediaQuery.of(context).size.height * 0.3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Record Ride",
            style: getRegularStyle(color: Theme.of(context).colorScheme.primaryContainer),
          ),
          Text(
            "Make your phone a GPS Tracking device",
            style: getMediumStyle(color: Theme.of(context).colorScheme.tertiaryFixed),
          ),
          SizedBox(height: 5),
          BlocConsumer<AppCubit, AppState>(
            listenWhen: (prev, curr) =>
                prev.currentLocation != curr.currentLocation &&
                curr.currentLocation != null,

            listener: (BuildContext context, AppState state) async {
              if (!_followUser) return;

              final pos = state.currentLocation!;
              final controller = await _controller.future;

              controller.animateCamera(
                CameraUpdate.newLatLng(LatLng(pos.latitude, pos.longitude)),
              );
            },
            buildWhen: (previous, current) =>
                previous.currentLocation != current.currentLocation,
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
          GradientButton(
            title: "Go to Dashboard",
            subtitle: "See full map",
            icon: Icons.arrow_forward,
            showBorder: true,
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => FullScreenMap())),
          ),
        ],
      ),
    );
  }

  Widget _exploreMoreWidget() {
    final options = [
      {"icon": Icons.qr_code, "label": "ReachMe Sticker", "locked": false},
      {"icon": Icons.local_offer_outlined, "label": "Products", "locked": false},
      {"icon": Icons.local_gas_station_outlined, "label": "Fuel Logs", "locked": false},
      {"icon": Icons.share_outlined, "label": "Location Sharing", "locked": false},
      {"icon": Icons.folder_open_outlined, "label": "Document Folder", "locked": false},
      {"icon": Icons.call, "label": "Voice Monitoring", "locked": true},
      {"icon": Icons.power_settings_new, "label": "Remote Engine OFF", "locked": true},
      {"icon": Icons.network_cell, "label": "Network Booster", "locked": true},
      {"icon": Icons.sos, "label": "Emergency", "locked": true},
      {"icon": Icons.speed, "label": "Overspeed Alert", "locked": true},
      {"icon": Icons.location_on_outlined, "label": "Geo-fence Alert", "locked": true},
      {"icon": Icons.more_horiz, "label": "More", "locked": false},
    ];

    return CustomCard(
      innerPadding: 10,
      elevation: 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Explore More",
            style: getRegularStyle(color: Theme.of(context).colorScheme.primaryContainer),
          ),
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.9,
            ),
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options[index];
              final locked = option["locked"] as bool;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    option["icon"] as IconData,
                    size: 28,
                    color: locked
                        ? Colors.grey.shade400
                        : Theme.of(context).colorScheme.primaryContainer,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    option["label"] as String,
                    textAlign: TextAlign.center,
                    style: getRegularStyle(
                      color: locked
                          ? Colors.grey.shade400
                          : Theme.of(context).colorScheme.tertiaryFixed,
                      fontSize: 11,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
