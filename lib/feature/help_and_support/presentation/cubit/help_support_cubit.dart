import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/suggestion_model.dart';
import '../../domain/repository/help_support_repository.dart';
import '../../data/model/report_issue_model.dart';

part 'help_support_state.dart';



class ReportIssueCubit
    extends Cubit<ReportIssueState> {

  final ReportIssueRepository
  repository;

  ReportIssueCubit(
      this.repository,
      ) : super(
    ReportIssueInitial(),
  );

  Future<void> submitIssue({

    required ReportIssueRequest request,
    required String token,

  }) async {

    try {

      emit(
        ReportIssueLoading(),
      );

      final response =
      await repository
          .submitIssue(

        request: request,
        token: token,
      );

      emit(
        ReportIssueSuccess(
          response["message"]?.toString() ?? "Issue submitted successfully",
        ),
      );

    } catch (e) {
      emit(
        ReportIssueError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> submitSuggestion({
    required SuggestionRequest request,
    required String token,
  }) async {
    try {
      emit(ReportIssueLoading());
      final response = await repository.submitSuggestion(
        request: request,
        token: token,
      );
      emit(ReportIssueSuccess(
          response["message"]?.toString() ?? "Suggestion submitted successfully"));
    } catch (e) {
      emit(ReportIssueError(e.toString()));
    }
  }
}
