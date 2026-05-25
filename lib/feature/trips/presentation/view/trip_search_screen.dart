import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/feature/trips/data/entity/ride_model.dart';
import 'package:trackify/feature/trips/presentation/cubit/ride_history_cubit.dart';
import 'package:trackify/feature/trips/presentation/cubit/ride_history_state.dart';
import 'package:trackify/feature/trips/presentation/view/trip_details/trip_details_screen.dart';
import 'package:trackify/feature/trips/presentation/view/ride_history_details/ride_history_details_screen.dart';
import 'package:trackify/feature/trips/presentation/view/widgets/trips/widgets/trip_card.dart';
import 'package:trackify/feature/trips/presentation/view/widgets/all_rides/widgets/ride_card.dart';
import 'package:trackify/l10n/app_localizations.dart';

class TripSearchScreen extends StatefulWidget {
  final bool isTripSearch;
  const TripSearchScreen({super.key, this.isTripSearch = true});

  @override
  State<TripSearchScreen> createState() => _TripSearchScreenState();
}

class _TripSearchScreenState extends State<TripSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

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
          widget.isTripSearch ? l10n.searchTrips : l10n.searchRides,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
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
                if (state is RideHistorySuccess) {
                  if (_query.isEmpty) {
                    return _buildExtraordinarySection(context, state.rides);
                  } else {
                    return _buildSearchResults(context, state.rides);
                  }
                }
                return const Center(child: CircularProgressIndicator());
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
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
          mainStat: "${l10n.topSpeedLabel} - ${topSpeedRide.topSpeed.toStringAsFixed(1)} ${l10n.kmh}",
          subStat: "${l10n.avgSpeedLabel} - ${topSpeedRide.avgSpeed.toStringAsFixed(1)} ${l10n.kmh}",
          ride: topSpeedRide,
        ),
        _buildExtraCard(
          context,
          icon: Icons.location_on,
          iconColor: Colors.redAccent,
          title: l10n.maxDistanceCovered,
          dateRange: "${maxDistRide.date} - ${maxDistRide.date}",
          mainStat: "${l10n.distanceLabel} - ${maxDistRide.distance.toStringAsFixed(1)} ${l10n.kms}",
          subStat: "${l10n.durationLabel} - ${maxDistRide.duration}",
          ride: maxDistRide,
        ),
        _buildExtraCard(
          context,
          icon: Icons.speed,
          iconColor: Colors.pinkAccent,
          title: l10n.bestAverageSpeed,
          dateRange: "${bestAvgSpeedRide.date} - ${bestAvgSpeedRide.date}",
          mainStat: "${l10n.avgSpeedLabel} - ${bestAvgSpeedRide.avgSpeed.toStringAsFixed(1)} ${l10n.kmh}",
          subStat: "${l10n.distanceLabel} - ${bestAvgSpeedRide.distance.toStringAsFixed(1)} ${l10n.kms}",
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
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
          style: TextStyle(
            color: highlightColor ?? Colors.white.withValues(alpha: 0.9),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults(BuildContext context, List<Ride> rides) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final results = rides.where((r) {
      if (widget.isTripSearch) {
        final title = "Trip ${rides.indexOf(r) + 1}".toLowerCase();
        final start = r.startLocation.toLowerCase();
        final end = r.endLocation.toLowerCase();
        return title.contains(_query) || start.contains(_query) || end.contains(_query);
      } else {
        final start = r.startLocation.toLowerCase();
        final end = r.endLocation.toLowerCase();
        return start.contains(_query) || end.contains(_query);
      }
    }).toList();

    if (results.isEmpty) {
      return Center(
        child: Text(
          widget.isTripSearch ? l10n.noTripsFound(_query) : l10n.noRidesFound(_query),
          style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final ride = results[index];
        if (widget.isTripSearch) {
          return TripCard(
            title: l10n.tripLabel((rides.indexOf(ride) + 1).toString()),
            rides: [ride],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TripDetailsScreen(
                    tripName: l10n.tripLabel((rides.indexOf(ride) + 1).toString()),
                    rides: [ride],
                  ),
                ),
              );
            },
          );
        } else {
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
        }
      },
    );
  }
}
