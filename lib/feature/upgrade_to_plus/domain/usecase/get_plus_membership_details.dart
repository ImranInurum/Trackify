import '../entity/plus_membership_entity.dart';
import '../repository/plus_membership_repository.dart';

class GetPlusMembershipDetails {
  final PlusMembershipRepository repository;

  GetPlusMembershipDetails(this.repository);

  Future<PlusMembershipEntity> call() async {
    return await repository.getPlusMembershipDetails();
  }
}
