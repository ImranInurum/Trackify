import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/data source/suggestion_data_source.dart';
import '../../data/model/report_issue_model.dart';
import '../../data/model/suggestion_model.dart';
part 'suggestion_state.dart';

class SuggestionCubit
    extends Cubit<SuggestionState> {

  final SuggestionRemoteDataSource
  remoteDataSource;

  SuggestionCubit(
      this.remoteDataSource,
      ) : super(
    SuggestionInitial(),

  );


  Future<void> submitSuggestion({


    required SuggestionRequest request,
    required String token,

  }) async {

    try {
      print("INSIDE SUBMIT SUGGESTION");

      emit(
        SuggestionLoading(),
      );

      final response =
      await remoteDataSource
          .submitSuggestion(

        request: request,
        token: token,
      );

      emit(
        SuggestionSuccess(
          response["message"],
        ),
      );

    } catch (e) {

      emit(
        SuggestionError(
          e.toString(),
        ),
      );
    }
  }
}