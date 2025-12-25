import 'package:fpdart/fpdart.dart';
import 'package:trackify/core/constants/api_constants.dart';
import 'package:trackify/core/utils/typedefs.dart';
import 'package:trackify/feature/map/data/entity/user_device_model.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/base_api_service.dart';
import '../../../../core/network/network_api_service.dart';
import '../../domain/repository/map_repository.dart';

class MapRepositoryImpl implements MapRepository {
  static final BaseApiServices _apiServices = NetworkApiService();

  @override
  ResultFuture<UserDeviceList> getUserDevices(Map<String, dynamic> body) async {
    try {
      final res = await _apiServices.getGetApiResponse(ApiConstants.deviceByUserId, body);
      return res.fold(
        (error) => Left(error),
        (data) => Right(UserDeviceList.fromJson(data)),
      );
    } on AppException catch (e) {
      return Left(e);
    }
  }
}
