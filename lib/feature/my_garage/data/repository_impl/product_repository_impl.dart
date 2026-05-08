import '../../domain/entities/product_entity.dart';
import '../../domain/repository/product_repository.dart';
import '../local data/product_local_data.dart';
import '../model/product model.dart';

class ProductRepositoryImpl implements ProductRepository {

  @override
  List<ProductEntity> getProduct() {
    return ProductLocalData.products
        .map((e) => ProductModel.fromJson(e))
        .toList();
  }


}