import 'package:trackify/feature/app_updates/domain/entity/update_entity.dart';
import 'package:trackify/feature/app_updates/domain/repositories/update_repositories.dart';

class GetUpdateUseCase {
  final UpdateRepository repository;

  GetUpdateUseCase(this.repository);

  Future<List<UpdateEntity>> call(){
    return  repository.getUpdates();
  }
}