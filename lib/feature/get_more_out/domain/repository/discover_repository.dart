import '../entities/discover_entity.dart';

abstract class DiscoverRepository {

  List<DiscoverEntity>
  getDiscoverFeatures();
}