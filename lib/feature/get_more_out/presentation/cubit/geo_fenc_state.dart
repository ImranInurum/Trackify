import '../../domain/entities/geo_fence_intro_entity.dart';

abstract class GeoFenceIntroState {}

class GeoFenceIntroInitial
    extends GeoFenceIntroState {}

class GeoFenceIntroLoading
    extends GeoFenceIntroState {}

class GeoFenceIntroLoaded
    extends GeoFenceIntroState {

  final List<GeoFenceIntroEntity>
  slides;

  GeoFenceIntroLoaded(this.slides);
}

class GeoFenceIntroError
    extends GeoFenceIntroState {

  final String message;

  GeoFenceIntroError(this.message);
}