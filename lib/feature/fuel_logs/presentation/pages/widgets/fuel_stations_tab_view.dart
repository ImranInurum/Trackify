import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trackify/l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import '../../cubit/fuel_stations_cubit.dart';
import '../../cubit/fuel_stations_state.dart';
import '../../../data/model/fuel_station_model.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';

class FuelStationsTabView extends StatefulWidget {
  const FuelStationsTabView({super.key});

  @override
  State<FuelStationsTabView> createState() => _FuelStationsTabViewState();
}

class _FuelStationsTabViewState extends State<FuelStationsTabView> {
  GoogleMapController? _mapController;
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();
  String? _darkMapStyle;

  @override
  void initState() {
    super.initState();
    _loadMapStyles();
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final mediaQuery = MediaQuery.of(context);

    return BlocBuilder<FuelStationsCubit, FuelStationsState>(
      builder: (context, state) {
        if (state is FuelStationsLoading) {
          return const Center(child: TrackifyLoader());
        }

        if (state is FuelStationsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.message,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      context.read<FuelStationsCubit>().fetchNearbyStations(),
                  child: Text(l10n.retry),
                ),
              ],
            ),
          );
        }

        if (state is FuelStationsLoaded) {
          return Stack(
            children: [
              // 1. Map View
              GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: state.userLocation,
                    zoom: 14,
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;
                    if (Theme.of(context).brightness == Brightness.dark && _darkMapStyle != null) {
                      controller.setMapStyle(_darkMapStyle);
                    } else {
                      controller.setMapStyle(null);
                    }
                  },
                  markers: state.markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                ),

              // 2. Map Controls (Floating)
              Positioned(
                right: 16,
                bottom: mediaQuery.size.height * 0.45,
                child: Column(
                  children: [
                    _buildMapAction(icon: Icons.person_outline, onTap: () {}),
                    const SizedBox(height: 12),
                    _buildMapAction(
                      icon: Icons.my_location,
                      onTap: () {
                        _mapController?.animateCamera(
                          CameraUpdate.newLatLng(state.userLocation),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // 3. Draggable Bottom Sheet
              DraggableScrollableSheet(
                controller: _sheetController,
                initialChildSize: 0.4,
                minChildSize: 0.12,
                maxChildSize: 0.9,
                snap: true,
                snapSizes: const [0.12, 0.4, 0.9],
                builder: (context, scrollController) {
                  return SafeArea(
                    top: false,
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Handle bar
                          Center(
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 12),
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: theme.dividerColor,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),

                          // Header with Add Station
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  l10n.fuelStations,
                                  style: TextStyle(
                                    fontSize: mediaQuery.textScaler.scale(16),
                                    fontWeight: FontWeight.bold,
                                    color: theme.textTheme.titleLarge?.color,
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.add, size: 18),
                                  label: Text(l10n.addStation),
                                  style: TextButton.styleFrom(
                                    backgroundColor: theme.primaryColor
                                        .withValues(alpha: 0.1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Tabs
                          Expanded(
                            child: DefaultTabController(
                              length: 3,
                              child: Column(
                                children: [
                                  TabBar(
                                    isScrollable: true,
                                    indicatorColor: theme.primaryColor,
                                    labelColor: theme.primaryColor,
                                    unselectedLabelColor: theme.colorScheme.onSurface,
                                    labelStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    labelPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    tabs: [
                                      Tab(text: l10n.nearby),
                                      Tab(text: l10n.favourites),
                                      Tab(text: l10n.addedByMe),
                                    ],
                                  ),
                                  Expanded(
                                    child: TabBarView(
                                      children: [
                                        state.stations.isEmpty
                                            ? _buildPlaceholder(
                                                "No stations found nearby",
                                              )
                                            : _buildStationList(
                                                state.stations,
                                                scrollController,
                                              ),
                                        _buildPlaceholder(l10n.noFavourites),
                                        _buildPlaceholder(l10n.noStationsAdded),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildMapAction({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: theme.cardColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: theme.iconTheme.color, size: 24),
      ),
    );
  }

  Widget _buildStationList(
    List<FuelStation> stations,
    ScrollController scrollController,
  ) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: stations.length,
      itemBuilder: (context, index) {
        return _buildStationCard(stations[index]);
      },
    );
  }

  Widget _buildStationCard(FuelStation station) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.pop(context, station.name);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.cardColor.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.dividerColor, width: 0.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo placeholder
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5), width: 0.5),
              ),
              child: ClipOval(child: _getBrandLogo(station.brand)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          station.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: mediaQuery.textScaler.scale(13),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (station.distance != null) ...[
                        Icon(
                          Icons.near_me_outlined,
                          size: 14,
                          color: theme.colorScheme.onSurface,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${station.distance!.toStringAsFixed(2)} km",
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: mediaQuery.textScaler.scale(10),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    station.address ?? 'Address not available',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: mediaQuery.textScaler.scale(10),
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

  Widget _getBrandLogo(String? brand) {
    const errorIcon = Icon(Icons.local_gas_station, color: Colors.grey);
    if (brand == null) return errorIcon;

    final b = brand.toLowerCase();
    String? logoUrl;
    if (b.contains('indian oil')) {
      logoUrl =
          'https://upload.wikimedia.org/wikipedia/en/thumb/8/8c/Indian_Oil_Logo.svg/200px-Indian_Oil_Logo.svg.png';
    } else if (b.contains('bpcl') || b.contains('bharat petroleum')) {
      logoUrl =
          'https://upload.wikimedia.org/wikipedia/en/thumb/e/ef/Bharat_Petroleum_Logo.svg/200px-Bharat_Petroleum_Logo.svg.png';
    } else if (b.contains('hp') || b.contains('hindustan petroleum')) {
      logoUrl =
          'https://upload.wikimedia.org/wikipedia/en/thumb/5/52/HP_Logo.svg/200px-HP_Logo.svg.png';
    }

    if (logoUrl != null) {
      return Image.network(
        logoUrl,
        errorBuilder: (context, error, stackTrace) => errorIcon,
      );
    }

    return errorIcon;
  }

  Widget _buildPlaceholder(String text) {
    return Center(
      child: Text(text, style: const TextStyle(color: Colors.grey)),
    );
  }
}
