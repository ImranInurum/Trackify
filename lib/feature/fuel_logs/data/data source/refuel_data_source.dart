import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trackify/core/config/network/api_host.dart';

import '../model/refuel_log_model.dart';

class RefuelDataSource {

  Future<List<RefuelLogModel>> getRefuelLogs(
      String imei
      ) async {

    final response = await http.get(
      Uri.parse(
        ApiURL.refuel(imei),
      ),
    );

    print("=========== REFUEL HISTORY API HIT ===========");
    print("STATUS CODE : ${response.statusCode}");
    print("RESPONSE BODY : ${response.body}");

    if (response.statusCode == 200) {

      final json = jsonDecode(response.body);

      final List data = json['data'] ?? [];

      // Create a brand-new RefuelLogModel for each JSON entry.
      // Each object is independent — no shared references.
      final List<RefuelLogModel> results = [];
      for (int i = 0; i < data.length; i++) {
        final Map<String, dynamic> entry = Map<String, dynamic>.from(data[i]);
        results.add(RefuelLogModel.fromJson(entry));
      }

      return results;

    } else {
      throw Exception('Failed to load refuel logs');
    }
  }
}