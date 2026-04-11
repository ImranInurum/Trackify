import 'package:trackify/core/common/models/vehicle_list_model.dart';
import 'package:trackify/core/utils/typedefs.dart';

abstract class ProfileRepository {
  ResultFuture<VehicleListResponse> getVehicles(String userId);
}
