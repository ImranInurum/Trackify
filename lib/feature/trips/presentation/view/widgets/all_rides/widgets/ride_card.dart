import 'package:flutter/material.dart';
import 'package:trackify/feature/trips/data/entity/ride_model.dart';
import 'package:trackify/feature/trips/presentation/view/widgets/all_rides/widgets/polyline_thumbnail.dart';
import 'package:trackify/l10n/app_localizations.dart';
import 'package:trackify/core/utils/distance_utils.dart';
import 'package:intl/intl.dart';

class RideCard extends StatelessWidget {
  final Ride ride;
  final VoidCallback? onTap;
  const RideCard({super.key, required this.ride, this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    String displayDate = ride.date;
    try {
      DateTime? parsedDate;
      if (ride.rawStartTime.isNotEmpty) {
        parsedDate = DateTime.parse(ride.rawStartTime).toLocal();
      } else {
        // Fallback parsing if rawStartTime is empty but date is present
        try {
          parsedDate = DateFormat('dd/MM/yyyy').parse(ride.date);
        } catch (_) {
          try {
            parsedDate = DateTime.parse(ride.date);
          } catch (_) {}
        }
      }
      
      if (parsedDate != null) {
        final now = DateTime.now();
        if (parsedDate.year == now.year &&
            parsedDate.month == now.month &&
            parsedDate.day == now.day) {
          displayDate = l10n.today;
        } else {
          displayDate = DateFormat('dd MMM yyyy').format(parsedDate);
        }
      } else {
        final now = DateTime.now();
        final format1 = "${now.day}/${now.month}/${now.year}";
        final format2 = DateFormat('dd MMM yyyy').format(now);
        if (ride.date == format1 || ride.date == format2) {
          displayDate = l10n.today;
        }
      }
    } catch (_) {}

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        debugPrint(
          "Card tapped! Polyline points: ${ride.polylinePoints.length}",
        );
        debugPrint("Ride id: ${ride.id}");
        onTap?.call();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5), width: 0.5),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            /// MAP SNIPPET (Placeholder for map route)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Container(
                height: 220,
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: PolylineThumbnail(
                        points: ride.polylinePoints,
                        startLabel: ride.startLocation,
                        endLabel: ride.endLocation,
                        rideId: ride.id,
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).cardColor.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "${ride.distance.toStringAsFixed(1)} ${context.displayKm}",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        displayDate,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        "${ride.startTime} - ${ride.endTime}",
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildStat(
                          context,
                          Icons.route_outlined,
                          "${ride.distance.toStringAsFixed(1)} ${context.displayKm}",
                          l10n.distanceLabel,
                        ),
                      ),
                      Expanded(
                        child: _buildStat(
                          context,
                          Icons.timer_outlined,
                          ride.duration,
                          l10n.durationLabel,
                        ),
                      ),
                      Expanded(
                        child: _buildStat(
                          context,
                          Icons.speed,
                          "${ride.avgSpeed.toStringAsFixed(1)} ${context.displayKmh}",
                          l10n.averageSpeed,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Divider(
                      height: 1,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                  // Row(
                  //   children: [
                  //     const Icon(Icons.circle, size: 8, color: Colors.green),
                  //     const SizedBox(width: 8),
                  //     Expanded(
                  //       child: Text(
                  //         ride.startLocation.replaceAll(' ', '') == '0.0000,0.0000' ? l10n.notAvailable : ride.startLocation,
                  //         style: TextStyle(
                  //           fontSize: 12,
                  //           color: Theme.of(
                  //             context,
                  //           ).colorScheme.onSurface.withValues(alpha: 0.7),
                  //           overflow: TextOverflow.ellipsis,
                  //         ),
                  //       ),
                  //     ),
                  // const Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 8),
                  //   child: Icon(
                  //     Icons.arrow_forward,
                  //     size: 12,
                  //     color: Colors.grey,
                  //   ),
                  // ),
                  // const Icon(
                  //   Icons.location_on,
                  //   size: 10,
                  //   color: Colors.red,
                  // ),
                  // const SizedBox(width: 4),
                  // Expanded(
                  //   child: Text(
                  //     ride.endLocation.replaceAll(' ', '') == '0.0000,0.0000' ? l10n.notAvailable : ride.endLocation,
                  //     style: TextStyle(
                  //       fontSize: 12,
                  //       color: Theme.of(
                  //         context,
                  //       ).colorScheme.onSurface.withValues(alpha: 0.7),
                  //       overflow: TextOverflow.ellipsis,
                  //     ),
                  //   ),
                  // ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.5),
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
