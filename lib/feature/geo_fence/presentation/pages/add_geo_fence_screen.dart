import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/geo_fence_cubit.dart';
import '../cubit/geo_fence_state.dart';
import '../../domain/entity/geo_fence_entity.dart';
import 'dart:math';
import 'dart:async';
import 'dart:ui';

class AddGeoFenceScreen extends StatefulWidget {
  final String? vehicleName;
  const AddGeoFenceScreen({super.key, this.vehicleName});

  @override
  State<AddGeoFenceScreen> createState() => _AddGeoFenceScreenState();
}

class _AddGeoFenceScreenState extends State<AddGeoFenceScreen> {
  LatLng _fencePosition = const LatLng(22.7533, 75.8937);
  LatLng? _userLocation;
  String _selectedType = '';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController(
    text: "Locating...",
  );
  double _radius = 500;
  GoogleMapController? _mapController;
  Timer? _debounceTimer;
  final FocusNode _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition();
    final userLatLng = LatLng(position.latitude, position.longitude);

    setState(() {
      _userLocation = userLatLng;
      _fencePosition = userLatLng;
    });

    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(userLatLng, 15));

    if (mounted) {
      context.read<GeoFenceCubit>().updateAddress(
        latitude: userLatLng.latitude,
        longitude: userLatLng.longitude,
        radius: _radius,
        selectedType: _selectedType,
      );
    }
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
        const SnackBar(content: Text("Please enter a geo-fence name")),
      );
      return;
    }

    final newFence = GeoFenceEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      type: _selectedType,
      latitude: _fencePosition.latitude,
      longitude: _fencePosition.longitude,
      radius: _radius,
      vehicleName: widget.vehicleName ?? "SP 125 MP09QV8269",
      isActive: true,
    );

    context.read<GeoFenceCubit>().addGeoFence(newFence);
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

    return BlocListener<GeoFenceCubit, GeoFenceState>(
      listener: (context, state) {
        if (state is GeoFenceSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Geo-fence saved successfully!")),
          );
          if (mounted) Navigator.pop(context);
        } else if (state is GeoFenceError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Error: ${state.message}")));
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
            // Map Section
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
                  onMapCreated: (controller) => _mapController = controller,
                  initialCameraPosition: CameraPosition(target: pos, zoom: 15),
                  circles: {
                    Circle(
                      circleId: const CircleId('fence'),
                      center: pos,
                      radius: rad,
                      fillColor: Colors.blue.withValues(alpha: 0.3),
                      strokeColor: Colors.blue,
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

            // Floating Address Bubble (Glassmorphism)
            IgnorePointer(
              child: Center(
                child: BlocBuilder<GeoFenceCubit, GeoFenceState>(
                  buildWhen: (p, c) => c is GeoFenceFormUpdated,
                  builder: (context, state) {
                    String displayAddress = _searchController.text;
                    if (state is GeoFenceFormUpdated && state.address != null) {
                      displayAddress = state.address!;
                    }

                    if (displayAddress == "Locating..." ||
                        displayAddress == "Search location...") {
                      return const SizedBox.shrink();
                    }

                    return SizedBox.shrink();
                  },
                ),
              ),
            ),

            // Top Search Bar (Glassmorphism)
            Positioned(
              top: 50,
              left: 20,
              right: 20,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 56,
                    decoration: BoxDecoration(
                      color: colorScheme.surface.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: colorScheme.onSurface,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: BlocBuilder<GeoFenceCubit, GeoFenceState>(
                            buildWhen: (p, c) => c is GeoFenceFormUpdated,
                            builder: (context, state) {
                              String displayAddress = _searchController.text;
                              if (state is GeoFenceFormUpdated &&
                                  state.address != null) {
                                displayAddress = state.address!;
                                if (_searchController.text != displayAddress) {
                                  _searchController.text = displayAddress;
                                }
                              }

                              bool isLoading = displayAddress == "Search location...";

                              return TextField(
                                controller: _searchController,
                                focusNode: _searchFocus,
                                readOnly: false,
                                textInputAction: TextInputAction.search,
                                onSubmitted: (value) {
                                  context.read<GeoFenceCubit>().searchLocation(
                                        value,
                                        _radius,
                                        _selectedType,
                                      );
                                },
                                style: TextStyle(
                                  color: isLoading
                                      ? colorScheme.onSurface.withValues(
                                          alpha: 0.5,
                                        )
                                      : colorScheme.onSurface,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  hintText: "Search location...",
                                  suffix: isLoading
                                      ? const SizedBox(
                                          height: 14,
                                          width: 14,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 1,
                                          ),
                                        )
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                          onPressed: () =>
                              _searchController.text = "Locating...",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Sheet
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "Select Geo-fence type for ",
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: widget.vehicleName ?? "SP 125 MP09QV8269",
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildTypeItem(
                          Icons.home_outlined,
                          "Home",
                          colorScheme,
                        ),
                        _buildTypeItem(
                          Icons.apartment_outlined,
                          "Office",
                          colorScheme,
                        ),
                        _buildTypeItem(
                          Icons.person_outline,
                          "Family",
                          colorScheme,
                        ),
                        _buildTypeItem(
                          Icons.local_parking_outlined,
                          "Parking",
                          colorScheme,
                        ),
                        _buildTypeItem(
                          Icons.location_on_outlined,
                          "Others",
                          colorScheme,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.05,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: _nameController,
                              style: TextStyle(
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.9,
                                ),
                              ),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                hintText: "Enter Geo-fence name, eg: Home",
                                hintStyle: TextStyle(
                                  color: theme.hintColor.withValues(alpha: 0.5),
                                ),
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.transparent,
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
                                width: 80,
                                decoration: BoxDecoration(
                                  color: colorScheme.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: isSubmitting
                                      ? SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: colorScheme.onPrimary,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          "Save",
                                          style: TextStyle(
                                            color: colorScheme.onPrimary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add_box,
                            color: colorScheme.primary,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Add Contacts for SMS Alert",
                            style: TextStyle(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              "Plus",
                              style: TextStyle(
                                color: colorScheme.onPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeItem(IconData icon, String label, ColorScheme colorScheme) {
    return BlocBuilder<GeoFenceCubit, GeoFenceState>(
      buildWhen: (p, c) => c is GeoFenceFormUpdated,
      builder: (context, state) {
        bool isSelected = _selectedType == label;
        if (state is GeoFenceFormUpdated) {
          isSelected = state.selectedType == label;
        }

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
                      ? colorScheme.primary.withValues(alpha: 0.1)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface.withValues(alpha: 0.1),
                  ),
                ),
                child: Icon(
                  icon,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface,
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
