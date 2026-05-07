import '../entities/geo_fence_intro_entity.dart';
import '../repository/geo_fenc_repository.dart';

class GetGeoFenceIntroUseCase {

  final GeoFenceIntroRepository
  repository;

  GetGeoFenceIntroUseCase(
      this.repository);

  List<GeoFenceIntroEntity> call() {

    return repository.getIntroSlides();
  }
}