import '../entities/discover_entity.dart';

abstract class DiscoverRepository {

  Future<List<DiscoverEntity>> getDiscoverFeatures();
}