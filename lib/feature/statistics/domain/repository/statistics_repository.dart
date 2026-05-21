import 'package:trackify/core/utils/typedefs.dart';
import '../../data/model/statistics_request_model.dart';
import '../../data/model/statistics_response_model.dart';

abstract class StatisticsRepository {
  ResultFuture<StatisticsResponseModel> getStatistics(
    StatisticsRequestModel request,
  );
}
