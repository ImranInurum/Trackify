import 'package:fpdart/fpdart.dart';
import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/base_api_service.dart';
import 'package:trackify/core/config/network/network_api_service.dart';
import 'package:trackify/core/utils/typedefs.dart';
import 'package:trackify/feature/map/data/entity/user_vehicles.dart';

import '../../../../core/config/network/exceptions.dart';
import '../../../../core/utils/shared_preferences.dart';
import '../../domain/repository/map_repository.dart';

class MapRepositoryImpl implements MapRepository {
  static final BaseApiServices _apiServices = NetworkApiService();

  @override
  ResultFuture<UserVehicles> getUserVehicles() async {
    try {
      final prefs = AppPreference.instance;
      final userId = await prefs.get(key: AppPreference.KEY_USER_ID);

      final res = await _apiServices.getGetApiResponse(
        ApiURL.getVehiclesByUserId(userId),
      );
      return res.fold(
        (error) => Left(error),
        (data) => Right(UserVehicles.fromJson(data)),
      );
    } on AppException catch (e) {
      return Left(e);
    }
  }
}
