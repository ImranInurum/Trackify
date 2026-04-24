import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/service_logs_cubit.dart';
import '../cubit/service_logs_state.dart';
import '../widgets/vehicle_selection_app_bar.dart';
import '../widgets/service_log_empty_state.dart';
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

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocBuilder<ServiceLogsCubit, ServiceLogsState>(
        builder: (context, state) {
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
                  child: ServiceLogEmptyState(
                    onAddPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddServiceLogScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
