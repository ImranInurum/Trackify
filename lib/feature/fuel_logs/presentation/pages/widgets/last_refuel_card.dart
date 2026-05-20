import 'package:flutter/material.dart';
import 'package:trackify/l10n/app_localizations.dart';

import '../../cubit/fuel_logs_state.dart';

class LastRefuelCard extends StatelessWidget {
  final FuelLogsLoaded state;
  final AppLocalizations l10n;

  const LastRefuelCard({super.key, required this.state, required this.l10n});

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.afterLastRefuel,
                      style: TextStyle(
                        color: theme.textTheme.titleMedium?.color,
                        fontSize: mediaQuery.textScaler.scale(15),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${(state.lastRefuelDate.isEmpty || state.lastRefuelDate == 'null') ? '--' : state.lastRefuelDate} | ₹${(state.lastRefuelAmount.isEmpty || state.lastRefuelAmount == 'null') ? '0' : state.lastRefuelAmount} | ${(state.lastRefuelLiters.isEmpty || state.lastRefuelLiters == 'null') ? '0' : state.lastRefuelLiters} ${l10n.litersShort}",
                      style: TextStyle(
                        color: theme.hintColor,
                        fontSize: mediaQuery.textScaler.scale(11),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _showInfoDialog(context, l10n),
                child: Icon(
                  Icons.info_outline,
                  size: mediaQuery.textScaler.scale(20),
                  color: theme.hintColor,
                ),
              ),
            ],
          ),
          SizedBox(height: mediaQuery.size.height * 0.03),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  l10n.fuelRemaining,
                  "${state.fuelRemaining == 'null' ? '0' : state.fuelRemaining}L",
                  Icons.local_gas_station_outlined,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  context,
                  l10n.distanceRemaining,
                  "${state.distanceRemaining == 'null' ? '0' : state.distanceRemaining}km",
                  Icons.directions_car_outlined,
                ),
              ),
            ],
          ),
          SizedBox(height: mediaQuery.size.height * 0.03),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  l10n.mileageArai,
                  "${state.mileageArai == 'null' ? '0' : state.mileageArai}km/L",
                  Icons.bolt_outlined,
                  isEditable: true,
                  onTap: () => _showUpdateMileageDialog(context, l10n),
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  context,
                  l10n.distanceTravelled,
                  "${state.distanceTravelled == 'null' ? '0' : state.distanceTravelled} ${l10n.km}",
                  Icons.route_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    bool isEditable = false,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: theme.primaryColor,
                size: mediaQuery.textScaler.scale(16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: mediaQuery.textScaler.scale(12),
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  color: theme.textTheme.titleLarge?.color,
                  fontSize: mediaQuery.textScaler.scale(22),
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isEditable) ...[
                const SizedBox(width: 6),
                Icon(
                  Icons.edit_outlined,
                  color: theme.hintColor,
                  size: mediaQuery.textScaler.scale(16),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: theme.colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.fuelEstimateNote,
                style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    l10n.gotIt,
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUpdateMileageDialog(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: theme.colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.updateMileageArai,
                style: TextStyle(
                  color: theme.textTheme.titleLarge?.color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.mileageDesc,
                style: TextStyle(color: theme.hintColor, fontSize: 13),
              ),
              const SizedBox(height: 16),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  fillColor: theme.inputDecorationTheme.fillColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.dividerColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.primaryColor, width: 1.5),
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.kmL,
                          style: TextStyle(color: theme.hintColor, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                ),
                style: TextStyle(color: theme.textTheme.bodyLarge?.color),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      l10n.cancel,
                      style: TextStyle(color: theme.hintColor, fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      l10n.save,
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
