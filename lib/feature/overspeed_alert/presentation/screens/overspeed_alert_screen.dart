import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/l10n/app_localizations.dart';
import 'package:trackify/feature/overspeed_alert/presentation/widgets/overspeed_card.dart';
import 'package:trackify/feature/overspeed_alert/presentation/screens/add_overspeed_alert_screen.dart';
import '../cubit/overspeed_alert_cubit.dart';
import '../cubit/overspeed_alert_state.dart';

class OverSpeedAlertScreen extends StatefulWidget {
  const OverSpeedAlertScreen({Key? key}) : super(key: key);

  @override
  State<OverSpeedAlertScreen> createState() => _OverSpeedAlertScreenState();
}

class _OverSpeedAlertScreenState extends State<OverSpeedAlertScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OverspeedAlertCubit>().fetchInitialData();
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
        title: Text(
          l10n.overspeedAlert,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: theme.colorScheme.onSurface),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<OverspeedAlertCubit, OverspeedAlertState>(
        builder: (context, state) {
          if (state is OverspeedAlertLoading || state is OverspeedAlertInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is OverspeedAlertError) {
            return Center(child: Text(state.message));
          }

          if (state is OverspeedAlertLoaded) {
            if (state.alerts.isEmpty) {
              return Center(
                child: Text(
                  "No alerts created yet.",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                await context.read<OverspeedAlertCubit>().fetchInitialData();
              },
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 20, bottom: 80),
                itemCount: state.alerts.length,
                itemBuilder: (context, index) {
                  final item = state.alerts[index];
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
                    child: OverspeedCard(overspeedAlert: item),
                  );
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddOverspeedAlertScreen(),
            ),
          );
        },
        child: Icon(Icons.add_rounded, size: 30, color: theme.colorScheme.onPrimary),
      ),
    );
  }
}
