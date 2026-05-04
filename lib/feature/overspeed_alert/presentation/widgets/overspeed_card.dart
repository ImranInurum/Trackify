import 'package:flutter/material.dart';
import 'package:trackify/core/common/models/vehicle_list_model.dart';
import 'package:trackify/l10n/app_localizations.dart';
import 'package:trackify/feature/overspeed_alert/data/model/overspeed_alert_model.dart';

class OverspeedCard extends StatelessWidget {
  final OverspeedAlertModel overspeedAlert;
  final Vehicle? vehicle;
  final VoidCallback? onDelete;

  const OverspeedCard({
    super.key,
    required this.overspeedAlert,
    this.vehicle,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                overspeedAlert.title.isEmpty
                    ? l10n.overspeedAlert
                    : overspeedAlert.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              if (onDelete != null)
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onDelete,
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
          Row(
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
                text: '${overspeedAlert.duration} ${l10n.sec}',
              ),

              _statChip(
                context,
                icon: Icons.date_range_outlined,
                text: _formatDate(overspeedAlert.createdAt),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Vehicle info
          Row(
            children: [
              Icon(
                Icons.directions_car_outlined,
                size: 16,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  vehicle != null
                      ? '${vehicle!.vehicleModel} — ${vehicle!.vehicleNumber}'
                      : 'IMEI: ${overspeedAlert.imei}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    if (dateStr.contains(',')) {
      return dateStr.split(',').first;
    }
    return dateStr;
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
        const SizedBox(width: 6),
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
