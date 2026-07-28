import 'package:equatable/equatable.dart';
import 'package:trackify/feature/map/data/entity/product_feature_model.dart';

abstract class ProductFeatureState extends Equatable {
  const ProductFeatureState();

  @override
  List<Object> get props => [];
}

class ProductFeatureInitial extends ProductFeatureState {}

class ProductFeatureLoading extends ProductFeatureState {}

class ProductFeatureLoaded extends ProductFeatureState {
  final List<ProductFeatureModel> features;

  const ProductFeatureLoaded({required this.features});

  @override
  List<Object> get props => [features];
}

class ProductFeatureError extends ProductFeatureState {
  final String message;

  const ProductFeatureError(this.message);

  @override
  List<Object> get props => [message];
}
