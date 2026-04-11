import 'package:trackify/core/utils/typedefs.dart';
import 'package:trackify/feature/add_vehicle_and_device/add_vehicle/data/models/add_vehicle_request.dart';
import 'package:trackify/feature/add_vehicle_and_device/add_vehicle/data/repository/add_vehicle_repository_impl.dart';
import 'package:trackify/feature/add_vehicle_and_device/add_vehicle/domain/repository/add_vehicle_repository.dart';

class AddVehicleUseCase {
  final AddVehicleRepository repository = AddVehicleRepositoryImpl();

  ResultFuture<dynamic> addVehicle({required AddVehicleRequest request}) async {
    return await repository.addVehicle(request);
  }
}
