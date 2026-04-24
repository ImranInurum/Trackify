import 'package:flutter/material.dart';
import 'package:trackify/l10n/app_localizations.dart';
import 'package:trackify/feature/overspeed_alert/data/model/overspeed_alert_model.dart';

class OverspeedCard extends StatelessWidget {
  final OverspeedAlertModel overspeedAlert;

  const OverspeedCard({super.key, required this.overspeedAlert});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            overspeedAlert.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {},
                icon: Icon(
                  Icons.delete_rounded,
                  color: theme.colorScheme.error,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Speed · Duration · Date row
          Padding(
            padding: const EdgeInsets.only(right: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statChip(
                  context,
                  icon: Icons.speed_outlined,
                  text: '${overspeedAlert.speedLimit} ${l10n.kmHr}',
                ),

                _statChip(
                  context,
                  icon: Icons.alarm_rounded,
                  text: '${overspeedAlert.timeDuration} ${l10n.sec}',
                ),

                _statChip(
                  context,
                  icon: Icons.date_range_outlined,
                  text: overspeedAlert.date,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Vehicle list
          ...overspeedAlert.vehicles.map(
            (v) => Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                children: [
                  Icon(
                    Icons.directions_car_outlined,
                    size: 16,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${v.vehicleModel} — ${v.vehicleNumber}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _statChip(
    BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}
