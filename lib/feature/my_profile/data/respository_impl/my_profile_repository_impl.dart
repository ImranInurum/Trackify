import 'package:trackify/core/config/network/base_api_service.dart';
import 'package:trackify/core/config/network/network_api_service.dart';
import 'package:trackify/feature/my_profile/domain/respository/my_profile_repository.dart';

class MyProfileRepositoryImpl extends MyProfileRepository {
  static final BaseApiServices _apiServices = NetworkApiService();

  // @override
  // ResultFuture<VehicleListResponse> getVehicles(String userId) async {
  //   try {
  //     final url = ApiURL.getVehiclesByUserId(userId);
  //     final result = await _apiServices.getGetApiResponse(url);
  //
  //     return result.fold(
  //           (failure) => Left(failure),
  //           (data) => Right(VehicleListResponse.fromJson(data)),
  //     );
  //   } on AppException catch (e) {
  //     return Left(e);
  //   }
  // }
}
