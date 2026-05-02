import '../model/geo_fence_model.dart';

class GeoFenceRemoteDataSource {
  // In-memory list to act as a dummy database, starting empty
  static final List<GeoFenceModel> _dummyFences = [];

  Future<List<GeoFenceModel>> getGeoFences() async {
    // Simulating API call
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_dummyFences);
  }

  Future<void> addGeoFence(GeoFenceModel model) async {
    // Simulating API save
    await Future.delayed(const Duration(seconds: 1));
    _dummyFences.add(model);
  }
}