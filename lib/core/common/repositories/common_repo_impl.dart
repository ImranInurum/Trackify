import 'package:fpdart/fpdart.dart';
import 'package:trackify/core/common/models/vehicle_list_model.dart';
import 'package:trackify/core/common/repositories/common_repository.dart';
import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/base_api_service.dart';
import 'package:trackify/core/config/network/exceptions.dart';
import 'package:trackify/core/config/network/network_api_service.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:trackify/core/utils/typedefs.dart';

class CommonRepositoryImpl implements CommonRepository {
  static final BaseApiServices _apiServices = NetworkApiService();

  @override
  ResultFuture<VehicleListResponse> getUserVehicles() async {
    try {
      final prefs = AppPreference.instance;
      final userId = await prefs.get(key: AppPreference.KEY_USER_ID);

      final res = await _apiServices.getGetApiResponse(
        ApiURL.getVehiclesByUserId(userId),
      );
      return res.fold(
        (error) => Left(error),
        (data) => Right(VehicleListResponse.fromJson(data)),
      );
    } on AppException catch (e) {
      return Left(e);
    }
  }
}
