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

  @override
  ResultFuture<bool> checkImeiAssigned(String imei) async {
    try {
      debugPrint('Checking IMEI: $imei');
      final response = await _apiService.getGetApiResponse(
        ApiURL.checkImei(imei),
      );
      debugPrint('Check IMEI response: $response');
      // The API returns true or false, but it might be wrapped in a success/data object depending on backend.
      // Wait, "agar isme responce true ho" implies it's returning true directly or inside data.
      // Let's assume it returns true/false directly or { "status": true } maybe?
      // I will check if the response is boolean or if response['data'] is boolean.
      bool isAssigned = false;
      
      response.fold(
        (error) {
          debugPrint('API Error: $error');
          // If error occurs, we check if it's a 400 with 'assigned' message
          if (error.message.toLowerCase().contains('assigned') ||
              error.message.toLowerCase().contains('already') ||
              error.message.toLowerCase().contains('vehicle')) {
            isAssigned = true;
          }
        },
        (data) {
          if (data is bool) {
            isAssigned = data;
          } else if (data is Map) {
            // First check message just to be absolutely sure
            final message = data['message']?.toString().toLowerCase() ?? '';
            if (message.contains('assigned') || message.contains('already') || message.contains('vehicle')) {
              isAssigned = true;
            } else if (data.containsKey('data') && data['data'] is bool) {
              isAssigned = data['data'] as bool;
            } else if (data.containsKey('isAssigned') && data['isAssigned'] is bool) {
              isAssigned = data['isAssigned'] as bool;
            } else if (data.containsKey('status')) {
              isAssigned = data['status'] == true || data['status'] == 'true';
            } else if (data['success'] == true || data['success'] == 'true') {
              isAssigned = true; 
            }
          }
        }
      );

      if (isAssigned) {
        return const Right(true);
      }

      if (response.isLeft()) {
        return Left(response.getLeft().toNullable()!);
      }
      
      return Right(isAssigned);
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(FetchDataException('Unexpected error: $e'));
    }
  }
}
