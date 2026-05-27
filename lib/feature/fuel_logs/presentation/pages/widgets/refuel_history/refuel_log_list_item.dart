import 'package:flutter/material.dart';
import 'package:trackify/l10n/app_localizations.dart';
import 'package:trackify/core/utils/distance_utils.dart';

class RefuelLogListItem extends StatelessWidget {
  final String date;
  final String time;
  final String odometer;
  final String location;
  final String amount;
  final String rate;
  final String? distance;
  final String? liters;
  final String? mileage;
  final bool showDetails;

  const RefuelLogListItem({
    super.key,
    required this.date,
    required this.time,
    required this.odometer,
    required this.location,
    required this.amount,
    required this.rate,
    this.distance,
    this.liters,
    this.mileage,
    this.showDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(screenWidth * 0.04),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: theme.dividerColor, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: mediaQuery.textScaler.scale(18),
                        color: theme.hintColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "$date • $time",
                        style: TextStyle(
                          color: theme.textTheme.bodyMedium?.color,
                          fontWeight: FontWeight.bold,
                          fontSize: mediaQuery.textScaler.scale(14),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "${l10n.currencySymbol}$amount",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: mediaQuery.textScaler.scale(14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert, color: theme.hintColor),
                        onSelected: (value) {
                          if (value == 'edit') {
                            // TODO: Handle edit
                          } else if (value == 'delete') {
                            // TODO: Handle delete
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit_outlined,
                                    size: mediaQuery.textScaler.scale(18)),
                                const SizedBox(width: 12),
                                Text(l10n.edit),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete_outline,
                                    size: mediaQuery.textScaler.scale(18)),
                                const SizedBox(width: 12),
                                Text(l10n.delete),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.speed,
                          size: mediaQuery.textScaler.scale(18),
                          color: theme.hintColor),
                      const SizedBox(width: 8),
                      Text(
                        "$odometer ${context.displayKms}",
                        style: TextStyle(
                          color: theme.textTheme.bodyLarge?.color,
                          fontWeight: FontWeight.bold,
                          fontSize: mediaQuery.textScaler.scale(15),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "${l10n.currencySymbol}$rate",
                    style: TextStyle(
                      color: theme.hintColor,
                      fontSize: mediaQuery.textScaler.scale(13),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.location_on_outlined,
                      size: mediaQuery.textScaler.scale(18),
                      color: theme.hintColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      location,
                      style: TextStyle(
                        color: theme.hintColor,
                        fontSize: mediaQuery.textScaler.scale(13),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (showDetails && distance != null) ...[
          Container(
            margin: const EdgeInsets.only(left: 24),
            height: 24,
            width: 1,
            color: theme.dividerColor,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: theme.cardColor.withAlpha(128),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildMiniDetail(
                    context, Icons.route_outlined, "$distance ${context.displayKms}"),
                _buildSeparator(context),
                _buildMiniDetail(context, Icons.local_gas_station_outlined,
                    "$liters ${l10n.litersShort}"),
                _buildSeparator(context),
                _buildMiniDetail(
                    context, Icons.bolt_outlined, "$mileage ${context.displayKmL}"),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 24),
            height: 16,
            width: 1,
            color: theme.dividerColor,
          ),
        ],
      ],
    );
  }

  Widget _buildMiniDetail(BuildContext context, IconData icon, String text) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    return Row(
      children: [
        Icon(icon, size: mediaQuery.textScaler.scale(14), color: theme.hintColor),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: theme.hintColor,
            fontSize: mediaQuery.textScaler.scale(12),
          ),
        ),
      ],
    );
  }

  Widget _buildSeparator(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      height: 12,
      width: 1,
      color: Theme.of(context).dividerColor,
    );
  }
}
