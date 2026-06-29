import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trackify/app/cubit/app_cubit.dart';
import 'package:trackify/app/cubit/app_state.dart';
import 'package:trackify/core/constants/app_images.dart';
import 'package:trackify/core/theme/app_colors.dart';
import 'package:trackify/core/utils/map_utils.dart';
import 'package:trackify/core/widgets/bouncing_widget.dart';
import 'package:trackify/core/widgets/draggable_app_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:trackify/feature/add_vehicle_and_device/choice_selector.dart';
import 'package:trackify/feature/app_updates/presentiation/pages/update_screen.dart';
import 'package:trackify/feature/device_warranty/pages/device_warranty_page.dart';
import 'package:trackify/feature/document_folder/presentation/pages/document_screen.dart';
import 'package:trackify/feature/emergency_sos/presentation/pages/emergency_alert_screen.dart';
import 'package:trackify/feature/help_and_support/presentation/pages/help_support_screen.dart';
import 'package:trackify/feature/map/data/entity/user_vehicles.dart';
import 'package:trackify/feature/map/presentation/pages/full_screen_map.dart';
import 'package:trackify/feature/my_garage/presentation/view/my_garage_screen.dart';
import 'package:trackify/feature/overspeed_alert/presentation/screens/overspeed_alert_screen.dart';
import 'package:trackify/feature/reach_me_sticker/presentation/screens/reach_me_sticker_screen.dart';
import 'package:trackify/feature/record_via_phone/presentation/pages/record_via_phone_screen.dart';
import 'package:trackify/feature/safe_parking/presentation/pages/safe_parking_screen.dart';
import 'package:trackify/feature/trips/presentation/view/ride_history_details/ride_history_details_screen.dart';
import 'package:trackify/feature/trips/presentation/view/widgets/all_rides/widgets/ride_card.dart';
import 'package:trackify/feature/video_tutorial/presentation/pages/category_screen.dart';
import '../../../../core/services/socket_service.dart';
import '../../../../core/utils/shared_preferences.dart';
import '../../../device_data/presentation/pages/device_data_screen.dart';
import '../../../fuel_logs/presentation/pages/fuel_logs_screen.dart';
import '../../../geo_fence/presentation/pages/geo_fence_screen.dart';
import '../../../get_more_out/presentation/pages/disover_screen.dart';
import '../../../location_sharing/presentation/pages/location_sharing_screen.dart';
import 'package:trackify/feature/service_logs/presentation/screens/service_logs_screen.dart';
import '../../../notifications/presentation/screen/notification_list_screen.dart';
import 'package:trackify/feature/trips/presentation/cubit/ride_history_cubit.dart';
import 'package:trackify/feature/trips/data/entity/ride_model.dart';
import 'package:trackify/feature/trips/presentation/cubit/ride_history_state.dart';

import 'package:trackify/feature/map/data/repository/promo_video_repository_impl.dart';
import 'package:trackify/feature/map/presentation/cubit/promo_video_cubit.dart';
import 'package:trackify/feature/map/presentation/cubit/promo_video_state.dart';
import 'package:trackify/feature/map/presentation/widgets/promo_video_card.dart';

import '../../../../core/config/style_manager.dart';
import '../../../upgrade_to_plus/presentation/pages/upgrade_to_plus.dart';
import '../cubit/map_cubit.dart';
import '../cubit/map_state.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:trackify/core/common/models/vehicle_list_model.dart';
import 'package:trackify/core/utils/distance_utils.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  String? _lightMapStyle;
  String? _darkMapStyle;
  Vehicles? _selectedDevice;
  BitmapDescriptor? _customMarker;
  final prefs = AppPreference.instance;
  bool _isExploreExpanded = false; // For Expandable Explore More section
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;

  // Animation controller for cinematic camera movements
  AnimationController? _cameraAnimationController;

  // Current camera state (tracked locally to avoid async calls)
  LatLng? _cameraTarget;
  double _cameraZoom = 14.0;
  double _cameraTilt = 0.0;
  double _cameraBearing = 0.0;

  // Animation start/end states
  LatLng? _animStartTarget;
  LatLng? _animEndTarget;
  double _animStartZoom = 14.0;
  double _animEndZoom = 16.0;
  double _animStartTilt = 0.0;
  double _animEndTilt = 0.0;
  double _animStartBearing = 0.0;
  double _animEndBearing = 0.0;

  // Animated marker state
  LatLng? _animatedMarkerPos;
  double _animatedMarkerBearing = 0.0;
  AnimationController? _markerAnimController;
  LatLng? _animStartMarkerTarget;
  LatLng? _animEndMarkerTarget;
  double _animStartMarkerBearing = 0.0;
  double _animEndMarkerBearing = 0.0;
  
  int _lastDataReceivedMs = 0;
  int _lastCameraUpdateMs = 0;
  int _lastMarkerRebuildMs = 0;
  final ValueNotifier<int> _mapRebuildNotifier = ValueNotifier<int>(0);

  bool _isInitialFocusDone = false;

  Timer? _rideHistoryUpdateTimer;

  @override
  void dispose() {
    _rideHistoryUpdateTimer?.cancel();
    _cameraAnimationController?.dispose();
    _markerAnimController?.dispose();
    _mapRebuildNotifier.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _markerAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(); // Runs continuously to compute physics

    _markerAnimController!.addListener(() {
      if (_animStartMarkerTarget != null && _animEndMarkerTarget != null) {
          final now = DateTime.now().millisecondsSinceEpoch;
          final elapsed = now - _lastDataReceivedMs;

          if (elapsed > 15000) {
            // Stop moving if no data received for 15 seconds
          } else {
            // Linear constant interpolation for steady movement
            double t = elapsed / 10000.0; // Assume 10 seconds between updates
            if (t > 1.0) t = 1.0; // Prevent overshooting
            
            final double lat = _animStartMarkerTarget!.latitude + (_animEndMarkerTarget!.latitude - _animStartMarkerTarget!.latitude) * t;
            final double lng = _animStartMarkerTarget!.longitude + (_animEndMarkerTarget!.longitude - _animStartMarkerTarget!.longitude) * t;
            _animatedMarkerPos = LatLng(lat, lng);
            
            double diffBearing = _animEndMarkerBearing - _animStartMarkerBearing;
            if (diffBearing > 180) diffBearing -= 360;
            if (diffBearing < -180) diffBearing += 360;
            
            _animatedMarkerBearing = _animStartMarkerBearing + diffBearing * t;
          }
          
          if (now - _lastMarkerRebuildMs >= 50) {
            _lastMarkerRebuildMs = now;
            _mapRebuildNotifier.value++;
          }
          
          if (_isInitialFocusDone && mounted && _mapController != null) {
            if (now - _lastCameraUpdateMs >= 50) {
              _lastCameraUpdateMs = now;
              
              final currentTarget = _cameraTarget ?? _animatedMarkerPos!;
              
              final double latDiff = (_animatedMarkerPos!.latitude - currentTarget.latitude).abs();
              final double lngDiff = (_animatedMarkerPos!.longitude - currentTarget.longitude).abs();
              final double distanceDiff = latDiff + lngDiff;
              
              double dynamicPosFactor = 0.15;
              if (distanceDiff > 0.002) {
                dynamicPosFactor = 1.0;
              } else if (distanceDiff > 0.0006) {
                dynamicPosFactor = 0.15 + (1.0 - 0.15) * ((distanceDiff - 0.0006) / 0.0014);
              }

              final double camLat = currentTarget.latitude + (_animatedMarkerPos!.latitude - currentTarget.latitude) * dynamicPosFactor;
              final double camLng = currentTarget.longitude + (_animatedMarkerPos!.longitude - currentTarget.longitude) * dynamicPosFactor;
              
              final nextPos = CameraPosition(
                target: LatLng(camLat, camLng),
                zoom: _cameraZoom,
                tilt: _cameraTilt,
                bearing: 0.0,
              );
              
              _cameraTarget = nextPos.target;
              try {
                _mapController!.moveCamera(CameraUpdate.newCameraPosition(nextPos));
              } catch (e) {}
            }
          }
      }
    });

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
      80,
    );
    if (mounted) {
      setState(() {
        _customMarker = BitmapDescriptor.fromBytes(markerIcon);
      });
      _mapRebuildNotifier.value++;
    }
  }

  LatLng? _getBestPosition() {
    final appState = context.read<AppCubit>().state;
    final currentPos = appState.currentLocation;
    LatLng? bestPos = appState.livePosition;

    if (bestPos == null &&
        _selectedDevice?.currentLocation != null &&
        _selectedDevice!.currentLocation!.lat != null &&
        _selectedDevice!.currentLocation!.lng != null) {
      bestPos = LatLng(
        _selectedDevice!.currentLocation!.lat!,
        _selectedDevice!.currentLocation!.lng!,
      );
    }

    if (bestPos == null && currentPos != null) {
      bestPos = LatLng(currentPos.latitude, currentPos.longitude);
    }
    return bestPos;
  }

  void _triggerInitialFocusAnimation() {
    LatLng? target = _getBestPosition();
    if (target == null) return;

    final appState = context.read<AppCubit>().state;

    // Glide smoothly focusing on the vehicle (drone camera zoom & rotate effect)
    // 600ms delay ensures native layout/tiles/styles are ready before animation starts
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      _animateCameraTo(
        target: target,
        zoom: 13.0,
        tilt: 0.0,
        bearing: 0.0,
        duration: const Duration(milliseconds: 4000), // slow cinematic glide
        curve: Curves.easeInOutCubic,
      );
      setState(() {
        _isInitialFocusDone = true;
      });
    });
  }

  void _animateCameraTo({
    required LatLng target,
    required double zoom,
    required double tilt,
    required double bearing,
    required Duration duration,
    Curve curve = Curves.easeInOutCubic,
  }) {
    if (_mapController == null) return;

    _cameraAnimationController?.stop();

    _animStartTarget = _cameraTarget ?? target;
    _animStartZoom = _cameraZoom;
    _animStartTilt = _cameraTilt;
    _animStartBearing = _cameraBearing;

    _animEndTarget = target;
    _animEndZoom = zoom;
    _animEndTilt = tilt;

    _animStartBearing = _normalizeBearing(_animStartBearing);
    double endBearingNormalized = _normalizeBearing(bearing);

    double diff = endBearingNormalized - _animStartBearing;
    if (diff > 180) {
      diff -= 360;
    } else if (diff < -180) {
      diff += 360;
    }
    _animEndBearing = _animStartBearing + diff;

    _cameraAnimationController?.dispose();
    _cameraAnimationController = AnimationController(
      vsync: this,
      duration: duration,
    );

    final curvedAnimation = CurvedAnimation(
      parent: _cameraAnimationController!,
      curve: curve,
    );

    _cameraAnimationController!.addListener(() {
      if (!mounted) return;
      final t = curvedAnimation.value;
      if (_animStartTarget == null || _animEndTarget == null) return;

      double lat =
          _animStartTarget!.latitude +
          (_animEndTarget!.latitude - _animStartTarget!.latitude) * t;
      double lng =
          _animStartTarget!.longitude +
          (_animEndTarget!.longitude - _animStartTarget!.longitude) * t;
      LatLng newTarget = LatLng(lat, lng);

      double newZoom = _animStartZoom + (_animEndZoom - _animStartZoom) * t;
      double newTilt = _animStartTilt + (_animEndTilt - _animStartTilt) * t;
      double newBearing =
          _animStartBearing + (_animEndBearing - _animStartBearing) * t;

      _cameraTarget = newTarget;
      _cameraZoom = newZoom;
      _cameraTilt = newTilt;
      _cameraBearing = newBearing;

      try {
        _mapController?.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: newTarget,
              zoom: newZoom,
              tilt: newTilt,
              bearing: newBearing,
            ),
          ),
        );
      } catch (e) {
        debugPrint("Failed to move camera on disposed/detached map controller: $e");
      }
    });

    _cameraAnimationController!.forward();
  }

  void _manageRideHistoryTimer(AppState state) {
    if (_selectedDevice == null || !mounted) return;
    final liveDevice = state.devices.firstWhere(
      (d) => d['imei']?.toString() == _selectedDevice?.imei || d['_id']?.toString() == _selectedDevice?.id || d['id']?.toString() == _selectedDevice?.id,
      orElse: () => <String, dynamic>{},
    );
    if (liveDevice.isNotEmpty) {
      String speedStr = liveDevice['sp']?.toString() ?? "0";
      double speed = double.tryParse(speedStr) ?? 0.0;
      String status = liveDevice['status']?.toString().toLowerCase() ?? '';
      
      bool isMoving = speed > 2.0 || status == 'moving';
      
      if (isMoving) {
        if (_rideHistoryUpdateTimer == null || !_rideHistoryUpdateTimer!.isActive) {
          context.read<RideHistoryCubit>().getRideHistoryData();
          _rideHistoryUpdateTimer = Timer.periodic(const Duration(seconds: 20), (_) {
             if (mounted) context.read<RideHistoryCubit>().getRideHistoryData();
          });
        }
      } else {
        if (_rideHistoryUpdateTimer != null && _rideHistoryUpdateTimer!.isActive) {
          _rideHistoryUpdateTimer?.cancel();
          _rideHistoryUpdateTimer = null;
          // Fetch one last time to get the final parked stats
          context.read<RideHistoryCubit>().getRideHistoryData();
        }
      }
    }
  }

  double _normalizeBearing(double bearing) {
    double b = bearing % 360;
    if (b < 0) b += 360;
    return b;
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
                    final savedUid = prefs.getSync(key: AppPreference.KEY_SELECTED_UID);
                    final savedImei = prefs.getSync(key: AppPreference.IMEI);

                    final savedVehicle = vehicles.firstWhere(
                      (v) => (savedUid.isNotEmpty && v.id == savedUid) || 
                             (savedImei.isNotEmpty && v.imei == savedImei),
                      orElse: () => vehicles.first,
                    );
                    
                    setState(() {
                      _selectedDevice = savedVehicle;
                    });
                    
                    prefs.set(
                      key: AppPreference.KEY_SELECTED_UID,
                      value: savedVehicle.id,
                    );
                    prefs.set(
                      key: AppPreference.IMEI,
                      value: savedVehicle.imei ?? '',
                    );
                    
                    print("selected device is ${savedVehicle.imei} with id ${savedVehicle.id}");
                    // Refresh rides for the initially selected vehicle
                    context.read<RideHistoryCubit>().getRideHistoryData();
                  }
                }
              },
            ),
            BlocListener<AppCubit, AppState>(
              listenWhen: (prev, curr) =>
                  prev.mapStyle != curr.mapStyle ||
                  prev.mapType != curr.mapType ||
                  prev.isTrafficEnabled != curr.isTrafficEnabled ||
                  prev.livePosition != curr.livePosition ||
                  prev.liveBearing != curr.liveBearing ||
                  prev.devices != curr.devices,
              listener: (context, state) async {
                _manageRideHistoryTimer(state);
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
                  if (mounted && _mapController != null) {
                    try {
                      await MapUtils.setStyle(_mapController!, style);
                    } catch (e) {
                      debugPrint("Error setting map style: $e");
                    }
                  }
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
            double bearing = 0.0;

            // 1. Get live position specific to THIS device from socket data
            final liveData = appState.devices.firstWhere(
              (d) =>
                  d['imei'] == _selectedDevice?.imei ||
                  d['_id'] == _selectedDevice?.id ||
                  d['id'] == _selectedDevice?.id,
              orElse: () => <String, dynamic>{},
            );

            if (liveData.isNotEmpty) {
              final lat = double.tryParse(liveData['lt']?.toString() ?? '');
              final lng = double.tryParse(liveData['lg']?.toString() ?? '');
              if (lat != null && lng != null) {
                bestPos = LatLng(lat, lng);
              }
            }

            double rawCourse = double.tryParse(
              (liveData['course'] ?? liveData['bearing'] ?? liveData['angle'] ?? liveData['dir'] ?? '-1').toString()
            ) ?? -1.0;

            bearing = _animatedMarkerPos != null ? _animatedMarkerBearing : (rawCourse >= 0 ? rawCourse : 0.0);

            // 2. Fallback to API static location
            if (bestPos == null &&
                _selectedDevice?.currentLocation != null &&
                _selectedDevice!.currentLocation!.lat != null &&
                _selectedDevice!.currentLocation!.lng != null) {
              bestPos = LatLng(
                _selectedDevice!.currentLocation!.lat!,
                _selectedDevice!.currentLocation!.lng!,
              );
            }
            
            if (bestPos != null && _animatedMarkerPos != null) {
              double dist = Geolocator.distanceBetween(
                _animatedMarkerPos!.latitude,
                _animatedMarkerPos!.longitude,
                bestPos.latitude,
                bestPos.longitude,
              );
              
              double speed = double.tryParse((liveData['sp'] ?? liveData['speed'] ?? '0').toString()) ?? 0.0;
              
              if (dist > 1.0) {
                double calcB = Geolocator.bearingBetween(
                  _animatedMarkerPos!.latitude,
                  _animatedMarkerPos!.longitude,
                  bestPos.latitude,
                  bestPos.longitude,
                );
                bearing = (calcB + 360) % 360;
              } else if (speed > 2.0 && rawCourse >= 0) {
                bearing = rawCourse;
              }
            }


            // 3. Fallback to phone current location
            bestPos ??= LatLng(currentPos.latitude, currentPos.longitude);

            // Marker Animation Logic
            if (_animatedMarkerPos == null) {
               _animatedMarkerPos = bestPos;
               _animatedMarkerBearing = bearing;
               
               // First ping, set camera instantly
               if (_mapController != null) {
                 _mapController!.moveCamera(
                   CameraUpdate.newCameraPosition(
                     CameraPosition(
                       target: bestPos,
                       zoom: 17.5,
                       bearing: 0.0,
                     ),
                   ),
                 );
               }
            } else {
               if (_animEndMarkerTarget != bestPos) {
                 _animStartMarkerTarget = _animatedMarkerPos;
                 _animStartMarkerBearing = _animatedMarkerBearing;
                 
                 _animEndMarkerTarget = bestPos;
                 
                 _animStartMarkerBearing = _normalizeBearing(_animStartMarkerBearing);
                 double endB = _normalizeBearing(bearing);
                 double diff = endB - _animStartMarkerBearing;
                 if (diff > 180) diff -= 360;
                 else if (diff < -180) diff += 360;
                 _animEndMarkerBearing = _animStartMarkerBearing + diff;
                 
                 _lastDataReceivedMs = DateTime.now().millisecondsSinceEpoch;
               }
            }

            return Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    child: IgnorePointer(
                      child: ValueListenableBuilder<int>(
                        valueListenable: _mapRebuildNotifier,
                        builder: (context, _, child) {
                          final animPos = _animatedMarkerPos ?? bestPos!;
                          final animBearing = _animatedMarkerPos != null ? _animatedMarkerBearing : bearing;

                          return GoogleMap(
                              key: ValueKey(_selectedDevice?.id),
                              initialCameraPosition: CameraPosition(
                                target: bestPos!,
                                zoom: 17.5,
                                bearing: 0.0,
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
                                  position: animPos,
                                  icon:
                                      _customMarker ?? BitmapDescriptor.defaultMarker,
                                  anchor: const Offset(0.5, 0.5),
                                  flat: true,
                                  rotation: animBearing % 360,
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
  
                            // Initialize camera state fields
                            _cameraTarget = appState.livePosition ?? bestPos;
                            _cameraZoom = 11.0;
                            _cameraTilt = 0.0;
                            _cameraBearing = _normalizeBearing(appState.liveBearing - 120.0);
  
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  _triggerInitialFocusAnimation();
                                });
                              },
                            );
                        }
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
    return BlocBuilder<RideHistoryCubit, RideHistoryState>(
      builder: (context, rideState) {
        return BlocBuilder<AppCubit, AppState>(
          builder: (context, appState) {
            Ride? lastRide;
            if (rideState is RideHistorySuccess && rideState.rides.isNotEmpty) {
              lastRide = rideState.rides.last;
            }

            final liveDevice = appState.devices.firstWhere(
              (d) => d['imei']?.toString() == _selectedDevice?.imei || d['_id']?.toString() == _selectedDevice?.id || d['id']?.toString() == _selectedDevice?.id,
              orElse: () => <String, dynamic>{},
            );
            
            final odometer = liveDevice['odometer']?.toString() ?? "0";
            dynamic attrs = liveDevice['attributes'];
            if (attrs is String) {
              try { attrs = jsonDecode(attrs); } catch (_) {}
            }

            String speed = "${liveDevice['sp'] ?? _selectedDevice?.currentLocation?.speed ?? 0} ${context.displayKmh}";
            
            String todayDistanceStr = "0.0";
            String durationStr = "0${l10n.minutesShort} 0${l10n.secondsShort}";
            String topSpeed = "0 ${context.displayKmh}";

            if (lastRide != null) {
              todayDistanceStr = lastRide.distance.toStringAsFixed(1);
              durationStr = lastRide.duration;
              topSpeed = "${lastRide.topSpeed.toStringAsFixed(1)} ${context.displayKmh}";
            } else {
              final todayDistanceRaw = liveDevice['todayDistance'] ?? liveDevice['td'] ?? liveDevice['distance'] ?? odometer;
              if (todayDistanceRaw != null && todayDistanceRaw.toString().isNotEmpty) {
                 double val = double.tryParse(todayDistanceRaw.toString()) ?? 0.0;
                 todayDistanceStr = val.toStringAsFixed(1);
              } else {
                 todayDistanceStr = odometer;
              }

              final todayDurationRaw = liveDevice['todayDuration'] ?? liveDevice['dur'] ?? liveDevice['duration'] ?? "0";
              if (todayDurationRaw != null && todayDurationRaw.toString().isNotEmpty && todayDurationRaw.toString() != "0") {
                final rawStr = todayDurationRaw.toString();
                if (rawStr.contains('m') || rawStr.contains('h') || rawStr.contains(':')) {
                  durationStr = rawStr;
                } else {
                  final double? numVal = double.tryParse(rawStr);
                  if (numVal != null && numVal > 0) {
                    int totalSeconds = numVal.round();
                    if (numVal > 100000) { totalSeconds = (numVal / 1000).round(); }
                    else if (numVal < 1440) { totalSeconds = (numVal * 60).round(); }
                    final int h = totalSeconds ~/ 3600;
                    final int m = (totalSeconds % 3600) ~/ 60;
                    final int s = totalSeconds % 60;
                    if (h > 0) { durationStr = "${h}h ${m}${l10n.minutesShort}"; }
                    else { durationStr = "${m}${l10n.minutesShort} ${s}${l10n.secondsShort}"; }
                  }
                }
              }
            }

            String distance = "$todayDistanceStr ${context.displayKm}";

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                children: [
                  _buildStatItem(l10n.distanceLabel, distance),
                  _buildStatItem(l10n.rideDuration, durationStr),
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DiscoverFeaturesScreen(),
          ),
        );
      },
      child: Container(
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
        "badge": "Coming Soon",
      },
      {
        "icon": Icons.local_parking_rounded,
        "label": l10n.safeParking.replaceAll(' ', '\n'),
        "badge": "Coming Soon",
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
        "badge": "Coming Soon",
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
      onTap: () => option["badge"] == "Coming Soon"
          ? null
          : _handleExploreTap(option, selectedDevice, l10n),
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
                color: option["badge"] == "Coming Soon"
                    ? Theme.of(context).disabledColor
                    : Theme.of(context).colorScheme.primary,
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
      final vehicle = selectedDevice != null
          ? Vehicle(
              id: selectedDevice.id,
              userId: selectedDevice.userId,
              vehicleMaker: selectedDevice.vehicleMaker,
              vehicleNumber: selectedDevice.vehicleNumber,
              vehicleModel: selectedDevice.vehicleModel,
              imei: selectedDevice.imei,
            )
          : null;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OverSpeedAlertScreen(vehicle: vehicle),
        ),
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
    } else if (label == l10n.appUpdates.replaceAll(' ', '\n')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UpdateScreen()),
      );
    } else if (label == l10n.helpAndSupport.replaceAll(' ', '\n')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HelpSuggestionScreen()),
      );
    } else if (label == l10n.emergency.replaceAll(' ', '\n')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EmergencyAlertScreen()),
      );
    } else if (label == l10n.safeParking.replaceAll(' ', '\n')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SafeParkingScreen()),
      );
    } else if (label == l10n.documentFolder.replaceAll(' ', '\n')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DocumentFolderScreen()),
      );
    } else if (label == l10n.videoTutorials.replaceAll(' ', '\n')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CategoryScreen()),
      );
    } else if (label == l10n.deviceDataPlanLabel.replaceAll(' ', '\n')) {
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
          MaterialPageRoute(builder: (context) => DeviceDataScreen()),
        );
      }
    } else if (label == l10n.geoFenceAlert.replaceAll(' ', '\n')) {
      final vName = selectedDevice != null
          ? "${selectedDevice.vehicleMaker} ${selectedDevice.vehicleNumber}"
          : null;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              GeoFenceScreen(vehicleName: vName, imei: selectedDevice?.imei),
        ),
      );
    } else if (label == l10n.upgradeToPlus.replaceAll(' ', '\n')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UpgradeToPlusScreen()),
      );
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
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.videos.length + (state.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Loader at bottom
                    if (index >= state.videos.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final video = state.videos[index];

                    return PromoVideoCard(video: video);
                  },
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
        print("device.imei----------------------------------${device.imei}");
        await prefs.set(key: AppPreference.KEY_SELECTED_UID, value: device.id);
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

        context.read<AppCubit>().initializeSocket(imei: device.imei);
      },
    );
  }
}
