import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/base_api_service.dart';
import '../model/current_plan_model.dart';
import '../model/recharge_plan_model.dart';

abstract class DeviceDataRemoteDataSource {
  Future<List<RechargePlanModel>> getRechargePlans();
  Future<CurrentPlanModel> getCurrentDataPlan(String imei);
}

class DeviceDataRemoteDataSourceImpl implements DeviceDataRemoteDataSource {
  final BaseApiServices _apiServices;

  DeviceDataRemoteDataSourceImpl(this._apiServices);

  @override
  Future<List<RechargePlanModel>> getRechargePlans() async {
    final response = await _apiServices.getGetApiResponse(ApiURL.getRechargePlans);
    return response.fold(
      (l) => throw l,
      (r) {
        final List data = r['data'] ?? [];
        return data.map((json) => RechargePlanModel.fromJson(json)).toList();
      },
    );
  }

  @override
  Future<CurrentPlanModel> getCurrentDataPlan(String imei) async {
    final response = await _apiServices.getGetApiResponse(
      ApiURL.getCurrentDataPlan(imei),
    );
    return response.fold(
      (l) => throw l,
      (r) {
        final data = r['data'] as Map<String, dynamic>? ?? {};
        return CurrentPlanModel.fromJson(data);
      },
    );
  }
}
