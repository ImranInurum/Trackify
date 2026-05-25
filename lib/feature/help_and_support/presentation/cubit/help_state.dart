import '../../data/model/my_issue_model.dart';
import '../../data/model/suggestion_model.dart';


class HelpState {
  final bool isLoading;

  final List<MyIssueModel> issues;

  final List<MySuggestionModel> suggestions;

  final String? error;

  const HelpState({
    this.isLoading = false,
    this.issues = const [],
    this.suggestions = const [],
    this.error,
  });

  HelpState copyWith({
    bool? isLoading,
    List<MyIssueModel>? issues,
    List<MySuggestionModel>? suggestions,
    String? error,
  }) {
    return HelpState(
      isLoading: isLoading ?? this.isLoading,
      issues: issues ?? this.issues,
      suggestions: suggestions ?? this.suggestions,
      error: error,
    );
  }
}