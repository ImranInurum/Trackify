import 'package:trackify/core/utils/typedefs.dart';
import '../entity/current_plan_entity.dart';
import '../repository/device_data_repository.dart';

class GetCurrentDataPlanUseCase {
  final DeviceDataRepository repository;

  GetCurrentDataPlanUseCase(this.repository);

  ResultFuture<CurrentPlanEntity> call(String imei) {
    return repository.getCurrentDataPlan(imei);
  }
}
