import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/base_api_service.dart';
import '../model/device_warranty_model.dart';
import '../model/warranty_payment_summary_model.dart';
import '../model/extend_warranty_model.dart';

abstract class DeviceWarrantyRemoteDataSource {
  Future<DeviceWarrantyModel> getDeviceWarranty(String imei);
  Future<WarrantyPaymentSummaryModel> getWarrantyPaymentSummary(
    WarrantyPaymentSummaryRequest request,
  );
  Future<ExtendWarrantyResponseModel> extendWarranty(
    ExtendWarrantyRequest request,
  );
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

  @override
  Future<WarrantyPaymentSummaryModel> getWarrantyPaymentSummary(
    WarrantyPaymentSummaryRequest request,
  ) async {
    final response = await _apiServices.getGetApiResponse(
      ApiURL.getWarrantyPaymentSummary(request.imei, request.planId),
    );
    return response.fold(
      (l) => throw l,
      (r) {
        final Map<String, dynamic> responseData = r as Map<String, dynamic>? ?? {};
        final Map<String, dynamic> data = responseData['data'] as Map<String, dynamic>? ?? {};
        return WarrantyPaymentSummaryModel.fromJson(data);
      },
    );
  }

  @override
  Future<ExtendWarrantyResponseModel> extendWarranty(
    ExtendWarrantyRequest request,
  ) async {
    final response = await _apiServices.getPostApiResponse(
      ApiURL.extendWarranty,
      request.toJson(),
    );
    return response.fold(
      (l) => throw l,
      (r) {
        final Map<String, dynamic> responseData = r as Map<String, dynamic>? ?? {};
        final Map<String, dynamic> data = responseData['data'] as Map<String, dynamic>? ?? {};
        return ExtendWarrantyResponseModel.fromJson(data);
      },
    );
  }
}
