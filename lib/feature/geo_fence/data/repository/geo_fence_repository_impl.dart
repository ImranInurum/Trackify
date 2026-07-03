import '../../domain/entity/geo_fence_entity.dart';
import '../../domain/repository/geo_fence_repository.dart';
import '../data_source/geo_fence_remote_data_source.dart';
import '../model/geo_fence_model.dart';

class GeoFenceRepositoryImpl implements GeoFenceRepository {
  final GeoFenceRemoteDataSource remoteDataSource;

  GeoFenceRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<GeoFenceEntity>> getGeoFences(String imei) {
    return remoteDataSource.getGeoFences(imei);
  }

  @override
  Future<void> addGeoFence(GeoFenceEntity geoFence) {
    return remoteDataSource.addGeoFence(GeoFenceModel(
      id: geoFence.id,
      imei: geoFence.imei,
      name: geoFence.name,
      type: geoFence.type,
      latitude: geoFence.latitude,
      longitude: geoFence.longitude,
      radius: geoFence.radius,
      vehicleName: geoFence.vehicleName,
    ));
  }

  @override
  Future<void> editGeoFence(GeoFenceEntity geoFence) {
    return remoteDataSource.editGeoFence(GeoFenceModel(
      id: geoFence.id,
      imei: geoFence.imei,
      name: geoFence.name,
      type: geoFence.type,
      latitude: geoFence.latitude,
      longitude: geoFence.longitude,
      radius: geoFence.radius,
      vehicleName: geoFence.vehicleName,
    ));
  }

  @override
  Future<void> deleteGeoFence(String imei, String fenceId) {
    return remoteDataSource.deleteGeoFence(imei, fenceId);
  }
}
