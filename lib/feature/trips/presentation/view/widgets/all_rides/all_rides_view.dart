import 'package:flutter/material.dart';
import 'package:trackify/feature/trips/presentation/view/widgets/all_rides/widgets/all_rides_empty_state.dart';
import 'package:trackify/feature/trips/presentation/view/widgets/all_rides/widgets/ride_card.dart';
import 'package:trackify/l10n/app_localizations.dart';
import '../../../cubit/ride_history_cubit.dart';
import '../../../cubit/ride_history_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:trackify/core/services/connectivity_service.dart';

import 'package:trackify/feature/trips/presentation/view/ride_history_details/ride_history_details_screen.dart';

import 'package:trackify/feature/trips/presentation/view/widgets/sorting_bottom_sheet.dart';
import '../../trip_search_screen.dart';


import 'package:trackify/app/app_navigation.dart';
import 'package:trackify/core/utils/shared_preferences.dart';

class AllRides extends StatefulWidget {
  const AllRides({super.key});

  @override
  State<AllRides> createState() => _AllRidesState();
}

class _AllRidesState extends State<AllRides> {
  String _searchQuery = '';
  String? _loadedImei;

  @override
  void initState() {
    super.initState();
    _loadedImei = AppPreference.instance.getSync(key: AppPreference.IMEI);
    context.read<RideHistoryCubit>().getRideHistoryData();
    AppNavigation.currentTabNotifier.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    AppNavigation.currentTabNotifier.removeListener(_onTabChanged);
    super.dispose();
  }

  void _onTabChanged() {
    if (AppNavigation.currentTabNotifier.value == 1) {
      final currentImei = AppPreference.instance.getSync(key: AppPreference.IMEI);
      if (currentImei != _loadedImei) {
        _loadedImei = currentImei;
        if (mounted) {
          context.read<RideHistoryCubit>().getRideHistoryData();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;


    return Column(
      children: [
        /// SEARCH BAR & FILTER
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.onSurface.withOpacity(0.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Icon(
                        Icons.search,
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TripSearchScreen(isTripSearch: false),
                              ),
                            );
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Text(
                              l10n.searchRides,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.4),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => SortingBottomSheet(
                      initialSortBy: 'Date',
                      initialIsRecentToOldest: true,
                      onApply: (sortBy, isRecentToOldest) {
                        context.read<RideHistoryCubit>().sortRides(
                          sortBy,
                          isRecentToOldest,
                        );
                      },
                    ),
                  );
                },
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.5),
                    ),
                  ),
                  child: Icon(Icons.sort, color: theme.colorScheme.primary),
                ),
              ),
            ],
          ),
        ),

        /// ALL RIDES LIST
        Expanded(
          child: BlocBuilder<RideHistoryCubit, RideHistoryState>(
            builder: (context, state) {
              if (state is RideHistoryLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is RideHistorySuccess) {
                final reversedRides = state.rides.reversed.toList();
                final filteredRides = reversedRides.where((ride) {
                  final startLoc = ride.startLocation.toLowerCase();
                  final endLoc = ride.endLocation.toLowerCase();
                  return startLoc.contains(_searchQuery) ||
                      endLoc.contains(_searchQuery);
                }).toList();

                return RefreshIndicator(
                  onRefresh: () async {
                    final isConnected = await ConnectivityService().checkConnectivity();
                    if (isConnected) {
                      try {
                        final box = Hive.box('map_cache');
                        await box.clear();
                      } catch (e) {
                        debugPrint('Error clearing map cache: $e');
                      }
                    }
                    await context.read<RideHistoryCubit>().getRideHistoryData();
                  },
                  child: filteredRides.isEmpty
                      ? const SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: 400,
                            child: AllRidesEmptyState(),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredRides.length,
                          itemBuilder: (context, index) {
                            final ride = filteredRides[index];
                            return RideCard(
                              ride: ride,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RideHistoryDetailsScreen(ride: ride),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                );
              }

              if (state is RideHistoryFailure) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await context.read<RideHistoryCubit>().getRideHistoryData();
                  },
                  child: const SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: 400,
                      child: AllRidesEmptyState(),
                    ),
                  ),
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}
