import '../entities/product_entity.dart';
import '../repository/product_repository.dart';

class GetProductsUsecase {
  final ProductRepository repository;

  GetProductsUsecase(this.repository);

  List<ProductEntity> call() {
    return repository.getProduct();
  }
}