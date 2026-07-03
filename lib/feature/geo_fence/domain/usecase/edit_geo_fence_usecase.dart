import '../entity/geo_fence_entity.dart';
import '../repository/geo_fence_repository.dart';

class EditGeoFenceUseCase {
  final GeoFenceRepository repository;

  EditGeoFenceUseCase(this.repository);

  Future<void> call(GeoFenceEntity geoFence) {
    return repository.editGeoFence(geoFence);
  }
}
