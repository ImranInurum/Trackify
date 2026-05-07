import '../../domain/entities/geo_fence_intro_entity.dart';

abstract class GeoFenceIntroState {}

class GeoFenceIntroInitial
    extends GeoFenceIntroState {}

class GeoFenceIntroLoaded
    extends GeoFenceIntroState {

  final List<GeoFenceIntroEntity>
  slides;

  GeoFenceIntroLoaded(this.slides);
}