import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/config/network/api_host.dart';

import '../models/geo_fence_model.dart';

class GeoFenceIntroDataSource {
  Future<List<GeoFenceIntroModel>> getIntroSlides(
    String categoryId,
  ) async {
    final response = await http.get(
      Uri.parse(
        ApiURL.geoFenceIntro.replaceAll('{featureId}', categoryId),
      ),
    );

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);

      return GeoFenceIntroModel.fromApiResponse(
        decodedData,
      );
    } else {
      throw Exception(
        "Failed to fetch intro",
      );
    }
  }
}