import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trackify/app/cubit/app_cubit.dart';
import 'package:trackify/app/cubit/app_state.dart';
import 'package:trackify/core/constants/app_images.dart';
import 'package:trackify/core/utils/map_utils.dart';
import 'package:trackify/core/widgets/bouncing_widget.dart';
import 'package:trackify/feature/map/data/entity/user_vehicles.dart';
import '../../../../l10n/app_localizations.dart';

class FullScreenMap extends StatefulWidget {
  final Vehicles? selectedVehicle;
  const FullScreenMap({super.key, this.selectedVehicle});

  @override
  State<FullScreenMap> createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  GoogleMapController? _mapController;
  String? _lightMapStyle;
  String? _darkMapStyle;
  bool _showSharedWithMe = false;
  BitmapDescriptor? _customMarker;

  @override
  void initState() {
    super.initState();
    _loadMapStyles();
    _loadCustomMarker();
  }

  Future<void> _loadMapStyles() async {
    _lightMapStyle = await MapUtils.loadStyle(
      'assets/map_styles/light_map.json',
    );
    _darkMapStyle = await MapUtils.loadStyle(
      'assets/map_styles/full_map_style.json',
    );
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

  Future<void> _updateMapStyle(GoogleMapController controller) async {
    final appConfig = context.read<AppCubit>().state;

    if (appConfig.mapType == 'satellite') {
      await MapUtils.setStyle(controller, null);
      return;
    }

    String? style;
    if (appConfig.mapStyle == 'Dark') {
      style = _darkMapStyle;
    } else if (appConfig.mapStyle == 'Light') {
      style = _lightMapStyle;
    } else if (appConfig.mapStyle == 'Simple') {
      style = await MapUtils.loadStyle('assets/map_styles/light_map.json');
    }

    await MapUtils.setStyle(controller, style);
  }

  void _showMapStyleSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      barrierColor: Colors.black45,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36)),
      builder: (context) {
        return BlocBuilder<AppCubit, AppState>(
          builder: (context, state) {
            final l10n = AppLocalizations.of(context)!;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),

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
                        state,
                      ),
                      _buildStyleOption(
                        l10n.lightStyle,
                        AppImages.lightMapStyle,
                        state,
                      ),
                      _buildStyleOption(
                        l10n.simpleStyle,
                        AppImages.simpleMapStyle,
                        state,
                      ),
                      _buildStyleOption(
                        l10n.satelliteStyle,
                        AppImages.sateLiteMapStyle,
                        state,
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
                        state.isTrafficEnabled,
                        (val) => context.read<AppCubit>().updateMapConfig(
                          isTrafficEnabled: val,
                        ),
                      ),
                      const SizedBox(width: 24),
                      _buildMapOption(
                        l10n.labelsLabel,
                        AppImages.darkMapStyle,
                        state.isLabelsEnabled,
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
      onTap: () async {
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

        if (_mapController != null) {
          _updateMapStyle(_mapController!);
        }
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              if (isActive)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 10,
                      color: Colors.white,
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
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppCubit, AppState>(
      listenWhen: (previous, current) =>
          previous.livePosition != current.livePosition,
      listener: (context, state) {
        if (state.livePosition != null && _mapController != null) {
          _mapController!.animateCamera(
            CameraUpdate.newLatLng(state.livePosition!),
          );
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            _buildMap(),
            _buildTopActions(),
            _buildRightSideActions(),
            _buildDraggableBottomCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildMap() {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, appState) {
        final currentPos = appState.currentLocation;
        if (currentPos == null) {
          return const Center(child: CircularProgressIndicator());
        }

        // Prioritize Live Position from Socket
        LatLng? bestPos = appState.livePosition;

        // Fallback to selected vehicle's static location
        if (bestPos == null &&
            widget.selectedVehicle?.currentLocation != null &&
            widget.selectedVehicle!.currentLocation!.lat != null &&
            widget.selectedVehicle!.currentLocation!.lng != null) {
          bestPos = LatLng(
            widget.selectedVehicle!.currentLocation!.lat!,
            widget.selectedVehicle!.currentLocation!.lng!,
          );
        }

        // Final fallback to phone location
        bestPos ??= LatLng(currentPos.latitude, currentPos.longitude);

        return GoogleMap(
          key: ValueKey(widget.selectedVehicle?.id),
          initialCameraPosition: CameraPosition(target: bestPos, zoom: 15),
          myLocationEnabled: false,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          mapType: appState.mapType == 'satellite'
              ? MapType.satellite
              : MapType.normal,
          trafficEnabled: appState.isTrafficEnabled,
          markers: {
            Marker(
              markerId: const MarkerId('vehicle_marker'),
              position: bestPos,
              icon: _customMarker ?? BitmapDescriptor.defaultMarker,
              anchor: const Offset(0.5, 0.5),
              rotation: appState.liveBearing,
            ),
          },
          onMapCreated: (controller) async {
            _mapController = controller;

            if (_darkMapStyle == null || _lightMapStyle == null) {
              await _loadMapStyles();
            }
            _updateMapStyle(controller);
          },
        );
      },
    );
  }

  Widget _buildTopActions() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 10,
      right: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRoundButton(
            Icons.arrow_back,
            onTap: () => Navigator.pop(context),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildRoundButton(
                Icons.more_vert,
                onTap: () =>
                    setState(() => _showSharedWithMe = !_showSharedWithMe),
              ),
              if (_showSharedWithMe)
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 200),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 10 * value - 10),
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Theme.of(context).dividerColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.sharedWithMe,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRightSideActions() {
    return Positioned(
      right: 16,
      bottom: 240, // Adjusted to be above the bottom sheet
      child: Column(
        children: [
          _buildMapActionButton(Icons.motorcycle, hasNotification: true),
          _buildMapActionButton(Icons.map_outlined, onTap: _showMapStyleSheet),
          _buildMapActionButton(Icons.person_pin_circle_outlined),
          _buildMapActionButton(Icons.my_location),
          _buildMapActionButton(Icons.fullscreen),
        ],
      ),
    );
  }

  Widget _buildMapActionButton(
    IconData icon, {
    bool hasNotification = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Stack(
        children: [
          _buildRoundButton(icon, onTap: onTap),
          if (hasNotification)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).cardColor,
                    width: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRoundButton(IconData icon, {VoidCallback? onTap}) {
    return BouncingWidget(
      onTap: onTap ?? () {},
      child: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          shape: BoxShape.circle,
          border: Border.all(color: Theme.of(context).dividerColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.85),
          size: 24,
        ),
      ),
    );
  }

  Widget _buildDraggableBottomCard() {
    return DraggableScrollableSheet(
      initialChildSize:
          0.14, // Increased slightly to accommodate the new layout
      minChildSize: 0.14,
      maxChildSize: 0.40,
      snap: true,
      snapSizes: const [0.20, 0.40],
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(36),
              topRight: Radius.circular(36),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildVehicleHeader(),
                      // Removed separate _buildStatusRow as it's now integrated in header

                      // Mid-Stop content
                      const SizedBox(height: 30),
                      _buildStatsGrid(),

                      // Fully-Expanded content
                      const SizedBox(height: 24),
                      _buildBottomInfoCards(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVehicleHeader() {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final liveDevice = state.devices.firstWhere(
          (d) =>
              d['imei']?.toString() == widget.selectedVehicle?.id?.toString(),
          orElse: () => {},
        );

        final liveSpeed =
            liveDevice['sp']?.toString() ??
            widget.selectedVehicle?.currentLocation?.speed?.toString() ??
            "0";

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Vehicle Icon
                Image.asset(
                  AppImages.bikeImage,
                  height: 48,
                  width: 48,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 12),
                // Vehicle Name and Number
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.selectedVehicle?.vehicleMaker ??
                            AppLocalizations.of(
                              context,
                            )!.vehicleNamePlaceholder,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        widget.selectedVehicle?.vehicleNumber ??
                            AppLocalizations.of(
                              context,
                            )!.vehicleNumberPlaceholder,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(
                            0xFF4A90A4,
                          ), // Matched blue from screenshot
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                // Speed Info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          liveSpeed,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          AppLocalizations.of(context)!.kmh,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      AppLocalizations.of(
                        context,
                      )!.speedLabel, // Using "Speed" label
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.4),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                // Up/Down Arrows
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildSmallArrowButton(Icons.keyboard_arrow_up),
                    const SizedBox(height: 6),
                    _buildSmallArrowButton(Icons.keyboard_arrow_down),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Parked Since Status
            Text(
              AppLocalizations.of(context)!.parkedSinceTime("11:17 AM, Today"),
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSmallArrowButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Icon(
        icon,
        size: 16,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        // Find current device in the live devices list to get live speed/odometer
        final liveDevice = state.devices.firstWhere(
          (d) =>
              d['imei']?.toString() == widget.selectedVehicle?.id?.toString(),
          orElse: () => {},
        );

        final liveSpeed =
            liveDevice['sp']?.toString() ??
            widget.selectedVehicle?.currentLocation?.speed?.toString() ??
            "0";

        final odometer = liveDevice['odometer']?.toString() ?? "0";

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.todaysStats,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildGridItem(
                  "$odometer ${AppLocalizations.of(context)!.km}",
                  AppLocalizations.of(context)!.distanceLabel,
                ),
                _buildGridItem(
                  "0${AppLocalizations.of(context)!.minutesShort} 0${AppLocalizations.of(context)!.secondsShort}",
                  AppLocalizations.of(context)!.durationLabel,
                ),
                _buildGridItem(
                  "$liveSpeed ${AppLocalizations.of(context)!.kmh}",
                  AppLocalizations.of(context)!.averageSpeed,
                ),
                _buildGridItem(
                  AppLocalizations.of(context)!.plusLabel,
                  AppLocalizations.of(context)!.topSpeed,
                  isPlus: true,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildGridItem(String value, String label, {bool isPlus = false}) {
    return Column(
      children: [
        if (isPlus)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE6BE75), Color(0xFFD4AF37)],
              ),
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD4AF37).withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              AppLocalizations.of(context)!.plusLabel,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          )
        else
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomInfoCards() {
    return Row(
      children: [
        // Fuel Card
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_gas_station, size: 18, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    const Text("E", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(width: 4),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Container(
                          width: 8,
                          height: 12,
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          decoration: BoxDecoration(
                            color: i < 3 ? const Color(0xFF3498DB) : Colors.grey[300],
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text("F", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "260.6 kms more to go", // TODO: Add to localization (kmsMoreToGo key missing)
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Battery Card
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  "Vehicle Battery", // TODO: Add to localization (vehicleBattery key missing)
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(Icons.battery_charging_full, size: 14, color: Colors.green),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      "Normal (12.2V)",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildNavIcon(Icons.home_outlined, isSelected: true),
        _buildNavIcon(Icons.route_outlined),
        _buildNavIcon(Icons.bar_chart_outlined),
        _buildNavIcon(Icons.person_outline),
      ],
    );
  }

  Widget _buildNavIcon(IconData icon, {bool isSelected = false}) {
    return Icon(
      icon,
      color: isSelected
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      size: 28,
    );
  }
}
