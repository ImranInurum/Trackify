import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trackify/feature/trips/data/entity/ride_model.dart';
import 'package:trackify/feature/trips/presentation/cubit/ride_history_details_cubit.dart';

void main() {
  group('RideHistoryDetailsCubit Telemetry Processing Tests', () {
    late Ride mockRide;

    setUp(() {
      mockRide = Ride(
        id: '123',
        date: '2026-05-23',
        startTime: '10:00 AM',
        endTime: '10:15 AM',
        distance: 5.0,
        startLocation: 'Point A',
        endLocation: 'Point B',
        duration: '15 mins',
        topSpeed: 60.0,
        avgSpeed: 30.0,
        mapImageUrl: '',
        polylinePoints: const [
          LatLng(12.971598, 77.594562),
          LatLng(12.972000, 77.595000),
          LatLng(12.973000, 77.596000),
          LatLng(12.974000, 77.597000),
        ],
        points: [
          RidePoint(
            location: const LatLng(12.971598, 77.594562),
            speed: 10.0,
            time: '2026-05-23 10:00:00',
          ),
          RidePoint(
            location: const LatLng(12.974000, 77.597000),
            speed: 50.0,
            time: '10:15:00', // Time-only format test
          ),
        ],
      );
    });

    test('Loads and processes ride points correctly with speed and custom time formatting', () async {
      final cubit = RideHistoryDetailsCubit(ride: mockRide);

      // Wait for async isolate processing to complete
      await Future.delayed(const Duration(milliseconds: 500));

      final state = cubit.state;

      expect(state.isDataProcessing, isFalse);
      expect(state.smoothPositions.isNotEmpty, isTrue);
      expect(state.smoothSpeeds.isNotEmpty, isTrue);
      expect(state.smoothTimes.isNotEmpty, isTrue);

      // First smooth point should match initial point speed and start time
      expect(state.smoothSpeeds.first, closeTo(10.0, 0.1));
      // End smooth point speed should be around 50.0
      expect(state.smoothSpeeds.last, closeTo(50.0, 0.1));

      // Make sure the formatted time is updated correctly and contains no placeholders like --:--
      expect(state.smoothTimes.first.contains(':'), isTrue);
      expect(state.smoothTimes.last.contains(':'), isTrue);
      expect(state.smoothTimes.first.contains('--'), isFalse);
      expect(state.smoothTimes.last.contains('--'), isFalse);

      await cubit.close();
    });
  });
}
