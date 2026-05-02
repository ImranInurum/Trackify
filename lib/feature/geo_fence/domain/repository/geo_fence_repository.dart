import '../entity/geo_fence_entity.dart';

abstract class GeoFenceRepository {
  Future<List<GeoFenceEntity>> getGeoFences();
  Future<void> addGeoFence(GeoFenceEntity geoFence);
}
