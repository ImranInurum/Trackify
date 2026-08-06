import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/l10n/app_localizations.dart';

import 'package:intl/intl.dart';

import '../../cubit/fuel_logs_cubit.dart';
import '../../cubit/fuel_logs_state.dart';
import 'package:trackify/core/utils/distance_utils.dart';

class LastRefuelCard extends StatelessWidget {
  final FuelLogsLoaded state;
  final AppLocalizations l10n;

  const LastRefuelCard({super.key, required this.state, required this.l10n});

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty || dateStr == 'null') return '--';
    try {
      final parsedDate = DateTime.parse(dateStr);
      return DateFormat('d MMM yyyy').format(parsedDate);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 0.5,
        ),
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
                        fontSize: mediaQuery.textScaler.scale(13),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${_formatDate(state.lastRefuelDate)} | ₹${(state.lastRefuelAmount.isEmpty || state.lastRefuelAmount == 'null') ? '0' : state.lastRefuelAmount} | ${(state.lastRefuelLiters.isEmpty || state.lastRefuelLiters == 'null') ? '0' : state.lastRefuelLiters} ${l10n.litersShort}",
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: mediaQuery.textScaler.scale(10),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // TODO: Implement reset API call here
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Reset functionality coming soon!')),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.025,
                        vertical: screenWidth * 0.015,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.redAccent.withValues(alpha: 0.3),
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.restart_alt_rounded,
                            size: mediaQuery.textScaler.scale(12),
                            color: Colors.redAccent,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            l10n.resetBtn,
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: mediaQuery.textScaler.scale(10),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  GestureDetector(
                    onTap: () => _showInfoDialog(context, l10n),
                    child: Icon(
                      Icons.info_outline,
                      size: mediaQuery.textScaler.scale(18),
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
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
          const SizedBox(height: 16),
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
                  "${state.distanceTravelled == 'null' ? '0' : state.distanceTravelled} ${context.displayKm}",
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
                size: mediaQuery.textScaler.scale(14),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: mediaQuery.textScaler.scale(10),
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  color: theme.textTheme.titleLarge?.color,
                  fontSize: mediaQuery.textScaler.scale(20),
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isEditable) ...[
                const SizedBox(width: 6),
                Icon(
                  Icons.edit_outlined,
                  color: theme.colorScheme.onSurface,
                  size: mediaQuery.textScaler.scale(14),
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
                  fontSize: 13,
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
                      fontSize: 14,
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
    final initialMileage = state.mileageArai == 'null' ? '' : state.mileageArai;
    final TextEditingController controller = TextEditingController(
      text: initialMileage,
    );

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
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
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.mileageDesc,
                style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 11),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  fillColor: theme.inputDecorationTheme.fillColor,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.dividerColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: theme.primaryColor,
                      width: 1.5,
                    ),
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          context.displayKmL,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 0,
                    minHeight: 0,
                  ),
                ),
                style: TextStyle(color: theme.textTheme.bodyLarge?.color),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(
                      l10n.cancel,
                      style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 14),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () async {
                      final mileageText = controller.text.trim();
                      if (mileageText.isNotEmpty) {
                        final error = await context
                            .read<FuelLogsCubit>()
                            .updateMileage(mileageText);
                        if (error != null && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(error),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      }
                      if (context.mounted) {
                        Navigator.pop(ctx);
                      }
                    },
                    child: Text(
                      l10n.save,
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontSize: 14,
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
