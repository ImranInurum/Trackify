import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trackify/core/config/network/api_host.dart';

import 'package:trackify/feature/fuel_logs/data/model/fuel_log_calculation_model.dart';

class FuelLogDataSource {

  Future<FuelCalculationModel>
  getFuelCalculation(
      String imei,
      ) async {

    final response = await http.get(

      Uri.parse(
        ApiURL.dashboard(imei),
      ),
    );

    print("FUEL LOG API HIT");

    print(response.body);

    if (response.statusCode == 200) {

      return FuelCalculationModel.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      "Failed To Fetch Fuel Logs",
    );
  }
}