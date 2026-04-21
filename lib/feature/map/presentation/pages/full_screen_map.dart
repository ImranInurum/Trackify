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

class FullScreenMap extends StatefulWidget {
  const FullScreenMap({super.key});

  @override
  State<FullScreenMap> createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
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
    _lightMapStyle = await MapUtils.loadStyle('assets/map_styles/light_map.json');
    _darkMapStyle = await MapUtils.loadStyle('assets/map_styles/full_map_style.json');
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
      shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(36),
      ),
      builder: (context) {
        return BlocBuilder<AppCubit, AppState>(
          builder: (context, state) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(            boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],),

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
                    "Map Style",
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
                      _buildStyleOption("Dark", AppImages.darkMapStyle, state),
                      _buildStyleOption("Light", AppImages.lightMapStyle, state),
                      _buildStyleOption(
                        "Simple",
                        AppImages.simpleMapStyle,
                        state,
                      ),
                      _buildStyleOption(
                        "Satellite",
                        AppImages.sateLiteMapStyle,
                        state,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    "Map Options",
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
                        "Traffic",
                        AppImages.trafficMapStyle,
                        state.isTrafficEnabled,
                        (val) => context.read<AppCubit>().updateMapConfig(isTrafficEnabled: val),
                      ),
                      const SizedBox(width: 24),
                      _buildMapOption(
                        "Labels",
                        AppImages.darkMapStyle,
                        state.isLabelsEnabled,
                        (val) => context.read<AppCubit>().updateMapConfig(isLabelsEnabled: val),
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
          context.read<AppCubit>().updateMapConfig(mapType: 'satellite', mapStyle: 'Satellite');
        } else {
          context.read<AppCubit>().updateMapConfig(mapType: 'normal', mapStyle: name);
        }
        
        final controller = await _controller.future;
        _updateMapStyle(controller);
      },
      child: Column(
        children: [
          Container(
            height: 68,
            width: 68,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(16),
              border: isSelected
                  ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2.5)
                  : Border.all(color: Theme.of(context).dividerColor),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
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
                  image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(16),
                  border: isActive
                      ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2)
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
                    child: const Icon(Icons.check, size: 10, color: Colors.white),
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
    return Scaffold(
      body: Stack(
        children: [
          _buildMap(),
          _buildTopActions(),
          _buildRightSideActions(),
          _buildDraggableBottomCard(),
        ],
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

        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(currentPos.latitude, currentPos.longitude),
            zoom: 15,
          ),
          myLocationEnabled: false,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          mapType: appState.mapType == 'satellite' ? MapType.satellite : MapType.normal,
          trafficEnabled: appState.isTrafficEnabled,
          markers: {
            if (currentPos != null)
              Marker(
                markerId: const MarkerId('current_location'),
                position: LatLng(currentPos.latitude, currentPos.longitude),
                icon: _customMarker ?? BitmapDescriptor.defaultMarker,
                anchor: const Offset(0.5, 0.5),
              ),
          },
          onMapCreated: (controller) async {
            if (!_controller.isCompleted) {
              _controller.complete(controller);
            }
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
          _buildRoundButton(Icons.arrow_back, onTap: () => Navigator.pop(context)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildRoundButton(
                Icons.more_vert,
                onTap: () => setState(() => _showSharedWithMe = !_showSharedWithMe),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                      "Shared with me",
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
                  border: Border.all(color: Theme.of(context).cardColor, width: 2),
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
      initialChildSize: 0.18,
      minChildSize: 0.18,
      maxChildSize: 0.38,
      snap: true,
      snapSizes: const [0.18, 0.38],
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
                color: Colors.black.withOpacity(0.1),
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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    children: [
                      _buildVehicleHeader(),
                      const SizedBox(height: 16),
                      _buildStatusRow(),

                      // Mid-Stop content
                      const SizedBox(height: 30),
                      _buildStatsGrid(),

                      // Fully-Expanded content
                      const SizedBox(height: 24),
                      _buildFuelGauge(),
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
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.transparent, // Clean transparent look
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.asset(
            AppImages.bikeImage,
            height: 44,
            width: 44,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "SP 125",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "MP09QV8269",
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            Icon(Icons.keyboard_arrow_up, color: Colors.grey.shade400, size: 20),
            Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade400, size: 20),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatusItem("Parked Since: 07:16 PM, 23 Feb"),
        _buildStatusItem("0m 0s", isDuration: true),
      ],
    );
  }

  Widget _buildStatusItem(String label, {bool isDuration = false}) {
    return Column(
      crossAxisAlignment: isDuration ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        Text(
          isDuration ? "Duration" : "Status",
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Today's Stats",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildGridItem("0 km", "Distance"),
            _buildGridItem("0m 0s", "Duration"),
            _buildGridItem("0 km/hr", "Avg Speed"),
            _buildGridItem("Plus", "Top Speed", isPlus: true),
          ],
        ),
      ],
    );
  }

  Widget _buildGridItem(String value, String label, {bool isPlus = false}) {
    return Column(
      children: [
        if (isPlus)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFDBBE8F), Color(0xFFC5A367)],
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              "Plus",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
          )
        else
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF2C3E50),
            ),
          ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildFuelGauge() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_gas_station, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          const Text("E", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              children: List.generate(
                8,
                (i) => Expanded(
                  child: Container(
                    height: 10,
                    margin: const EdgeInsets.symmetric(horizontal: 1.5),
                    decoration: BoxDecoration(
                      color: i < 3
                          ? Theme.of(context).colorScheme.onSurface.withOpacity(0.4)
                          : Theme.of(context).dividerColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text("F", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(width: 12),
          const Text(
            "0.0 kms more to go",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
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
