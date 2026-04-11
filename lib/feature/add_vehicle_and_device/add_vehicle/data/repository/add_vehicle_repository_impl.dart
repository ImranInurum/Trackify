import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/base_api_service.dart';
import 'package:trackify/core/config/network/network_api_service.dart';

import '../../../../../core/utils/shared_preferences.dart';
import '../../../../../core/utils/typedefs.dart';
import '../../domain/repository/add_vehicle_repository.dart';
import '../models/add_vehicle_request.dart';

class AddVehicleRepositoryImpl implements AddVehicleRepository {
  final BaseApiServices _apiService = NetworkApiService();

  @override
  ResultFuture<dynamic> addVehicle(AddVehicleRequest request) async {
    final token = await AppPreference.instance.get(key: AppPreference.KEY_TOKEN);

    final Map<String, dynamic> body = request.toJson();
    body['auth'] = token;

    return _apiService.getPostApiResponse(ApiURL.addVehicle, body);
  }
}
