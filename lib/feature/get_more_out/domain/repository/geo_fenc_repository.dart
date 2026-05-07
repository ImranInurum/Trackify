import '../entities/geo_fence_intro_entity.dart';

abstract class GeoFenceIntroRepository {

  List<GeoFenceIntroEntity>
  getIntroSlides();
}