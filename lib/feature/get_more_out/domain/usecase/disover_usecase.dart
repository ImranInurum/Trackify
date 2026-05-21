import '../entities/discover_entity.dart';
import '../repository/discover_repository.dart';

class GetDiscoverUseCase {

  final DiscoverRepository repository;

  GetDiscoverUseCase(
      this.repository,
      );

  Future<List<DiscoverEntity>> call() {

    return repository.getDiscoverFeatures();
  }
}