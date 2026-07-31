import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/network_api_service.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:trackify/feature/add_fuel/data/model/add_fuel_model.dart';
import '../model/refuel_log_model.dart';

class RefuelDataSource {
  final NetworkApiService _apiServices = NetworkApiService();

  Future<List<RefuelLogModel>> getRefuelLogs(String imei) async {
    final unit = await AppPreference.instance.get(key: AppPreference.KEY_DISTANCE_UNIT);
    final response = await _apiServices.getGetApiResponse(
      ApiURL.refuel(imei, unit: unit.isNotEmpty ? unit : 'km'),
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

  Future<void> deleteRefuelLog(String vehicleId, String refuelId) async {
    final response = await _apiServices.getDeleteApiResponse(
      ApiURL.deleteRefuel(vehicleId, refuelId),
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

  Future<void> updateRefuelLog(String refuelId, AddFuelModel model) async {
    try {
      print("=========== UPDATE REFUEL API HIT ===========");
      print("REFUEL ID: $refuelId");
      print("REQUEST BODY: ${model.toUpdateMap()}");

      final response = await http.put(
        Uri.parse(ApiURL.updateRefuelLog(refuelId)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${ApiURL.authToken}',
        },
        body: jsonEncode(model.toUpdateMap()),
      );

      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE BODY: ${response.body}");

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to update refuel log: ${response.body}');
      }
    } catch (e) {
      print("UPDATE REFUEL ERROR: $e");
      rethrow;
    }
  }
}
