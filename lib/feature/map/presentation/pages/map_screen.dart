import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trackify/app/cubit/app_cubit.dart';
import 'package:trackify/app/cubit/app_state.dart';
import 'package:trackify/core/theme/app_colors.dart';
import 'package:trackify/core/widgets/draggable_app_bar.dart';
import 'package:trackify/feature/map/data/entity/user_device_model.dart';

import '../../../../core/config/style_manager.dart';
import '../cubit/map_cubit.dart';
import '../cubit/map_state.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
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
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: BlocConsumer<MapCubit, MapState>(
        listener: (context, state) {},
        builder: (context, state) {
          final devices = state is MapLoaded
              ? (state.deviceList.devices ?? <UserDevices>[])
              : <UserDevices>[];
          final topSpacing = MediaQuery.of(context).padding.top + 64;

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
                      _buildExploreMore(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),

              DraggableAppBar(
                devices: devices,
                selectedDevice: devices.isNotEmpty ? devices.first : null,
                collapsedTrailing: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.black,
                    size: 26,
                  ),
                ),
                expandedTrailing: IconButton(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  icon: const Icon(Icons.settings, color: Colors.black, size: 20),
                ),
                onAddVehicle: () {
                  // navigate to add vehicle screen
                },
                onDeviceTap: (device) {
                  // handle selected device here
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return BlocBuilder<MapCubit, MapState>(
      buildWhen: (prev, curr) =>
          curr is MapLoaded || curr is MapLoading || curr is MapError,
      builder: (context, state) {
        String deviceName = "No Device";
        String imei = "---";

        if (state is MapLoaded && state.deviceList.devices?.isNotEmpty == true) {
          final device = state.deviceList.devices![0]; // Displaying first device for now
          deviceName = device.deviceName ?? "Unnamed Device";
          imei = device.imei ?? "---";
        }

        return Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 5,
            bottom: 12,
            left: 16,
            right: 16,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.motorcycle,
                  color: AppColors.primaryLight,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      deviceName,
                      style: getBoldStyle(color: Colors.black, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Text(
                          imei,
                          style: getMediumStyle(
                            color: AppColors.textSecondaryLight,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Lite 4G",
                          style: getMediumStyle(
                            color: AppColors.primaryLight,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.black,
                  size: 26,
                ),
                onPressed: () {},
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMapSection() {
    return Container(
      height: 340,
      margin: const EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
      padding: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: AppColors.primaryLightVariant.withOpacity(0.98),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 2,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          final currentPos = state.currentLocation;
          if (currentPos == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(currentPos.latitude, currentPos.longitude),
                      zoom: 15,
                    ),
                    myLocationEnabled: true,
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    onMapCreated: (GoogleMapController controller) async {
                      if (!_controller.isCompleted) {
                        _controller.complete(controller);
                      }
                      await _applyMapTheme(controller, state.themeMode);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Row(
                  children: [
                    Text(
                      "Today",
                      style: getBoldStyle(color: AppColors.paletteGreen, fontSize: 10),
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
    );
  }

  Widget _buildStatsRow() {
    return BlocBuilder<MapCubit, MapState>(
      builder: (context, state) {
        String distance = "0.0 km";
        String speed = "0 km/hr";
        String duration = "0m 0s";
        String topSpeed = "0 km/hr";

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                children: [
                  _buildStatItem("Distance", distance),
                  _buildStatItem("Ride Duration", duration),
                ],
              ),
            ),
            Spacer(),
            Expanded(
              child: Column(
                children: [
                  _buildStatItem("Speed", speed),
                  _buildStatItem("Top Speed", topSpeed),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("$label:", style: getRegularStyle(color: Colors.black54, fontSize: 11)),
        SizedBox(width: 4),
        Text(
          value,
          style: getThinStyle(
            color: Colors.black87,
            fontSize: 13,
          ).copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
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
                  backgroundColor: Colors.grey.shade100,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.cyan),
                ),
                Text("63%", style: getBoldStyle(color: Colors.cyan, fontSize: 10)),
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
                      "Get more out of Trackify",
                      style: getBoldStyle(color: Colors.cyan.shade800, fontSize: 14),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.cyan, size: 18),
                  ],
                ),
                Text(
                  "Discover more — awesome things await!",
                  style: getRegularStyle(color: Colors.grey.shade600, fontSize: 11),
                ),
              ],
            ),
          ),
          const Icon(Icons.close, color: Colors.grey, size: 18),
        ],
      ),
    );
  }

  Widget _buildExploreMore() {
    // final l10n = AppLocalizations.of(context)!;
    final options = [
      {
        "icon": Icons.qr_code_scanner,
        "label": "ReachMe\nSticker",
        "badge": "Explore Now",
      },
      {"icon": Icons.phone_android_rounded, "label": "Record via\nPhone", "badge": null},
      {"icon": Icons.handyman_outlined, "label": "Service Logs", "badge": null},
      {"icon": Icons.share_outlined, "label": "Location\nSharing", "badge": null},
      {"icon": Icons.local_parking_rounded, "label": "Safe Parking", "badge": null},
      {"icon": Icons.campaign_outlined, "label": "App Updates", "badge": null},
      {"icon": Icons.local_gas_station_outlined, "label": "Fuel Logs", "badge": null},
      {"icon": Icons.location_on_outlined, "label": "Geo-fence\nAlert", "badge": null},
      {"icon": Icons.speed_outlined, "label": "Overspeed\nAlert", "badge": null},
      {"icon": Icons.folder_open_outlined, "label": "Document\nFolder", "badge": null},
      {"icon": Icons.list_alt_rounded, "label": "Device\nData Plan", "badge": null},
      {"icon": Icons.gpp_good_outlined, "label": "Device\nWarranty", "badge": null},
      {"icon": Icons.chat_outlined, "label": "Help &\nSupport", "badge": null},
      {"icon": Icons.sos_outlined, "label": "Emergency", "badge": null},
      {"icon": Icons.play_arrow_outlined, "label": "Video\nTutorials", "badge": null},
      {"icon": null, "label": "Upgrade to\nPlus", "badge": null, "isPlus": true},
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Explore more", style: getBoldStyle(color: Colors.black87, fontSize: 17)),
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
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (option["isPlus"] == true)
                    Container(
                      margin: const EdgeInsets.only(bottom: 6, top: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                      child: const Text(
                        "Plus",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    )
                  else
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(option["icon"] as IconData, size: 28, color: Colors.black87),
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
                                color: const Color(0xFF00A3E0),
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
                    style: getMediumStyle(color: Colors.black54, fontSize: 11),
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
