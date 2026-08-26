import 'package:trackify/core/utils/typedefs.dart';
import '../../data/models/add_inventory_request.dart';

abstract class InventoryRepository {
  ResultFuture<String> addInventory(AddInventoryRequest request);
}
