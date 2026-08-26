import 'package:flutter/material.dart';
import 'package:trackify/feature/trips/presentation/view/widgets/all_rides/all_rides_view.dart';
import 'package:trackify/feature/trips/presentation/view/widgets/trips/trips_view.dart';
import '../../../../l10n/app_localizations.dart';

class TripScreen extends StatefulWidget {
  const TripScreen({super.key});

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      /// APP BAR
      appBar: AppBar(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: theme.scaffoldBackgroundColor,
        title: Text(
          l10n.journey,
          style: TextStyle(
            fontSize: 20.0,
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [
          _buildCustomTabBar(),

          /// TAB VIEW CONTENT
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [AllRides(), Trips()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTabBar() {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark
            ? Theme.of(context).colorScheme.onSurface.withOpacity(0.08)
            : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [_buildTab(l10n.allRides, 0), _buildTab(l10n.trips, 1)],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isSelected = _tabController.index == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => _tabController.animateTo(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? theme.colorScheme.surface : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                fontSize: 13,
                color: isSelected
                    ? const Color(0xFF0284C7)
                    : theme.colorScheme.onSurface.withOpacity(0.55),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
