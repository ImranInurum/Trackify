import '../entities/feature_entity.dart';

abstract class FeatureRepository {

  Future<List<FeatureEntity>>
  getFeatures(String categoryId);
}