import '../entities/product_entity.dart';
import '../repository/product_repository.dart';

class GetProductsUsecase {
  final ProductRepository repository;

  GetProductsUsecase(this.repository);

  Future<List<ProductEntity>> call() async {
    return await repository.getProduct();
  }
}