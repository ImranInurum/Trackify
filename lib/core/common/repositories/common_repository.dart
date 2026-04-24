import 'package:trackify/core/common/models/vehicle_list_model.dart';
import 'package:trackify/core/utils/typedefs.dart';

abstract interface class CommonRepository {
  // get user vehicles
  ResultFuture<VehicleListResponse> getUserVehicles();
}
