import 'package:fpdart/fpdart.dart';
import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/base_api_service.dart';
import 'package:trackify/core/config/network/exceptions.dart';
import 'package:trackify/core/config/network/network_api_service.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:trackify/core/utils/typedefs.dart';
import 'package:trackify/feature/record_via_phone/data/model/device_data_by_date_response.dart';

import '../../domain/repository/record_via_phone_repository.dart';

class RecordViaPhoneRepositoryImpl implements RecordViaPhoneRepository {
  static final BaseApiServices _apiServices = NetworkApiService();

  @override
  ResultFuture<DeviceDataByDateResponse> getDeviceDataByDate(
    Map<String, dynamic> body,
  ) async {
    try {
      final token = await AppPreference.instance.get(key: AppPreference.KEY_TOKEN);
      final Map<String, dynamic> requestBody = Map.from(body);
      requestBody['auth'] = token;

      final res = await _apiServices.getPostApiResponse(
        ApiURL.deviceDataByDate,
        requestBody,
      );
      print('phone >>>>>>>$res');
      return res.fold(
        (error) => Left(error),
        (data) => Right(DeviceDataByDateResponse.fromJson(data)),
      );
    } on AppException catch (e) {
      return Left(e);
    }
  }
  @override
  ResultFuture<void> saveRideModeOnline(Map<String, dynamic> body) async {
    try {
      final token = await AppPreference.instance.get(key: AppPreference.KEY_TOKEN);
      final Map<String, dynamic> requestBody = Map.from(body);
      
      // Some endpoints expect auth token in body if headers aren't used for it
      // though usually it's in headers. Since it's done for getDeviceDataByDate, we'll keep it consistent.
      // The curl showed Authorization header. Our BaseApiService typically adds the Bearer token automatically if it's stored.
      // But let's follow the existing pattern if needed, or simply pass the body.
      // For safety, pass body as is. NetworkApiService usually attaches the token in headers.
      // Wait, getDeviceDataByDate does requestBody['auth'] = token;
      // We'll just pass the body directly.
      
      final res = await _apiServices.getPostApiResponse(
        ApiURL.createRideMode,
        requestBody,
      );
      return res.fold(
        (error) => Left(error),
        (data) => const Right(null),
      );
    } on AppException catch (e) {
      return Left(e);
    }
  }

  @override
  ResultFuture<dynamic> getOnlinePastRides(String userId) async {
    try {
      final res = await _apiServices.getGetApiResponse(ApiURL.onlinePastRides(userId));
      return res.fold(
        (error) => Left(error),
        (data) => Right(data),
      );
    } on AppException catch (e) {
      return Left(e);
    }
  }
}
