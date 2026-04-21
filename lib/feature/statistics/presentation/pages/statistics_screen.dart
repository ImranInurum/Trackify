import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trackify/core/constants/app_images.dart';
import 'package:trackify/core/theme/app_colors.dart';
import 'package:trackify/l10n/app_localizations.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  DateTime _selectedDate = DateTime.now();

  void _onPreviousDay() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
    });
  }

  void _onNextDay() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 1));
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
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
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          l10n.statistics,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            _DatePickerBar(
              selectedDate: _selectedDate,
              onPrevious: _onPreviousDay,
              onNext: _onNextDay,
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 20),
            const _RidingBehaviourCard(),
            const SizedBox(height: 20),
            const _JourneyCard(),
            const SizedBox(height: 20),
            const _SpeedCard(),
            const SizedBox(height: 20),
            const _FuelCard(),
            const SizedBox(height: 32),
          ],
        ),
      ),
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
    return isToday ? '${format.format(date)} ${l10n.todayLabel}' : format.format(date);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
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
                      _ArrowButton(icon: Icons.chevron_left_rounded, onTap: onPrevious),
                      const SizedBox(width: 8),
                      _ArrowButton(icon: Icons.chevron_right_rounded, onTap: onNext),
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
          child: Icon(icon, size: 28, color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
    );
  }
}

class _RidingBehaviourCard extends StatelessWidget {
  const _RidingBehaviourCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
          Text(
            l10n.ridingBehaviour,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                AppImages.blackWhiteBikeIcon,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.directions_bike, size: 50),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  l10n.ridingBehaviourVacationDesc,
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
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
}

class _JourneyCard extends StatelessWidget {
  const _JourneyCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _StatSectionCard(
      title: l10n.journey,
      metrics: [
        _MetricItem(
          label: l10n.distanceTravelled,
          value: '0.0 km',
          iconPath: AppImages.distanceTravelledIcon,
          color: const Color(0xFFB9F3E4),
        ),
        _MetricItem(
          label: l10n.timeDuration,
          value: '0m 0s',
          iconPath: AppImages.timeDurationIcon,
          color: const Color(0xFFC3E7FF),
        ),
      ],
    );
  }
}

class _SpeedCard extends StatelessWidget {
  const _SpeedCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _StatSectionCard(
      title: l10n.speed,
      metrics: [
        _MetricItem(
          label: l10n.averageSpeed,
          value: '0.0 km/hr',
          iconPath: AppImages.averageSpeedIcon,
          color: const Color(0xFFFDE8E0),
        ),
        _MetricItem(
          label: l10n.topSpeed,
          value: '0.0 km/hr',
          iconPath: AppImages.topSpeedIcon,
          color: const Color(0xFFFFF7D1),
        ),
      ],
    );
  }
}

class _FuelCard extends StatelessWidget {
  const _FuelCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _StatSectionCard(
      title: l10n.fuel,
      metrics: [
        _MetricItem(
          label: l10n.fuelConsumed,
          value: '0.0 L',
          iconPath: AppImages.fuelIcon,
          color: const Color(0xFFE5F1E5),
        ),
        _MetricItem(
          label: l10n.fuelCost,
          value: '₹0.0',
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
              Container(width: 1, height: 60, color: Theme.of(context).dividerColor),
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
  final String iconPath;
  final Color color;

  const _MetricItem({
    required this.label,
    required this.value,
    required this.iconPath,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
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
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.trending_down_rounded, size: 14, color: Colors.red),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  l10n.vsPreviousPeriod('0'),
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
