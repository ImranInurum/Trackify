import 'package:trackify/feature/app_updates/data/data_source/update_remote_data.dart';
import 'package:trackify/feature/app_updates/domain/entity/update_entity.dart';
import 'package:trackify/feature/app_updates/domain/repositories/update_repositories.dart';

class UpdateRepositoryImpl implements UpdateRepository{
  final UpdateRemoteDataSource remoteDataSource;

  UpdateRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<UpdateEntity>> getUpdates(){
    return remoteDataSource.getUpdates();
  }

}