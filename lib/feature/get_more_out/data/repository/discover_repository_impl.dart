import '../../domain/entities/discover_entity.dart';
import '../../domain/repository/discover_repository.dart';
import '../local data/disover_local_data.dart';
import '../models/discover_model.dart';

class DiscoverRepositoryImpl
    implements DiscoverRepository {

  @override
  List<DiscoverEntity>
  getDiscoverFeatures() {

    return DiscoverLocalData
        .discoverItems
        .map(
          (e) =>
          DiscoverModel.fromMap(e),
    )
        .toList();
  }
}