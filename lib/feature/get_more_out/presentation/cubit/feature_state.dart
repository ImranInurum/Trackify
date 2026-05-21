import '../../domain/entities/feature_entity.dart';

abstract class FeatureState {}

class FeatureInitial
    extends FeatureState {}

class FeatureLoading
    extends FeatureState {}

class FeatureLoaded
    extends FeatureState {

  final List<FeatureEntity> items;

  FeatureLoaded(this.items);
}

class FeatureError
    extends FeatureState {

  final String message;

  FeatureError(this.message);
}