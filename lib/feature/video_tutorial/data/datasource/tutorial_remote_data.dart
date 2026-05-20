import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/feature/video_tutorial/data/model/tutorial_model.dart';

class TutorialRemoteData {

  Future<List<TutorialModel>> fetchTutorial(
      String categoryId) async {

    final uri = Uri.parse(
      ApiURL.tutorial,
    ).replace(
      queryParameters: {
        "category_id": categoryId,
      },
    );

    final response = await http.get(uri);

    final body = jsonDecode(response.body);

    final List data = body['data'];

    return data
        .map((e) => TutorialModel.fromJson(e))
        .toList();
  }
}