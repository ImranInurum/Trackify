import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/base_api_service.dart';
import '../model/device_warranty_model.dart';

abstract class DeviceWarrantyRemoteDataSource {
  Future<DeviceWarrantyModel> getDeviceWarranty(String imei);
}

class DeviceWarrantyRemoteDataSourceImpl implements DeviceWarrantyRemoteDataSource {
  final BaseApiServices _apiServices;

  DeviceWarrantyRemoteDataSourceImpl(this._apiServices);

  @override
  Future<DeviceWarrantyModel> getDeviceWarranty(String imei) async {
    final response = await _apiServices.getGetApiResponse(
      ApiURL.getDeviceWarranty(imei),
    );
    return response.fold(
      (l) => throw l,
      (r) {
        final Map<String, dynamic> responseData = r as Map<String, dynamic>? ?? {};
        final Map<String, dynamic> data = responseData['data'] as Map<String, dynamic>? ?? {};
        return DeviceWarrantyModel.fromJson(data);
      },
    );
  }
}
