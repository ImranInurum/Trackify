import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/config/network/api_host.dart';
import '../model/suggestion_model.dart';

class SuggestionRemoteDataSource {

  Future<Map<String, dynamic>> submitSuggestion({

    required SuggestionRequest request,
    required String token,

  }) async {

    try {

      print("Suggestion Request => ${jsonEncode(request.toJson())}");

      print("API HIT");
      print(jsonEncode(request.toJson()));

      final response = await http.post(

        Uri.parse(
          ApiURL.suggestion,
        ),

        headers: {

          "Content-Type": "application/json",

          "Authorization": "Bearer $token",
        },

        body: jsonEncode(
          request.toJson(),
        ),
      );

      final data = jsonDecode(response.body);

      print("Suggestion Response => ${response.body}");

      if (response.statusCode == 200 ||
          response.statusCode == 201) {

        return data;

      } else {

        throw Exception(
          data["message"] ??
              "Something went wrong",
        );
      }

    } catch (e) {

      throw Exception(
        e.toString(),
      );
    }
  }
}