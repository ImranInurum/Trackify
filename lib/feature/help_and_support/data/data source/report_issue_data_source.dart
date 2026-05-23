import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trackify/core/config/network/api_host.dart';

import '../model/report_issue_model.dart';
import '../model/suggestion_model.dart';


class ReportIssueRemoteDataSource {

  Future<Map<String, dynamic>> submitIssue({

    required ReportIssueRequest request,
    required String token,

  }) async {

    try {

      final response = await http.post(

        Uri.parse(
          ApiURL.report,
        ),

        headers: {

          "Content-Type":
          "application/json",

          "Authorization":
          "Bearer $token",
        },

        body: jsonEncode(
          request.toJson(),
        ),
      );

      final data =
      jsonDecode(response.body);

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

  Future<Map<String, dynamic>> submitSuggestion({
    required SuggestionRequest request,
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiURL.report),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(request.toJson()),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return data;
      } else {
        throw Exception(
          data["message"] ?? "Something went wrong",
        );
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
