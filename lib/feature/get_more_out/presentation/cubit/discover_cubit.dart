import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecase/disover_usecase.dart';
import 'disocver_state.dart';



class DiscoverCubit extends Cubit<DiscoverState> {

  final GetDiscoverUseCase
  getDiscoverFeaturesUseCase;

  DiscoverCubit(
      this.getDiscoverFeaturesUseCase,
      ) : super(DiscoverInitial());

  void loadFeatures() {

    final data =
    getDiscoverFeaturesUseCase.call();

    emit(DiscoverLoaded(data));
  }
}