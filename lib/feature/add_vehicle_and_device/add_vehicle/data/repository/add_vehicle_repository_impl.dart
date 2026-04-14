import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/base_api_service.dart';
import 'package:trackify/core/config/network/network_api_service.dart';

import '../../../../../core/utils/typedefs.dart';
import '../../domain/repository/add_vehicle_repository.dart';
import '../models/add_vehicle_request.dart';

class AddVehicleRepositoryImpl implements AddVehicleRepository {
  final BaseApiServices _apiService = NetworkApiService();

  @override
  ResultFuture<dynamic> addVehicle(AddVehicleRequest request) async {
    final Map<String, dynamic> body = request.toJson();
    return _apiService.getPostApiResponse(ApiURL.addVehicle, body);
  }

  @override
  ResultFuture<dynamic> getVehicleConfig() async {
    return _apiService.getGetApiResponse(ApiURL.vehicleConfig);
  }

  @override
  ResultFuture<dynamic> getVehicleMakers(String vehicleType, String fuelType) async {
    return _apiService.getGetApiResponse(ApiURL.vehicleMakers(vehicleType, fuelType));
  }

  @override
  ResultFuture<dynamic> getVehicleModels(
    String vehicleType,
    String fuelType,
    String brandId,
  ) async {
    return _apiService.getGetApiResponse(
      ApiURL.vehicleModels(vehicleType, fuelType, brandId),
    );
  }
}
