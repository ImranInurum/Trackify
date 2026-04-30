import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/feature/fuel_logs/presentation/pages/widgets/refuel_history_tab_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../service_logs/presentation/cubit/service_logs_cubit.dart';
import '../../../service_logs/presentation/cubit/service_logs_state.dart';
import '../../../service_logs/presentation/widgets/vehicle_selection_app_bar.dart';
import '../cubit/fuel_logs_cubit.dart';
import '../cubit/fuel_stations_cubit.dart';
import '../../data/repository/overpass_service.dart';
import 'widgets/dashboard_tab_view.dart';
import 'widgets/fuel_stations_tab_view.dart';
import '../../../add_fuel/add_fuel_screen.dart';

class FuelLogsScreen extends StatefulWidget {
  const FuelLogsScreen({super.key});

  @override
  State<FuelLogsScreen> createState() => _FuelLogsScreenState();
}

class _FuelLogsScreenState extends State<FuelLogsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isFabExtended = true;
  late final Timer _fabTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<ServiceLogsCubit>().loadVehicles();

    // Periodic expansion: every 10 seconds
    _fabTimer = Timer.periodic(const Duration(seconds: 17), (timer) {
      if (mounted) {
        setState(() {
          _isFabExtended = true;
        });
        // Collapse after 3 seconds of being shown
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _isFabExtended = false;
            });
          }
        });
      }
    });

    // Initial collapse after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isFabExtended = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fabTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FuelLogsCubit()..loadFuelLogs()),
        BlocProvider(
          create: (context) =>
              FuelStationsCubit(OverpassService())..fetchNearbyStations(),
        ),
      ],
      child: BlocConsumer<ServiceLogsCubit, ServiceLogsState>(
        listener: (context, state) {
          if (state is ServiceLogsSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.serviceLogAddedSuccess)),
            );
          }
          if (state is ServiceLogsError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is! ServiceLogsLoaded && state is! ServiceLogsSubmitting) {
            return Scaffold(
              backgroundColor: theme.scaffoldBackgroundColor,
              body: Center(
                child: CircularProgressIndicator(color: theme.primaryColor),
              ),
            );
          }

          final currentState = state is ServiceLogsLoaded
              ? state
              : (context.read<ServiceLogsCubit>().state as ServiceLogsLoaded);

          return Scaffold(
            body: Column(
              children: [
                VehicleSelectionAppBar(
                  title: l10n.fuelLogs,
                  selectedVehicle: currentState.selectedVehicle,
                  vehicles: currentState.vehicles,
                  onBack: () => Navigator.pop(context),
                  onVehicleSelected: (vehicle) {
                    context.read<ServiceLogsCubit>().selectVehicle(vehicle.id!);
                    context.read<FuelLogsCubit>().loadFuelLogs();
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.01,
                  ),
                  child: Container(
                    height: screenHeight * 0.065,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      indicator: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelColor: theme.primaryColor,
                      unselectedLabelColor: theme.hintColor,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: mediaQuery.textScaler.scale(14),
                      ),
                      unselectedLabelStyle: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: mediaQuery.textScaler.scale(14),
                      ),
                      tabs: [
                        Tab(text: l10n.dashboard),
                        Tab(text: l10n.refuelHistory),
                        Tab(text: l10n.fuelStations),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      DashboardTabView(),
                      RefuelHistoryTabView(),
                      FuelStationsTabView(),
                    ],
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddFuelScreen()),
                );
              },
              tooltip: l10n.addRefuelingDetails,
              backgroundColor: theme.primaryColor,
              elevation: 4,
              // We use a custom label to put the icon on the right
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SizeTransition(
                              sizeFactor: animation,
                              axis: Axis.horizontal,
                              axisAlignment: -1,
                              child: child,
                            ),
                          );
                        },
                    child: _isFabExtended
                        ? Padding(
                            key: const ValueKey('extended_text'),
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              l10n.addRefuelingDetails,
                              style: TextStyle(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: mediaQuery.textScaler.scale(14),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(key: ValueKey('shrunk_text')),
                  ),
                  Icon(
                    Icons.add,
                    color: theme.colorScheme.onPrimary,
                    size: mediaQuery.textScaler.scale(24),
                  ),
                ],
              ),
              // We leave icon null to use our custom label layout
              icon: null,
              extendedPadding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
          );
        },
      ),
    );
  }
}
