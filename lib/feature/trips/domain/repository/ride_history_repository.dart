import 'package:trackify/core/utils/typedefs.dart';

import '../../data/entity/ride_model.dart';

abstract class RideHistoryRepository {
  ResultFuture<List<Ride>> rideHistory(Map<String, dynamic> body);
}
