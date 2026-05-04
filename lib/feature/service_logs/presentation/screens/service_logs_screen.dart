import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/service_logs_cubit.dart';
import '../cubit/service_logs_state.dart';
import '../widgets/vehicle_selection_app_bar.dart';
import '../widgets/service_log_empty_state.dart';
import '../widgets/service_log_card.dart';
import 'add_service_log_screen.dart';
import '../../../../l10n/app_localizations.dart';

class ServiceLogsScreen extends StatefulWidget {
  const ServiceLogsScreen({super.key});

  @override
  State<ServiceLogsScreen> createState() => _ServiceLogsScreenState();
}

class _ServiceLogsScreenState extends State<ServiceLogsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ServiceLogsCubit>().loadVehicles();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<ServiceLogsCubit, ServiceLogsState>(
      builder: (context, state) {
        bool showFab = false;
        if (state is ServiceLogsLoaded && state.logs.isNotEmpty) {
          showFab = true;
        }

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          floatingActionButton: showFab
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddServiceLogScreen(),
                      ),
                    );
                  },
                  shape: const CircleBorder(),
                  backgroundColor: theme.colorScheme.primary,
                  child: const Icon(Icons.add, color: Colors.white),
                )
              : null,
          body: _buildBody(context, state, l10n, theme),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    ServiceLogsState state,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    if (state is ServiceLogsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ServiceLogsError) {
      return Center(child: Text(state.message));
    }

    if (state is ServiceLogsLoaded) {
      return Column(
        children: [
          VehicleSelectionAppBar(
            title: l10n.serviceLogs,
            selectedVehicle: state.selectedVehicle,
            vehicles: state.vehicles,
            onBack: () => Navigator.pop(context),
            onVehicleSelected: (vehicle) {
              context.read<ServiceLogsCubit>().selectVehicle(vehicle.id!);
            },
          ),
          Expanded(
            child: state.logs.isEmpty
                ? ServiceLogEmptyState(
                    onAddPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddServiceLogScreen(),
                        ),
                      );
                    },
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    children: state.logs
                        .map((log) => ServiceLogCard(log: log))
                        .toList(),
                  ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
