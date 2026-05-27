import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:trackify/core/common/models/vehicle_list_model.dart';
import 'package:trackify/core/constants/app_images.dart';
import 'package:trackify/l10n/app_localizations.dart';
import 'package:trackify/core/utils/distance_utils.dart';
import 'package:trackify/feature/service_logs/presentation/widgets/vehicle_selection_app_bar.dart';
import '../cubit/statistics_cubit.dart';
import '../cubit/statistics_state.dart';
import '../../data/model/statistics_response_model.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<StatisticsCubit>().fetchInitialData();
  }

  Future<void> _selectDate(BuildContext context, DateTime currentDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        final theme = Theme.of(context);
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.colorScheme.primary,
              onPrimary: theme.colorScheme.onPrimary,
              onSurface: theme.colorScheme.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != currentDate) {
      context.read<StatisticsCubit>().selectDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocBuilder<StatisticsCubit, StatisticsState>(
      builder: (context, state) {
        if (state is StatisticsInitial ||
            (state is StatisticsLoading && state.userVehicles.isEmpty)) {
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                l10n.statistics,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: false,
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is StatisticsError && state.userVehicles.isEmpty) {
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                l10n.statistics,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: false,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<StatisticsCubit>().fetchInitialData(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final userVehicles = state is StatisticsLoaded
            ? state.userVehicles
            : state is StatisticsLoading
            ? state.userVehicles
            : state is StatisticsError
            ? state.userVehicles
            : <Vehicle>[];

        final selectedVehicle = state is StatisticsLoaded
            ? state.selectedVehicle
            : state is StatisticsLoading
            ? state.selectedVehicle
            : state is StatisticsError
            ? state.selectedVehicle
            : null;

        final selectedDate = state is StatisticsLoaded
            ? state.selectedDate
            : state is StatisticsLoading
            ? state.selectedDate
            : state is StatisticsError
            ? state.selectedDate
            : DateTime.now();

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                VehicleSelectionAppBar(
                  title: l10n.statistics,
                  selectedVehicle: selectedVehicle,
                  vehicles: userVehicles,
                  onBack: () => Navigator.pop(context),
                  showBackButton: false,
                  onVehicleSelected: (vehicle) {
                    context.read<StatisticsCubit>().selectVehicle(vehicle);
                  },
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _DatePickerBar(
                    selectedDate: selectedDate,
                    onPrevious: () {
                      final newDate = selectedDate.subtract(
                        const Duration(days: 1),
                      );
                      context.read<StatisticsCubit>().selectDate(newDate);
                    },
                    onNext: () {
                      final newDate = selectedDate.add(const Duration(days: 1));
                      context.read<StatisticsCubit>().selectDate(newDate);
                    },
                    onTap: () => _selectDate(context, selectedDate),
                  ),
                ),
                const SizedBox(height: 12),
                if (state is StatisticsLoading)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state is StatisticsError)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.message,
                            style: TextStyle(color: theme.colorScheme.error),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              if (selectedVehicle != null) {
                                context.read<StatisticsCubit>().loadStatistics(
                                  vehicle: selectedVehicle,
                                  date: selectedDate,
                                  vehicles: userVehicles,
                                );
                              }
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (state is StatisticsLoaded)
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          _RidingBehaviourCard(
                            data: state.statistics.data?.ridingBehaviour,
                          ),
                          const SizedBox(height: 20),
                          _JourneyCard(data: state.statistics.data?.journey),
                          const SizedBox(height: 20),
                          _SpeedCard(data: state.statistics.data?.speed),
                          const SizedBox(height: 20),
                          _FuelCard(data: state.statistics.data?.fuel),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DatePickerBar extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onTap;

  const _DatePickerBar({
    required this.selectedDate,
    required this.onPrevious,
    required this.onNext,
    required this.onTap,
  });

  String _formatDate(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;
    final format = isToday ? DateFormat('MMMM d') : DateFormat('MMMM d, y');
    final l10n = AppLocalizations.of(context)!;
    return isToday
        ? '${format.format(date)} ${l10n.todayLabel}'
        : format.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 20,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                ),
                const SizedBox(width: 12),
                Text(
                  _formatDate(context, selectedDate),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    // Prevent closing if we had a parent tap
                  },
                  child: Row(
                    children: [
                      _ArrowButton(
                        icon: Icons.chevron_left_rounded,
                        onTap: onPrevious,
                      ),
                      const SizedBox(width: 8),
                      _ArrowButton(
                        icon: Icons.chevron_right_rounded,
                        onTap: onNext,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ArrowButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Stop propagation to InkWell
      },
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(4),
          child: Icon(
            icon,
            size: 28,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _RidingBehaviourCard extends StatelessWidget {
  final RidingBehaviourModel? data;

  const _RidingBehaviourCard({this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final score = data?.score ?? 0;
    final scoreText = data?.scoreText ?? 'N/A';
    final statusText = data?.statusText ?? 'N/A';
    final comparisonText = data?.comparisonText ?? '';

    final isZeroScore = data == null ||
        score == 0 ||
        scoreText == '0.0%' ||
        scoreText == '0%' ||
        scoreText == '0' ||
        scoreText == '0.0';

    if (isZeroScore) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.ridingBehaviour,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Image.asset(
                  AppImages.blackWhiteBikeIcon,
                  width: 100,
                  height: 80,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.directions_bike, size: 50),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    l10n.ridingBehaviourVacationDesc,
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    final parts = comparisonText.split(' ');
    final trendVal = parts.isNotEmpty ? parts.first : '';
    final trendLabel = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    final isDecrease = comparisonText.startsWith('-');
    final trendColor = isDecrease ? Colors.red : Colors.green;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.ridingBehaviour,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Icon(
                Icons.arrow_forward_rounded,
                size: 18,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.dark
                  ? theme.colorScheme.surfaceContainerHighest.withOpacity(0.2)
                  : theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // Split Badge/Pill
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.colorScheme.primary,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(6),
                            bottomLeft: Radius.circular(6),
                          ),
                        ),
                        child: Text(
                          scoreText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: theme.brightness == Brightness.dark
                              ? theme.colorScheme.surfaceContainerHighest
                              : Colors.white,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(6),
                            bottomRight: Radius.circular(6),
                          ),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Trend section
                if (comparisonText.isNotEmpty)
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          isDecrease
                              ? Icons.trending_down_rounded
                              : Icons.trending_up_rounded,
                          size: 18,
                          color: trendColor,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '$trendVal ',
                                  style: TextStyle(
                                    color: trendColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                TextSpan(
                                  text: trendLabel,
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.6),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _JourneyCard extends StatelessWidget {
  final JourneyModel? data;

  const _JourneyCard({this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _StatSectionCard(
      title: l10n.journey,
      metrics: [
        _MetricItem(
          label: l10n.distanceTravelled,
          value: (data?.distanceTravelledText ?? '0.0 km').replaceAll('km', context.displayKm),
          comparisonText: data?.distanceComparisonText ?? '',
          iconPath: AppImages.distanceTravelledIcon,
          color: const Color(0xFFB9F3E4),
        ),
        _MetricItem(
          label: l10n.timeDuration,
          value: data?.timeDurationText ?? '0m',
          comparisonText: data?.durationComparisonText ?? '',
          iconPath: AppImages.timeDurationIcon,
          color: const Color(0xFFC3E7FF),
        ),
      ],
    );
  }
}

class _SpeedCard extends StatelessWidget {
  final SpeedModel? data;

  const _SpeedCard({this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _StatSectionCard(
      title: l10n.speed,
      metrics: [
        _MetricItem(
          label: l10n.averageSpeed,
          value: (data?.averageSpeedText ?? '0.0 km/hr').replaceAll('km/hr', context.displayKmHr).replaceAll('km', context.displayKm),
          comparisonText: data?.averageSpeedComparisonText ?? '',
          iconPath: AppImages.averageSpeedIcon,
          color: const Color(0xFFFDE8E0),
        ),
        _MetricItem(
          label: l10n.topSpeed,
          value: (data?.topSpeedText ?? '0.0 km/hr').replaceAll('km/hr', context.displayKmHr).replaceAll('km', context.displayKm),
          comparisonText: data?.topSpeedComparisonText ?? '',
          iconPath: AppImages.topSpeedIcon,
          color: const Color(0xFFFFF7D1),
        ),
      ],
    );
  }
}

class _FuelCard extends StatelessWidget {
  final FuelModel? data;

  const _FuelCard({this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _StatSectionCard(
      title: l10n.fuel,
      metrics: [
        _MetricItem(
          label: l10n.fuelConsumed,
          value: data?.fuelConsumedText ?? '0.0 L',
          comparisonText: data?.fuelConsumedComparisonText ?? '',
          iconPath: AppImages.fuelIcon,
          color: const Color(0xFFE5F1E5),
        ),
        _MetricItem(
          label: l10n.fuelCost,
          value: data?.fuelCostText ?? '₹0.0',
          comparisonText: data?.fuelCostComparisonText ?? '',
          iconPath: AppImages.fuelCostIcon,
          color: const Color(0xFFE5F1E5),
        ),
      ],
    );
  }
}

class _StatSectionCard extends StatelessWidget {
  final String title;
  final List<_MetricItem> metrics;

  const _StatSectionCard({required this.title, required this.metrics});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: metrics[0]),
              Container(
                width: 1,
                height: 60,
                color: Theme.of(context).dividerColor,
              ),
              Expanded(child: metrics[1]),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String label;
  final String value;
  final String comparisonText;
  final String iconPath;
  final Color color;

  const _MetricItem({
    required this.label,
    required this.value,
    required this.comparisonText,
    required this.iconPath,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIncrease = comparisonText.startsWith('+');
    final isNegativeImpact =
        (label == AppLocalizations.of(context)?.fuelConsumed ||
        label == AppLocalizations.of(context)?.fuelCost);

    Color trendColor = Colors.grey;
    if (comparisonText.isNotEmpty) {
      if (isIncrease) {
        trendColor = isNegativeImpact ? Colors.red : Colors.green;
      } else {
        trendColor = isNegativeImpact ? Colors.green : Colors.red;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  iconPath,
                  width: 14,
                  height: 14,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.info_outline, size: 14),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          if (comparisonText.isNotEmpty)
            Row(
              children: [
                Icon(
                  isIncrease
                      ? Icons.trending_up_rounded
                      : Icons.trending_down_rounded,
                  size: 14,
                  color: trendColor,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    comparisonText,
                    style: TextStyle(
                      fontSize: 10,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            )
          else
            const SizedBox(height: 14),
        ],
      ),
    );
  }
}
