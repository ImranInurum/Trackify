import 'package:fpdart/fpdart.dart';
import 'package:trackify/core/common/models/vehicle_list_model.dart';
import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/base_api_service.dart';
import 'package:trackify/core/config/network/exceptions.dart';
import 'package:trackify/core/config/network/network_api_service.dart';
import 'package:trackify/core/utils/typedefs.dart';
import 'package:trackify/feature/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  static final BaseApiServices _apiServices = NetworkApiService();

  @override
  ResultFuture<VehicleListResponse> getVehicles(String userId) async {
    try {
      final url = ApiURL.getVehiclesByUserId(userId);
      final result = await _apiServices.getGetApiResponse(url);

      return result.fold(
        (failure) => Left(failure),
        (data) => Right(VehicleListResponse.fromJson(data)),
      );
    } on AppException catch (e) {
      return Left(e);
    }
  }
}
