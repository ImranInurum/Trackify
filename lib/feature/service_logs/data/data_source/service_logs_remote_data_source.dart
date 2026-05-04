import 'dart:io';
import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/base_api_service.dart';
import 'package:trackify/core/config/network/exceptions.dart';
import '../model/service_log_model.dart';

class ServiceLogsRemoteDataSource {
  final BaseApiServices _apiServices;

  ServiceLogsRemoteDataSource(this._apiServices);

  Future<List<ServiceLogModel>> getServiceLogs({
    String? vehicleId,
    String? imei,
    String? startDate,
    String? endDate,
  }) async {
    String url = ApiURL.serviceLogs;
    final Map<String, String> queryParams = {};
    
    if (vehicleId != null && vehicleId.isNotEmpty) queryParams['vehicle_id'] = vehicleId;
    if (imei != null && imei.isNotEmpty) queryParams['imei'] = imei;
    if (startDate != null && startDate.isNotEmpty) queryParams['start_date'] = startDate;
    if (endDate != null && endDate.isNotEmpty) queryParams['end_date'] = endDate;

    if (queryParams.isNotEmpty) {
      url += "?${Uri(queryParameters: queryParams).query}";
    }

    final response = await _apiServices.getGetApiResponse(url);
    
    return response.fold(
      (l) {
        if (l is NotFoundException) {
          return [];
        }
        throw l;
      },
      (r) {
        final List results = r['data'] ?? r['result'] ?? [];
        return results.map((e) => ServiceLogModel.fromJson(e)).toList();
      },
    );
  }

  Future<void> saveServiceLog(Map<String, dynamic> data) async {
    // If there's an image, use multipart.
    final imagePath = data['service_bill_image'] as String?;

    if (imagePath != null && imagePath.isNotEmpty && !imagePath.startsWith('http')) {
      final fields = <String, String>{};
      data.forEach((key, value) {
        if (key != 'service_bill_image' && value != null) {
          fields[key] = value.toString();
        }
      });

      final file = File(imagePath);
      final bytes = await file.readAsBytes();
      final fileName = imagePath.split(Platform.pathSeparator).last;

      final response = await _apiServices.getPostUploadMultiPartApiResponse(
        ApiURL.addServiceLogs,
        fields,
        bytes,
        fileName,
        'service_bill_image',
        'POST',
      );

      return response.fold(
        (l) => throw l,
        (r) => null,
      );
    } else {
      final response = await _apiServices.getPostApiResponse(ApiURL.addServiceLogs, data);
      return response.fold(
        (l) => throw l,
        (r) => null,
      );
    }
  }
}
