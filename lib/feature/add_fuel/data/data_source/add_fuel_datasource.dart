import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/feature/add_fuel/data/model/add_fuel_model.dart';

class AddFuelDataSource {

  Future<void> saveFuel(
      AddFuelModel model,
      ) async {

    // =========================
    // DEBUG
    // =========================

    print("=========== API HIT ===========");

    print("REQUEST BODY :");

    print(model.toMap());

    try {

      final response = await http.post(

        Uri.parse(ApiURL.addFuel),

        headers: {
          "Content-Type": "application/json",
        },

        body: jsonEncode(
          model.toMap(),
        ),
      );



      print("STATUS CODE : ${response.statusCode}");

      print("RESPONSE BODY : ${response.body}");



      if (response.statusCode != 200 &&
          response.statusCode != 201) {

        throw Exception(
          "Failed To Save Fuel",
        );
      }

    } catch (e) {

      print("API ERROR : $e");

      rethrow;
    }
  }

  Future<void> updateFuel(
      String refuelId,
      AddFuelModel model,
      ) async {
    print("=========== API HIT (UPDATE) ===========");
    print("REQUEST BODY :");
    print(model.toUpdateMap());

    try {
      final response = await http.put(
        Uri.parse(ApiURL.updateRefuelLog(refuelId)),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${ApiURL.authToken}',
        },
        body: jsonEncode(
          model.toUpdateMap(),
        ),
      );

      print("STATUS CODE : ${response.statusCode}");
      print("RESPONSE BODY : ${response.body}");

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("Failed To Update Fuel");
      }
    } catch (e) {
      print("API ERROR (UPDATE) : $e");
      rethrow;
    }
  }
}