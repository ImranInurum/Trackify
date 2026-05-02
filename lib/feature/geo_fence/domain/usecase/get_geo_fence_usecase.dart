import '../entity/geo_fence_entity.dart';
import '../repository/geo_fence_repository.dart';

class GetGeoFenceUseCase {
  final GeoFenceRepository repository;

  GetGeoFenceUseCase(this.repository);

  Future<List<GeoFenceEntity>> call() {
    return repository.getGeoFences();
  }
}
