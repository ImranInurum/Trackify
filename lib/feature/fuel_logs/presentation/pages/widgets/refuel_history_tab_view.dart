import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/l10n/app_localizations.dart';

import '../../cubit/fuel_logs_cubit.dart';
import '../../cubit/fuel_logs_state.dart';
import '../../cubit/refuel_history_cubit.dart';
import '../../cubit/refuel_history_state.dart';

import 'refuel_history/refuel_log_list_item.dart';
import 'refuel_history/refuel_summary_grid.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';
import 'package:trackify/feature/add_fuel/presentation/pages/add_fuel_screen.dart' as trackify_add_fuel;

class RefuelHistoryTabView extends StatefulWidget {
  final String vehicleId;

  const RefuelHistoryTabView({super.key, required this.vehicleId});

  @override
  State<RefuelHistoryTabView> createState() => _RefuelHistoryTabViewState();
}

class _RefuelHistoryTabViewState extends State<RefuelHistoryTabView> {
  String _selectedSort = 'newestFirst';

  String _selectedTimeFilter = 'thisYear';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RefuelHistoryCubit>().loadRefuelHistory(widget.vehicleId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final mediaQuery = MediaQuery.of(context);

    final screenWidth = mediaQuery.size.width;

    final screenHeight = mediaQuery.size.height;

    return BlocBuilder<RefuelHistoryCubit, RefuelHistoryState>(
      builder: (context, refuelState) {
        if (refuelState is RefuelHistoryLoading) {
          return const Center(child: TrackifyLoader());
        }

        if (refuelState is RefuelHistoryLoaded) {
          final fuelState = context.watch<FuelLogsCubit>().state;
          final totalFuelAdded = fuelState is FuelLogsLoaded
              ? fuelState.totalFuelAdded
              : "0";
          final totalSpendings = fuelState is FuelLogsLoaded
              ? fuelState.totalSpendings
              : "0";
          final averageMileage = fuelState is FuelLogsLoaded
              ? fuelState.averageMileage
              : "0";
          // Use actual list length so the count is always in sync with visible history
          final refuelCount = refuelState.refuelLogs.length.toString();

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<RefuelHistoryCubit>().loadRefuelHistory(widget.vehicleId);
              context.read<FuelLogsCubit>().loadFuelLogs(widget.vehicleId);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.01,
              ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                _buildTimeFilter(context, l10n),

                SizedBox(height: screenHeight * 0.015),

                RefuelSummaryGrid(
                  totalFuel: totalFuelAdded,

                  totalSpendings: totalSpendings,

                  avgMileage: averageMileage,

                  refuelCount: refuelCount,
                ),

                SizedBox(height: screenHeight * 0.02),

                _buildHistoryHeader(context, l10n),

                SizedBox(height: screenHeight * 0.005),

                _buildRefuelLogs(
                  context,

                  l10n,

                  _applyFilters(refuelState.refuelLogs),
                  
                  refuelState.refuelLogs.isNotEmpty 
                      ? refuelState.refuelLogs.reduce((a, b) => a.dateTime.isAfter(b.dateTime) ? a : b).id 
                      : null,
                ),

                SizedBox(height: screenHeight * 0.1),
              ],
            ),
          ));
        }

        if (refuelState is RefuelHistoryError) {
          return Center(child: Text(refuelState.message));
        }

        return const SizedBox();
      },
    );
  }

  // =========================================================
  // FILTERS
  // =========================================================

  List<RefuelLog> _applyFilters(List<RefuelLog> logs) {
    final now = DateTime.now();

    List<RefuelLog> filtered = logs.where((log) {
      switch (_selectedTimeFilter) {
        case 'today':
          return log.dateTime.year == now.year &&
              log.dateTime.month == now.month &&
              log.dateTime.day == now.day;

        case 'thisMonth':
          return log.dateTime.year == now.year &&
              log.dateTime.month == now.month;

        case 'thisYear':
          return log.dateTime.year == now.year;

        case 'all':
          return true;

        default:
          return log.dateTime.year == now.year;
      }
    }).toList();

    switch (_selectedSort) {
      case 'newestFirst':
        filtered.sort((a, b) => b.dateTime.compareTo(a.dateTime));

        break;

      case 'oldestFirst':
        filtered.sort((a, b) => a.dateTime.compareTo(b.dateTime));

        break;

      case 'mostExpensive':
        filtered.sort(
          (a, b) => (double.tryParse(b.amount) ?? 0).compareTo(
            double.tryParse(a.amount) ?? 0,
          ),
        );

        break;

      case 'leastExpensive':
        filtered.sort(
          (a, b) => (double.tryParse(a.amount) ?? 0).compareTo(
            double.tryParse(b.amount) ?? 0,
          ),
        );

        break;

      case 'bestMileage':
        filtered.sort(
          (a, b) => (double.tryParse(b.mileage ?? '0') ?? 0).compareTo(
            double.tryParse(a.mileage ?? '0') ?? 0,
          ),
        );

        break;

      case 'worstMileage':
        filtered.sort(
          (a, b) => (double.tryParse(a.mileage ?? '0') ?? 0).compareTo(
            double.tryParse(b.mileage ?? '0') ?? 0,
          ),
        );

        break;
    }

    return filtered;
  }

  // =========================================================
  // TIME FILTER
  // =========================================================

  Widget _buildTimeFilter(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);

    final mediaQuery = MediaQuery.of(context);

    return PopupMenuButton<String>(
      initialValue: _selectedTimeFilter,

      onSelected: (value) {
        setState(() {
          _selectedTimeFilter = value;
        });
      },

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Icon(
            Icons.calendar_today_outlined,

            size: mediaQuery.textScaler.scale(16),

            color: theme.colorScheme.onSurface,
          ),

          const SizedBox(width: 8),

          Text(
            _getTimeFilterLabel(l10n, _selectedTimeFilter),

            style: TextStyle(
              color: theme.colorScheme.onSurface,

              fontSize: mediaQuery.textScaler.scale(12),

              fontWeight: FontWeight.w500,
            ),
          ),

          Icon(Icons.keyboard_arrow_down, color: theme.colorScheme.onSurface),
        ],
      ),

      itemBuilder: (context) => [
        PopupMenuItem(value: 'today', child: Text(l10n.today)),

        PopupMenuItem(value: 'thisMonth', child: Text(l10n.thisMonth)),

        PopupMenuItem(value: 'thisYear', child: Text(l10n.thisYear)),

        PopupMenuItem(value: 'all', child: Text(l10n.all)),

        PopupMenuItem(value: 'customDates', child: Text(l10n.customDates)),
      ],
    );
  }

  String _getTimeFilterLabel(AppLocalizations l10n, String filterKey) {
    switch (filterKey) {
      case 'today':
        return l10n.today;

      case 'thisMonth':
        return l10n.thisMonth;

      case 'thisYear':
        return l10n.thisYear;

      case 'all':
        return l10n.all;

      case 'customDates':
        return l10n.customDates;

      default:
        return l10n.thisYear;
    }
  }

  // =========================================================
  // HEADER
  // =========================================================

  Widget _buildHistoryHeader(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Row(
          children: [
            Text(
              l10n.refuelingHistory,

              style: TextStyle(
                color: theme.colorScheme.onSurface,

                fontSize: 14,

                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(width: 8),

            GestureDetector(
              onTap: () {
                final refuelState = context.read<RefuelHistoryCubit>().state;
                if (refuelState is RefuelHistoryLoaded) {
                  _showExcelView(context, l10n, _applyFilters(refuelState.refuelLogs));
                }
              },
              child: Icon(
                Icons.file_download_outlined,

                size: 20,

                color: theme.primaryColor,
              ),
            ),
          ],
        ),

        PopupMenuButton<String>(
          initialValue: _selectedSort,

          onSelected: (value) {
            setState(() {
              _selectedSort = value;
            });
          },

          child: Row(
            children: [
              Icon(Icons.sort, size: 18, color: theme.colorScheme.onSurface),

              const SizedBox(width: 4),

              Text(
                _getSortLabel(l10n, _selectedSort),

                style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 12),
              ),

              Icon(Icons.keyboard_arrow_down, color: theme.colorScheme.onSurface),
            ],
          ),

          itemBuilder: (context) => [
            PopupMenuItem(value: 'newestFirst', child: Text(l10n.newestFirst)),

            PopupMenuItem(value: 'oldestFirst', child: Text(l10n.oldestFirst)),

            PopupMenuItem(
              value: 'mostExpensive',

              child: Text(l10n.mostExpensive),
            ),

            PopupMenuItem(
              value: 'leastExpensive',

              child: Text(l10n.leastExpensive),
            ),

            PopupMenuItem(value: 'bestMileage', child: Text(l10n.bestMileage)),

            PopupMenuItem(
              value: 'worstMileage',

              child: Text(l10n.worstMileage),
            ),
          ],
        ),
      ],
    );
  }

  String _getSortLabel(AppLocalizations l10n, String sortKey) {
    switch (sortKey) {
      case 'newestFirst':
        return l10n.newestFirst;

      case 'oldestFirst':
        return l10n.oldestFirst;

      case 'mostExpensive':
        return l10n.mostExpensive;

      case 'leastExpensive':
        return l10n.leastExpensive;

      case 'bestMileage':
        return l10n.bestMileage;

      case 'worstMileage':
        return l10n.worstMileage;

      default:
        return l10n.newestFirst;
    }
  }

  // =========================================================
  // REFUEL LOG LIST
  // =========================================================

  Widget _buildRefuelLogs(
    BuildContext context,

    AppLocalizations l10n,

    List<RefuelLog> logs,
    
    String? mostRecentLogId,
  ) {
    if (logs.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),

          child: Text(l10n.noDataAvailable),
        ),
      );
    }

    return Column(
      children: logs.asMap().entries.map((entry) {
        final index = entry.key;

        final log = entry.value;

        final dateStr =
            "${log.dateTime.day} "
            "${_getMonth(log.dateTime.month)} "
            "${log.dateTime.year}";

        final timeStr =
            "${log.dateTime.hour % 12 == 0 ? 12 : log.dateTime.hour % 12}:"
            "${log.dateTime.minute.toString().padLeft(2, '0')} "
            "${log.dateTime.hour >= 12 ? 'PM' : 'AM'}";

        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: RefuelLogListItem(
            date: dateStr,
            time: timeStr,
            odometer: double.tryParse(log.odometer)?.toInt().toString() ?? log.odometer,
            location: log.location,
            amount: log.amount,
            rate: log.rate,
            distance: log.distanceSinceLast,
            liters: log.liters,
            mileage: log.mileage,
            showDetails: index == 0,
            isRecent: log.id == mostRecentLogId,
            onEdit: () async {
              final fuelLogsCubit = context.read<FuelLogsCubit>();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: fuelLogsCubit,
                    child: trackify_add_fuel.AddFuelScreen(
                      isEditMode: true,
                      initialLog: log,
                    ),
                  ),
                ),
              );
              
              if (context.mounted) {
                context.read<FuelLogsCubit>().reloadFuelLogs();
                context.read<RefuelHistoryCubit>().loadRefuelHistory(widget.vehicleId);
              }
            },
            onDelete: () {
              _confirmDelete(context, l10n, log.id);
            },
          ),
        );
      }).toList(),
    );
  }

  String _getMonth(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return months[month - 1];
  }

  void _confirmDelete(
    BuildContext context,
    AppLocalizations l10n,
    String refuelId,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(l10n.areYouSureDeleteRefuelLog),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<RefuelHistoryCubit>().deleteRefuelLog(refuelId).then(
                (_) {
                  context.read<FuelLogsCubit>().reloadFuelLogs();
                },
              );
            },
            child: Text(l10n.delete, ),
          ),
        ],
      ),
    );
  }

  void _showExcelView(BuildContext context, AppLocalizations l10n, List<RefuelLog> logs) {
    bool isDownloading = false;
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              insetPadding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.refuelingHistory,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Flexible(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        child: DataTable(
                          headingRowColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColor.withOpacity(0.1),
                          ),
                          columns: [
                            DataColumn(label: Text(l10n.dateHeader)),
                            DataColumn(label: Text(l10n.timeHeader)),
                            DataColumn(label: Text(l10n.odometerHeader)),
                            DataColumn(label: Text(l10n.locationHeader)),
                            DataColumn(label: Text(l10n.amountHeader)),
                            DataColumn(label: Text(l10n.rateHeader)),
                            DataColumn(label: Text(l10n.litersHeader)),
                            DataColumn(label: Text(l10n.mileageHeader)),
                          ],
                          rows: logs.map((log) {
                            final dateStr =
                                "${log.dateTime.day} ${_getMonth(log.dateTime.month)} ${log.dateTime.year}";
                            final timeStr =
                                "${log.dateTime.hour % 12 == 0 ? 12 : log.dateTime.hour % 12}:${log.dateTime.minute.toString().padLeft(2, '0')} ${log.dateTime.hour >= 12 ? 'PM' : 'AM'}";
                            return DataRow(cells: [
                              DataCell(Text(dateStr)),
                              DataCell(Text(timeStr)),
                              DataCell(Text(double.tryParse(log.odometer)?.toInt().toString() ?? log.odometer)),
                              DataCell(Text(log.location)),
                              DataCell(Text(log.amount)),
                              DataCell(Text(log.rate)),
                              DataCell(Text(log.liters ?? '-')),
                              DataCell(Text(log.mileage ?? '-')),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: isDownloading
                            ? null
                            : () async {
                                setState(() => isDownloading = true);
                                await _downloadCsv(context, logs);
                                if (ctx.mounted) {
                                  setState(() => isDownloading = false);
                                }
                              },
                        icon: isDownloading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.download),
                        label: Text(isDownloading ? l10n.downloadingStatus : l10n.downloadCsvButton),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _downloadCsv(BuildContext context, List<RefuelLog> logs) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      StringBuffer sb = StringBuffer();
      sb.writeln('Date,Time,Odometer,Location,Amount,Rate,Liters,Mileage');

      String escape(String? val) {
        if (val == null) return '';
        if (val.contains(',')) return '"$val"';
        return val;
      }

      for (var log in logs) {
        final dateStr =
            "${log.dateTime.day} ${_getMonth(log.dateTime.month)} ${log.dateTime.year}";
        final timeStr =
            "${log.dateTime.hour % 12 == 0 ? 12 : log.dateTime.hour % 12}:${log.dateTime.minute.toString().padLeft(2, '0')} ${log.dateTime.hour >= 12 ? 'PM' : 'AM'}";
        sb.writeln(
            '${escape(dateStr)},${escape(timeStr)},${escape(double.tryParse(log.odometer)?.toInt().toString() ?? log.odometer)},${escape(log.location)},${escape(log.amount)},${escape(log.rate)},${escape(log.liters)},${escape(log.mileage)}');
      }

      final Uint8List bytes = Uint8List.fromList(utf8.encode(sb.toString()));

      String? outputFile = await FilePicker.saveFile(
        dialogTitle: 'Save Refuel History',
        fileName: 'refuel_history.csv',
        type: FileType.custom,
        allowedExtensions: ['csv'],
        bytes: bytes,
      );

      if (outputFile != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.fileDownloadSuccess)),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorDownloadingFile(e.toString()))),
        );
      }
    }
  }
}
