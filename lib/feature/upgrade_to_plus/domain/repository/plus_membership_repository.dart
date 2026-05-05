import '../entity/plus_membership_entity.dart';

abstract class PlusMembershipRepository {
  Future<PlusMembershipEntity> getPlusMembershipDetails();
  Future<void> upgradeToPlus();
}
