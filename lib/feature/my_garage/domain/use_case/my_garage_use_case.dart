import 'package:trackify/core/common/models/vehicle_list_model.dart';
import 'package:trackify/core/utils/typedefs.dart';
import 'package:trackify/feature/my_garage/domain/repository/my_garage_repository.dart';

class MyGarageUseCase {
  final MyGarageRepository repository;
  MyGarageUseCase(this.repository);

  ResultFuture<VehicleListResponse> getVehicles({required String userId}) async {
    return await repository.getVehicles(userId);
  }
}
