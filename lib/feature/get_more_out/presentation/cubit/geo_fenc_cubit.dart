import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecase/geo_fenc_usecase.dart';
import 'geo_fenc_state.dart';

class GeoFenceIntroCubit
    extends Cubit<GeoFenceIntroState> {

  final GetGeoFenceIntroUseCase
  getGeoFenceIntroUseCase;

  GeoFenceIntroCubit(
      this.getGeoFenceIntroUseCase)
      : super(GeoFenceIntroInitial());

  Future<void> loadSlides({
    required String categoryId,
  }) async {

    try {

      emit(GeoFenceIntroLoading());

      final slides =
      await getGeoFenceIntroUseCase(
        categoryId,
      );

      emit(
        GeoFenceIntroLoaded(slides),
      );

    } catch (e) {

      emit(
        GeoFenceIntroError(
          e.toString(),
        ),
      );
    }
  }
}