import 'package:trackify/core/utils/typedefs.dart';
import '../../data/models/add_inventory_request.dart';
import '../repository/inventory_repository.dart';

class AddInventoryUseCase {
  final InventoryRepository repository;

  AddInventoryUseCase(this.repository);

  ResultFuture<String> call(AddInventoryRequest request) {
    return repository.addInventory(request);
  }
}
