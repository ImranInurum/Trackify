import 'package:trackify/feature/my_garage/domain/entities/product_entity.dart';

abstract class ProductState{}

class ProductInitial extends ProductState{}

class ProductLoaded extends ProductState{
 final List<ProductEntity> product;

 ProductLoaded(this.product);
 
}