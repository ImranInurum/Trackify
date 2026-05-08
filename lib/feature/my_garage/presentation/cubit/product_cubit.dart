import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repository_impl/product_repository_impl.dart';
import '../../domain/use_case/product_usecase.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {

  final GetProductsUsecase getProductsUsecase;

  ProductCubit(
      this.getProductsUsecase,
      ) : super(ProductInitial());


  void loadProducts() {

    final usecase = GetProductsUsecase(
      ProductRepositoryImpl(),
    );

    final data = usecase();

    emit(ProductLoaded(data));
  }
}