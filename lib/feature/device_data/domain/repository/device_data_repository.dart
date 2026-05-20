import 'package:trackify/core/utils/typedefs.dart';
import '../entity/current_plan_entity.dart';
import '../entity/recharge_plan_entity.dart';

abstract class DeviceDataRepository {
  ResultFuture<List<RechargePlanEntity>> getRechargePlans();
  ResultFuture<CurrentPlanEntity> getCurrentDataPlan(String imei);
}
