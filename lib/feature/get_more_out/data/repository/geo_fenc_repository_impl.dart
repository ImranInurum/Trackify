import '../data source/geo_fence_local_data.dart';
import '../../domain/entities/geo_fence_intro_entity.dart';

import '../../domain/repository/geo_fenc_repository.dart';

class GeoFenceIntroRepositoryImpl implements GeoFenceIntroRepository {
  final GeoFenceIntroDataSource remoteDataSource;

  GeoFenceIntroRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<GeoFenceIntroEntity>> getIntroSlides(String categoryId) async {
    return await remoteDataSource.getIntroSlides(categoryId);
  }
}
