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
      backgroundColor: const Color(0xFFF6F6F6),

      /// APP BAR
      appBar: AppBar(
        elevation: 2,
        shadowColor: Colors.black12,
        backgroundColor: Colors.white,
        title: const Text(
          "Journey",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        actions: [
          PopupMenuButton<String>(
            elevation: 8,
            onSelected: (value) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("$value Clicked")));
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            icon: const Icon(Icons.more_vert, color: Colors.black),
            itemBuilder: (context) => const [
              PopupMenuItem(value: "Shared Rides", child: Text("Shared Rides")),
              PopupMenuItem(value: "Saved Rides", child: Text("Saved Rides")),
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
        color: const Color(0xFFEFEFEF),
        borderRadius: BorderRadius.circular(30),
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
    final isSelected = _tabController.index == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _tabController.animateTo(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFDFF3FA) : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: isSelected ? const Color(0xFF00AEEF) : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
