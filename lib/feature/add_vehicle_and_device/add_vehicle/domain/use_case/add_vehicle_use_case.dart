import 'package:trackify/core/utils/typedefs.dart';
import 'package:trackify/feature/add_vehicle_and_device/add_vehicle/data/models/add_vehicle_request.dart';
import 'package:trackify/feature/add_vehicle_and_device/add_vehicle/domain/repository/add_vehicle_repository.dart';

class AddVehicleUseCase {
  final AddVehicleRepository repository;
  AddVehicleUseCase(this.repository);

  ResultFuture<dynamic> addVehicle({required AddVehicleRequest request}) async {
    return await repository.addVehicle(request);
  }

  ResultFuture<dynamic> getVehicleConfig() async {
    return await repository.getVehicleConfig();
  }

  ResultFuture<dynamic> getVehicleMakers({
    required String vehicleType,
    required String fuelType,
  }) async {
    return await repository.getVehicleMakers(vehicleType, fuelType);
  }

  ResultFuture<dynamic> getVehicleModels({
    required String vehicleType,
    required String fuelType,
    required String brandId,
  }) async {
    return await repository.getVehicleModels(vehicleType, fuelType, brandId);
  }
}
