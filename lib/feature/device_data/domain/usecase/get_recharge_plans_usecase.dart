import 'package:trackify/core/utils/typedefs.dart';
import '../entity/recharge_plan_entity.dart';
import '../repository/device_data_repository.dart';

class GetRechargePlansUseCase {
  final DeviceDataRepository repository;

  GetRechargePlansUseCase(this.repository);

  ResultFuture<List<RechargePlanEntity>> call() {
    return repository.getRechargePlans();
  }
}
