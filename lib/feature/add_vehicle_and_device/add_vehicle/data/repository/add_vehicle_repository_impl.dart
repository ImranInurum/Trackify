import 'package:fpdart/fpdart.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/network/base_api_service.dart';
import '../../../../../core/network/network_api_service.dart';
import '../../../../../core/utils/shared_preferences.dart';
import '../../../../../core/utils/typedefs.dart';
import '../../domain/repository/add_vehicle_repository.dart';
import '../models/add_vehicle_request.dart';
import '../models/vehicle_list_model.dart';

class AddVehicleRepositoryImpl implements AddVehicleRepository {
  final BaseApiServices _apiService = NetworkApiService();

  @override
  ResultFuture<dynamic> addVehicle(AddVehicleRequest request) async {
    final token = await AppPreference.instance.get(key: AppPreference.KEY_TOKEN);

    final Map<String, dynamic> body = request.toJson();
    body['auth'] = token;

    return _apiService.getPostApiResponse(ApiConstants.addVehicle, body);
  }

  @override
  ResultFuture<VehicleListResponse> getVehicles(String userId) async {
    final token = await AppPreference.instance.get(key: AppPreference.KEY_TOKEN);
    final url = ApiConstants.getVehiclesByUserId(userId);

    final result = await _apiService.getGetApiResponse(url, {'auth': token});

    return result.fold(
      (failure) => Left(failure),
      (data) => Right(VehicleListResponse.fromJson(data)),
    );
  }
}
