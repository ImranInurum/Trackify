import '../entities/feature_entity.dart';
import '../repository/feature_repository.dart';

class GetFeatureUseCase {

  final FeatureRepository repository;

  GetFeatureUseCase(this.repository);

  Future<List<FeatureEntity>>
  call(String categoryId) async {

    return await repository
        .getFeatures(categoryId);
  }
}