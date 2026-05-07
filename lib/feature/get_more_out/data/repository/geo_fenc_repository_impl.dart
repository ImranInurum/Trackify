import '../../domain/entities/geo_fence_intro_entity.dart';

import '../../domain/repository/geo_fenc_repository.dart';

import '../local data/geo_fence_local_data.dart';
import '../models/geo_fence_model.dart';

class GeoFenceIntroRepositoryImpl
    implements GeoFenceIntroRepository {

  @override
  List<GeoFenceIntroEntity>
  getIntroSlides() {

    return GeoFenceIntroLocalData
        .introSlides
        .map(
          (e) =>
          GeoFenceIntroModel.fromMap(e),
    )
        .toList();
  }
}