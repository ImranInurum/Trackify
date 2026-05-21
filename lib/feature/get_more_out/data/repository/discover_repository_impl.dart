import '../../domain/entities/discover_entity.dart';
import '../../domain/repository/discover_repository.dart';
import '../data source/discover_data_source.dart';

class DiscoverRepositoryImpl
    implements DiscoverRepository {

  final DiscoverDataSource dataSource;

  DiscoverRepositoryImpl(this.dataSource);

  @override
  Future<List<DiscoverEntity>>
  getDiscoverFeatures() async {

    return await dataSource
        .getDiscoverFeatures();
  }
}