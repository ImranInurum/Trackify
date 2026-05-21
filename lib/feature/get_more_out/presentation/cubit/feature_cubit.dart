// ===============================
// feature_cubit.dart
// ===============================

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecase/get_safey_usecase.dart';
import 'feature_state.dart';

class FeatureCubit
    extends Cubit<FeatureState> {

  final GetFeatureUseCase
  getFeatureUseCase;

  FeatureCubit(this.getFeatureUseCase)
      : super(FeatureInitial());

  Future<void>
  loadFeatures(String categoryId) async {

    try {

      emit(FeatureLoading());

      final items =
      await getFeatureUseCase(
        categoryId,
      );

      emit(
        FeatureLoaded(items),
      );

    } catch (e) {

      emit(
        FeatureError(
          e.toString(),
        ),
      );
    }
  }
}