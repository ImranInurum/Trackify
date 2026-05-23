import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repository/help_repository.dart';
import 'help_state.dart';

class HelpCubit extends Cubit<HelpState> {
  final HelpRepository repository;

  HelpCubit(this.repository)
      : super(const HelpState());

  Future<void> getMyIssues() async {
    emit(
      state.copyWith(
        isLoading: true,
        error: null,
      ),
    );

    try {
      final issues =
      await repository.getMyIssues();

      emit(
        state.copyWith(
          isLoading: false,
          issues: issues,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> getMySuggestions() async {
    emit(
      state.copyWith(
        isLoading: true,
        error: null,
      ),
    );

    try {
      final suggestions =
      await repository.getMySuggestions();

      emit(
        state.copyWith(
          isLoading: false,
          suggestions: suggestions,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e.toString(),
        ),
      );
    }
  }
}