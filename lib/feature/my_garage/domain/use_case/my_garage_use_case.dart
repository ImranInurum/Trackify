import 'package:trackify/core/common/models/vehicle_list_model.dart';
import 'package:trackify/core/utils/typedefs.dart';
import 'package:trackify/feature/my_garage/data/repository_impl/my_garage_repo_impl.dart';
import 'package:trackify/feature/my_garage/domain/repository/my_garage_repository.dart';

class MyGarageUseCase {
  final MyGarageRepository repository = MyGarageRepoImpl();

  ResultFuture<VehicleListResponse> getVehicles({required String userId}) async {
    return await repository.getVehicles(userId);
  }
}
