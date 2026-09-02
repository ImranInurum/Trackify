import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:trackify/core/utils/distance_utils.dart';

class JourneyCard extends StatelessWidget {
  final Color cardColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final VoidCallback? onTap;
  final String distance;
  final String hours;
  final String minutes;

  const JourneyCard({
    super.key,
    required this.cardColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    this.onTap,
    this.distance = "0.0",
    this.hours = "0",
    this.minutes = "0",
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity( 0.5), width: 0.5),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.journeyWithTrackify,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: primaryTextColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.lifetime,
                      style: TextStyle(
                        fontSize: 12,
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
                Icon(Icons.arrow_forward, color: secondaryTextColor, size: 20),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetric(
                    icon: Icons.location_on_outlined,
                    label: AppLocalizations.of(context)!.distanceTravelled,
                    value: distance,
                    unit: context.displayKm,
                    color: const Color(0xFF4D7B7B),
                  ),
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.white.withOpacity( 0.1),
                ),
                Expanded(
                  child: _buildMetric(
                    icon: Icons.access_time,
                    label: AppLocalizations.of(context)!.timeDuration,
                    value: hours,
                    unit: "${AppLocalizations.of(context)!.hr} $minutes ${AppLocalizations.of(context)!.min}",
                    color: const Color(0xFF3D7B9E),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric({
    required IconData icon,
    required String label,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: secondaryTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: primaryTextColor,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              unit,
              style: TextStyle(
                fontSize: 14,
                color: secondaryTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
