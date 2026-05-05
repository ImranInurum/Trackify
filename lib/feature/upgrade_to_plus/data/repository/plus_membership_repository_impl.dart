import '../../domain/entity/plus_membership_entity.dart';
import '../../domain/repository/plus_membership_repository.dart';
import '../data_source/plus_membership_remote_data_source.dart';

class PlusMembershipRepositoryImpl implements PlusMembershipRepository {
  final PlusMembershipRemoteDataSource remoteDataSource;

  PlusMembershipRepositoryImpl(this.remoteDataSource);

  @override
  Future<PlusMembershipEntity> getPlusMembershipDetails() async {
    return await remoteDataSource.getPlusMembershipDetails();
  }

  @override
  Future<void> upgradeToPlus() async {
    return await remoteDataSource.upgradeToPlus();
  }
}
