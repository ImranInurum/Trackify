// ===============================
// discover_cubit.dart
// ===============================

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecase/disover_usecase.dart';
import 'disocver_state.dart';

class DiscoverCubit extends Cubit<DiscoverState> {

  final GetDiscoverUseCase getDiscoverUseCase;

  DiscoverCubit(this.getDiscoverUseCase)
      : super(DiscoverInitial());

  Future<void> fetchDiscoverFeatures() async {

    try {

      emit(DiscoverLoading());

      final result = await getDiscoverUseCase();

      emit(DiscoverLoaded(result));

    } catch (e) {

      emit(
        DiscoverError(
          e.toString(),
        ),
      );
    }
  }
}