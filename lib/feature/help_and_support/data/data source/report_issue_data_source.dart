import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/base_api_service.dart';

import '../model/report_issue_model.dart';
import '../model/suggestion_model.dart';

class ReportIssueRemoteDataSource {
  final BaseApiServices _apiServices;

  ReportIssueRemoteDataSource(this._apiServices);

  Future<Map<String, dynamic>> submitIssue({
    required ReportIssueRequest request,
    required String token,
  }) async {
    ApiURL.updateAuthToken(token);
    final response = await _apiServices.getPostApiResponse(
      ApiURL.report,
      request.toJson(),
    );

    return response.fold(
      (l) => throw l,
      (r) => r as Map<String, dynamic>,
    );
  }

  Future<Map<String, dynamic>> submitSuggestion({
    required SuggestionRequest request,
    required String token,
  }) async {
    ApiURL.updateAuthToken(token);
    final response = await _apiServices.getPostApiResponse(
      ApiURL.suggestion,
      request.toJson(),
    );

    return response.fold(
      (l) => throw l,
      (r) => r as Map<String, dynamic>,
    );
  }
}
