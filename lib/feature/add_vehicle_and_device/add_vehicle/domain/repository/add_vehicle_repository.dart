import '../../../../../core/utils/typedefs.dart';
import '../../data/models/add_vehicle_request.dart';

import '../../data/models/vehicle_list_model.dart';

abstract class AddVehicleRepository {
  ResultFuture<dynamic> addVehicle(AddVehicleRequest request);
  ResultFuture<VehicleListResponse> getVehicles(String userId);
}
