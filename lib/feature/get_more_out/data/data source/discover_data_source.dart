// ===============================
// discover_remote_data_source.dart
// ===============================

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trackify/core/config/network/api_host.dart';
import '../models/discover_model.dart';

class DiscoverDataSource {

  Future<List<DiscoverModel>> getDiscoverFeatures() async {

    final response = await http.get(
      Uri.parse(ApiURL.discover),
    );

    if (response.statusCode == 200) {

      final decodedData = jsonDecode(response.body);

      final List data = decodedData['data'];

      return DiscoverModel.fromList(data);

    } else {
      throw Exception("Failed to load discover features");
    }
  }
}