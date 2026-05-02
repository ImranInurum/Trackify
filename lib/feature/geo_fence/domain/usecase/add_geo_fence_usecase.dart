import '../entity/geo_fence_entity.dart';
import '../repository/geo_fence_repository.dart';

class AddGeoFenceUseCase {
  final GeoFenceRepository repository;

  AddGeoFenceUseCase(this.repository);

  Future<void> call(GeoFenceEntity geoFence) {
    return repository.addGeoFence(geoFence);
  }
}
