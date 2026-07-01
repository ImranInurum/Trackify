import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/l10n/app_localizations.dart';

import '../../cubit/fuel_logs_cubit.dart';
import '../../cubit/fuel_logs_state.dart';

import 'odometer_card.dart';
import 'last_refuel_card.dart';
import 'spending_card.dart';
import 'nearby_fuel_stations_list.dart';

import 'package:trackify/feature/service_logs/presentation/cubit/service_logs_cubit.dart';
import 'package:trackify/feature/service_logs/presentation/cubit/service_logs_state.dart';

class DashboardTabView extends StatelessWidget {
  const DashboardTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return BlocBuilder<FuelLogsCubit, FuelLogsState>(
      builder: (context, state) {
        if (state is FuelLogsInitial) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final serviceState = context.read<ServiceLogsCubit>().state;

            if (serviceState is ServiceLogsLoaded) {
              final imei = serviceState.selectedVehicle?.imei ?? '';

              context.read<FuelLogsCubit>().loadFuelLogs(imei);
            }
          });
        }

        if (state is FuelLogsLoaded) {
          return Container(
            color: theme.scaffoldBackgroundColor,
            child: ListView(
              padding: EdgeInsets.all(screenWidth * 0.04),
              children: [
                OdometerCard(state: state, l10n: l10n),
                SizedBox(height: screenHeight * 0.02),
                LastRefuelCard(state: state, l10n: l10n),
                SizedBox(height: screenHeight * 0.02),
                SpendingCard(state: state, l10n: l10n),
                SizedBox(height: screenHeight * 0.02),
                const NearbyFuelStationsDashboard(),
                SizedBox(height: screenHeight * 0.1), // Space for FAB
              ],
            ),
          );
        }
        
        if (state is FuelLogsLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFE5B14B)),
          );
        }

        if (state is FuelLogsError) {
          return Center(
            child: Text(
              l10n.noDataAvailable,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                fontSize: 16,
              ),
            ),
          );
        }
        
        return const SizedBox.shrink();
      },
    );
  }
}
