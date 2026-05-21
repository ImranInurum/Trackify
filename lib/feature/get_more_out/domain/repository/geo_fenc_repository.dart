import '../entities/geo_fence_intro_entity.dart';

abstract class GeoFenceIntroRepository {

  Future<List<GeoFenceIntroEntity>>
  getIntroSlides(String categoryId);
}