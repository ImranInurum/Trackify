// ===============================
// feature_data_source.dart
// ===============================

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/config/network/api_host.dart';
import '../models/feature_model.dart';

class FeatureDataSource {

  Future<List<FeatureModel>>
  getFeatures(String categoryId) async {

    final response = await http.get(

      Uri.parse(
        "${ApiURL.featureDetails}/$categoryId",
      ),
    );

    if (response.statusCode == 200) {

      final decodedData =
      jsonDecode(response.body);

      final List data =
      decodedData['data']['features'];

      return FeatureModel.fromList(data);

    } else {

      throw Exception(
        "Failed to fetch features",
      );
    }
  }
}