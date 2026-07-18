import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/l10n/app_localizations.dart';
import 'package:trackify/feature/overspeed_alert/presentation/widgets/overspeed_card.dart';
import 'package:trackify/feature/overspeed_alert/presentation/screens/add_overspeed_alert_screen.dart';
import '../cubit/overspeed_alert_cubit.dart';
import '../cubit/overspeed_alert_state.dart';
import 'package:trackify/core/common/models/vehicle_list_model.dart';
import 'package:trackify/feature/overspeed_alert/data/model/overspeed_alert_model.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';


class OverSpeedAlertScreen extends StatefulWidget {
  final Vehicle? vehicle;
  const OverSpeedAlertScreen({Key? key, this.vehicle}) : super(key: key);

  @override
  State<OverSpeedAlertScreen> createState() => _OverSpeedAlertScreenState();
}

class _OverSpeedAlertScreenState extends State<OverSpeedAlertScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OverspeedAlertCubit>().fetchInitialData(targetVehicle: widget.vehicle);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(l10n.overspeedAlert),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: theme.colorScheme.onSurface,
          ),
        ),
        centerTitle: false,
      ),
      body: BlocBuilder<OverspeedAlertCubit, OverspeedAlertState>(
        builder: (context, state) {
          if (state is OverspeedAlertInitial) {
            return const Center(child: TrackifyLoader());
          }

          if (state is OverspeedAlertError) {
            return Center(child: Text(state.message));
          }

          if (state is OverspeedAlertLoaded || state is OverspeedAlertLoading) {
            final isLoaded = state is OverspeedAlertLoaded;
            final selectedVehicle = isLoaded ? (state as OverspeedAlertLoaded).selectedVehicle : widget.vehicle;
            final alerts = isLoaded ? (state as OverspeedAlertLoaded).alerts : <OverspeedAlertModel>[];

            return Column(
              children: [
                if (state is OverspeedAlertLoading)
                  const Expanded(child: const Center(child: TrackifyLoader()))
                else if (alerts.isEmpty)
                  Expanded(
                    child: Center(
                      child: Text(
                        l10n.noAlertsCreated,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        if (selectedVehicle != null) {
                          await context.read<OverspeedAlertCubit>().selectVehicle(selectedVehicle);
                        } else {
                          await context.read<OverspeedAlertCubit>().fetchInitialData();
                        }
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 10, bottom: 80),
                        itemCount: alerts.length,
                        itemBuilder: (context, index) {
                          final item = alerts[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddOverspeedAlertScreen(
                                    alertToEdit: item,
                                  ),
                                ),
                              );
                            },
                            child: OverspeedCard(
                              overspeedAlert: item,
                              vehicle: selectedVehicle,
                              onDelete: () {
                                if (item.id != null) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: theme.cardColor,
                                        title: Text(
                                          l10n.deleteAlertTitle,
                                          style: theme.textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        content: Text(
                                          l10n.deleteAlertDesc,
                                          style: theme.textTheme.bodyMedium,
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: Text(
                                              l10n.cancel,
                                              style: theme.textTheme.bodyMedium?.copyWith(
                                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                                              ),
                                            ),
                                        ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.redAccent,
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              context.read<OverspeedAlertCubit>().deleteOverspeedAlert(item.id!);
                                            },
                                            child: Text(l10n.delete, style: const TextStyle(color: Colors.white)),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: theme.colorScheme.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddOverspeedAlertScreen(),
            ),
          );
        },
        child: Icon(
          Icons.add_rounded,
          size: 30,
          color: theme.colorScheme.onPrimary,
        ),
      ),
    );
  }
}
