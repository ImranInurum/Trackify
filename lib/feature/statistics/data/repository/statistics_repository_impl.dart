import 'package:fpdart/fpdart.dart';
import 'package:trackify/core/config/network/exceptions.dart';
import 'package:trackify/core/utils/typedefs.dart';
import '../../domain/repository/statistics_repository.dart';
import '../data_source/statistics_remote_data_source.dart';
import '../model/statistics_request_model.dart';
import '../model/statistics_response_model.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  final StatisticsRemoteDataSource _remoteDataSource;

  StatisticsRepositoryImpl(this._remoteDataSource);

  @override
  ResultFuture<StatisticsResponseModel> getStatistics(
    StatisticsRequestModel request,
  ) async {
    try {
      final response = await _remoteDataSource.getStatistics(request);
      final model = StatisticsResponseModel.fromJson(response);
      return Right(model);
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(FetchDataException(e.toString()));
    }
  }
}
