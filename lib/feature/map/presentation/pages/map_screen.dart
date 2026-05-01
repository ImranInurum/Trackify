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
import 'package:trackify/feature/device_warranty/pages/device_warranty_page.dart';
import 'package:trackify/feature/help_and_support/presentation/pages/help_support_screen.dart';
import 'package:trackify/feature/map/data/entity/user_vehicles.dart';
import 'package:trackify/feature/map/presentation/pages/full_screen_map.dart';
import 'package:trackify/feature/my_garage/presentation/view/my_garage_screen.dart';
import 'package:trackify/feature/overspeed_alert/presentation/screens/overspeed_alert_screen.dart';
import 'package:trackify/feature/reach_me_sticker/presentation/screens/reach_me_sticker_screen.dart';
import 'package:trackify/feature/record_via_phone/presentation/pages/record_via_phone_screen.dart';
import 'package:trackify/feature/trips/presentation/view/ride_history_details/ride_history_details_screen.dart';
import 'package:trackify/feature/trips/presentation/view/widgets/all_rides/widgets/ride_card.dart';
import '../../../../core/utils/shared_preferences.dart';
import '../../../device_data/presentation/pages/device_data_screen.dart';
import '../../../fuel_logs/presentation/pages/fuel_logs_screen.dart';
import '../../../location_sharing/presentation/pages/location_sharing_screen.dart';
import 'package:trackify/feature/service_logs/presentation/screens/service_logs_screen.dart';
import '../../../notifications/presentation/screen/notification_list_screen.dart';
import 'package:trackify/feature/trips/presentation/cubit/ride_history_cubit.dart';
import 'package:trackify/feature/trips/presentation/cubit/ride_history_state.dart';

import 'package:trackify/feature/map/data/repository/promo_video_repository_impl.dart';
import 'package:trackify/feature/map/presentation/cubit/promo_video_cubit.dart';
import 'package:trackify/feature/map/presentation/cubit/promo_video_state.dart';
import 'package:trackify/feature/map/presentation/widgets/promo_video_card.dart';

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
  GoogleMapController? _mapController;
  String? _lightMapStyle;
  String? _darkMapStyle;
  Vehicles? _selectedDevice;
  BitmapDescriptor? _customMarker;
  final prefs = AppPreference.instance;
  bool _isExploreExpanded = false; // For Expandable Explore More section
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadMapStyles();
    _loadCustomMarker();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<MapCubit>().fetchVehicles();
      }
    });
  }

  void _scrollListener() {
    if (_scrollController.offset > 300 && !_showScrollToTop) {
      setState(() => _showScrollToTop = true);
    } else if (_scrollController.offset <= 300 && _showScrollToTop) {
      setState(() => _showScrollToTop = false);
    }
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
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) =>
          PromoVideoCubit(PromoVideoRepositoryImpl())..fetchPromoVideos(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: MultiBlocListener(
          listeners: [
            BlocListener<MapCubit, MapState>(
              listener: (context, state) {
                if (state is MapLoaded) {
                  final vehicles = state.vehicleList.vehicles ?? [];
                  if (vehicles.isNotEmpty && _selectedDevice == null) {
                    prefs.get(key: AppPreference.IMEI).then((savedImei) {
                      if (mounted) {
                        final savedVehicle = vehicles.firstWhere(
                          (v) => v.imei == savedImei,
                          orElse: () => vehicles.first,
                        );
                        setState(() {
                          _selectedDevice = savedVehicle;
                        });
                        // Refresh rides for the initially selected vehicle
                        context.read<RideHistoryCubit>().getRideHistoryData();
                      }
                    });
                  }
                }
              },
            ),
            BlocListener<AppCubit, AppState>(
              listenWhen: (prev, curr) =>
                  prev.mapStyle != curr.mapStyle ||
                  prev.mapType != curr.mapType ||
                  prev.isTrafficEnabled != curr.isTrafficEnabled,
              listener: (context, state) async {
                if (_mapController != null) {
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

                  await MapUtils.setStyle(_mapController!, style);
                }
              },
            ),
          ],
          child: BlocBuilder<MapCubit, MapState>(
            builder: (context, state) {
              final List<Vehicles> vehicles = state is MapLoaded
                  ? (state.vehicleList.vehicles ?? <Vehicles>[])
                  : <Vehicles>[];

              final topSpacing = MediaQuery.of(context).padding.top + 78;

              return Scaffold(
                body: Stack(
                  children: [
                    Positioned.fill(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                          if (scrollInfo.metrics.pixels >=
                              scrollInfo.metrics.maxScrollExtent - 50) {
                            context.read<PromoVideoCubit>().loadMoreVideos();
                          }
                          return false;
                        },
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              SizedBox(height: topSpacing),
                              _buildMapSection(),
                              _buildPromoBanner(),
                              _buildExploreMore(_selectedDevice),
                              _buildRecentRidesSection(), // Actual RideCard here
                              _buildVideosSection(), // Vertical videos
                              const SizedBox(height: 100),
                            ],
                          ),
                        ),
                      ),
                    ),
                    _buildDraggableAppBar(vehicles),
                  ],
                ),
              );
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _showScrollToTop
            ? GestureDetector(
                onTap: () {
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                child: Container(
                  height: 32, // Reduced height
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_upward,
                        color: Colors.grey[800],
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.scrollToTop,
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildMapSection() {
    final l10n = AppLocalizations.of(context)!;
    return BouncingWidget(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                FullScreenMap(selectedVehicle: _selectedDevice),
          ),
        );
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
            LatLng? bestPos;
            if (_selectedDevice?.currentLocation != null &&
                _selectedDevice!.currentLocation!.lat != null &&
                _selectedDevice!.currentLocation!.lng != null) {
              bestPos = LatLng(
                _selectedDevice!.currentLocation!.lat!,
                _selectedDevice!.currentLocation!.lng!,
              );
            }

            bestPos ??= LatLng(currentPos.latitude, currentPos.longitude);

            return Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    child: IgnorePointer(
                      child: GoogleMap(
                        key: ValueKey(_selectedDevice?.id),
                        initialCameraPosition: CameraPosition(
                          target: bestPos,
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
                          Marker(
                            markerId: const MarkerId('current_location'),
                            position: bestPos,
                            icon:
                                _customMarker ?? BitmapDescriptor.defaultMarker,
                            anchor: const Offset(0.5, 0.5),
                          ),
                        },
                        onMapCreated: (GoogleMapController controller) async {
                          _mapController = controller;

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
        String speed =
            "${_selectedDevice?.currentLocation?.speed ?? 0} ${l10n.kmh}";
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

    // Only show 8 items (2 rows) if not expanded
    final displayItems = _isExploreExpanded
        ? options
        : options.take(8).toList();

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.fromLTRB(
            16,
            16,
            16,
            24,
          ), // Extra bottom padding for button
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
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
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.85,
                ),
                itemCount: displayItems.length,
                itemBuilder: (context, index) {
                  final option = displayItems[index];
                  return _buildExploreItem(option, selectedDevice, l10n);
                },
              ),
            ],
          ),
        ),
        Positioned(
          bottom: -4, // Floats exactly on the border
          child: InkWell(
            onTap: () =>
                setState(() => _isExploreExpanded = !_isExploreExpanded),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                border: Border.all(
                  color: Theme.of(context).dividerColor.withOpacity(0.2),
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _isExploreExpanded ? l10n.viewLess : l10n.viewMore,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    _isExploreExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Theme.of(context).colorScheme.primary,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExploreItem(
    Map<String, dynamic> option,
    Vehicles? selectedDevice,
    AppLocalizations l10n,
  ) {
    return InkWell(
      onTap: () => _handleExploreTap(option, selectedDevice, l10n),
      child: Column(
        children: [
          if (option["isPlus"] == true)
            _buildPlusBadge(l10n)
          else
            _buildIconWithBadge(option),
          const SizedBox(height: 8),
          Text(
            option["label"] as String,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: getMediumStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              fontSize: 10.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlusBadge(AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6, top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD4AF37), Color(0xFFE1D2B0), Color(0xFFE2C275)],
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        l10n.plusLabel,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 11,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildIconWithBadge(Map<String, dynamic> option) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          option["icon"] as IconData,
          size: 26,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        if (option["badge"] != null)
          Positioned(
            top: -8,
            right: -24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
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
    );
  }

  void _handleExploreTap(
    Map<String, dynamic> option,
    Vehicles? selectedDevice,
    AppLocalizations l10n,
  ) {
    final label = option["label"];
    if (label == l10n.recordViaPhone.replaceAll(' ', '\n')) {
      if (selectedDevice?.imei == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No device found"),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                RecordViaPhoneScreen(imei: selectedDevice?.imei ?? ''),
          ),
        );
      }
    } else if (label == l10n.reachMeSticker.replaceAll(' ', '\n')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ReachMeStickerScreen()),
      );
    } else if (label == l10n.locationSharing.replaceAll(' ', '\n')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LocationSharingScreen()),
      );
    } else if (label == l10n.serviceLogs.replaceAll(' ', '\n')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ServiceLogsScreen()),
      );
    } else if (label == l10n.overspeedAlert.replaceAll(' ', '\n')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OverSpeedAlertScreen()),
      );
    } else if (label == l10n.fuelLogs.replaceAll(' ', '\n')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FuelLogsScreen()),
      );
    } else if (label == l10n.deviceWarrantyLabel.replaceAll(' ', '\n')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WarrantyScreen()),
      );
    }
    else if (label == l10n.helpAndSupport.replaceAll(' ', '\n')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HelpSuggestionScreen(),
        ),
      );
    }
    else if (label == l10n.deviceDataPlanLabel.replaceAll(' ', '\n')) {
      if (selectedDevice?.imei == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No device found"),
            backgroundColor: Colors.red,
          ),
        );
      }


      else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DeviceDataScreen(

            ),
          ),
        );
      }
    }
  }

  Widget _buildRecentRidesSection() {
    return BlocBuilder<RideHistoryCubit, RideHistoryState>(
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        if (state is RideHistoryLoading) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is RideHistoryFailure) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                children: [
                  Text(l10n.failedToLoadRides),
                  TextButton(
                    onPressed: () =>
                        context.read<RideHistoryCubit>().getRideHistoryData(),
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is RideHistorySuccess) {
          if (state.rides.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  l10n.noRecentRidesFound,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            );
          }
          final lastRide = state.rides.last;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.previousRides,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                RideCard(
                  ride: lastRide,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RideHistoryDetailsScreen(ride: lastRide),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildVideosSection() {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.videosYouMightLike,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          BlocBuilder<PromoVideoCubit, PromoVideoState>(
            builder: (context, state) {
              if (state is PromoVideoLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is PromoVideoError) {
                return Center(
                  child: Column(
                    children: [
                      Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                      TextButton(
                        onPressed: () =>
                            context.read<PromoVideoCubit>().fetchPromoVideos(),
                        child: Text(l10n.retry),
                      ),
                    ],
                  ),
                );
              }
              if (state is PromoVideoLoaded) {
                if (state.videos.isEmpty) {
                  return const Center(child: Text("No videos found"));
                }
                return Column(
                  children: [
                    ...state.videos.map((video) {
                      return PromoVideoCard(video: video);
                    }).toList(),
                    if (state.hasMore)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: CircularProgressIndicator(),
                      ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDraggableAppBar(List<Vehicles> vehicles) {
    return DraggableAppBar(
      vehicles: vehicles,
      selectedDevice: _selectedDevice,
      collapsedTrailing: IconButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NotificationListScreen(),
          ),
        ),
        icon: Icon(
          Icons.notifications_none_rounded,
          color: Theme.of(context).colorScheme.onSurface,
          size: 26,
        ),
      ),
      expandedTrailing: IconButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyGarageScreen()),
        ),
        icon: Icon(
          Icons.settings,
          color: Theme.of(context).colorScheme.onSurface,
          size: 20,
        ),
      ),
      onAddVehicle: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChoiceSelector()),
      ),
      onDeviceTap: (device) async {
        await prefs.set(key: AppPreference.IMEI, value: device.imei ?? '');
        setState(() => _selectedDevice = device);
        if (mounted) {
          context.read<RideHistoryCubit>().getRideHistoryData();
        }
        if (_mapController != null &&
            device.currentLocation?.lat != null &&
            device.currentLocation?.lng != null) {
          _mapController!.animateCamera(
            CameraUpdate.newLatLngZoom(
              LatLng(
                device.currentLocation!.lat!,
                device.currentLocation!.lng!,
              ),
              15,
            ),
          );
        }
      },
    );
  }
}
