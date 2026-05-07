import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/feature/trips/presentation/cubit/trips_cubit.dart';
import 'package:trackify/feature/trips/presentation/cubit/trips_state.dart';
import 'package:trackify/feature/trips/presentation/view/widgets/trips/widgets/trip_empty_state.dart';
import 'package:trackify/feature/trips/presentation/view/widgets/trips/widgets/trip_tooltip.dart';

class Trips extends StatefulWidget {
  const Trips({super.key});

  @override
  State<Trips> createState() => _TripsState();
}

class _TripsState extends State<Trips> {
  bool _showOverlay = true;
  bool _isFabExtended = true;
  Timer? _fabTimer;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    // Periodic expansion: every 17 seconds
    _fabTimer = Timer.periodic(const Duration(seconds: 17), (timer) {
      if (mounted) {
        setState(() {
          _isFabExtended = true;
        });
        // Collapse after 3 seconds of being shown
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _isFabExtended = false;
            });
          }
        });
      }
    });

    // Initial collapse after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isFabExtended = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _fabTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return BlocProvider(
      create: (context) => TripsCubit()..fetchTrips(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// BACKGROUND CONTENT (Data Loaded State)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                /// SEARCH BAR & FILTER
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onSurface.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.onSurface.withOpacity(0.1),
                          ),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            Icon(
                              Icons.search,
                              color: theme.colorScheme.onSurface.withOpacity(0.5),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    _searchQuery = value.toLowerCase();
                                  });
                                },
                                decoration: InputDecoration(
                                  fillColor: Colors.transparent,
                                  filled: true,
                                  hintText: 'Search Trips by Name',
                                  hintStyle: TextStyle(
                                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                                    fontSize: 14,
                                  ),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.primary.withOpacity(0.5),
                        ),
                      ),
                      child: Icon(
                        Icons.sort,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),

                /// TRIPS LIST
                Expanded(
                  child: BlocBuilder<TripsCubit, TripsState>(
                    builder: (context, state) {
                      if (state is TripsLoading) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: theme.colorScheme.primary,
                          ),
                        );
                      } else if (state is TripsError) {
                        return Center(
                          child: Text(
                            state.message,
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      } else if (state is TripsLoaded) {
                        final filteredTrips = state.trips.where((trip) {
                          return trip.name.toLowerCase().contains(_searchQuery);
                        }).toList();

                        if (filteredTrips.isEmpty) {
                          if (_searchQuery.isNotEmpty) {
                            return Center(
                              child: Text(
                                "No trips found",
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                                  fontSize: 16,
                                ),
                              ),
                            );
                          }
                          return const TripEmptyState();
                        }

                        return ListView.builder(
                          itemCount: filteredTrips.length,
                          itemBuilder: (context, index) {
                            final trip = filteredTrips[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.onSurface.withOpacity(0.02),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: theme.colorScheme.onSurface.withOpacity(0.1),
                                ),
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      width: 80,
                                      height: 60,
                                      color: theme.colorScheme.onSurface.withOpacity(0.1),
                                      child: Image.asset(
                                        'assets/images/explore_app_image.jpg', // Placeholder
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Icon(
                                          Icons.image,
                                          color: theme.colorScheme.onSurface.withOpacity(0.2),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          trip.name,
                                          style: TextStyle(
                                            color: theme.colorScheme.primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on_outlined,
                                              size: 14,
                                              color: theme.colorScheme.onSurface.withOpacity(0.5),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              "${trip.distance} kms",
                                              style: TextStyle(
                                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                                                fontSize: 12,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8),
                                              child: Text(
                                                "|",
                                                style: TextStyle(
                                                  color: theme.colorScheme.onSurface.withOpacity(0.3),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            Icon(
                                              Icons.route_outlined,
                                              size: 14,
                                              color: theme.colorScheme.onSurface.withOpacity(0.5),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              "${trip.rideCount} rides",
                                              style: TextStyle(
                                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),

          /// FLOATING ACTION BUTTON
          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton.extended(
              onPressed: () {
                // TODO: Add Trip logic
              },
              backgroundColor: theme.colorScheme.primary,
              elevation: 4,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SizeTransition(
                              sizeFactor: animation,
                              axis: Axis.horizontal,
                              axisAlignment: -1,
                              child: child,
                            ),
                          );
                        },
                    child: _isFabExtended
                        ? const Padding(
                            key: ValueKey('extended_text'),
                            padding: EdgeInsets.only(right: 8),
                            child: Text(
                              "Create a New Trip",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(key: ValueKey('shrunk_text')),
                  ),
                  const Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 24,
                  ),
                ],
              ),
              icon: null,
              extendedPadding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
          ),

          /// TOOLTIP & OVERLAY (Only shows on Empty State)
          BlocBuilder<TripsCubit, TripsState>(
            builder: (context, state) {
              final isTripsEmpty = state is TripsLoaded && state.trips.isEmpty;
              if (_showOverlay && isTripsEmpty) {
                return Positioned.fill(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      /// SEMI-TRANSPARENT OVERLAY
                      Positioned.fill(
                        child: GestureDetector(
                          onTap: () => setState(() => _showOverlay = false),
                          child: Container(color: Colors.black.withOpacity(0.35)),
                        ),
                      ),

                      /// FLOATING TOOLTIP
                      Positioned(
                        bottom: 40,
                        child: TripTooltip(
                          onSkip: () {
                            setState(() {
                              _showOverlay = false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
