import 'package:trackify/feature/my_profile/data/respository_impl/my_profile_repository_impl.dart';
import 'package:trackify/feature/my_profile/domain/respository/my_profile_repository.dart';

class MyProfileUseCase {
  final MyProfileRepository repository = MyProfileRepositoryImpl();

  // ResultFuture<VehicleListResponse> getVehicles({required String userId}) async {
  //   return await repository.getVehicles(userId);
  // }
}
