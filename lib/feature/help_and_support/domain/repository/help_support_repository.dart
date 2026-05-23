import '../../data/data source/report_issue_data_source.dart';
import '../../data/model/report_issue_model.dart';
import '../../data/model/suggestion_model.dart';

class ReportIssueRepository {

  final ReportIssueRemoteDataSource
  remoteDataSource;

  ReportIssueRepository(
      this.remoteDataSource,
      );

  Future<Map<String, dynamic>>
  submitIssue({

    required ReportIssueRequest request,
    required String token,

  }) async {

    return await remoteDataSource
        .submitIssue(
      request: request,
      token: token,
    );
  }

  Future<Map<String, dynamic>> submitSuggestion({
    required SuggestionRequest request,
    required String token,
  }) async {
    return await remoteDataSource.submitSuggestion(
      request: request,
      token: token,
    );
  }
}
