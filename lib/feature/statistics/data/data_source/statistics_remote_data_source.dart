import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/base_api_service.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import '../model/statistics_request_model.dart';

abstract class StatisticsRemoteDataSource {
  Future<dynamic> getStatistics(StatisticsRequestModel request);
}

class StatisticsRemoteDataSourceImpl implements StatisticsRemoteDataSource {
  final BaseApiServices _apiServices;

  StatisticsRemoteDataSourceImpl(this._apiServices);

  @override
  Future<dynamic> getStatistics(StatisticsRequestModel request) async {
    final unit = await AppPreference.instance.get(key: AppPreference.KEY_DISTANCE_UNIT);
    final response = await _apiServices.getGetApiResponse(
      ApiURL.statistics(request.imei, date: request.date, unit: unit.isNotEmpty ? unit : 'km'),
    );
    return response.fold((l) => throw l, (r) => r);
  }
}
