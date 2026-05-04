import '../repository/geo_fence_repository.dart';

class DeleteGeoFenceUseCase {
  final GeoFenceRepository _repository;

  DeleteGeoFenceUseCase(this._repository);

  Future<void> call(String imei) async {
    return await _repository.deleteGeoFence(imei);
  }
}
