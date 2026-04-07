import 'package:flutter/material.dart';
import 'package:trackify/feature/trips/presentation/view/widgets/all_rides/widgets/all_rides_empty_state.dart';
import 'package:trackify/feature/trips/presentation/view/widgets/all_rides/widgets/ride_card.dart';
import '../../../../data/entity/ride_model.dart';

class AllRides extends StatelessWidget {
  const AllRides({super.key});

  @override
  Widget build(BuildContext context) {
    // DUMMY DATA FOR DEMONSTRATION
    final List<Ride> dummyRides = [
      Ride(
        id: "1",
        date: "Thursday, Apr 02, 2026",
        startTime: "09:12 AM",
        endTime: "10:04 AM",
        distance: 12.4,
        duration: "52m",
        avgSpeed: 23.8,
        topSpeed: 45.2,
        startLocation: "Indiranagar, Bangalore",
        endLocation: "MG Road, Bangalore",
        mapImageUrl: "https://api.placeholder.com/400/200",
      ),
      Ride(
        id: "2",
        date: "Wednesday, Apr 01, 2026",
        startTime: "05:45 PM",
        endTime: "06:30 PM",
        distance: 8.7,
        duration: "45m",
        avgSpeed: 19.3,
        topSpeed: 38.5,
        startLocation: "MG Road, Bangalore",
        endLocation: "Indiranagar, Bangalore",
        mapImageUrl: "https://api.placeholder.com/400/200",
      ),
      Ride(
        id: "3",
        date: "Tuesday, Mar 31, 2026",
        startTime: "08:30 AM",
        endTime: "09:15 AM",
        distance: 11.2,
        duration: "45m",
        avgSpeed: 24.8,
        topSpeed: 42.1,
        startLocation: "Whitefield, Bangalore",
        endLocation: "MG Road, Bangalore",
        mapImageUrl: "https://api.placeholder.com/400/200",
      ),
    ];

    if (dummyRides.isEmpty) {
      return const AllRidesEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dummyRides.length,
      itemBuilder: (context, index) {
        return RideCard(ride: dummyRides[index]);
      },
    );
  }
}
