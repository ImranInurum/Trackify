import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/config/font_manager.dart';
import 'package:trackify/core/widgets/location_consent_dialog.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/geo_fence_cubit.dart';
import '../cubit/geo_fence_state.dart';
import '../../domain/entity/geo_fence_entity.dart';
import 'dart:math';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/services.dart';

class AddGeoFenceScreen extends StatefulWidget {
  final String? vehicleName;
  final String? imei;
  final GeoFenceEntity? initialFence;
  const AddGeoFenceScreen({super.key, this.vehicleName, this.imei, this.initialFence});

  @override
  State<AddGeoFenceScreen> createState() => _AddGeoFenceScreenState();
}

class _AddGeoFenceScreenState extends State<AddGeoFenceScreen> {
  LatLng _fencePosition = const LatLng(22.7533, 75.8937);
  LatLng? _userLocation;
  String _selectedType = '';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  double _radius = 500;
  GoogleMapController? _mapController;
  Timer? _debounceTimer;
  final FocusNode _searchFocus = FocusNode();
  String? _darkMapStyle;

  @override
  void initState() {
    super.initState();
    _loadMapStyles();
    if (widget.initialFence != null) {
      _fencePosition = LatLng(widget.initialFence!.latitude, widget.initialFence!.longitude);
      _radius = widget.initialFence!.radius;
      _selectedType = widget.initialFence!.type;
      _nameController.text = widget.initialFence!.name;
      _searchController.text = "";
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialFence == null) {
        _searchController.text = AppLocalizations.of(context)!.geoFenceLocating;
      }
    });

    if (widget.initialFence == null) {
      _fetchCurrentLocation();
    } else {
      Future.delayed(const Duration(milliseconds: 500), () {
        _mapController?.animateCamera(CameraUpdate.newLatLngZoom(_fencePosition, 15));
        context.read<GeoFenceCubit>().updateAddress(
          latitude: _fencePosition.latitude,
          longitude: _fencePosition.longitude,
          radius: _radius,
          selectedType: _selectedType,
        );
      });
    }
  }

  Future<void> _loadMapStyles() async {
    try {
      _darkMapStyle = await rootBundle.loadString(
        'assets/map_styles/dark_map.json',
      );
    } catch (e) {
      debugPrint("Error loading map styles: $e");
    }
  }

  Future<void> _fetchCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      if (mounted) {
        final bool userConsented = await LocationConsentDialog.show(context);
        if (!userConsented) return;
      }
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition();
    final userLatLng = LatLng(position.latitude, position.longitude);

    if (!mounted) return;

    setState(() {
      _userLocation = userLatLng;
      _fencePosition = userLatLng;
    });

    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(userLatLng, 15));

    context.read<GeoFenceCubit>().updateAddress(
      latitude: userLatLng.latitude,
      longitude: userLatLng.longitude,
      radius: _radius,
      selectedType: _selectedType,
    );
  }

  void _onCameraMove(CameraPosition position) {
    _fencePosition = position.target;
    _radius = (500 * pow(2, 15 - position.zoom)).toDouble().clamp(50.0, 5000.0);

    context.read<GeoFenceCubit>().updateForm(
      latitude: _fencePosition.latitude,
      longitude: _fencePosition.longitude,
      radius: _radius,
      selectedType: _selectedType,
      address: _searchController.text,
    );

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        context.read<GeoFenceCubit>().updateAddress(
          latitude: _fencePosition.latitude,
          longitude: _fencePosition.longitude,
          radius: _radius,
          selectedType: _selectedType,
        );
      }
    });
  }

  void _onSave() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.geoFenceNameRequired)),
      );
      return;
    }

    final newFence = GeoFenceEntity(
      id: widget.initialFence?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      imei: widget.imei ?? widget.initialFence?.imei ?? '',
      name: _nameController.text,
      type: _selectedType,
      latitude: _fencePosition.latitude,
      longitude: _fencePosition.longitude,
      radius: _radius,
      vehicleName: widget.vehicleName ?? widget.initialFence?.vehicleName ?? "Vehicle",
      isActive: widget.initialFence?.isActive ?? true,
    );

    if (widget.initialFence != null) {
      context.read<GeoFenceCubit>().editGeoFence(newFence);
    } else {
      context.read<GeoFenceCubit>().addGeoFence(newFence);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return BlocListener<GeoFenceCubit, GeoFenceState>(
      listener: (context, state) {
        if (state is GeoFenceSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.geoFenceSaveSuccess)),
          );
          if (mounted) Navigator.pop(context);
        } else if (state is GeoFenceError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is GeoFenceFormUpdated) {
          _fencePosition = LatLng(state.latitude, state.longitude);
          _radius = state.radius;
          _selectedType = state.selectedType;
          if (state.address != null &&
              _searchController.text != state.address &&
              !_searchFocus.hasFocus) {
            _searchController.text = state.address!;
          }
          if (_mapController != null) {
            _mapController!.animateCamera(
              CameraUpdate.newLatLng(LatLng(state.latitude, state.longitude)),
            );
          }
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            /// MAP SECTION (WITH PADDING FOR CENTER-ALIGNING CIRCLE IN VISIBLE VIEWPORT)
            BlocBuilder<GeoFenceCubit, GeoFenceState>(
              buildWhen: (previous, current) =>
                  current is GeoFenceFormUpdated || current is GeoFenceInitial,
              builder: (context, state) {
                LatLng pos = _fencePosition;
                double rad = _radius;

                if (state is GeoFenceFormUpdated) {
                  pos = LatLng(state.latitude, state.longitude);
                  rad = state.radius;
                }

                return GoogleMap(
                  padding: const EdgeInsets.only(bottom: 260),
                  onMapCreated: (controller) {
                    _mapController = controller;
                    if (isDark && _darkMapStyle != null) {
                      controller.setMapStyle(_darkMapStyle);
                    } else {
                      controller.setMapStyle(null);
                    }
                  },
                  initialCameraPosition: CameraPosition(target: pos, zoom: 15),
                  circles: {
                    Circle(
                      circleId: const CircleId('fence'),
                      center: pos,
                      radius: rad,
                      fillColor: const Color(0xFF0284C7).withOpacity(0.2),
                      strokeColor: const Color(0xFF0284C7),
                      strokeWidth: 2,
                    ),
                  },
                  markers: {
                    if (_userLocation != null)
                      Marker(
                        markerId: const MarkerId('current_location_marker'),
                        position: _userLocation!,
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueRed,
                        ),
                      ),
                  },
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  onCameraMove: _onCameraMove,
                );
              },
            ),

            /// TOP FLOATING HEADER (BACK BUTTON & TITLE)
            Positioned(
              top: 50,
              left: 16,
              right: 16,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        height: 46,
                        width: 46,
                        decoration: BoxDecoration(
                          color: isDark ? colorScheme.surface.withOpacity(0.85) : Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark ? colorScheme.outline.withOpacity(0.2) : const Color(0xFFE2E8F0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: colorScheme.onSurface,
                            size: 18,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isDark ? colorScheme.surface.withOpacity(0.85) : Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: isDark ? colorScheme.outline.withOpacity(0.2) : const Color(0xFFE2E8F0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          widget.initialFence != null ? "Edit Geo-fence" : "Add Geo-fence",
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: FontFamilyManager.fontFamily,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// REDESIGNED BOTTOM SHEET
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? colorScheme.surface : Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.4 : 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// DRAG HANDLE PILL
                      Center(
                        child: Container(
                          width: 38,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: isDark ? colorScheme.outline.withOpacity(0.4) : const Color(0xFFCBD5E1),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),

                      /// TITLE WITH HIGHLIGHTED VEHICLE NAME
                      RichText(
                        text: TextSpan(
                          text: AppLocalizations.of(context)!.geoFenceSelectType,
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 15,
                            fontFamily: FontFamilyManager.fontFamily,
                          ),
                          children: [
                            TextSpan(
                              text: widget.vehicleName ?? "Honda Motorcycle & Scooter India MP09QV1111",
                              style: const TextStyle(
                                color: Color(0xFF0284C7),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// TYPE SELECTION ICONS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildTypeItem(
                            Icons.home_rounded,
                            AppLocalizations.of(context)!.geoFenceTypeHome,
                            colorScheme,
                            isDark,
                          ),
                          _buildTypeItem(
                            Icons.apartment_rounded,
                            AppLocalizations.of(context)!.geoFenceTypeOffice,
                            colorScheme,
                            isDark,
                          ),
                          _buildTypeItem(
                            Icons.person_rounded,
                            AppLocalizations.of(context)!.geoFenceTypeFamily,
                            colorScheme,
                            isDark,
                          ),
                          _buildTypeItem(
                            Icons.local_parking_rounded,
                            AppLocalizations.of(context)!.geoFenceTypeParking,
                            colorScheme,
                            isDark,
                          ),
                          _buildTypeItem(
                            Icons.location_on_rounded,
                            AppLocalizations.of(context)!.geoFenceTypeOthers,
                            colorScheme,
                            isDark,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      /// INPUT FIELD AND GRADIENT SAVE BUTTON
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _nameController,
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                hintText: AppLocalizations.of(context)!.geoFenceNameFieldHint,
                                hintStyle: TextStyle(
                                  color: colorScheme.onSurface.withOpacity(0.4),
                                  fontSize: 14,
                                ),
                                filled: true,
                                fillColor: isDark ? colorScheme.onSurface.withOpacity(0.06) : const Color(0xFFF8FAFC),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: isDark ? colorScheme.outline.withOpacity(0.2) : const Color(0xFFE2E8F0),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: isDark ? colorScheme.outline.withOpacity(0.2) : const Color(0xFFE2E8F0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFF0284C7), width: 1.5),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          BlocBuilder<GeoFenceCubit, GeoFenceState>(
                            builder: (context, state) {
                              bool isSubmitting = state is GeoFenceSubmitting;
                              return GestureDetector(
                                onTap: isSubmitting ? null : _onSave,
                                child: Container(
                                  height: 48,
                                  width: 90,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF0284C7),
                                        Color(0xFF0369A1),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF0284C7).withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: isSubmitting
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Text(
                                            AppLocalizations.of(context)!.save,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              letterSpacing: 0.2,
                                            ),
                                          ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeItem(
    IconData icon,
    String label,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    return BlocBuilder<GeoFenceCubit, GeoFenceState>(
      buildWhen: (p, c) => c is GeoFenceFormUpdated,
      builder: (context, state) {
        bool isSelected = _selectedType == label;
        if (state is GeoFenceFormUpdated) {
          isSelected = state.selectedType == label;
        }

        final primaryAccent = const Color(0xFF0284C7);

        return GestureDetector(
          onTap: () {
            _nameController.text = label;
            context.read<GeoFenceCubit>().updateForm(
              latitude: _fencePosition.latitude,
              longitude: _fencePosition.longitude,
              radius: _radius,
              selectedType: label,
              address: _searchController.text,
            );
          },
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFE0F2FE)
                      : (isDark ? colorScheme.onSurface.withOpacity(0.06) : const Color(0xFFF8FAFC)),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? primaryAccent
                        : (isDark ? colorScheme.outline.withOpacity(0.2) : const Color(0xFFE2E8F0)),
                    width: isSelected ? 1.8 : 1,
                  ),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? primaryAccent : colorScheme.onSurface.withOpacity(0.6),
                  size: 22,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? primaryAccent : colorScheme.onSurface.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
