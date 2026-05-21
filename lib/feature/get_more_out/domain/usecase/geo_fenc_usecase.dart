import '../entities/geo_fence_intro_entity.dart';
import '../repository/geo_fenc_repository.dart';

class GetGeoFenceIntroUseCase {

  final GeoFenceIntroRepository
  repository;

  GetGeoFenceIntroUseCase(
      this.repository);

  Future<List<GeoFenceIntroEntity>> call(String categoryId) {

    return repository.getIntroSlides(categoryId);
  }
}