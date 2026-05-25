part of 'help_support_cubit.dart';

abstract class ReportIssueState {}

class ReportIssueInitial
    extends ReportIssueState {}

class ReportIssueLoading
    extends ReportIssueState {}

class ReportIssueSuccess
    extends ReportIssueState {

  final String message;

  ReportIssueSuccess(
      this.message,
      );
}

class ReportIssueError
    extends ReportIssueState {

  final String error;

  ReportIssueError(
      this.error,
      );
}