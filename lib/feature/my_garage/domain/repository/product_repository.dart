import 'package:trackify/feature/my_garage/domain/entities/product_entity.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getProduct();
}