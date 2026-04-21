import 'package:flutter/material.dart';
import 'package:trackify/feature/trips/presentation/view/widgets/all_rides/all_rides_view.dart';
import 'package:trackify/feature/trips/presentation/view/widgets/trips/trips_view.dart';

class TripScreen extends StatefulWidget {
  const TripScreen({super.key});

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> with SingleTickerProviderStateMixin {
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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      /// APP BAR
      appBar: AppBar(
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          "Journey",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            elevation: 8,
            color: Theme.of(context).cardColor,
            surfaceTintColor: Colors.transparent,
            onSelected: (value) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("$value Clicked")));
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            icon: Icon(Icons.more_vert, color: Theme.of(context).colorScheme.onSurface),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "Shared Rides",
                child: Text(
                  "Shared Rides",
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                ),
              ),
              PopupMenuItem(
                value: "Saved Rides",
                child: Text(
                  "Saved Rides",
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
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
              children: const [
                AllRides(),
                Trips(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTabBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          _buildTab("ALL RIDES", 0),
          _buildTab("TRIPS", 1),
        ],
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
            color: isSelected ? theme.colorScheme.primary.withOpacity(0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
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
