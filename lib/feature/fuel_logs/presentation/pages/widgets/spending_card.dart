import 'package:flutter/material.dart';
import 'package:trackify/l10n/app_localizations.dart';
import '../../cubit/fuel_logs_state.dart';

class SpendingCard extends StatelessWidget {
  final FuelLogsLoaded state;
  final AppLocalizations l10n;

  const SpendingCard({super.key, required this.state, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.05),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.spendingOnFuel,
            style: TextStyle(
              color: theme.textTheme.titleMedium?.color,
              fontSize: mediaQuery.textScaler.scale(15),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: mediaQuery.size.height * 0.02),
          Text(
            l10n.thisWeek,
            style: TextStyle(
              color: theme.hintColor,
              fontSize: mediaQuery.textScaler.scale(11),
            ),
          ),
          SizedBox(height: mediaQuery.size.height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "₹${(state.totalSpendings.isEmpty || state.totalSpendings == 'null') ? '0' : state.totalSpendings} • ${(state.totalFuelAdded.isEmpty || state.totalFuelAdded == 'null') ? '0' : state.totalFuelAdded} L",
                  style: TextStyle(
                    color: theme.textTheme.titleLarge?.color,
                    fontSize: mediaQuery.textScaler.scale(20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.trending_down,
                    color: theme.colorScheme.error,
                    size: mediaQuery.textScaler.scale(18),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    l10n.percentageValue("100"),
                    style: TextStyle(
                      color: theme.colorScheme.error,
                      fontSize: mediaQuery.textScaler.scale(14),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
