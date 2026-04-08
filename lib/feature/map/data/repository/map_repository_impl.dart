import 'package:fpdart/fpdart.dart';
import 'package:trackify/core/constants/api_constants.dart';
import 'package:trackify/core/utils/typedefs.dart';
import 'package:trackify/feature/map/data/entity/user_vehicles.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/base_api_service.dart';
import '../../../../core/network/network_api_service.dart';
import '../../../../core/utils/shared_preferences.dart';
import '../../domain/repository/map_repository.dart';

class MapRepositoryImpl implements MapRepository {
  static final BaseApiServices _apiServices = NetworkApiService();

  @override
  ResultFuture<UserVehicles> getUserVehicles(Map<String, dynamic> body) async {
    try {
      final prefs = AppPreference.instance;
      final userId = await prefs.get(key: AppPreference.KEY_USER_ID);
      final token = await prefs.get(key: AppPreference.KEY_TOKEN);

      final Map<String, dynamic> requestBody = Map.from(body);
      requestBody['auth'] = token;

      final res = await _apiServices.getGetApiResponse(
        ApiConstants.getVehiclesByUserId(userId),
        requestBody,
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
