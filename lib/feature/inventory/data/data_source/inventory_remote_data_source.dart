import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/base_api_service.dart';
import '../models/add_inventory_request.dart';

abstract class InventoryRemoteDataSource {
  Future<String> addInventory(AddInventoryRequest request);
}

class InventoryRemoteDataSourceImpl implements InventoryRemoteDataSource {
  final BaseApiServices _apiServices;

  InventoryRemoteDataSourceImpl(this._apiServices);

  @override
  Future<String> addInventory(AddInventoryRequest request) async {
    final response = await _apiServices.getPostApiResponse(
      '${ApiURL.baseURL}/api/inventory/add-single',
      request.toJson(),
    );
    
    return response.fold(
      (l) => throw l,
      (r) {
        // Handle the dynamic response and return a message
        return r['message']?.toString() ?? 'Inventory added successfully';
      },
    );
  }
}
