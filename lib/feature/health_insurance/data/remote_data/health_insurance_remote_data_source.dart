import 'package:trackify/core/config/network/base_api_service.dart';
import 'package:trackify/core/config/network/api_host.dart';
import '../model/health_insurance_model.dart';
import '../model/save_health_insurance_model.dart';

class HealthInsuranceRemoteDataSource {
  final BaseApiServices _apiServices;

  HealthInsuranceRemoteDataSource(this._apiServices);

  /// Fetches the list of health insurance options from the API.
  Future<List<HealthInsuranceOptionModel>> getHealthInsuranceOptions() async {
    final response = await _apiServices.getGetApiResponse(
      ApiURL.healthInsuranceOptions,
    );
    return response.fold((l) => throw l, (r) {
      final Map<String, dynamic> responseData = r as Map<String, dynamic>? ?? {};
      final List<dynamic> data = responseData['data'] as List<dynamic>? ?? [];
      return data
          .map((e) => HealthInsuranceOptionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    });
  }

  /// Saves the health insurance details via the API.
  Future<SaveHealthInsuranceResponseModel> saveHealthInsurance(
    SaveHealthInsuranceRequest request,
  ) async {
    final response = await _apiServices.getPostApiResponse(
      ApiURL.saveHealthInsurance,
      request.toJson(),
    );
    return response.fold((l) => throw l, (r) {
      final Map<String, dynamic> responseData = r as Map<String, dynamic>? ?? {};
      final Map<String, dynamic> data = responseData['data'] as Map<String, dynamic>? ?? {};
      return SaveHealthInsuranceResponseModel.fromJson(data);
    });
  }
}
