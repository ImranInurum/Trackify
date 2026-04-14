import '../../../../../core/utils/typedefs.dart';
import '../../data/models/add_vehicle_request.dart';

abstract interface class AddVehicleRepository {
  ResultFuture<dynamic> addVehicle(AddVehicleRequest request);
  ResultFuture<dynamic> getVehicleConfig();
  ResultFuture<dynamic> getVehicleMakers(String vehicleType, String fuelType);
  ResultFuture<dynamic> getVehicleModels(
    String vehicleType,
    String fuelType,
    String brandId,
  );
}
