import 'package:flutter/material.dart';
import 'package:trackify/feature/trips/presentation/view/widgets/all_rides/widgets/all_rides_empty_state.dart';
import 'package:trackify/feature/trips/presentation/view/widgets/all_rides/widgets/ride_card.dart';
import '../../../cubit/ride_history_cubit.dart';
import '../../../cubit/ride_history_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:trackify/feature/trips/presentation/view/ride_history_details/ride_history_details_screen.dart';

class AllRides extends StatefulWidget {
  const AllRides({super.key});

  @override
  State<AllRides> createState() => _AllRidesState();
}

class _AllRidesState extends State<AllRides> {
  @override
  void initState() {
    super.initState();
    context.read<RideHistoryCubit>().getRideHistoryData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RideHistoryCubit, RideHistoryState>(
      builder: (context, state) {
        if (state is RideHistoryLoading) {
          return const Center(child: CircularProgressIndicator());
        }

           if (state is RideHistorySuccess) {
          return state.rides.isEmpty
              ? const AllRidesEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.rides.length,
                  itemBuilder: (context, index) {
                    final ride = state.rides[index];
                    return RideCard(
                      ride: ride,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RideHistoryDetailsScreen(ride: ride),
                          ),
                        );
                      },
                    );
                  },
                );
        }
        //
        // if (state is RideHistoryFailure) {
        //   return Center(
        //     child: Text("Failed to load rides: ${state.exception}"),
        //   );
        // }

        return const SizedBox();
      },
    );
  }
}
