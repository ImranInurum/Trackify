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
      return res.fold(
        (error) => Left(error),
        (data) => Right(DeviceDataByDateResponse.fromJson(data)),
      );
    } on AppException catch (e) {
      return Left(e);
    }
  }
}
