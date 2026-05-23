import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/network_api_service.dart';
import 'package:trackify/core/utils/shared_preferences.dart';

import '../../domain/repository/help_repository.dart';
import '../model/my_issue_model.dart';
import '../model/suggestion_model.dart';

class HelpRepositoryImpl implements HelpRepository {
  final NetworkApiService _apiService = NetworkApiService();

  @override
  Future<List<MyIssueModel>> getMyIssues() async {
    final userId = await AppPreference.instance.get(key: AppPreference.KEY_USER_ID);

    final result = await _apiService.getGetApiResponse(
      "${ApiURL.myIssue}/$userId",
    );

    return result.fold(
      (exception) => throw exception,
      (response) {
        if (response is Map && response.containsKey('data')) {
          final List data = response['data'] ?? [];
          return data.map((e) => MyIssueModel.fromJson(e)).toList();
        } else {
          return [];
        }
      },
    );
  }

  @override
  Future<List<MySuggestionModel>> getMySuggestions() async {
    final userId = await AppPreference.instance.get(key: AppPreference.KEY_USER_ID);

    final result = await _apiService.getGetApiResponse(
      "${ApiURL.mySuggestions}/$userId",
    );
    return result.fold(
      (exception) => throw exception,
      (response) {
        if (response is Map && response.containsKey('data')) {
          final List data = response['data'] ?? [];
          return data.map((e) => MySuggestionModel.fromJson(e)).toList();
        } else {
          return [];
        }
      },
    );
  }
}