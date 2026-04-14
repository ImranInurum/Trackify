import 'package:trackify/core/common/models/vehicle_list_model.dart';
import 'package:trackify/core/utils/typedefs.dart';
import 'package:trackify/feature/profile/data/repository_impl/profile_repository_impl.dart';
import 'package:trackify/feature/profile/domain/repository/profile_repository.dart';

class ProfileUseCase {
  final ProfileRepository repository = ProfileRepositoryImpl();

  ResultFuture<VehicleListResponse> getVehicles({required String userId}) async {
    return await repository.getVehicles(userId);
  }
}
