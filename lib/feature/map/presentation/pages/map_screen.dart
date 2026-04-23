import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trackify/app/cubit/app_cubit.dart';
import 'package:trackify/app/cubit/app_state.dart';
import 'package:trackify/core/constants/app_images.dart';
import 'package:trackify/core/theme/app_colors.dart';
import 'package:trackify/core/utils/map_utils.dart';
import 'package:trackify/core/widgets/bouncing_widget.dart';
import 'package:trackify/core/widgets/draggable_app_bar.dart';
import 'package:trackify/feature/add_vehicle_and_device/choice_selector.dart';
import 'package:trackify/feature/map/data/entity/user_vehicles.dart';
import 'package:trackify/feature/map/presentation/pages/full_screen_map.dart';
import 'package:trackify/feature/my_garage/presentation/view/my_garage_screen.dart';
import 'package:trackify/feature/reach_me_sticker/presentation/screens/reach_me_sticker_screen.dart';
import 'package:trackify/feature/record_via_phone/presentation/pages/record_via_phone_screen.dart';
import '../../../../core/utils/shared_preferences.dart';
import '../../../location_sharing/presentation/pages/location_sharing_screen.dart';
import '../../../notifications/presentation/screen/notification_list_screen.dart';

import '../../../../core/config/style_manager.dart';
import '../cubit/map_cubit.dart';
import '../cubit/map_state.dart';
import '../../../../l10n/app_localizations.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  String? _lightMapStyle;
  String? _darkMapStyle;
  Vehicles? _selectedDevice;
  BitmapDescriptor? _customMarker;
  final prefs = AppPreference.instance;

  @override
  void initState() {
    super.initState();
    _loadMapStyles();
    _loadCustomMarker();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          context.read<MapCubit>().fetchVehicles();
        }
      });
    });
  }

  Future<void> _loadMapStyles() async {
    _lightMapStyle = await MapUtils.loadStyle(
      'assets/map_styles/light_map.json',
    );
    _darkMapStyle = await MapUtils.loadStyle('assets/map_styles/dark_map.json');
  }

  Future<void> _loadCustomMarker() async {
    final Uint8List markerIcon = await MapUtils.getBytesFromAsset(
      AppImages.bikeImage,
      100,
    );
    if (mounted) {
      setState(() {
        _customMarker = BitmapDescriptor.fromBytes(markerIcon);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: MultiBlocListener(
        listeners: [
          BlocListener<MapCubit, MapState>(listener: (context, state) {}),
          BlocListener<AppCubit, AppState>(
            listenWhen: (prev, curr) =>
                prev.mapStyle != curr.mapStyle ||
                prev.mapType != curr.mapType ||
                prev.isTrafficEnabled != curr.isTrafficEnabled,
            listener: (context, state) async {
              if (_controller.isCompleted) {
                final controller = await _controller.future;
                String? style;
                if (state.mapStyle == 'Dark') {
                  style = _darkMapStyle;
                } else if (state.mapStyle == 'Light') {
                  style = _lightMapStyle;
                } else if (state.mapStyle == 'Simple') {
                  style = await MapUtils.loadStyle(
                    'assets/map_styles/light_map.json',
                  );
                } else if (state.mapStyle == 'Satellite') {
                  style = null;
                }

                await MapUtils.setStyle(controller, style);
              }
            },
          ),
        ],
        child: BlocBuilder<MapCubit, MapState>(
          builder: (context, state) {
            final List<Vehicles> vehicles = state is MapLoaded
                ? (state.vehicleList.vehicles ?? <Vehicles>[])
                : <Vehicles>[];

            // Initialize selected device if not set
            if (_selectedDevice == null && vehicles.isNotEmpty) {
              _selectedDevice = vehicles.first;

            }

            final l10n = AppLocalizations.of(context)!;
            final topSpacing = MediaQuery.of(context).padding.top + 78;

            return Stack(
              children: [
                Positioned.fill(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(height: topSpacing),
                        _buildMapSection(),
                        _buildPromoBanner(),
                        _buildExploreMore(_selectedDevice),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                DraggableAppBar(
                  vehicles: vehicles,
                  selectedDevice: _selectedDevice,
                  collapsedTrailing: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const NotificationListScreen(),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.notifications_none_rounded,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 26,
                    ),
                  ),
                  expandedTrailing: IconButton(
                    alignment: Alignment.center,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MyGarageScreen(),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.settings,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 20,
                    ),
                  ),
                  onAddVehicle: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ChoiceSelector(),
                      ),
                    );
                  },
                  onDeviceTap: (device) async {
                    await prefs.set(
                      key: AppPreference.IMEI,
                      value: device.imei ?? '',
                    );
                    setState(() {
                      _selectedDevice = device;
                    });
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMapSection() {
    final l10n = AppLocalizations.of(context)!;
    return BouncingWidget(
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => FullScreenMap()));
      },
      child: Container(
        height: 300,
        margin: const EdgeInsets.all(16),
        padding: EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: BlocBuilder<AppCubit, AppState>(
          builder: (context, appState) {
            final currentPos = appState.currentLocation;
            if (currentPos == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    child: IgnorePointer(
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            currentPos.latitude,
                            currentPos.longitude,
                          ),
                          zoom: 15,
                        ),
                        myLocationEnabled: false,
                        zoomControlsEnabled: false,
                        myLocationButtonEnabled: false,
                        scrollGesturesEnabled: false,
                        zoomGesturesEnabled: false,
                        tiltGesturesEnabled: false,
                        rotateGesturesEnabled: false,
                        mapType: appState.mapType == 'satellite'
                            ? MapType.satellite
                            : MapType.normal,
                        trafficEnabled: appState.isTrafficEnabled,
                        markers: {
                          if (currentPos != null)
                            Marker(
                              markerId: const MarkerId('current_location'),
                              position: LatLng(
                                currentPos.latitude,
                                currentPos.longitude,
                              ),
                              icon:
                                  _customMarker ??
                                  BitmapDescriptor.defaultMarker,
                              anchor: const Offset(0.5, 0.5),
                            ),
                        },
                        onMapCreated: (GoogleMapController controller) async {
                          if (!_controller.isCompleted) {
                            _controller.complete(controller);
                          }

                          final appState = context.read<AppCubit>().state;

                          if (_darkMapStyle == null || _lightMapStyle == null) {
                            await _loadMapStyles();
                          }

                          String? style;
                          if (appState.mapStyle == 'Dark') {
                            style = _darkMapStyle;
                          } else if (appState.mapStyle == 'Light') {
                            style = _lightMapStyle;
                          } else if (appState.mapStyle == 'Simple') {
                            style = await MapUtils.loadStyle(
                              'assets/map_styles/light_map.json',
                            );
                          }

                          await MapUtils.setStyle(controller, style);
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    children: [
                      Text(
                        l10n.todayText,
                        style: getBoldStyle(
                          color: AppColors.paletteGreen,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: _buildStatsRow(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<MapCubit, MapState>(
      builder: (context, state) {
        String distance = "0.0 ${l10n.km}";
        String speed = "0 ${l10n.kmh}";
        String duration = "0${l10n.minutesShort} 0${l10n.secondsShort}";
        String topSpeed = "0 ${l10n.kmh}";

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                children: [
                  _buildStatItem(l10n.distanceLabel, distance),
                  _buildStatItem(l10n.rideDuration, duration),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  _buildStatItem(l10n.speedLabel, speed),
                  _buildStatItem(l10n.topSpeed, topSpeed),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          l10n.labelColon(label),
          style: getRegularStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            fontSize: 11,
          ),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            value,
            style: getThinStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 13,
            ).copyWith(fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildPromoBanner() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.5),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            height: 44,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: 0.63,
                  strokeWidth: 3.5,
                  backgroundColor: Theme.of(context).dividerColor,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  l10n.progressPercentage("63"),
                  style: getBoldStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      l10n.getMoreOutOfTrackify,
                      style: getBoldStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 14,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Theme.of(context).colorScheme.primary,
                      size: 18,
                    ),
                  ],
                ),
                Text(
                  l10n.discoverMoreDesc,
                  style: getRegularStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.close,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            size: 18,
          ),
        ],
      ),
    );
  }

  Widget _buildExploreMore(Vehicles? selectedDevice) {
    final l10n = AppLocalizations.of(context)!;
    final options = [
      {
        "icon": Icons.qr_code_scanner,
        "label": l10n.reachMeSticker.replaceAll(' ', '\n'),
        "badge": l10n.exploreNow,
      },
      {
        "icon": Icons.phone_android_rounded,
        "label": l10n.recordViaPhone.replaceAll(' ', '\n'),
        "badge": null,
      },
      {
        "icon": Icons.handyman_outlined,
        "label": l10n.serviceLogs.replaceAll(' ', '\n'),
        "badge": null,
      },
      {
        "icon": Icons.share_outlined,
        "label": l10n.locationSharing.replaceAll(' ', '\n'),
        "badge": null,
      },
      {
        "icon": Icons.local_parking_rounded,
        "label": l10n.safeParking.replaceAll(' ', '\n'),
        "badge": null,
      },
      {
        "icon": Icons.campaign_outlined,
        "label": l10n.appUpdates.replaceAll(' ', '\n'),
        "badge": null,
      },
      {
        "icon": Icons.local_gas_station_outlined,
        "label": l10n.fuelLogs.replaceAll(' ', '\n'),
        "badge": null,
      },
      {
        "icon": Icons.location_on_outlined,
        "label": l10n.geoFenceAlert.replaceAll(' ', '\n'),
        "badge": null,
      },
      {
        "icon": Icons.speed_outlined,
        "label": l10n.overspeedAlert.replaceAll(' ', '\n'),
        "badge": null,
      },
      {
        "icon": Icons.folder_open_outlined,
        "label": l10n.documentFolder.replaceAll(' ', '\n'),
        "badge": null,
      },
      {
        "icon": Icons.list_alt_rounded,
        "label": l10n.deviceDataPlanLabel.replaceAll(' ', '\n'),
        "badge": null,
      },
      {
        "icon": Icons.gpp_good_outlined,
        "label": l10n.deviceWarrantyLabel.replaceAll(' ', '\n'),
        "badge": null,
      },
      {
        "icon": Icons.chat_outlined,
        "label": l10n.helpAndSupport.replaceAll(' ', '\n'),
        "badge": null,
      },
      {
        "icon": Icons.sos_outlined,
        "label": l10n.emergency.replaceAll(' ', '\n'),
        "badge": null,
      },
      {
        "icon": Icons.play_arrow_outlined,
        "label": l10n.videoTutorials.replaceAll(' ', '\n'),
        "badge": null,
      },
      {
        "icon": null,
        "label": l10n.upgradeToPlus.replaceAll(' ', '\n'),
        "badge": null,
        "isPlus": true,
      },
    ];

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.exploreMore,
            style: getBoldStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 24,
              crossAxisSpacing: 8,
              childAspectRatio: 0.9,
            ),
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options[index];
              return InkWell(
                onTap: () {
                  if (option["label"] ==
                      l10n.recordViaPhone.replaceAll(' ', '\n')) {
                    if (selectedDevice?.imei == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("No device found for this vehicle."),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => RecordViaPhoneScreen(
                            imei: selectedDevice?.imei ?? '',
                          ),
                        ),
                      );
                    }
                  }

                  if (option["label"] ==
                      l10n.reachMeSticker.replaceAll(' ', '\n')) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ReachMeStickerScreen(),
                      ),
                    );
                  }
                  if (option["label"] ==
                      l10n.locationSharing.replaceAll(' ', '\n')) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LocationSharingScreen(),
                      ),
                    );
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (option["isPlus"] == true)
                      Container(
                        margin: const EdgeInsets.only(bottom: 6, top: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFD4AF37),
                              Color(0xFFE1D2B0),
                              Color(0xFFE2C275),
                            ],
                            stops: [0.0, 0.4, 1.0],
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          l10n.plusLabel,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                        ),
                      )
                    else
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            option["icon"] as IconData,
                            size: 28,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          if (option["badge"] != null)
                            Positioned(
                              top: -10,
                              right: -36,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  option["badge"] as String,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    const SizedBox(height: 10),
                    Text(
                      option["label"] as String,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: getMediumStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.7),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
