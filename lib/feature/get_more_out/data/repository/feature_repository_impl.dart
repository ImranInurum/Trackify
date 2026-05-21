import '../../domain/entities/feature_entity.dart';
import '../../domain/repository/feature_repository.dart';
import '../data source/feature_local_data.dart';

class FeatureRepositoryImpl
    implements FeatureRepository {

  final FeatureDataSource dataSource;

  FeatureRepositoryImpl(this.dataSource);

  @override
  Future<List<FeatureEntity>>
  getFeatures(String categoryId) async {

    return await dataSource
        .getFeatures(categoryId);
  }
}