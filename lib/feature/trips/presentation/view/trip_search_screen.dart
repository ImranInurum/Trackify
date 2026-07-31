import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:trackify/feature/trips/data/entity/ride_model.dart';
import 'package:trackify/feature/trips/presentation/cubit/ride_history_cubit.dart';
import 'package:trackify/feature/trips/presentation/cubit/ride_history_state.dart';
import 'package:trackify/feature/trips/presentation/view/trip_details/trip_details_screen.dart';
import 'package:trackify/feature/trips/presentation/view/ride_history_details/ride_history_details_screen.dart';
import 'package:trackify/feature/trips/presentation/view/widgets/trips/widgets/trip_card.dart';
import 'package:trackify/feature/trips/presentation/view/widgets/all_rides/widgets/ride_card.dart';
import 'package:trackify/l10n/app_localizations.dart';
import 'package:trackify/core/utils/distance_utils.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';

class TripSearchScreen extends StatefulWidget {
  final bool isTripSearch;
  const TripSearchScreen({super.key, this.isTripSearch = true});

  @override
  State<TripSearchScreen> createState() => _TripSearchScreenState();
}

class _TripSearchScreenState extends State<TripSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  DateTime? _selectedDate;
  List<Map<String, dynamic>> _savedTrips = [];
  bool _isLoadingTrips = false;

  @override
  void initState() {
    super.initState();
    if (widget.isTripSearch) {
      _loadSavedTrips();
    }
  }

  Future<void> _loadSavedTrips() async {
    setState(() {
      _isLoadingTrips = true;
    });
    try {
      final box = await Hive.openBox('saved_trips');
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
    } catch (e) {
      debugPrint('Error loading saved trips: $e');
      if (mounted) {
        setState(() {
          _isLoadingTrips = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;


    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.isTripSearch ? l10n.searchTrips : l10n.searchRides, ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          /// SEARCH BAR
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF11141B) : theme.colorScheme.onSurface.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
              ),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: (value) => setState(() => _query = value.toLowerCase()),
                decoration: InputDecoration(
                  hintText: widget.isTripSearch ? l10n.searchTripsHint : l10n.searchRidesHint,
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search, 
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    size: 20,
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_selectedDate != null || _query.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _query = '';
                              _selectedDate = null;
                            });
                          },
                        ),
                      IconButton(
                        icon: Icon(
                          _selectedDate != null ? Icons.calendar_today : Icons.calendar_today_outlined,
                          color: _selectedDate != null ? theme.primaryColor : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          size: 20,
                        ),
                        onPressed: () async {
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
                      ),
                    ],
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
            ),
          ),

          Expanded(
            child: BlocBuilder<RideHistoryCubit, RideHistoryState>(
              builder: (context, state) {
                if (state is RideHistoryLoading || _isLoadingTrips) {
                  return const Center(child: TrackifyLoader());
                }
                if (state is RideHistorySuccess) {
                  if (widget.isTripSearch && _savedTrips.isEmpty && _query.isNotEmpty) {
                    return Center(
                      child: Text(
                        l10n.noTripsFound(_query),
                        style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                      ),
                    );
                  }
                  if (!widget.isTripSearch && state.rides.isEmpty) {
                    return Center(
                      child: Text(
                        l10n.noDataAvailable,
                        style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                      ),
                    );
                  }
                  if (_query.isEmpty && _selectedDate == null) {
                    if (state.rides.isEmpty) {
                      return Center(
                        child: Text(
                          l10n.noDataAvailable,
                          style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                        ),
                      );
                    }
                    return _buildExtraordinarySection(context, state.rides);
                  } else {
                    return _buildSearchResults(context, state.rides);
                  }
                }
                if (state is RideHistoryFailure) {
                  if (widget.isTripSearch && _savedTrips.isNotEmpty && _query.isNotEmpty) {
                    return _buildSearchResults(context, []);
                  }
                  return Center(
                    child: Text(
                      l10n.noDataAvailable,
                      style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExtraordinarySection(BuildContext context, List<Ride> rides) {
    if (rides.isEmpty) return const SizedBox();

    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    // Calculate Extraordinary Trips
    final topSpeedRide = rides.reduce((a, b) => a.topSpeed > b.topSpeed ? a : b);
    final maxDistRide = rides.reduce((a, b) => a.distance > b.distance ? a : b);
    final bestAvgSpeedRide = rides.reduce((a, b) => a.avgSpeed > b.avgSpeed ? a : b);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              l10n.extraordinaryTrips,
              style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Divider(color: theme.colorScheme.onSurface.withValues(alpha: 0.1))),
          ],
        ),
        const SizedBox(height: 16),
        _buildExtraCard(
          context,
          icon: Icons.local_fire_department,
          iconColor: Colors.orange,
          title: l10n.topSpeedClocked,
          dateRange: "${topSpeedRide.date} - ${topSpeedRide.date}",
          mainStat: "${l10n.topSpeedLabel} - ${topSpeedRide.topSpeed.toStringAsFixed(1)} ${context.displayKmh}",
          subStat: "${l10n.avgSpeedLabel} - ${topSpeedRide.avgSpeed.toStringAsFixed(1)} ${context.displayKmh}",
          ride: topSpeedRide,
        ),
        _buildExtraCard(
          context,
          icon: Icons.location_on,
          iconColor: Colors.redAccent,
          title: l10n.maxDistanceCovered,
          dateRange: "${maxDistRide.date} - ${maxDistRide.date}",
          mainStat: "${l10n.distanceLabel} - ${maxDistRide.distance.toStringAsFixed(1)} ${context.displayKms}",
          subStat: "${l10n.durationLabel} - ${maxDistRide.duration}",
          ride: maxDistRide,
        ),
        _buildExtraCard(
          context,
          icon: Icons.speed,
          iconColor: Colors.pinkAccent,
          title: l10n.bestAverageSpeed,
          dateRange: "${bestAvgSpeedRide.date} - ${bestAvgSpeedRide.date}",
          mainStat: "${l10n.avgSpeedLabel} - ${bestAvgSpeedRide.avgSpeed.toStringAsFixed(1)} ${context.displayKmh}",
          subStat: "${l10n.distanceLabel} - ${bestAvgSpeedRide.distance.toStringAsFixed(1)} ${context.displayKms}",
          ride: bestAvgSpeedRide,
        ),
      ],
    );
  }

  Widget _buildExtraCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String dateRange,
    required String mainStat,
    required String subStat,
    required Ride ride,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    const goldColor = Color(0xFFFFD700);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RideHistoryDetailsScreen(ride: ride),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF15181F) : theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.05)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateRange,
                    style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        fontSize: 12,
                      ),
                      children: [
                        _buildSpanPart(mainStat, goldColor),
                        const TextSpan(text: "  "),
                        _buildSpanPart(subStat, null),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextSpan _buildSpanPart(String text, Color? highlightColor) {
    final parts = text.split('- ');
    if (parts.length < 2) return TextSpan(text: text);
    
    return TextSpan(
      children: [
        TextSpan(text: "${parts[0]}- "),
        TextSpan(
          text: parts[1],
          style: TextStyle(color: highlightColor ?? Colors.white.withValues(alpha: 0.9),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults(BuildContext context, List<Ride> rides) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    if (widget.isTripSearch) {
      final results = _savedTrips.where((trip) {
        final title = (trip['title'] as String? ?? '').toLowerCase();
        final ridesData = trip['rides'] as List<dynamic>? ?? [];
        bool matchesRide = false;
        bool matchesDate = _selectedDate == null;
        
        for (var r in ridesData) {
          try {
            final start = (r['start_location'] ?? r['startLocation'] ?? '').toString().toLowerCase();
            final end = (r['end_location'] ?? r['endLocation'] ?? '').toString().toLowerCase();
            if (_query.isNotEmpty && (start.contains(_query) || end.contains(_query))) {
              matchesRide = true;
            }
            
            if (_selectedDate != null) {
              final dateStr = r['date'] as String?;
              final selectedDateStr = DateFormat('dd MMM yyyy').format(_selectedDate!);
              if (dateStr == selectedDateStr) {
                matchesDate = true;
              }
              // Check DD/MM/YYYY as well since formats could vary
              final selectedDateStr2 = DateFormat('dd/MM/yyyy').format(_selectedDate!);
              if (dateStr == selectedDateStr2) {
                matchesDate = true;
              }
            }
          } catch (_) {}
        }
        
        final matchesQuery = _query.isEmpty || title.contains(_query) || matchesRide;
        return matchesQuery && matchesDate;
      }).toList();

      if (results.isEmpty) {
        return Center(
          child: Text(
            l10n.noTripsFound(_query),
            style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: results.length,
        itemBuilder: (context, index) {
          final trip = results[index];
          final ridesData = trip['rides'] as List<dynamic>;
          final tripRides = ridesData.map((e) => Ride.fromJson(e as Map<String, dynamic>)).toList();
          final displayTitle = _getLocalizedTripTitle(trip['title'] ?? l10n.tripLabel('${index + 1}'), l10n);

          return TripCard(
            title: displayTitle,
            rides: tripRides,
            imagePath: trip['imagePath'] as String?,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TripDetailsScreen(
                    tripName: displayTitle,
                    rides: tripRides,
                  ),
                ),
              );
            },
          );
        },
      );
    } else {
      final results = rides.where((r) {
        final start = r.startLocation.toLowerCase();
        final end = r.endLocation.toLowerCase();
        final matchesQuery = _query.isEmpty || start.contains(_query) || end.contains(_query);
        
        bool matchesDate = _selectedDate == null;
        if (_selectedDate != null) {
          final selectedDateStr = DateFormat('dd MMM yyyy').format(_selectedDate!);
          final selectedDateStr2 = DateFormat('dd/MM/yyyy').format(_selectedDate!);
          if (r.date == selectedDateStr || r.date == selectedDateStr2) {
            matchesDate = true;
          }
        }
        
        return matchesQuery && matchesDate;
      }).toList();

      if (results.isEmpty) {
        return Center(
          child: Text(
            l10n.noRidesFound(_query),
            style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: results.length,
        itemBuilder: (context, index) {
          final ride = results[index];
          return RideCard(
            ride: ride,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RideHistoryDetailsScreen(ride: ride),
                ),
              );
            },
          );
        },
      );
    }
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
