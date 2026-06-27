import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/network_api_service.dart';

import 'package:trackify/feature/fuel_logs/data/model/fuel_log_calculation_model.dart';

class FuelLogDataSource {
  final NetworkApiService _apiServices = NetworkApiService();

  Future<FuelCalculationModel> getFuelCalculation(String imei) async {
    final response = await _apiServices.getGetApiResponse(
      ApiURL.dashboard(imei),
    );

    return response.fold(
      (l) => throw Exception("Failed To Fetch Fuel Logs: ${l.message}"),
      (r) {
        print("FUEL LOG API HIT");
        print(r);
        
        final Map<String, dynamic> responseData = r as Map<String, dynamic>? ?? {};
        return FuelCalculationModel.fromJson(responseData);
      },
    );
  }
}