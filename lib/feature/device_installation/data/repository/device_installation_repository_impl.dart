import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/exceptions.dart';
import 'package:trackify/core/config/network/network_api_service.dart';
import 'package:trackify/core/utils/typedefs.dart';
import '../../domain/repository/device_installation_repository.dart';
import '../entity/assign_device_request.dart';


class DeviceInstallationRepositoryImpl implements DeviceInstallationRepository {
  final NetworkApiService _apiService = NetworkApiService();

  @override
  ResultFuture<dynamic> assignDevice(AssignDeviceRequest request) async {
    try {
      debugPrint('Assigning device with request: ${request.toJson()}');
      final response = await _apiService.getPostApiResponse(
        ApiURL.assignDevices,
        request.toJson(),
      );
      debugPrint('Assigning device response: $response');
      // NetworkApiService's getPostApiResponse already returns an Either<AppException, dynamic>
      return response;
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(FetchDataException('Unexpected error: $e'));
    }
  }
}
