import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/base_api_service.dart';
import 'package:trackify/core/config/network/exceptions.dart';
import '../model/geo_fence_model.dart';

class GeoFenceRemoteDataSource {
  final BaseApiServices _apiServices;

  GeoFenceRemoteDataSource(this._apiServices);

  Future<List<GeoFenceModel>> getGeoFences(String imei) async {
    final response = await _apiServices.getGetApiResponse(ApiURL.getGeoFenceData(imei));
    
    return response.fold(
      (l) {
        if (l is NotFoundException) {
          return [];
        }
        throw l;
      },
      (r) {
        final List results = r['result'] ?? [];
        return results.map((e) => GeoFenceModel.fromJson(e)).toList();
      },
    );
  }

  Future<void> addGeoFence(GeoFenceModel model) async {
    final response = await _apiServices.getPostApiResponse(
      ApiURL.updateGeoFence,
      model.toJson(),
    );

    return response.fold(
      (l) => throw l,
      (r) => null,
    );
  }

  Future<void> editGeoFence(GeoFenceModel model) async {
    final response = await _apiServices.getPutApiResponse(
      ApiURL.editGeoFenceById(model.id),
      model.toJson(),
    );

    return response.fold(
      (l) => throw l,
      (r) => null,
    );
  }

  Future<void> deleteGeoFence(String imei, String fenceId) async {
    final response = await _apiServices.getDeleteApiResponse(
      ApiURL.deleteGeoFence(imei, fenceId),
      {},
    );

    return response.fold(
      (l) => throw l,
      (r) => null,
    );
  }
}