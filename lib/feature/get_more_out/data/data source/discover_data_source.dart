// ===============================
// discover_remote_data_source.dart
// ===============================

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/network_api_service.dart';
import '../models/discover_model.dart';

class DiscoverDataSource {
  Future<List<DiscoverModel>> getDiscoverFeatures() async {
    final response = await NetworkApiService().getGetApiResponse(
      ApiURL.discover,
    );

    return response.fold(
      (failure) {
        throw Exception(failure.message);
      },
      (success) {
        if (success['success'] == true) {
          final List data = success['data'];
          return DiscoverModel.fromList(data);
        } else {
          throw Exception(success['message'] ?? "Failed to load discover features");
        }
      },
    );
  }
}