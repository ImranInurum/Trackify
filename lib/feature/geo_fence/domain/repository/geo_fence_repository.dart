import '../entity/geo_fence_entity.dart';

abstract class GeoFenceRepository {
  Future<List<GeoFenceEntity>> getGeoFences(String imei);
  Future<void> addGeoFence(GeoFenceEntity geoFence);
  Future<void> deleteGeoFence(String imei);
}
