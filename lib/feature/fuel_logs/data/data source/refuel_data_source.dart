import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/network_api_service.dart';

import '../model/refuel_log_model.dart';

class RefuelDataSource {
  final NetworkApiService _apiServices = NetworkApiService();

  Future<List<RefuelLogModel>> getRefuelLogs(String imei) async {
    final response = await _apiServices.getGetApiResponse(
      ApiURL.refuel(imei),
    );

    return response.fold(
      (l) => throw Exception('Failed to load refuel logs: ${l.message}'),
      (r) {
        print("=========== REFUEL HISTORY API HIT ===========");
        print("RESPONSE BODY : $r");
        
        final Map<String, dynamic> responseData = r as Map<String, dynamic>? ?? {};
        final List data = responseData['data'] ?? [];

        // Create a brand-new RefuelLogModel for each JSON entry.
        // Each object is independent — no shared references.
        final List<RefuelLogModel> results = [];
        for (int i = 0; i < data.length; i++) {
          final Map<String, dynamic> entry = Map<String, dynamic>.from(data[i]);
          results.add(RefuelLogModel.fromJson(entry));
        }

        return results;
      },
    );
  }

  Future<void> deleteRefuelLog(String imei, String refuelId) async {
    final response = await _apiServices.getDeleteApiResponse(
      ApiURL.deleteRefuel(imei, refuelId),
      {},
    );

    response.fold(
      (l) => throw Exception('Failed to delete refuel log: ${l.message}'),
      (r) {
        print("=========== DELETE REFUEL API HIT ===========");
        print("DELETE RESPONSE: $r");
      },
    );
  }
}