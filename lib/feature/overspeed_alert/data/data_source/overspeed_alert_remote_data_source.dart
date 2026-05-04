import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/base_api_service.dart';

class OverspeedAlertRemoteDataSource {
  final BaseApiServices _apiServices;

  OverspeedAlertRemoteDataSource(this._apiServices);

  Future<dynamic> createOverspeedAlert(Map<String, dynamic> data) async {
    final response = await _apiServices.getPostApiResponse(
      ApiURL.createOverspeedAlert,
      data,
    );
    return response.fold(
      (l) => throw l,
      (r) => r,
    );
  }

  Future<dynamic> getOverspeedAlerts(String imei) async {
    final response = await _apiServices.getGetApiResponse(
      ApiURL.getOverspeedAlerts(imei),
    );
    return response.fold(
      (l) => throw l,
      (r) => r,
    );
  }
}
