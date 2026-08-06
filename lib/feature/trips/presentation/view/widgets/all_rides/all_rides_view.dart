import 'package:flutter/material.dart';
import 'package:trackify/app/cubit/app_cubit.dart';
import 'package:trackify/app/cubit/app_state.dart';
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
import 'package:intl/intl.dart';


import 'package:trackify/app/app_navigation.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';

class AllRides extends StatefulWidget {
  const AllRides({super.key});

  @override
  State<AllRides> createState() => _AllRidesState();
}

class _AllRidesState extends State<AllRides> {
  DateTime? _selectedDate;
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

    return BlocListener<AppCubit, AppState>(
      listenWhen: (previous, current) => previous.distanceUnit != current.distanceUnit,
      listener: (context, state) {
        context.read<RideHistoryCubit>().getRideHistoryData();
      },
      child: BlocBuilder<RideHistoryCubit, RideHistoryState>(
      builder: (context, state) {
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
            if (context.mounted) {
              await context.read<RideHistoryCubit>().getRideHistoryData();
            }
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: Theme.of(context).colorScheme.copyWith(
                                      primary: theme.primaryColor,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              setState(() {
                                _selectedDate = picked;
                              });
                            }
                          },
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                                width: 0.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 16),
                                Icon(
                                  _selectedDate != null ? Icons.calendar_today : Icons.calendar_today_outlined,
                                  color: _selectedDate != null ? theme.primaryColor : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    child: Text(
                                      _selectedDate != null ? DateFormat('dd MMM yyyy').format(_selectedDate!) : 'Select Date',
                                      style: TextStyle(
                                        color: _selectedDate != null ? theme.primaryColor : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                                        fontSize: 14,
                                        fontWeight: _selectedDate != null ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                                if (_selectedDate != null)
                                  IconButton(
                                    icon: const Icon(Icons.clear, size: 20),
                                    onPressed: () {
                                      setState(() {
                                        _selectedDate = null;
                                      });
                                    },
                                  ),
                              ],
                            ),
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
                            builder: (context) {
                              final cubit = context.read<RideHistoryCubit>();
                              return SortingBottomSheet(
                                initialSortBy: cubit.currentSortBy,
                                initialIsRecentToOldest: cubit.currentIsRecentToOldest,
                                onApply: (sortBy, isRecentToOldest) {
                                  cubit.sortRides(sortBy, isRecentToOldest);
                                },
                              );
                            },
                          );
                        },
                        child: Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                              width: 0.5,
                            ),
                          ),
                          child: Icon(Icons.sort, color: theme.colorScheme.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (state is RideHistoryLoading)
                const SliverFillRemaining(
                  child: Center(child: TrackifyLoader()),
                ),

              if (state is RideHistoryFailure)
                const SliverFillRemaining(
                  child: SizedBox(
                    height: 400,
                    child: AllRidesEmptyState(),
                  ),
                ),

              if (state is RideHistorySuccess)
                ...(() {
                  final reversedRides = state.rides.reversed.toList();
                  final filteredRides = reversedRides.where((ride) {
                    if (_selectedDate == null) return true;
                    
                    DateTime? parsedDate;
                    if (ride.rawStartTime.isNotEmpty) {
                      try {
                        parsedDate = DateTime.parse(ride.rawStartTime).toLocal();
                      } catch (_) {}
                    }
                    if (parsedDate == null && ride.date.isNotEmpty) {
                      try {
                        parsedDate = DateFormat('dd/MM/yyyy').parse(ride.date);
                      } catch (_) {
                        try {
                          parsedDate = DateTime.parse(ride.date);
                        } catch (_) {}
                      }
                    }
                    
                    if (parsedDate != null) {
                      return parsedDate.year == _selectedDate!.year &&
                             parsedDate.month == _selectedDate!.month &&
                             parsedDate.day == _selectedDate!.day;
                    }
                    
                    final dateStr1 = DateFormat('dd MMM yyyy').format(_selectedDate!);
                    final dateStr2 = DateFormat('dd/MM/yyyy').format(_selectedDate!);
                    return ride.date == dateStr1 || ride.date == dateStr2;
                  }).toList();

                  if (filteredRides.isEmpty) {
                    return [
                      const SliverFillRemaining(
                        child: SizedBox(
                          height: 400,
                          child: AllRidesEmptyState(),
                        ),
                      )
                    ];
                  }

                  return [
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
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
                          childCount: filteredRides.length,
                        ),
                      ),
                    )
                  ];
                })(),
            ],
          ),
        );
      },
    ),
    );
  }
}
