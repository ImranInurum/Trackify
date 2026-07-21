import 'package:flutter/material.dart';
import 'package:trackify/feature/trips/presentation/view/widgets/all_rides/all_rides_view.dart';
import 'package:trackify/feature/trips/presentation/view/widgets/trips/trips_view.dart';
import 'package:trackify/feature/trips/presentation/view/saved_rides_screen.dart';
import 'package:trackify/feature/record_via_phone/presentation/pages/shared_rides_screen.dart' as trackify_shared;
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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      /// APP BAR
      appBar: AppBar(
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          l10n.journey,
          style: TextStyle(fontSize: 20.0, color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            elevation: 8,
            color: Theme.of(context).cardColor,
            surfaceTintColor: Colors.transparent,
            onSelected: (value) {
              if (value == l10n.savedRides) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SavedRidesScreen()),
                );
              } else if (value == l10n.sharedRides) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const trackify_shared.SharedRidesScreen()),
                );
              } else {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l10n.clicked(value))));
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: l10n.sharedRides,
                child: Text(
                  l10n.sharedRides,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              PopupMenuItem(
                value: l10n.savedRides,
                child: Text(
                  l10n.savedRides,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ],
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
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [_buildTab(l10n.allRides, 0), _buildTab(l10n.trips, 1)],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final theme = Theme.of(context);
    final isSelected = _tabController.index == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _tabController.animateTo(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary.withOpacity(0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.w700,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
