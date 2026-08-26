import 'package:fpdart/fpdart.dart';
import 'package:trackify/core/utils/typedefs.dart';
import 'package:trackify/core/config/network/exceptions.dart';
import '../../domain/repository/inventory_repository.dart';
import '../models/add_inventory_request.dart';
import '../data_source/inventory_remote_data_source.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryRemoteDataSource _remoteDataSource;

  InventoryRepositoryImpl(this._remoteDataSource);

  @override
  ResultFuture<String> addInventory(AddInventoryRequest request) async {
    try {
      final response = await _remoteDataSource.addInventory(request);
      return Right(response);
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(FetchDataException(e.toString()));
    }
  }
}
