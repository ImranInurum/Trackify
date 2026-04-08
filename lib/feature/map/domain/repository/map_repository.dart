import 'package:trackify/feature/map/data/entity/user_vehicles.dart';

import '../../../../core/utils/typedefs.dart';

abstract interface class MapRepository {
  ResultFuture<UserVehicles> getUserVehicles(Map<String, dynamic> body);
}
