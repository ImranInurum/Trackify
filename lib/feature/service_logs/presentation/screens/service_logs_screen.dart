import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/service_logs_cubit.dart';
import '../cubit/service_logs_state.dart';
import '../widgets/vehicle_selection_app_bar.dart';
import '../widgets/service_log_empty_state.dart';
import '../widgets/service_log_card.dart';
import 'add_service_log_screen.dart';
import 'service_details_screen.dart';
import '../../../../l10n/app_localizations.dart';

class ServiceLogsScreen extends StatefulWidget {
  const ServiceLogsScreen({super.key});

  @override
  State<ServiceLogsScreen> createState() => _ServiceLogsScreenState();
}

class _ServiceLogsScreenState extends State<ServiceLogsScreen> {
  String _selectedFilter = 'All Time';
  late List<String> _filters;

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
    _filters = [l10n.today, l10n.thisWeek, l10n.thisMonth, l10n.thisYear, l10n.allTime];
    // if _selectedFilter is in english format from init, keep it but we might want to map it. 
    // Actually, it's better to store the enum/internal string for filtering, 
    // but since it's just 'All Time' initially, let's just initialize it to l10n.allTime if it's 'All Time'.
    if (_selectedFilter == 'All Time') {
      _selectedFilter = l10n.allTime;
    }

    if (state is ServiceLogsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ServiceLogsError) {
      return Center(child: Text(state.message));
    }

    if (state is ServiceLogsLoaded) {
      final now = DateTime.now();
      final filteredLogs = state.logs.where((log) {
        if (log.serviceDate == null) return false;
        final date = DateTime.tryParse(log.serviceDate!);
        if (date == null) return false;

        if (_selectedFilter == l10n.today) {
          return date.year == now.year && date.month == now.month && date.day == now.day;
        } else if (_selectedFilter == l10n.thisWeek) {
          final diff = now.difference(date).inDays;
          return diff <= 7 && diff >= 0;
        } else if (_selectedFilter == l10n.thisMonth) {
          return date.year == now.year && date.month == now.month;
        } else if (_selectedFilter == l10n.thisYear) {
          return date.year == now.year;
        }
        return true; // All Time
      }).toList();

      double totalSpendings = 0;
      for (var log in filteredLogs) {
        totalSpendings += (log.amount ?? 0);
      }
      int totalServices = filteredLogs.length;
      double avgSpending = totalServices > 0 ? totalSpendings / totalServices : 0;
      
      int avgIntervalMonths = 0;
      if (totalServices > 1) {
        final sortedLogs = List.from(filteredLogs);
        sortedLogs.sort((a, b) {
           final d1 = a.serviceDate != null ? DateTime.tryParse(a.serviceDate!) : null;
           final d2 = b.serviceDate != null ? DateTime.tryParse(b.serviceDate!) : null;
           if (d1 == null && d2 == null) return 0;
           if (d1 == null) return 1;
           if (d2 == null) return -1;
           return d1.compareTo(d2);
        });
        
        final firstDate = sortedLogs.first.serviceDate != null ? DateTime.tryParse(sortedLogs.first.serviceDate!) : null;
        final lastDate = sortedLogs.last.serviceDate != null ? DateTime.tryParse(sortedLogs.last.serviceDate!) : null;
        
        if (firstDate != null && lastDate != null && lastDate.isAfter(firstDate)) {
           final diffDays = lastDate.difference(firstDate).inDays;
           final diffMonths = diffDays / 30.0;
           avgIntervalMonths = (diffMonths / (totalServices - 1)).round();
        }
      }

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
            child: CustomScrollView(
              slivers: [
                // Filter Dropdown
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: PopupMenuButton<String>(
                        onSelected: (value) {
                          setState(() {
                            _selectedFilter = value;
                          });
                        },
                        itemBuilder: (context) {
                          return _filters.map((filter) {
                            return PopupMenuItem<String>(
                              value: filter,
                              child: Text(filter, style: theme.textTheme.bodyMedium),
                            );
                          }).toList();
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.calendar_today_outlined, size: 16, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                            const SizedBox(width: 8),
                            Text(_selectedFilter, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6), fontWeight: FontWeight.w500)),
                            const SizedBox(width: 4),
                            Icon(Icons.keyboard_arrow_down, size: 16, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Dashboard Grid
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.8,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    delegate: SliverChildListDelegate([
                      _buildStatCard(
                        icon: Icons.currency_rupee_rounded,
                        iconColor: Colors.green,
                        title: l10n.totalSpendings,
                        value: "₹ ${totalSpendings.toStringAsFixed(2)}",
                        theme: theme,
                      ),
                      _buildStatCard(
                        icon: Icons.water_drop_outlined,
                        iconColor: Colors.blueAccent,
                        title: l10n.totalServices,
                        value: "$totalServices",
                        theme: theme,
                      ),
                      _buildStatCard(
                        icon: Icons.bolt,
                        iconColor: Colors.redAccent,
                        title: l10n.avgSpending,
                        value: "₹ ${avgSpending.toStringAsFixed(2)}",
                        subtitle: l10n.perService,
                        theme: theme,
                      ),
                      _buildStatCard(
                        icon: Icons.local_gas_station_outlined,
                        iconColor: Colors.purpleAccent,
                        title: l10n.avgInterval,
                        value: "$avgIntervalMonths",
                        subtitle: l10n.months,
                        theme: theme,
                      ),
                    ]),
                  ),
                ),

                // Service Logs Heading
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                    child: Text(
                      l10n.serviceLogs,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ),
                ),

                // Logs List
                if (filteredLogs.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
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
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return ServiceLogCard(
                            log: filteredLogs[index],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ServiceDetailsScreen(log: filteredLogs[index]),
                                ),
                              );
                            },
                          );
                        },
                        childCount: filteredLogs.length,
                      ),
                    ),
                  ),
                  
                // Padding at bottom
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    String? subtitle,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }
}
