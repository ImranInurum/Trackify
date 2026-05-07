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

  void loadSlides() {

    final slides =
    getGeoFenceIntroUseCase.call();

    emit(
      GeoFenceIntroLoaded(slides),
    );
  }
}