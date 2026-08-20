import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:trackify/core/utils/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trackify/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trackify/app/cubit/app_cubit.dart';
import 'package:trackify/app/cubit/app_state.dart';
import 'package:trackify/app/app_navigation.dart';
import 'package:trackify/core/constants/app_images.dart';
import 'package:trackify/core/theme/app_colors.dart';
import 'package:trackify/core/utils/map_utils.dart';
import 'package:trackify/core/widgets/bouncing_widget.dart';
import 'package:trackify/core/widgets/draggable_app_bar.dart';
import 'package:trackify/feature/add_vehicle_and_device/choice_selector.dart';
import 'package:trackify/feature/app_updates/presentiation/pages/update_screen.dart';
import 'package:trackify/feature/device_warranty/pages/device_warranty_page.dart';
import 'package:trackify/feature/document_folder/presentation/pages/document_screen.dart';
import 'package:trackify/feature/device_installation/presentation/pages/device_installation_screen.dart';
import 'package:trackify/feature/my_garage/presentation/view/products_screen.dart';
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

import 'package:trackify/feature/map/presentation/cubit/promo_video_cubit.dart';
import 'package:trackify/feature/map/presentation/cubit/promo_video_state.dart';
import 'package:trackify/feature/map/presentation/widgets/promo_video_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:trackify/feature/map/data/entity/promo_offer_model.dart';
import 'package:trackify/core/config/network/api_host.dart';

import '../../../../core/config/style_manager.dart';
import '../../../upgrade_to_plus/presentation/pages/upgrade_to_plus.dart';
import '../cubit/map_cubit.dart';
import '../cubit/map_state.dart';
import 'package:trackify/core/common/models/vehicle_list_model.dart';
import 'package:trackify/core/utils/distance_utils.dart';
import 'package:trackify/feature/geo_fence/presentation/cubit/geo_fence_cubit.dart';
import 'package:trackify/feature/geo_fence/presentation/cubit/geo_fence_state.dart';
import 'package:trackify/feature/device_warranty/data/repository/device_warranty_repository_impl.dart';
import 'package:trackify/feature/device_warranty/data/data_source/device_warranty_data_source.dart';
import 'package:trackify/core/config/network/network_api_service.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';
import '../../../device_data/presentation/cubit/device_data_cubit.dart';
import '../../../device_data/presentation/cubit/device_data_state.dart';
import '../../../device_data/domain/entity/current_plan_entity.dart';
import 'package:trackify/feature/get_more_out/presentation/cubit/discover_cubit.dart';
import 'package:trackify/feature/get_more_out/presentation/cubit/disocver_state.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin, WidgetsBindingObserver {
  GoogleMapController? _mapController;
  String? _lightMapStyle;
  String? _darkMapStyle;
  Vehicles? _selectedDevice;
  BitmapDescriptor? _customMarker;
  BitmapDescriptor? _carMarker;
  BitmapDescriptor? _rickshawMarker;
  BitmapDescriptor? _busMarker;
  BitmapDescriptor? _vanMarker;
  BitmapDescriptor? _userLocationMarker;
  final prefs = AppPreference.instance;
  bool _isExploreExpanded = false; // For Expandable Explore More section
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;
  bool _hasNavigatedToInstallation = false;

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
  bool _hidePromoBanner = false;
  bool _isOfferExpanded = true;
  String _currentMarkerLetter = '';

  Timer? _rideHistoryUpdateTimer;

  // Dynamic offers state
  List<PromoOfferModel> _allOffers = [];
  List<PromoOfferModel> _promoOffers = [];
  bool _isLoadingOffers = false;
  int _currentOfferIndex = 0;
  late PageController _offerPageController;
  Timer? _offerAutoScrollTimer;

  @override
  void dispose() {
    _rideHistoryUpdateTimer?.cancel();
    _offerAutoScrollTimer?.cancel();
    _offerPageController.dispose();
    _cameraAnimationController?.dispose();
    _markerAnimController?.dispose();
    _mapRebuildNotifier.dispose();
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (mounted) {
        context.read<MapCubit>().fetchVehicles();
        if (_selectedDevice != null && _selectedDevice!.imei != null) {
          context.read<AppCubit>().initializeSocket(imei: _selectedDevice!.imei);
        }
      }
    }
  }

  Brightness? _currentBrightness;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final brightness = Theme.of(context).brightness;
    if (_currentBrightness != brightness) {
      _currentBrightness = brightness;
      if (_mapController != null && mounted) {
        final appState = context.read<AppCubit>().state;
        final style = _getMapStyle(appState, context);
        MapUtils.setStyle(_mapController!, style);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _offerPageController = PageController();
    _fetchOffers();
    _startOfferAutoScroll();
    _hidePromoBanner = AppPreference.instance.getBoolSync(
      key: 'hide_promo_banner',
    );

    _markerAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(); // Runs continuously to compute physics

    _markerAnimController!.addListener(() {
      if (_animStartMarkerTarget != null && _animEndMarkerTarget != null) {
        final now = DateTime.now().millisecondsSinceEpoch;
        final elapsed = now - _lastDataReceivedMs;

        bool hasMoved = false;

        if (elapsed > 15000) {
          // Stop moving if no data received for 15 seconds
        } else {
          // Linear constant interpolation for steady movement
          double t = elapsed / 10000.0; // Assume 10 seconds between updates
          if (t > 1.0) t = 1.0; // Prevent overshooting

          final double lat =
              _animStartMarkerTarget!.latitude +
              (_animEndMarkerTarget!.latitude -
                      _animStartMarkerTarget!.latitude) *
                  t;
          final double lng =
              _animStartMarkerTarget!.longitude +
              (_animEndMarkerTarget!.longitude -
                      _animStartMarkerTarget!.longitude) *
                  t;

          if (_animatedMarkerPos?.latitude != lat ||
              _animatedMarkerPos?.longitude != lng) {
            _animatedMarkerPos = LatLng(lat, lng);
            hasMoved = true;
          }

          double diffBearing = _animEndMarkerBearing - _animStartMarkerBearing;
          if (diffBearing > 180) diffBearing -= 360;
          if (diffBearing < -180) diffBearing += 360;

          final double newBearing = _animStartMarkerBearing + diffBearing * t;
          if (_animatedMarkerBearing != newBearing) {
            _animatedMarkerBearing = newBearing;
            hasMoved = true;
          }
        }

        if (hasMoved && now - _lastMarkerRebuildMs >= 50) {
          _lastMarkerRebuildMs = now;
          _mapRebuildNotifier.value++;
        }

        if (_isInitialFocusDone &&
            mounted &&
            _mapController != null &&
            !(_cameraAnimationController?.isAnimating ?? false)) {
          if (now - _lastCameraUpdateMs >= 50) {
            _lastCameraUpdateMs = now;

            final currentTarget = _cameraTarget ?? _animatedMarkerPos!;

            final double latDiff =
                (_animatedMarkerPos!.latitude - currentTarget.latitude).abs();
            final double lngDiff =
                (_animatedMarkerPos!.longitude - currentTarget.longitude).abs();
            final double distanceDiff = latDiff + lngDiff;

            double dynamicPosFactor = 0.15;
            if (distanceDiff > 0.002) {
              dynamicPosFactor = 1.0;
            } else if (distanceDiff > 0.0006) {
              dynamicPosFactor =
                  0.15 + (1.0 - 0.15) * ((distanceDiff - 0.0006) / 0.0014);
            }

            final double camLat =
                currentTarget.latitude +
                (_animatedMarkerPos!.latitude - currentTarget.latitude) *
                    dynamicPosFactor;
            final double camLng =
                currentTarget.longitude +
                (_animatedMarkerPos!.longitude - currentTarget.longitude) *
                    dynamicPosFactor;

            double diffBearing = _animatedMarkerBearing - _cameraBearing;
            if (diffBearing > 180) diffBearing -= 360;
            if (diffBearing < -180) diffBearing += 360;
            double newCameraBearing = _cameraBearing + diffBearing * 0.15;

            final nextPos = CameraPosition(
              target: LatLng(camLat, camLng),
              zoom: _cameraZoom,
              tilt: _cameraTilt,
              bearing: newCameraBearing,
            );

            _cameraTarget = nextPos.target;
            _cameraBearing = newCameraBearing;
            try {
              _mapController!.moveCamera(
                CameraUpdate.newCameraPosition(nextPos),
              );
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
        final appState = context.read<AppCubit>().state;
        context.read<MapCubit>().fetchVehicles();
        context.read<PromoVideoCubit>().fetchPromoVideos(
          _selectedDevice?.imei ?? 'null',
        );
        final name = appState.userData?.name ?? 'Me';
        final letter = name.isNotEmpty ? name[0].toUpperCase() : 'Me';
        final primaryColor = Theme.of(context).colorScheme.primary;
        _createUserLocationMarker(letter, primaryColor);
        _loadGeoFenceIcons(primaryColor);
      }
    });
  }

  Future<void> _fetchOffers() async {
    if (!mounted) return;
    print('[MapScreen Banners] Fetching offers from API...');
    setState(() {
      _isLoadingOffers = true;
    });

    try {
      final response = await http
          .get(Uri.parse(ApiURL.promoOffers))
          .timeout(const Duration(seconds: 10));

      print('[MapScreen Banners] Status code: ${response.statusCode}');
      print('[MapScreen Banners] Response body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        List<PromoOfferModel> fetchedOffers = [];
        if (decoded is List) {
          fetchedOffers = decoded
              .map((e) => PromoOfferModel.fromJson(e))
              .toList();
        } else if (decoded is Map && decoded['data'] is List) {
          fetchedOffers = (decoded['data'] as List)
              .map((e) => PromoOfferModel.fromJson(e))
              .toList();
        }

        print('[MapScreen Banners] Parsed ${fetchedOffers.length} offers.');

        if (mounted) {
          setState(() {
            _allOffers = fetchedOffers;
            _isLoadingOffers = false;
          });
          _filterOffers();
          _startOfferAutoScroll();
          return;
        }
      }
    } catch (e) {
      print('[MapScreen Banners] Error fetching offers: $e');
    }

    // Fallback to empty list (no mock/demo banners)
    if (mounted) {
      setState(() {
        _allOffers = [];
        _isLoadingOffers = false;
      });
      _filterOffers();
      _startOfferAutoScroll();
    }
  }

  void _filterOffers() {
    if (!mounted) return;
    final now = DateTime.now();
    print('[MapScreen Banners] Filtering offers. Current local time: $now');
    final active = _allOffers.where((offer) {
      print(
        '[MapScreen Banners] Offer: ${offer.tagText} | isActive: ${offer.isActive} | showDateTime: ${offer.showDateTime} | expiryDateTime: ${offer.expiryDateTime}',
      );
      if (!offer.isActive) {
        print('[MapScreen Banners] -> Skipped: Not active');
        return false;
      }
      if (offer.showDateTime != null && now.isBefore(offer.showDateTime!)) {
        print('[MapScreen Banners] -> Skipped: Not yet show time');
        return false;
      }
      if (offer.expiryDateTime != null &&
          !now.isBefore(offer.expiryDateTime!)) {
        print('[MapScreen Banners] -> Skipped: Already expired');
        return false;
      }
      print('[MapScreen Banners] -> Kept: Active!');
      return true;
    }).toList();

    print('[MapScreen Banners] Active offers count: ${active.length}');

    bool isChanged = active.length != _promoOffers.length;
    if (!isChanged) {
      for (int i = 0; i < active.length; i++) {
        if (active[i].id != _promoOffers[i].id) {
          isChanged = true;
          break;
        }
      }
    }

    if (isChanged) {
      setState(() {
        _promoOffers = active;
        if (_currentOfferIndex >= _promoOffers.length) {
          _currentOfferIndex = 0;
        }
      });
    }
  }

  void _startOfferAutoScroll() {
    _offerAutoScrollTimer?.cancel();
    _offerAutoScrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      _filterOffers();
      if (_promoOffers.isEmpty ||
          !mounted ||
          _offerPageController.hasClients == false) {
        return;
      }
      int nextIndex = _currentOfferIndex + 1;
      if (nextIndex >= _promoOffers.length) {
        nextIndex = 0;
      }
      _offerPageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  BitmapDescriptor? _homeIcon;
  BitmapDescriptor? _officeIcon;
  BitmapDescriptor? _familyIcon;
  BitmapDescriptor? _parkingIcon;
  BitmapDescriptor? _othersIcon;

  GeoFenceState? _lastGeoState;
  String? _lastImeiForGeoCircles;
  final Set<Circle> _cachedGeoCircles = {};
  final Set<Marker> _cachedGeoMarkers = {};

  Future<void> _loadGeoFenceIcons(Color primaryColor) async {
    _homeIcon = await MapUtils.createGeoFenceMarkerIcon(
      Icons.home_outlined,
      primaryColor,
    );
    _officeIcon = await MapUtils.createGeoFenceMarkerIcon(
      Icons.apartment_outlined,
      primaryColor,
    );
    _familyIcon = await MapUtils.createGeoFenceMarkerIcon(
      Icons.person_outline,
      primaryColor,
    );
    _parkingIcon = await MapUtils.createGeoFenceMarkerIcon(
      Icons.local_parking_outlined,
      primaryColor,
    );
    _othersIcon = await MapUtils.createGeoFenceMarkerIcon(
      Icons.location_on_outlined,
      primaryColor,
    );
    _cachedGeoMarkers.clear(); // invalidate cache to apply new icons
    if (mounted) _mapRebuildNotifier.value++;
  }

  String? _getMapStyle(AppState state, BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (state.mapType == 'satellite' ||
        state.mapStyle == 'Satellite' ||
        state.mapStyle == l10n?.satelliteStyle) {
      return null;
    }

    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    if (state.mapStyle == 'Simple' || state.mapStyle == l10n?.simpleStyle) {
      return _lightMapStyle;
    }

    return isDarkTheme ? _darkMapStyle : _lightMapStyle;
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
    final Uint8List carIcon = await MapUtils.getBytesFromAsset(
      AppImages.carImage,
      80,
    );
    final Uint8List rickshawIcon = await MapUtils.getBytesFromAsset(
      AppImages.rickshawImage,
      80,
    );
    final Uint8List busIcon = await MapUtils.getBytesFromAsset(
      AppImages.busImage,
      80,
    );
    final Uint8List vanIcon = await MapUtils.getBytesFromAsset(
      AppImages.vanImage,
      80,
    );
    if (mounted) {
      setState(() {
        _customMarker = BitmapDescriptor.fromBytes(markerIcon);
        _carMarker = BitmapDescriptor.fromBytes(carIcon);
        _rickshawMarker = BitmapDescriptor.fromBytes(rickshawIcon);
        _busMarker = BitmapDescriptor.fromBytes(busIcon);
        _vanMarker = BitmapDescriptor.fromBytes(vanIcon);
      });
      _mapRebuildNotifier.value++;
    }
  }

  Future<void> _createUserLocationMarker(
    String letter,
    Color primaryColor,
  ) async {
    const int size = 120;
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    const double center = size / 2;
    const double pinBodyRadius = 36.0;
    const double tipHeight = 18.0;

    // Outer glow ring
    final Paint glowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.22)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      const Offset(center, center - tipHeight / 2),
      pinBodyRadius + 12,
      glowPaint,
    );

    // White border
    final Paint borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      const Offset(center, center - tipHeight / 2),
      pinBodyRadius + 3.5,
      borderPaint,
    );

    // Circle body with theme primary color
    final Paint bodyPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      const Offset(center, center - tipHeight / 2),
      pinBodyRadius,
      bodyPaint,
    );

    // Draw the letter
    final ui.ParagraphBuilder pb =
        ui.ParagraphBuilder(
            ui.ParagraphStyle(
              fontSize: 38,
              fontWeight: ui.FontWeight.w700,
              textAlign: TextAlign.center,
            ),
          )
          ..pushStyle(
            ui.TextStyle(
              color: Colors.white,
              fontSize: 38,
              fontWeight: ui.FontWeight.w700,
            ),
          )
          ..addText(letter);
    final ui.Paragraph paragraph = pb.build();
    paragraph.layout(ui.ParagraphConstraints(width: size.toDouble()));
    canvas.drawParagraph(
      paragraph,
      Offset(0, center - tipHeight / 2 - paragraph.height / 2),
    );

    final ui.Image image = await recorder.endRecording().toImage(size, size);
    final ByteData? byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    if (byteData != null && mounted) {
      setState(() {
        _userLocationMarker = BitmapDescriptor.fromBytes(
          byteData.buffer.asUint8List(),
        );
      });
      _mapRebuildNotifier.value++;
    }
  }

  LatLng? _getBestPosition() {
    if (!mounted) return null;
    final appState = context.read<AppCubit>().state;
    final currentPos = appState.currentLocation;
    LatLng? bestPos;

    final bool isDeviceNotInstalledOrExpired =
        _selectedDevice == null ||
        _selectedDevice!.imei == null ||
        _selectedDevice!.imei!.isEmpty ||
        _isWarrantyExpired;

    if (!isDeviceNotInstalledOrExpired) {
      bestPos = appState.livePosition;

      if (bestPos == null &&
          _selectedDevice?.currentLocation != null &&
          _selectedDevice!.currentLocation!.lat != null &&
          _selectedDevice!.currentLocation!.lng != null) {
        bestPos = LatLng(
          _selectedDevice!.currentLocation!.lat!,
          _selectedDevice!.currentLocation!.lng!,
        );
      }
    }

    if (bestPos == null && currentPos != null) {
      bestPos = LatLng(currentPos.latitude, currentPos.longitude);
    }
    return bestPos;
  }

  void _triggerInitialFocusAnimation() {
    LatLng? target = _getBestPosition();
    if (target == null) return;

    final bool isDeviceNotInstalledOrExpired =
        _selectedDevice == null ||
        _selectedDevice!.imei == null ||
        _selectedDevice!.imei!.isEmpty ||
        _isWarrantyExpired;

    double bearing = 0.0;

    if (!isDeviceNotInstalledOrExpired) {
      final appState = context.read<AppCubit>().state;
      final currData = appState.devices.firstWhere(
        (d) =>
            d['imei'] == _selectedDevice?.imei ||
            d['_id'] == _selectedDevice?.id ||
            d['id'] == _selectedDevice?.id,
        orElse: () => <String, dynamic>{},
      );
      bearing =
          double.tryParse(
            (currData['course'] ??
                    currData['bearing'] ??
                    currData['angle'] ??
                    currData['dir'] ??
                    '0')
                .toString(),
          ) ??
          0.0;
    }

    // Glide smoothly focusing on the vehicle (drone camera zoom & rotate effect)
    // 600ms delay ensures native layout/tiles/styles are ready before animation starts
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      _animateCameraTo(
        target: target,
        zoom: 16.0,
        tilt: 0.0,
        bearing: isDeviceNotInstalledOrExpired
            ? 0.0
            : (_animatedMarkerPos != null ? _animatedMarkerBearing : bearing),
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
        debugPrint(
          "Failed to move camera on disposed/detached map controller: $e",
        );
      }
    });

    _cameraAnimationController!.forward();
  }

  void _manageRideHistoryTimer(AppState state) {
    if (_selectedDevice == null || _isWarrantyExpired || !mounted) {
      if (_rideHistoryUpdateTimer != null) {
        _rideHistoryUpdateTimer?.cancel();
        _rideHistoryUpdateTimer = null;
      }
      return;
    }
    final liveDevice = state.devices.firstWhere(
      (d) =>
          d['imei']?.toString() == _selectedDevice?.imei ||
          d['_id']?.toString() == _selectedDevice?.id ||
          d['id']?.toString() == _selectedDevice?.id,
      orElse: () => <String, dynamic>{},
    );
    if (liveDevice.isNotEmpty) {
      String speedStr = liveDevice['sp']?.toString() ?? "0";
      double speed = double.tryParse(speedStr) ?? 0.0;
      String status = liveDevice['status']?.toString().toLowerCase() ?? '';

      bool isMoving = speed > 2.0 || status == 'moving';

      if (isMoving) {
        if (_rideHistoryUpdateTimer == null ||
            !_rideHistoryUpdateTimer!.isActive) {
          context.read<RideHistoryCubit>().getRideHistoryData();
          _rideHistoryUpdateTimer = Timer.periodic(
            const Duration(seconds: 20),
            (_) {
              if (mounted) {
                context.read<RideHistoryCubit>().getRideHistoryData();
              }
            },
          );
        }
      } else {
        if (_rideHistoryUpdateTimer != null &&
            _rideHistoryUpdateTimer!.isActive) {
          _rideHistoryUpdateTimer?.cancel();
          _rideHistoryUpdateTimer = null;
          // Fetch one last time to get the final parked stats
          context.read<RideHistoryCubit>().getRideHistoryData();
        }
      }
    }
  }

  bool _hasShownWarrantyPopup = false;
  bool _isWarrantyExpired = AppPreference.instance.getBoolSync(
    key: 'KEY_WARRANTY_EXPIRED',
    defaultValue: true,
  );
  bool _isWarrantyLoading = true;

  Future<void> _checkWarrantyStatus(String imei) async {
    if (mounted) {
      setState(() {
        _isWarrantyLoading = true;
      });
    }
    try {
      final repository = DeviceWarrantyRepositoryImpl(
        DeviceWarrantyRemoteDataSourceImpl(NetworkApiService()),
      );
      final result = await repository.getDeviceWarrantyStatus(imei);
      result.fold(
        (l) {
          final previouslyExpired = AppPreference.instance.getBoolSync(
            key: 'KEY_WARRANTY_EXPIRED',
            defaultValue: true,
          );
          if (previouslyExpired) {
            AppPreference.instance
                .setBool(key: 'KEY_WARRANTY_EXPIRED', value: false)
                .then((_) {
                  AppNavigation.refreshNavigationState();
                });
          }
          if (mounted) {
            setState(() {
              _isWarrantyExpired = false;
              _isWarrantyLoading = false;
            });
          }
        }, // error, ignore
        (r) {
          if (!mounted) return;
          final daysLeft = r.warranty?.daysLeft;
          final bool apiIsExpired = r.warranty?.isExpired ?? false;
          final expired = (daysLeft != null && daysLeft > 0)
              ? false
              : (apiIsExpired || (daysLeft != null && daysLeft <= 0));

          final previouslyExpired = AppPreference.instance.getBoolSync(
            key: 'KEY_WARRANTY_EXPIRED',
            defaultValue: true,
          );
          if (previouslyExpired != expired) {
            AppPreference.instance
                .setBool(key: 'KEY_WARRANTY_EXPIRED', value: expired)
                .then((_) {
                  AppNavigation.refreshNavigationState();
                });
          }

          setState(() {
            _isWarrantyExpired = expired;
            _isWarrantyLoading = false;
          });
          // Refresh recharge plan data to show alongside warranty expired banner
          if (expired && mounted) {
            context.read<DeviceDataCubit>().load();
          }
          if (daysLeft != null && daysLeft <= 2) {
            if (!_hasShownWarrantyPopup) {
              _hasShownWarrantyPopup = true;
              _showWarrantyPopup(daysLeft);
            }
          }
        },
      );
    } catch (e) {
      debugPrint("Error checking warranty for popup: $e");
      if (mounted) {
        setState(() {
          _isWarrantyLoading = false;
        });
      }
    }
  }

  void _showWarrantyPopup(int daysLeft) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 28,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.warrantyExpiringTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Text(
            daysLeft <= 0
                ? l10n.warrantyExpiredDesc
                : l10n.warrantyExpiringDesc(daysLeft.toString()),
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                l10n.dismiss,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const WarrantyScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(l10n.renewNow),
            ),
          ],
        );
      },
    );
  }

  double _normalizeBearing(double bearing) {
    double b = bearing % 360;
    if (b < 0) b += 360;
    return b;
  }

  @override
  Widget build(BuildContext context) {
    _isWarrantyExpired = AppPreference.instance.getBoolSync(
      key: 'KEY_WARRANTY_EXPIRED',
      defaultValue: true,
    );
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: MultiBlocListener(
        listeners: [
          // ── Logout detector: reset warranty state when user logs out ──
          BlocListener<AppCubit, AppState>(
            listenWhen: (prev, curr) =>
                prev.userData != null && curr.userData == null,
            listener: (context, appState) {
              if (mounted) {
                setState(() {
                  _selectedDevice = null;
                  _isWarrantyExpired = true;
                  _isWarrantyLoading = false;
                  _hasShownWarrantyPopup = false;
                  _hasNavigatedToInstallation = false;
                });
                debugPrint(
                  '[MapScreen] Logout detected — warranty & device state reset.',
                );
              }
            },
          ),
          BlocListener<MapCubit, MapState>(
            listener: (context, state) {
              if (state is MapLoaded) {
                final vehicles = state.vehicleList.vehicles ?? [];
                if (vehicles.isNotEmpty) {
                  // Vehicles exist — reset the navigation flag so that a future
                  // deletion will navigate again even if the flag was previously set.
                  _hasNavigatedToInstallation = false;

                  // Check if current selection is still valid in the new vehicles list
                  final bool isCurrentSelectedValid =
                      _selectedDevice != null &&
                      vehicles.any((v) => v.id == _selectedDevice!.id);

                  if (!isCurrentSelectedValid) {
                    // Selection is invalid (deleted or null). Reset selection.
                    final savedUid = prefs.getSync(
                      key: AppPreference.KEY_SELECTED_UID,
                    );
                    final savedImei = prefs.getSync(key: AppPreference.IMEI);

                    Vehicles? matchedVehicle;
                    if (savedUid.isNotEmpty) {
                      try {
                        matchedVehicle = vehicles.firstWhere(
                          (v) => v.id == savedUid,
                        );
                      } catch (_) {}
                    }
                    if (matchedVehicle == null && savedImei.isNotEmpty) {
                      try {
                        matchedVehicle = vehicles.firstWhere(
                          (v) => v.imei == savedImei,
                        );
                      } catch (_) {}
                    }

                    final savedVehicle = matchedVehicle ?? vehicles.first;

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
                    AppNavigation.refreshNavigationState();

                    // Refresh rides and initialize socket for the new vehicle
                    context.read<RideHistoryCubit>().getRideHistoryData();
                    context.read<AppCubit>().initializeSocket(
                      imei: savedVehicle.imei,
                    );

                    if (savedVehicle.imei != null &&
                        savedVehicle.imei!.isNotEmpty) {
                      context.read<GeoFenceCubit>().fetchGeoFences(
                        savedVehicle.imei!,
                      );
                      _checkWarrantyStatus(savedVehicle.imei!);
                      context.read<PromoVideoCubit>().fetchPromoVideos(
                        savedVehicle.imei!,
                      );
                    } else {
                      context.read<PromoVideoCubit>().fetchPromoVideos("null");
                      setState(() {
                        _isWarrantyExpired = AppPreference.instance.getBoolSync(
                          key: 'KEY_WARRANTY_EXPIRED',
                          defaultValue: true,
                        );
                        _isWarrantyLoading = false;
                      });
                    }
                  } else {
                    // Current selection is still valid, just update the data (strictly by ID)
                    final updatedDevice = vehicles.firstWhere(
                      (v) => v.id == _selectedDevice!.id,
                    );
                    setState(() {
                      _selectedDevice = updatedDevice;
                    });
                    if (updatedDevice.imei != null &&
                        updatedDevice.imei!.isNotEmpty) {
                      context.read<GeoFenceCubit>().fetchGeoFences(
                        updatedDevice.imei!,
                      );
                      _checkWarrantyStatus(updatedDevice.imei!);
                      context.read<PromoVideoCubit>().fetchPromoVideos(
                        updatedDevice.imei!,
                      );
                    } else {
                      context.read<PromoVideoCubit>().fetchPromoVideos("null");
                      setState(() {
                        _isWarrantyExpired = AppPreference.instance.getBoolSync(
                          key: 'KEY_WARRANTY_EXPIRED',
                          defaultValue: true,
                        );
                        _isWarrantyLoading = false;
                      });
                    }
                  }
                } else {
                  // ── Garage is EMPTY ──────────────────────────────────────────
                  // Clear stale in-memory & persistent vehicle references
                  setState(() {
                    _selectedDevice = null;
                    _isWarrantyLoading = false;
                    _isWarrantyExpired = true;
                  });
                  prefs.set(key: AppPreference.KEY_SELECTED_UID, value: '');
                  prefs.set(key: AppPreference.IMEI, value: '');
                  AppNavigation.refreshNavigationState();

                  // Guard: only navigate once per empty-garage event to prevent
                  // duplicate pushes if MapLoaded(empty) is emitted multiple times.
                  if (!_hasNavigatedToInstallation) {
                    _hasNavigatedToInstallation = true;
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const ChoiceSelector(),
                      ),
                      (route) => false,
                    );
                  }
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
                prev.devices != curr.devices ||
                prev.distanceUnit != curr.distanceUnit ||
                prev.userData?.name != curr.userData?.name,
            listener: (context, state) async {
              final name = state.userData?.name ?? 'Me';
              final letter = name.isNotEmpty ? name[0].toUpperCase() : 'Me';
              if (_currentMarkerLetter != letter) {
                _currentMarkerLetter = letter;
                final primaryColor = Theme.of(context).colorScheme.primary;
                _createUserLocationMarker(letter, primaryColor);
              }
              _manageRideHistoryTimer(state);
              if (_mapController != null) {
                String? style = _getMapStyle(state, context);
                if (mounted && _mapController != null) {
                  try {
                    await MapUtils.setStyle(_mapController!, style);
                  } catch (e) {
                    debugPrint("Error setting map style: $e");
                  }
                }
              }

              // Rebuild the UI if distance unit changes so the labels update instantly
              if (mounted) {
                setState(() {});
              }
            },
          ),
        ],
        child: BlocBuilder<MapCubit, MapState>(
          builder: (context, state) {
            final List<Vehicles> vehicles = state is MapLoaded
                ? (state.vehicleList.vehicles ?? <Vehicles>[])
                : <Vehicles>[];

            final topSpacing = MediaQuery.of(context).padding.top + 85;
            final bool isDeviceNotInstalledOrExpired =
                _selectedDevice == null ||
                _selectedDevice!.imei == null ||
                _selectedDevice!.imei!.isEmpty ||
                _isWarrantyExpired;

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
                            _buildOfferSection(),
                            if (_isWarrantyLoading)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 100.0),
                                child: Center(child: TrackifyLoader()),
                              )
                            else if (isDeviceNotInstalledOrExpired)
                              _buildPhoneAsGpsBanner()
                            else
                              _buildMapSection(),
                            if (!_hidePromoBanner &&
                                !isDeviceNotInstalledOrExpired &&
                                !_isWarrantyLoading) ...[
                              const SizedBox(height: 5),
                              _buildPromoBanner(),
                            ],
                            SizedBox(height: 5),
                            _buildExploreMore(_selectedDevice),
                            _buildRecentRidesSection(_selectedDevice),
                            _buildVideosSection(),
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
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_upward, color: Colors.grey[800], size: 16),
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
    );
  }

  Widget _buildOfferSection() {
    if (_isLoadingOffers) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: TrackifyLoader(size: 150, animated: true)),
      );
    }
    if (_promoOffers.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isOfferExpanded = !_isOfferExpanded;
            });
          },
          child: _buildOfferPill(),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.fastOutSlowIn,
          height: _isOfferExpanded ? 120 : 0,
          margin: EdgeInsets.only(top: _isOfferExpanded ? 8 : 0),
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(),
          child: AnimatedOpacity(
            opacity: _isOfferExpanded ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: AnimatedScale(
              scale: _isOfferExpanded ? 1.0 : 0.0,
              alignment: Alignment.topCenter,
              duration: const Duration(milliseconds: 350),
              curve: Curves.fastOutSlowIn,
              child: PageView.builder(
                controller: _offerPageController,
                itemCount: _promoOffers.length,
                physics: _isOfferExpanded
                    ? const BouncingScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentOfferIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final offer = _promoOffers[index];
                  return _buildOfferCard(offer);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOfferPill() {
    if (_promoOffers.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? theme.cardColor : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
        border: isDark
            ? Border.all(color: theme.dividerColor, width: 0.5)
            : null,
        gradient: isDark
            ? null
            : LinearGradient(
                colors: [Colors.grey[200]!, Colors.grey[300]!],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 24,
            height: 14,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: const BoxDecoration(
                    color: Color(0xFF671D4F),
                    shape: BoxShape.circle,
                  ),
                ),
                Positioned(
                  left: 8,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: const BoxDecoration(
                      color: Color(0xFF8FA4B3),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Text(
            "${_currentOfferIndex + 1}/${_promoOffers.length} Offers",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isDark ? theme.colorScheme.onSurface : Colors.black87,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            _isOfferExpanded
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down,
            size: 14,
            color: isDark
                ? theme.colorScheme.onSurface.withValues(alpha: 0.7)
                : Colors.black54,
          ),
        ],
      ),
    );
  }

  Widget _buildOfferCard(PromoOfferModel offer) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const UpgradeToPlusScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: offer.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                placeholder: (context, url) => Container(
                  color: theme.cardColor,
                  child: Center(
                    child: const TrackifyLoader(size: 80, animated: true),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: theme.cardColor,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Opacity(
                          opacity: 0.1,
                          child: Icon(
                            Icons.local_offer,
                            size: 80,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          "Special Offer Available",
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.dividerColor, width: 0.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
        height: 400,
        margin: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 6),
        padding: EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
              Theme.of(context).colorScheme.secondary.withValues(alpha: 0.02),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          border: Border.all(
            color: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.05),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: _buildAnimatedMapCore(showStats: true),
      ),
    );
  }

  Widget _buildAnimatedMapCore({bool showStats = true}) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, appState) {
        final currentPos = appState.currentLocation;
        if (currentPos == null) {
          return const Center(child: TrackifyLoader());
        }
        LatLng? bestPos;
        double bearing = 0.0;

        final bool isDeviceNotInstalledOrExpired =
            _selectedDevice == null ||
            _selectedDevice!.imei == null ||
            _selectedDevice!.imei!.isEmpty ||
            _isWarrantyExpired;

        if (isDeviceNotInstalledOrExpired) {
          bestPos = LatLng(currentPos.latitude, currentPos.longitude);
        } else {
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

          double rawCourse =
              double.tryParse(
                (liveData['course'] ??
                        liveData['bearing'] ??
                        liveData['angle'] ??
                        liveData['dir'] ??
                        '-1')
                    .toString(),
              ) ??
              -1.0;

          bearing = _animatedMarkerPos != null
              ? _animatedMarkerBearing
              : (rawCourse >= 0 ? rawCourse : 0.0);

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

            double speed =
                double.tryParse(
                  (liveData['sp'] ?? liveData['speed'] ?? '0').toString(),
                ) ??
                0.0;

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
        }

        // 3. Fallback to phone current location
        bestPos ??= LatLng(currentPos.latitude, currentPos.longitude);

        // Marker Animation Logic
        if (_animatedMarkerPos == null) {
          _animatedMarkerPos = bestPos;
          _animatedMarkerBearing = bearing;
          _animStartMarkerTarget = bestPos;
          _animStartMarkerBearing = bearing;
          _animEndMarkerTarget = bestPos;
          _animEndMarkerBearing = bearing;
          _lastDataReceivedMs = DateTime.now().millisecondsSinceEpoch;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _mapRebuildNotifier.value++;
          });

          // First ping, set camera instantly
          if (_mapController != null) {
            _mapController!.moveCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(target: bestPos, zoom: 17.5, bearing: 0.0),
              ),
            );
          }
        } else {
          if (_animEndMarkerTarget != bestPos) {
            int nowMs = DateTime.now().millisecondsSinceEpoch;
            double distToNew = Geolocator.distanceBetween(
              _animatedMarkerPos!.latitude,
              _animatedMarkerPos!.longitude,
              bestPos.latitude,
              bestPos.longitude,
            );

            if (distToNew > 500) {
              _animatedMarkerPos = bestPos;
              _animatedMarkerBearing = bearing;
              _animStartMarkerTarget = bestPos;
              _animStartMarkerBearing = bearing;
              _animEndMarkerTarget = bestPos;
              _animEndMarkerBearing = bearing;
              _lastDataReceivedMs = nowMs;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) _mapRebuildNotifier.value++;
              });
            } else {
              _animStartMarkerTarget = _animatedMarkerPos;
              _animStartMarkerBearing = _animatedMarkerBearing;
              _animEndMarkerTarget = bestPos;

              _animStartMarkerBearing = _normalizeBearing(
                _animStartMarkerBearing,
              );
              double endB = _normalizeBearing(bearing);
              double diff = endB - _animStartMarkerBearing;
              if (diff > 180) {
                diff -= 360;
              } else if (diff < -180)
                diff += 360;
              _animEndMarkerBearing = _animStartMarkerBearing + diff;

              _lastDataReceivedMs = nowMs;
            }
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
                      final animBearing = _animatedMarkerPos != null
                          ? _animatedMarkerBearing
                          : bearing;

                      return BlocBuilder<GeoFenceCubit, GeoFenceState>(
                        builder: (context, geoState) {
                          final l10n = AppLocalizations.of(context)!;
                          Set<Circle> circles = {};
                          Set<Marker> markers = {};
                          final bool hasDevice =
                              _selectedDevice?.imei != null &&
                              _selectedDevice!.imei!.isNotEmpty &&
                              !_isWarrantyExpired;

                          if (hasDevice) {
                            markers.add(
                              Marker(
                                markerId: const MarkerId('vehicle_marker'),
                                position: animPos,
                                icon: (() {
                                        final type = _selectedDevice?.vehicleType.toLowerCase() ?? '';
                                        if (type.contains('auto rickshaw') || type.contains('auto') || type.contains('3_wheeler')) {
                                          return _rickshawMarker;
                                        } else if (type.contains('car') || type.contains('4_wheeler') || type.contains('commercial ev')) {
                                          return _carMarker;
                                        } else if (type.contains('bus')) {
                                          return _busMarker;
                                        } else if (type.contains('van') || type.contains('truck') || type.contains('pickup') || type.contains('pick-up')) {
                                          return _vanMarker;
                                        }
                                        return _customMarker;
                                      })() ??
                                      BitmapDescriptor.defaultMarker,
                                anchor: const Offset(0.5, 0.5),
                                flat: true,
                                rotation: animBearing % 360,
                              ),
                            );
                          } else {
                            markers.add(
                            Marker(
                              markerId: const MarkerId('current_location'),
                              position: LatLng(
                                currentPos.latitude,
                                currentPos.longitude,
                              ),
                              icon:
                                  _userLocationMarker ??
                                  BitmapDescriptor.defaultMarkerWithHue(
                                    BitmapDescriptor.hueAzure,
                                  ),
                              anchor: const Offset(0.5, 0.5),
                              infoWindow: InfoWindow(
                                title: l10n.yourLocationLabel,
                              ),
                            ),
                          );
                          }


                          final currentImei = _selectedDevice?.imei;
                          if (_lastGeoState != geoState ||
                              _lastImeiForGeoCircles != currentImei ||
                              _cachedGeoCircles.isEmpty ||
                              _cachedGeoMarkers.isEmpty) {
                            _lastGeoState = geoState;
                            _lastImeiForGeoCircles = currentImei;
                            _cachedGeoCircles.clear();
                            _cachedGeoMarkers.clear();

                            if (geoState is GeoFenceLoaded) {
                              for (var fence in geoState.geoFences) {
                                if (!fence.isActive) continue;
                                if (fence.imei != currentImei) continue;

                                _cachedGeoCircles.add(
                                  Circle(
                                    circleId: CircleId(
                                      'geo_circle_${fence.id}_${fence.latitude}',
                                    ),
                                    center: LatLng(
                                      fence.latitude,
                                      fence.longitude,
                                    ),
                                    radius: fence.radius > 10
                                        ? fence.radius
                                        : 500.0,
                                    fillColor: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withValues(alpha: 0.3),
                                    strokeColor: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    strokeWidth: 2,
                                  ),
                                );

                                BitmapDescriptor markerIcon =
                                    _othersIcon ??
                                    BitmapDescriptor.defaultMarkerWithHue(
                                      BitmapDescriptor.hueCyan,
                                    );
                                final typeStr = '${fence.type} ${fence.name}'
                                    .toLowerCase();

                                if (typeStr.contains('home') ||
                                    typeStr.contains('घर') ||
                                    typeStr.contains('ಮನೆ') ||
                                    typeStr.contains('வீடு') ||
                                    typeStr.contains('منزل')) {
                                  markerIcon = _homeIcon ?? markerIcon;
                                } else if (typeStr.contains('office') ||
                                    typeStr.contains('कार्यालय') ||
                                    typeStr.contains('ಕಚೇರಿ') ||
                                    typeStr.contains('அலுவலகம்') ||
                                    typeStr.contains('مكتب')) {
                                  markerIcon = _officeIcon ?? markerIcon;
                                } else if (typeStr.contains('family') ||
                                    typeStr.contains('परिवार') ||
                                    typeStr.contains('कुटुंब') ||
                                    typeStr.contains('ಕುಟುಂಬ') ||
                                    typeStr.contains('குடும்பம்') ||
                                    typeStr.contains('عائلة')) {
                                  markerIcon = _familyIcon ?? markerIcon;
                                } else if (typeStr.contains('parking') ||
                                    typeStr.contains('पार्किंग') ||
                                    typeStr.contains('ಪಾರ್ಕಿಂಗ್') ||
                                    typeStr.contains('பார்க்கிங்') ||
                                    typeStr.contains('موقف')) {
                                  markerIcon = _parkingIcon ?? markerIcon;
                                }

                                _cachedGeoMarkers.add(
                                  Marker(
                                    markerId: MarkerId('geo_${fence.id}'),
                                    position: LatLng(
                                      fence.latitude,
                                      fence.longitude,
                                    ),
                                    icon: markerIcon,
                                    infoWindow: InfoWindow(title: fence.name),
                                  ),
                                );
                              }
                            }
                          }

                          if (hasDevice) {
                            circles.addAll(_cachedGeoCircles);
                            markers.addAll(_cachedGeoMarkers);
                          }

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
                            buildingsEnabled: false,
                            mapType: appState.mapType == 'satellite'
                                ? MapType.satellite
                                : MapType.normal,
                            trafficEnabled: appState.isTrafficEnabled,
                            markers: markers,
                            circles: circles,
                            onMapCreated:
                                (GoogleMapController controller) async {
                                  _mapController = controller;

                                  final appState = context
                                      .read<AppCubit>()
                                      .state;
                                  if (_darkMapStyle == null ||
                                      _lightMapStyle == null) {
                                    await _loadMapStyles();
                                  }

                                  final style = _getMapStyle(appState, context);
                                  await MapUtils.setStyle(controller, style);

                                  // Initialize camera state fields
                                  _cameraTarget = isDeviceNotInstalledOrExpired
                                      ? bestPos
                                      : (appState.livePosition ?? bestPos);
                                  _cameraZoom = 15.0;
                                  _cameraTilt = 0.0;
                                  _cameraBearing = isDeviceNotInstalledOrExpired
                                      ? 0.0
                                      : _normalizeBearing(
                                          appState.liveBearing - 120.0,
                                        );

                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    _triggerInitialFocusAnimation();
                                  });
                                },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            if (showStats) _buildStatsRow(),
          ],
        );
      },
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
              (d) =>
                  d['imei']?.toString() == _selectedDevice?.imei ||
                  d['_id']?.toString() == _selectedDevice?.id ||
                  d['id']?.toString() == _selectedDevice?.id,
              orElse: () => <String, dynamic>{},
            );

            final odometer = liveDevice['odometer']?.toString() ?? "0";
            dynamic attrs = liveDevice['attributes'];
            if (attrs is String) {
              try {
                attrs = jsonDecode(attrs);
              } catch (_) {}
            }

            bool isLastRideToday = false;
            if (lastRide != null) {
              try {
                if (lastRide.rawStartTime.isNotEmpty) {
                  final date = DateTime.parse(lastRide.rawStartTime).toLocal();
                  final now = DateTime.now();
                  if (date.year == now.year &&
                      date.month == now.month &&
                      date.day == now.day) {
                    isLastRideToday = true;
                  }
                } else {
                  final now = DateTime.now();
                  final format1 = "${now.day}/${now.month}/${now.year}";
                  final format2 =
                      "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
                  if (lastRide.date == format1 || lastRide.date == format2) {
                    isLastRideToday = true;
                  }
                }
              } catch (_) {}
            }

            String speed =
                "${liveDevice['sp'] ?? _selectedDevice?.currentLocation?.speed ?? 0} ${context.displayKmh}";
            if (!isLastRideToday) {
              speed = "0 ${context.displayKmh}";
            }

            String todayDistanceStr = "0.0";
            String durationStr = "0${l10n.minutesShort} 0${l10n.secondsShort}";
            String topSpeed = "0 ${context.displayKmh}";

            final lastUpdateRaw =
                liveDevice['last_update']?.toString() ??
                liveDevice['lastUpdate']?.toString() ??
                liveDevice['deviceTime']?.toString() ??
                liveDevice['time']?.toString();

            String startTimeStr = "";
            if (lastUpdateRaw != null && lastUpdateRaw.isNotEmpty) {
              try {
                DateTime updateDate;
                int? unixTime = int.tryParse(lastUpdateRaw);
                if (unixTime != null && unixTime > 1000000000) {
                  if (unixTime > 1000000000000) {
                    updateDate = DateTime.fromMillisecondsSinceEpoch(
                      unixTime,
                    ).toLocal();
                  } else {
                    updateDate = DateTime.fromMillisecondsSinceEpoch(
                      unixTime * 1000,
                    ).toLocal();
                  }
                } else {
                  updateDate = DateTime.parse(lastUpdateRaw).toLocal();
                }

                final now = DateTime.now();
                if (updateDate.year == now.year &&
                    updateDate.month == now.month &&
                    updateDate.day == now.day) {
                  startTimeStr =
                      "${updateDate.hour > 12 ? updateDate.hour - 12 : (updateDate.hour == 0 ? 12 : updateDate.hour)}:${updateDate.minute.toString().padLeft(2, '0')} ${updateDate.hour >= 12 ? 'PM' : 'AM'}";
                }
              } catch (_) {}
            }

            if (isLastRideToday && lastRide != null) {
              todayDistanceStr = lastRide.distance.toStringAsFixed(2);
              durationStr = lastRide.duration;
              topSpeed =
                  "${lastRide.topSpeed.toStringAsFixed(1)} ${context.displayKmh}";
              if (startTimeStr.isEmpty) {
                startTimeStr = lastRide.startTime;
              }
            } else {
              final todayDistanceRaw =
                  liveDevice['todayDistance'] ?? liveDevice['td'];
              if (todayDistanceRaw != null &&
                  todayDistanceRaw.toString().isNotEmpty) {
                double val =
                    double.tryParse(todayDistanceRaw.toString()) ?? 0.0;
                todayDistanceStr = val.toStringAsFixed(2);
              } else {
                todayDistanceStr = "0.00";
              }

              final todayDurationRaw =
                  liveDevice['todayDuration'] ??
                  liveDevice['dur'] ??
                  liveDevice['duration'] ??
                  "0";
              if (todayDurationRaw != null &&
                  todayDurationRaw.toString().isNotEmpty &&
                  todayDurationRaw.toString() != "0") {
                final rawStr = todayDurationRaw.toString();
                if (rawStr.contains('m') ||
                    rawStr.contains('h') ||
                    rawStr.contains(':')) {
                  durationStr = rawStr;
                } else {
                  final double? numVal = double.tryParse(rawStr);
                  if (numVal != null && numVal > 0) {
                    int totalSeconds = numVal.round();
                    if (numVal > 100000) {
                      totalSeconds = (numVal / 1000).round();
                    } else if (numVal < 1440) {
                      totalSeconds = (numVal * 60).round();
                    }
                    final int h = totalSeconds ~/ 3600;
                    final int m = (totalSeconds % 3600) ~/ 60;
                    final int s = totalSeconds % 60;
                    if (h > 0) {
                      durationStr = "${h}h $m${l10n.minutesShort}";
                    } else {
                      durationStr =
                          "$m${l10n.minutesShort} $s${l10n.secondsShort}";
                    }
                  }
                }
              }
            }

            final batteryVal = liveDevice['api_battery'];

            final voltageVal = null; // Ignored to strictly use DeviceStatus API battery

            String batteryText = "--";
            Color batteryColor = AppColors.paletteGreen;
            IconData batteryIcon = Icons.battery_charging_full;

            final rawVal = batteryVal ?? voltageVal;
            if (rawVal != null && rawVal.toString().trim().toLowerCase() != 'null' && rawVal.toString().trim() != '') {
              final rawStr = rawVal.toString().trim();
              int? intLevel;

              if (rawStr.toLowerCase().startsWith('0x')) {
                intLevel = int.tryParse(rawStr.substring(2), radix: 16);
              } else if (RegExp(r'^\d+$').hasMatch(rawStr)) {
                intLevel = int.tryParse(rawStr);
              }

              if (intLevel != null) {
                switch (intLevel) {
                  case 0:
                    batteryText = "Disconnected";
                    batteryColor = Colors.red.shade900;
                    batteryIcon = Icons.battery_alert_sharp;
                    break;
                  case 1:
                    batteryText = "Critical";
                    batteryColor = Colors.red.shade700;
                    batteryIcon = Icons.battery_1_bar;
                    break;
                  case 2:
                    batteryText = "Very low";
                    batteryColor = Colors.red.shade400;
                    batteryIcon = Icons.battery_2_bar;
                    break;
                  case 3:
                    batteryText = "Low";
                    batteryColor = Colors.orange.shade800;
                    batteryIcon = Icons.battery_3_bar;
                    break;
                  case 4:
                    batteryText = "Medium";
                    batteryColor = Colors.green.shade600;
                    batteryIcon = Icons.battery_4_bar;
                    break;
                  case 5:
                    batteryText = "Normal";
                    batteryColor = Colors.green.shade400;
                    batteryIcon = Icons.battery_5_bar;
                    break;
                  case 6:
                    batteryText = "Normal";
                    batteryColor = Colors.green.shade400;
                    batteryIcon = Icons.battery_full;
                    break;
                  default:
                    batteryText = "--";
                    batteryColor = AppColors.paletteGreen;
                    batteryIcon = Icons.battery_charging_full;
                    break;
                }
              }
            }

            String distance = "$todayDistanceStr ${context.displayKm}";

            String headerText = l10n.todayText;
            if (startTimeStr.isNotEmpty && startTimeStr != "--:--") {
              headerText += " | $startTimeStr";
            } else {
              headerText += " | --";
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 12,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              headerText,
                              style: getBoldStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        if (batteryText.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: batteryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: batteryColor.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  batteryIcon,
                                  color: batteryColor,
                                  size: 10,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  batteryText,
                                  style: getBoldStyle(
                                    color: batteryColor,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            _buildStatItem(l10n.distanceLabel, distance),
                            const SizedBox(height: 6),
                            _buildStatItem(l10n.rideDuration, durationStr),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          children: [
                            _buildStatItem(l10n.speedLabel, speed),
                            const SizedBox(height: 6),
                            _buildStatItem(l10n.topSpeed, topSpeed),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
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
    return BlocBuilder<DiscoverCubit, DiscoverState>(
      builder: (context, state) {
        double progressValue =
            double.tryParse(
              AppPreference.instance.getSync(key: 'discover_progress_value'),
            ) ??
            0.0;
        String progressString = AppPreference.instance.getSync(
          key: 'discover_progress_string',
        );
        if (progressString.isEmpty) {
          progressString = "0";
        }

        if (state is DiscoverLoaded) {
          int explored = 0;
          int total = 0;
          final regex = RegExp(r'\d+/(\d+)');
          final prefs = AppPreference.instance;
          final list = prefs.getStringList(
            key: AppPreference.KEY_EXPLORED_FEATURES,
          );

          for (var item in state.discoverList) {
            final match = regex.firstMatch(item.exploredText);
            int catTotal = 0;
            if (match != null) {
              catTotal = int.tryParse(match.group(1) ?? '0') ?? 0;
            } else {
              catTotal = int.tryParse(item.exploredText) ?? 0;
            }

            if (catTotal > 0) {
              total += catTotal;

              final catExplored = list
                  .where((id) => id.startsWith('${item.id}_'))
                  .length;
              explored += (catExplored > catTotal ? catTotal : catExplored);
            }
          }
          if (total > 0) {
            final calculatedValue = explored / total;
            final calculatedString = (calculatedValue * 100).toInt().toString();

            if (calculatedValue != progressValue ||
                calculatedString != progressString) {
              progressValue = calculatedValue;
              progressString = calculatedString;
              prefs.set(
                key: 'discover_progress_value',
                value: progressValue.toString(),
              );
              prefs.set(key: 'discover_progress_string', value: progressString);
              prefs.set(key: 'discover_explored', value: explored.toString());
              prefs.set(key: 'discover_total', value: total.toString());
            }
          }
        }

        final Color progressColor = Theme.of(context).colorScheme.primary;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DiscoverFeaturesScreen(),
              ),
            ).then((_) {
              if (mounted) {
                setState(
                  () {},
                ); // Force rebuild to recalculate progress from updated local list
                context.read<DiscoverCubit>().fetchDiscoverFeatures();
              }
            });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  Theme.of(
                    context,
                  ).colorScheme.secondary.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.2),
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
                        value: progressValue,
                        strokeWidth: 3.5,
                        backgroundColor: progressColor.withValues(alpha: 0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progressColor,
                        ),
                      ),
                      Text(
                        l10n.progressPercentage(progressString),
                        style: getBoldStyle(color: progressColor, fontSize: 10),
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
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.secondary,
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ).createShader(bounds),
                            child: Text(
                              l10n.getMoreOutOfTrackify,
                              style: getBoldStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.secondary,
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ).createShader(bounds),
                            child: const Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        l10n.discoverMoreDesc,
                        style: getRegularStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    AppPreference.instance.setBool(
                      key: 'hide_promo_banner',
                      value: true,
                    );
                    setState(() {
                      _hidePromoBanner = true;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.close,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPhoneAsGpsBanner() {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bool showOnlyWarrantyExpired =
        _isWarrantyExpired &&
        _selectedDevice?.imei != null &&
        _selectedDevice!.imei!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 18,
        ), // Added extra space to prevent overlay from top header
        // Top Horizontal Scrolling Banners
        SizedBox(
          height: 70,
          child: showOnlyWarrantyExpired
              ? Builder(
                  builder: (context) {
                    final l10n = AppLocalizations.of(context)!;
                    final dataState = context.watch<DeviceDataCubit>().state;
                    CurrentPlanEntity? currentPlan;
                    if (dataState is DeviceDataLoaded) {
                      currentPlan = dataState.currentPlan;
                    }

                    final bool isRechargeExpired =
                        currentPlan == null || currentPlan.daysLeft <= 0;
                    final String rechargeLabel = isRechargeExpired
                        ? l10n.rechargeExpired
                        : l10n.expiresInDays(currentPlan.daysLeft);
                    final Color rechargeColor = isRechargeExpired
                        ? Colors.red
                        : currentPlan.daysLeft <= 30
                        ? Colors.orange
                        : Colors.green;

                    return ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _buildSmallBanner(
                          icon: Icons.history_toggle_off,
                          title: l10n.deviceWarrantyExpired,
                          actionText: l10n.renewNow,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const WarrantyScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 12),
                        _buildStatusCard(
                          icon: Icons.sim_card_outlined,
                          label: l10n.rechargePlan,
                          statusText: rechargeLabel,
                          statusColor: rechargeColor,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const DeviceDataScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                )
              : ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildSmallBanner(
                      icon: Icons.inventory_2_outlined,
                      title: l10n.receivedTrackifyDevicePrompt,
                      actionText: l10n.activateNow,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                const DeviceInstallationScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    _buildSmallBanner(
                      icon: Icons.local_offer_outlined,
                      title: l10n.fivePercentOffPromo,
                      actionText: l10n.exploreExclusiveDeal,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ProductScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
        ),
        const SizedBox(height: 7),

        // Large Record Ride Banner
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    RecordViaPhoneScreen(imei: _selectedDevice?.imei ?? ''),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                width: 0.5, // Added 0.5 border width as requested
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Record Ride with Trackify',
                        style: getBoldStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16, // Reduced by 2 as requested
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '🏍️',
                        style: TextStyle(fontSize: 16),
                      ), // Reduced by 2
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Make your phone a GPS tracking device!',
                    style: getRegularStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.7),
                      fontSize: 12, // Reduced by 2 as requested
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Map Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 250,
                          width: double.infinity,
                          child: _buildAnimatedMapCore(showStats: false),
                        ),
                        Container(
                          width: double.infinity,
                          height: 250, // Increased height
                          color: isDark
                              ? Colors.black.withValues(alpha: 0.2)
                              : Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Bottom Button
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Go to dashboard',
                                style: getBoldStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Record rides, view past rides & statistics',
                                style: getRegularStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSmallBanner({
    required IconData icon,
    required String title,
    required String actionText,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 300,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: getRegularStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    actionText,
                    style: getBoldStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Compact status card — used to show recharge plan expiry alongside warranty card
  Widget _buildStatusCard({
    required IconData icon,
    required String label,
    required String statusText,
    required Color statusColor,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 180,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: statusColor.withValues(alpha: 0.35), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: statusColor, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: getRegularStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.55),
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
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
        "label": l10n.reachMeSticker,
        "badge": l10n.exploreNow,
      },
      {
        "icon": Icons.phone_android_rounded,
        "label": l10n.recordViaPhone,
        "badge": null,
      },
      {
        "icon": Icons.handyman_outlined,
        "label": l10n.serviceLogs,
        "badge": null,
      },
      {
        "icon": Icons.share_outlined,
        "label": l10n.locationSharing,
        "badge": null,
      },
      {
        "icon": Icons.local_parking_rounded,
        "label": l10n.safeParking,
        "badge": l10n.comingSoonOption,
      },
      {
        "icon": Icons.campaign_outlined,
        "label": l10n.appUpdates,
        "badge": null,
      },
      {
        "icon": Icons.local_gas_station_outlined,
        "label": l10n.fuelLogs,
        "badge": null,
      },
      {
        "icon": Icons.location_on_outlined,
        "label": l10n.geoFenceAlert,
        "badge": null,
      },
      {
        "icon": Icons.speed_outlined,
        "label": l10n.overspeedAlert,
        "badge": null,
      },
      {
        "icon": Icons.folder_open_outlined,
        "label": l10n.documentFolder,
        "badge": null,
      },
      {
        "icon": Icons.list_alt_rounded,
        "label": l10n.deviceDataPlanLabel,
        "badge": null,
      },
      {
        "icon": Icons.gpp_good_outlined,
        "label": l10n.deviceWarrantyLabel,
        "badge": null,
      },
      {
        "icon": Icons.chat_outlined,
        "label": l10n.helpAndSupport.replaceFirst(' & ', ' &\n'),
        "badge": null,
      },
      {
        "icon": Icons.sos_outlined,
        "label": l10n.emergency,
        "badge": null,
      },
      {
        "icon": Icons.play_arrow_outlined,
        "label": l10n.videoTutorials,
        "badge": null,
      },
      {
        "icon": null,
        "label": l10n.upgradeToPlus.replaceFirst(' to ', ' to\n'),
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
          margin: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 6,
            bottom: 16,
          ),
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
              BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10),
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
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.8,
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
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
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
    final isDeviceNotInstalled =
        selectedDevice == null ||
        selectedDevice.imei == null ||
        selectedDevice.imei!.isEmpty;
    final isLocked =
        (isDeviceNotInstalled || _isWarrantyExpired) &&
        (option["label"] == l10n.overspeedAlert ||
            option["label"] == l10n.emergency ||
            option["label"] == l10n.geoFenceAlert ||
            option["label"] == l10n.fuelLogs ||
            option["label"] == l10n.serviceLogs ||
            option["label"] == l10n.deviceDataPlanLabel ||
            (option["label"] == l10n.deviceWarrantyLabel &&
                isDeviceNotInstalled));

    return InkWell(
      onTap: () {
        if (isLocked) {
          _showUnlockDeviceDialog(context, option["label"] as String);
          return;
        }
        if (option["badge"] == l10n.comingSoonOption) return;
        _handleExploreTap(option, selectedDevice, l10n);
      },
      child: Column(
        children: [
          if (option["isPlus"] == true)
            _buildPlusBadge(l10n)
          else
            _buildIconWithBadge(option, isLocked),
          const SizedBox(height: 8),
          Text(
            option["label"] as String,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: getMediumStyle(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              fontSize: 10.5,
            ),
          ),
        ],
      ),
    );
  }

  void _showUnlockDeviceDialog(BuildContext context, String featureTitle) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: isDark
              ? colorScheme.surfaceContainerHigh
              : Colors.white,
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/device_image.png',
                    height: 140,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.phonelink_setup_rounded,
                        size: 60,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "To unlock $featureTitle you'll have to get Trackify device installed in your vehicle",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 24),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProductScreen(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: isDark
                          ? colorScheme.surfaceContainerHighest
                          : const Color(0xFFF9F7F2),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Unlock $featureTitle",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlusBadge(AppLocalizations l10n) {
    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
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
      ),
    );
  }

  Widget _buildIconWithBadge(Map<String, dynamic> option, bool isLocked) {
    final l10n = AppLocalizations.of(context)!;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 50,
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            option["icon"] as IconData,
            size: 26,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        if (isLocked)
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Icon(
                Icons.lock,
                size: 12,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          )
        else if (option["badge"] != null)
          Positioned(
            top: -8,
            right: -24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: option["badge"] == l10n.comingSoonOption
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
    if (label == l10n.recordViaPhone) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              RecordViaPhoneScreen(imei: selectedDevice?.imei ?? ''),
        ),
      );
    } else if (label == l10n.reachMeSticker) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ReachMeStickerScreen()),
      );
    } else if (label == l10n.locationSharing) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LocationSharingScreen()),
      );
    } else if (label == l10n.serviceLogs) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ServiceLogsScreen()),
      );
    } else if (label == l10n.overspeedAlert) {
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
    } else if (label == l10n.fuelLogs) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FuelLogsScreen()),
      );
    } else if (label == l10n.deviceWarrantyLabel) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WarrantyScreen()),
      );
    } else if (label == l10n.appUpdates) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UpdateScreen()),
      );
    } else if (label == l10n.helpAndSupport.replaceFirst(' & ', ' &\n')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HelpSuggestionScreen()),
      );
    } else if (label == l10n.emergency) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EmergencyAlertScreen(selectedDevice: selectedDevice)),
      );
    } else if (label == l10n.safeParking) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SafeParkingScreen()),
      );
    } else if (label == l10n.documentFolder) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DocumentFolderScreen()),
      );
    } else if (label == l10n.videoTutorials) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CategoryScreen()),
      );
    } else if (label == l10n.deviceDataPlanLabel) {
      if (selectedDevice?.imei == null || _isWarrantyExpired) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.noDeviceFound),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DeviceDataScreen()),
        );
      }
    } else if (label == l10n.geoFenceAlert) {
      final vName = selectedDevice != null
          ? "${selectedDevice.vehicleMaker} ${selectedDevice.vehicleNumber}"
          : null;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              GeoFenceScreen(vehicleName: vName, imei: selectedDevice?.imei),
        ),
      ).then((_) {
        if (mounted &&
            selectedDevice?.imei != null &&
            selectedDevice!.imei!.isNotEmpty) {
          context.read<GeoFenceCubit>().fetchGeoFences(selectedDevice.imei!);
        }
      });
    } else if (label == l10n.upgradeToPlus.replaceFirst(' to ', ' to\n')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UpgradeToPlusScreen()),
      );
    }
  }

  Widget _buildRecentRidesSection(Vehicles? selectedDevice) {
    final isDeviceNotInstalled =
        selectedDevice == null ||
        selectedDevice.imei == null ||
        selectedDevice.imei!.isEmpty ||
        _isWarrantyExpired;
    if (isDeviceNotInstalled) {
      return const SizedBox.shrink();
    }

    return BlocBuilder<RideHistoryCubit, RideHistoryState>(
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        if (state is RideHistoryLoading) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: TrackifyLoader()),
          );
        }
        if (state is RideHistoryFailure) {
          final errorStr = state.exception.toString().toLowerCase();
          final isNotFound =
              errorStr.contains('not found') ||
              errorStr.contains('no rides') ||
              errorStr.contains('no recent rides');

          if (isNotFound) {
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
            margin: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 8,
              bottom: 0,
            ),
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
                const SizedBox(height: 10),
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
      padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.videosYouMightLike,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 11),
          BlocBuilder<PromoVideoCubit, PromoVideoState>(
            builder: (context, state) {
              if (state is PromoVideoLoading) {
                return const Center(child: TrackifyLoader());
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
                        onPressed: () {
                          context.read<PromoVideoCubit>().fetchPromoVideos(
                            _selectedDevice?.imei ?? 'null',
                          );
                        },
                        child: Text(l10n.retry),
                      ),
                    ],
                  ),
                );
              }
              if (state is PromoVideoLoaded) {
                if (state.videos.isEmpty) {
                  return Center(child: Text(l10n.noVideosFound));
                }
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.videos.length + (state.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Loader at bottom
                    if (index >= state.videos.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: TrackifyLoader()),
                      );
                    }

                    final video = state.videos[index];

                    return PromoVideoCard(
                      key: ValueKey(video.id),
                      video: video,
                    );
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
      refreshKey: _isWarrantyExpired ? 1 : 0,
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
        if (!mounted) return;
        AppNavigation.refreshNavigationState();
        setState(() {
          _selectedDevice = device;
          _hasShownWarrantyPopup = false;
          _cachedGeoCircles.clear();
          _cachedGeoMarkers.clear();
          _lastGeoState = null;
        });
        context.read<RideHistoryCubit>().getRideHistoryData();
        if (device.imei != null && device.imei!.isNotEmpty) {
          context.read<GeoFenceCubit>().fetchGeoFences(device.imei!);
          context.read<PromoVideoCubit>().fetchPromoVideos(device.imei!);
        } else {
          context.read<PromoVideoCubit>().fetchPromoVideos('null');
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
        if (device.imei != null && device.imei!.isNotEmpty) {
          _checkWarrantyStatus(device.imei!);
        } else {
          final previouslyExpired = AppPreference.instance.getBoolSync(
            key: 'KEY_WARRANTY_EXPIRED',
            defaultValue: true,
          );
          if (previouslyExpired) {
            AppPreference.instance
                .setBool(key: 'KEY_WARRANTY_EXPIRED', value: false)
                .then((_) {
                  if (mounted) {
                    AppNavigation.refreshNavigationState();
                  }
                });
          }
          setState(() {
            _isWarrantyExpired = false;
          });
        }
      },
    );
  }
}
