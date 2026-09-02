import 'package:flutter/material.dart';
import 'package:trackify/l10n/app_localizations.dart';
import 'package:trackify/core/utils/flutter_compat_extensions.dart';

class RefuelSummaryGrid extends StatelessWidget {
  final String totalFuel;
  final String totalSpendings;
  final String avgMileage;
  final String refuelCount;

  const RefuelSummaryGrid({
    super.key,
    required this.totalFuel,
    required this.totalSpendings,
    required this.avgMileage,
    required this.refuelCount,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: screenWidth * 0.04,
      mainAxisSpacing: screenWidth * 0.04,
      childAspectRatio: 1.9,
      children: [
        _buildSummaryCard(
          context,
          l10n.totalFuelAdded,
          totalFuel,
          l10n.litersShort,
          Icons.refresh_outlined,
          const Color(0xFF52ACCC),
        ),
        _buildSummaryCard(
          context,
          l10n.totalSpendings,
          totalSpendings,
          l10n.currencySymbol,
          Icons.account_balance_wallet_outlined,
          const Color(0xFF4CAF50),
          isPrefix: true,
        ),
        _buildSummaryCard(
          context,
          l10n.avgMileage,
          avgMileage,
          l10n.litersShort,
          Icons.bolt_outlined,
          const Color(0xFFFF7043),
        ),
        _buildSummaryCard(
          context,
          l10n.refuels,
          refuelCount,
          "",
          Icons.local_gas_station_outlined,
          const Color(0xFF9575CD),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String value,
    String unit,
    IconData icon,
    Color iconColor, {
    bool isPrefix = false,
  }) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.03,
        vertical: screenWidth * 0.03,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity( 0.5), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: mediaQuery.textScaler.scale(18)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: mediaQuery.textScaler.scale(11),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              if (isPrefix)
                Text(
                  unit,
                  style: TextStyle(
                    color: theme.textTheme.titleLarge?.color,
                    fontSize: mediaQuery.textScaler.scale(14),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (isPrefix) const SizedBox(width: 4),
              Text(
                value,
                style: TextStyle(
                  color: theme.textTheme.titleLarge?.color,
                  fontSize: mediaQuery.textScaler.scale(20),
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (!isPrefix && unit.isNotEmpty) ...[
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: TextStyle(
                    color: theme.textTheme.titleLarge?.color,
                    fontSize: mediaQuery.textScaler.scale(14),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
