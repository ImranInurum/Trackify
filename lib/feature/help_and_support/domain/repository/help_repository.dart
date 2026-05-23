

import '../../data/model/my_issue_model.dart';
import '../../data/model/suggestion_model.dart';

abstract class HelpRepository {
  Future<List<MyIssueModel>> getMyIssues();

  Future<List<MySuggestionModel>>
  getMySuggestions();
}