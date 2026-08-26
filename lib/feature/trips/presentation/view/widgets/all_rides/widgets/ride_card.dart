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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    String displayDate = ride.date;
    try {
      DateTime? parsedDate;
      if (ride.rawStartTime.isNotEmpty) {
        parsedDate = DateTime.parse(ride.rawStartTime).toLocal();
      } else {
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
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? theme.colorScheme.outline.withOpacity(0.2)
                : const Color(0xFFE2E8F0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            /// MAP THUMBNAIL PREVIEW
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: PolylineThumbnail(
                        points: ride.polylinePoints,
                        startLabel: ride.startLocation,
                        endLabel: ride.endLocation,
                        rideId: ride.id,
                        isDotted: ride.distance < 0.1,
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF0F172A).withOpacity(0.9)
                              : Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF0284C7).withOpacity(0.3),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.straighten_rounded,
                              size: 13,
                              color: Color(0xFF0284C7),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${ride.distance.toStringAsFixed(1)} ${context.displayKm}",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0284C7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// DATE AND TIME ROW
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF0284C7),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            displayDate,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? theme.colorScheme.onSurface.withOpacity(0.06)
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 13,
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${ride.startTime} - ${ride.endTime}",
                              style: TextStyle(
                                color: theme.colorScheme.onSurface.withOpacity(0.7),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  /// UNIFIED STATS PANEL
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? theme.colorScheme.onSurface.withOpacity(0.05)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark
                            ? theme.colorScheme.outline.withOpacity(0.15)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildStatItem(
                            context: context,
                            icon: Icons.route_rounded,
                            value:
                                "${ride.distance.toStringAsFixed(1)} ${context.displayKm}",
                            label: l10n.distanceLabel,
                          ),
                        ),
                        Container(
                          height: 28,
                          width: 1,
                          color: isDark
                              ? theme.colorScheme.outline.withOpacity(0.2)
                              : const Color(0xFFE2E8F0),
                        ),
                        Expanded(
                          child: _buildStatItem(
                            context: context,
                            icon: Icons.timer_rounded,
                            value: ride.duration,
                            label: l10n.durationLabel,
                          ),
                        ),
                        Container(
                          height: 28,
                          width: 1,
                          color: isDark
                              ? theme.colorScheme.outline.withOpacity(0.2)
                              : const Color(0xFFE2E8F0),
                        ),
                        Expanded(
                          child: _buildStatItem(
                            context: context,
                            icon: Icons.speed_rounded,
                            value:
                                "${ride.avgSpeed.toStringAsFixed(1)} ${context.displayKmh}",
                            label: l10n.averageSpeed,
                          ),
                        ),
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

  Widget _buildStatItem({
    required BuildContext context,
    required IconData icon,
    required String value,
    required String label,
  }) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 14,
              color: const Color(0xFF0284C7),
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            color: theme.colorScheme.onSurface.withOpacity(0.55),
            fontSize: 10.5,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
