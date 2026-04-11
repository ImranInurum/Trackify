import '../../../../../core/utils/typedefs.dart';
import '../../data/models/add_vehicle_request.dart';

abstract class AddVehicleRepository {
  ResultFuture<dynamic> addVehicle(AddVehicleRequest request);
}
