import 'dart:async';
import 'package:flutter/material.dart';
import 'package:trackify/feature/trips/presentation/view/trip_details/trip_details_screen.dart';
import 'package:trackify/feature/trips/presentation/view/widgets/trips/widgets/trip_card.dart';
import 'package:trackify/feature/trips/presentation/view/widgets/trips/widgets/trip_empty_state.dart';
import 'package:trackify/feature/trips/presentation/view/widgets/sorting_bottom_sheet.dart';
import 'package:trackify/feature/trips/presentation/view/widgets/trips/widgets/trip_tooltip.dart';
import 'package:trackify/l10n/app_localizations.dart';
import '../../../cubit/ride_history_cubit.dart';
import '../../../cubit/ride_history_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../create_trip/create_trip_screen.dart';
import '../../trip_search_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Trips extends StatefulWidget {
  const Trips({super.key});

  @override
  State<Trips> createState() => _TripsState();
}

class _TripsState extends State<Trips> {
  bool _showOverlay = false;
  bool _isFabExtended = true;
  String _searchQuery = '';
  late final Timer _fabTimer;

  @override
  void initState() {
    super.initState();
    // Periodic expansion: every 17 seconds (matching Fuel Logs pattern)
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

    _checkTooltipVisibility();
  }

  Future<void> _checkTooltipVisibility() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenTooltip = prefs.getBool('has_seen_trip_tooltip') ?? false;
    if (!hasSeenTooltip) {
      setState(() {
        _showOverlay = true;
      });
    }
  }

  Future<void> _markTooltipAsSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_trip_tooltip', true);
    setState(() {
      _showOverlay = false;
    });
  }

  @override
  void dispose() {
    _fabTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          /// BACKGROUND CONTENT
          Column(
            children: [
              /// SEARCH BAR & FILTER
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.05,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            Icon(
                              Icons.search,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const TripSearchScreen(),
                                    ),
                                  );
                                },
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  child: Text(
                                    'Search Trips',
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.4),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => SortingBottomSheet(
                            initialSortBy: 'Date',
                            initialIsRecentToOldest: true,
                            onApply: (sortBy, isRecentToOldest) {
                              context.read<RideHistoryCubit>().sortRides(
                                sortBy,
                                isRecentToOldest,
                              );
                            },
                          ),
                        );
                      },
                      child: Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.05,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                        child: Icon(
                          Icons.sort,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: BlocBuilder<RideHistoryCubit, RideHistoryState>(
                  builder: (context, state) {
                    if (state is RideHistorySuccess && state.rides.isNotEmpty) {
                      // Filter logic: In a real app, we'd filter trip entities.
                      // For now, we'll check if the mock "Trip 1" matches the query.
                      final matchesSearch = "trip 1".contains(_searchQuery);

                      if (!matchesSearch) {
                        return Center(
                          child: Text(
                            "No trips found",
                            style: TextStyle(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                        );
                      }

                      return ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          TripCard(
                            title: "Trip 1",
                            rides: state.rides,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TripDetailsScreen(
                                    tripName: "Trip 1",
                                    rides: state.rides,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    }
                    return const TripEmptyState();
                  },
                ),
              ),
            ],
          ),

          /// TOOLTIP & OVERLAY
          if (_showOverlay) ...[
            /// SEMI-TRANSPARENT OVERLAY
            GestureDetector(
              onTap: () => setState(() => _showOverlay = false),
              child: Container(color: Colors.black.withValues(alpha: 0.35)),
            ),

            /// FLOATING TOOLTIP
            Positioned(
              bottom: 40,
              child: TripTooltip(
                onSkip: _markTooltipAsSeen,
              ),
            ),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateTripScreen()),
          );
        },
        tooltip: l10n.createNewTrip,
        backgroundColor: theme.primaryColor,
        elevation: 4,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
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
                  ? Padding(
                      key: const ValueKey('extended_text'),
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        l10n.createNewTrip,
                        style: TextStyle(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(key: ValueKey('shrunk_text')),
            ),
            Icon(Icons.add, color: theme.colorScheme.onPrimary, size: 24),
          ],
        ),
        icon: null,
        extendedPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
    );
  }
}
