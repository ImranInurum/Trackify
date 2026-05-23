part of 'suggestion_cubit.dart';

abstract class SuggestionState {}

class SuggestionInitial
    extends SuggestionState {}

class SuggestionLoading
    extends SuggestionState {}

class SuggestionSuccess
    extends SuggestionState {

  final String message;

  SuggestionSuccess(
      this.message,
      );
}

class SuggestionError
    extends SuggestionState {

  final String error;

  SuggestionError(
      this.error,
      );
}