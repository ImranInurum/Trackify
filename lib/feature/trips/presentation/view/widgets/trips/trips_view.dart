import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;
import 'package:trackify/feature/trips/data/entity/ride_model.dart';
import 'package:trackify/feature/trips/presentation/view/trip_details/trip_details_screen.dart';
import 'package:trackify/feature/trips/presentation/view/widgets/trips/widgets/trip_card.dart';
import 'package:trackify/feature/trips/presentation/view/widgets/trips/widgets/trip_empty_state.dart';
import 'package:trackify/feature/trips/presentation/view/widgets/sorting_bottom_sheet.dart';
import 'package:trackify/feature/trips/presentation/view/widgets/trips/widgets/trip_tooltip.dart';
import 'package:trackify/l10n/app_localizations.dart';

import '../../../cubit/ride_history_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../create_trip/create_trip_screen.dart';
import 'package:intl/intl.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';

class Trips extends StatefulWidget {
  const Trips({super.key});

  @override
  State<Trips> createState() => _TripsState();
}

class _TripsState extends State<Trips> {
  bool _showOverlay = false;
  bool _isFabExtended = true;
  DateTime? _selectedDate;
  List<Map<String, dynamic>> _savedTrips = [];
  bool _isLoadingTrips = true;
  late final Timer _fabTimer;
  StreamSubscription? _boxSubscription;

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
    _loadSavedTrips();
  }

  Future<void> _loadSavedTrips() async {
    try {
      final box = await Hive.openBox('saved_trips');

      _boxSubscription ??= box.watch().listen((_) {
          _updateTripsFromBox(box);
        });

      _updateTripsFromBox(box);
    } catch (e) {
      debugPrint('Error loading saved trips: $e');
      if (mounted) {
        setState(() {
          _isLoadingTrips = false;
        });
      }
    }
  }

  void _updateTripsFromBox(Box box) {
    final tripsJson = box.get('trips_list', defaultValue: []) as List<dynamic>;

    final List<Map<String, dynamic>> trips = [];
    for (var jsonStr in tripsJson) {
      try {
        final decoded = jsonDecode(jsonStr as String);
        trips.add(decoded);
      } catch (_) {}
    }

    if (mounted) {
      setState(() {
        _savedTrips = trips.reversed.toList(); // Newest first
        _isLoadingTrips = false;
      });
    }
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
    _boxSubscription?.cancel();
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
          CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: Theme.of(context).colorScheme.copyWith(
                                      primary: theme.primaryColor,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              setState(() {
                                _selectedDate = picked;
                              });
                            }
                          },
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.onSurface.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: theme.colorScheme.outlineVariant.withOpacity( 0.5),
                                width: 0.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 16),
                                Icon(
                                  _selectedDate != null ? Icons.calendar_today : Icons.calendar_today_outlined,
                                  color: _selectedDate != null ? theme.primaryColor : theme.colorScheme.onSurface.withOpacity(0.5),
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    child: Text(
                                      _selectedDate != null ? DateFormat('dd MMM yyyy').format(_selectedDate!) : 'Select Date',
                                      style: TextStyle(
                                        color: _selectedDate != null ? theme.primaryColor : theme.colorScheme.onSurface
                                            .withOpacity( 0.4),
                                        fontSize: 14,
                                        fontWeight: _selectedDate != null ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                                if (_selectedDate != null)
                                  IconButton(
                                    icon: const Icon(Icons.clear, size: 20),
                                    onPressed: () {
                                      setState(() {
                                        _selectedDate = null;
                                      });
                                    },
                                  ),
                              ],
                            ),
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
                            builder: (context) {
                              final cubit = context.read<RideHistoryCubit>();
                              return SortingBottomSheet(
                                initialSortBy: cubit.currentSortBy,
                                initialIsRecentToOldest:
                                    cubit.currentIsRecentToOldest,
                                onApply: (sortBy, isRecentToOldest) {
                                  cubit.sortRides(sortBy, isRecentToOldest);
                                },
                              );
                            },
                          );
                        },
                        child: Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onSurface.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: theme.colorScheme.outlineVariant.withOpacity( 0.5),
                              width: 0.5,
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
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              
              if (_isLoadingTrips)
                const SliverFillRemaining(child: Center(child: TrackifyLoader())),
                
              if (!_isLoadingTrips && _savedTrips.isEmpty)
                const SliverFillRemaining(child: TripEmptyState()),
                
              if (!_isLoadingTrips && _savedTrips.isNotEmpty)
                ...(() {
                  final List<Map<String, dynamic>> filteredTrips = [];
                  for (var trip in _savedTrips) {
                    final ridesData = trip['rides'] as List<dynamic>? ?? [];
                    final rides = ridesData
                        .map((e) => Ride.fromJson(e as Map<String, dynamic>))
                        .toList();

                    bool includeTrip = true;
                    if (_selectedDate != null) {
                      bool hasMatchingDate = false;
                      for (var r in rides) {
                        DateTime? parsedDate;
                        if (r.rawStartTime.isNotEmpty) {
                          try {
                            parsedDate = DateTime.parse(r.rawStartTime).toLocal();
                          } catch (_) {}
                        }
                        if (parsedDate == null && r.date.isNotEmpty) {
                          try {
                            parsedDate = DateFormat('dd/MM/yyyy').parse(r.date);
                          } catch (_) {
                            try {
                              parsedDate = DateTime.parse(r.date);
                            } catch (_) {}
                          }
                        }
                        
                        if (parsedDate != null) {
                          if (parsedDate.year == _selectedDate!.year &&
                              parsedDate.month == _selectedDate!.month &&
                              parsedDate.day == _selectedDate!.day) {
                            hasMatchingDate = true;
                            break;
                          }
                        } else {
                          final dateStr1 = DateFormat('dd MMM yyyy').format(_selectedDate!);
                          final dateStr2 = DateFormat('dd/MM/yyyy').format(_selectedDate!);
                          if (r.date == dateStr1 || r.date == dateStr2) {
                            hasMatchingDate = true;
                            break;
                          }
                        }
                      }
                      if (!hasMatchingDate) {
                        includeTrip = false;
                      }
                    }
                    if (includeTrip) {
                      filteredTrips.add(trip);
                    }
                  }

                  if (filteredTrips.isEmpty) {
                    return [const SliverFillRemaining(child: TripEmptyState())];
                  }

                  return [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final trip = filteredTrips[index];
                            final ridesData = trip['rides'] as List<dynamic>? ?? [];
                            final rides = ridesData
                                .map((e) => Ride.fromJson(e as Map<String, dynamic>))
                                .toList();

                            final savedUnit = trip['unit'] as String? ?? 'km';
                            final displayTitle = _getLocalizedTripTitle(
                              trip['title'] ?? l10n.tripLabel('${index + 1}'),
                              l10n,
                            );
                            return TripCard(
                              title: displayTitle,
                              rides: rides,
                              savedUnit: savedUnit,
                              imagePath: trip['imagePath'] as String?,
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TripDetailsScreen(
                                      tripName: displayTitle,
                                      rides: rides,
                                      savedUnit: savedUnit,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          childCount: filteredTrips.length,
                        ),
                      ),
                    )
                  ];
                })(),
            ],
          ),

          /// TOOLTIP & OVERLAY
          if (_showOverlay) ...[
            /// SEMI-TRANSPARENT OVERLAY
            GestureDetector(
              onTap: () => setState(() => _showOverlay = false),
              child: Container(color: Colors.black.withOpacity( 0.35)),
            ),

            /// FLOATING TOOLTIP
            Positioned(
              bottom: 40,
              child: TripTooltip(onSkip: _markTooltipAsSeen),
            ),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateTripScreen()),
          );
          _loadSavedTrips();
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

  String _getLocalizedTripTitle(String title, AppLocalizations l10n) {
    final regex = RegExp(r'^Trip\s+(\d+)$', caseSensitive: false);
    final match = regex.firstMatch(title);
    if (match != null) {
      final number = match.group(1)!;
      return l10n.tripLabel(number);
    }
    return title;
  }
}
