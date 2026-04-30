import 'package:flutter/material.dart';
import 'package:trackify/l10n/app_localizations.dart';
import '../../cubit/fuel_logs_state.dart';

class OdometerCard extends StatelessWidget {
  final FuelLogsLoaded state;
  final AppLocalizations l10n;

  const OdometerCard({super.key, required this.state, required this.l10n});

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
              Text(
                l10n.odometerReading,
                style: TextStyle(
                  color: theme.textTheme.titleMedium?.color,
                  fontSize: mediaQuery.textScaler.scale(15),
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: () => _showUpdateOdometerDialog(context, l10n),
                child: Text(
                  l10n.update,
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: mediaQuery.textScaler.scale(15),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: mediaQuery.size.height * 0.02),
          GestureDetector(
            onTap: () => _showUpdateOdometerDialog(context, l10n),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: state.odometerReading
                  .split('')
                  .map((d) => _buildDigitBox(context, d))
                  .toList(),
            ),
          ),
          SizedBox(height: mediaQuery.size.height * 0.015),
          Center(
            child: Text(
              l10n.gpsReadingNote,
              style: TextStyle(
                color: theme.hintColor,
                fontSize: mediaQuery.textScaler.scale(11),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: mediaQuery.size.height * 0.03),
          Divider(color: theme.dividerColor, height: 1),
          SizedBox(height: mediaQuery.size.height * 0.02),
          Row(
            children: [
              Icon(
                Icons.local_gas_station_outlined,
                color: theme.hintColor,
                size: mediaQuery.textScaler.scale(18),
              ),
              const SizedBox(width: 10),
              Text(
                l10n.tankCapacity,
                style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color,
                  fontSize: mediaQuery.textScaler.scale(14),
                ),
              ),
              const Spacer(),
              Text(
                "${state.tankCapacity} ${l10n.litersShort}",
                style: TextStyle(
                  color: theme.textTheme.bodyLarge?.color,
                  fontSize: mediaQuery.textScaler.scale(16),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => _showUpdateTankCapacityDialog(context, l10n),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.dividerColor),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    Icons.edit_outlined,
                    color: theme.hintColor,
                    size: mediaQuery.textScaler.scale(14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDigitBox(BuildContext context, String digit) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.008),
      width: screenWidth * 0.1,
      height: screenWidth * 0.13,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor, width: 1),
      ),
      child: Text(
        digit,
        style: TextStyle(
          color: theme.textTheme.titleLarge?.color,
          fontSize: mediaQuery.textScaler.scale(24),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showUpdateOdometerDialog(BuildContext context, AppLocalizations l10n) {
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
                l10n.currentOdometerReading,
                style: TextStyle(
                  color: theme.textTheme.titleLarge?.color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
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
                          l10n.kms,
                          style: TextStyle(color: theme.hintColor, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                ),
                style: TextStyle(color: theme.textTheme.bodyLarge?.color),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.odometerUpdateDesc,
                style: TextStyle(color: theme.hintColor, fontSize: 13),
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

  void _showUpdateTankCapacityDialog(BuildContext context, AppLocalizations l10n) {
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
              Row(
                children: [
                  Icon(Icons.local_gas_station, color: theme.iconTheme.color, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    l10n.updateTankCapacity,
                    style: TextStyle(
                      color: theme.textTheme.titleLarge?.color,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                l10n.tankCapacityDesc,
                style: TextStyle(color: theme.hintColor, fontSize: 13),
              ),
              const SizedBox(height: 16),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  fillColor: theme.inputDecorationTheme.fillColor,
                  hintText: l10n.hintEg("13"),
                  hintStyle: TextStyle(color: theme.hintColor),
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
                          l10n.litres,
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
