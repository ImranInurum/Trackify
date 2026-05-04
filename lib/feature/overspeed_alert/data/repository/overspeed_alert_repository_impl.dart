import 'package:fpdart/fpdart.dart';
import 'package:trackify/core/config/network/exceptions.dart';
import 'package:trackify/core/utils/typedefs.dart';
import '../../domain/repository/overspeed_alert_repository.dart';
import '../data_source/overspeed_alert_remote_data_source.dart';
import '../model/overspeed_alert_model.dart';

class OverspeedAlertRepositoryImpl implements OverspeedAlertRepository {
  final OverspeedAlertRemoteDataSource _remoteDataSource;

  OverspeedAlertRepositoryImpl(this._remoteDataSource);

  @override
  ResultFuture<String?> createOverspeedAlert({
    required String alertTitle,
    required int speedLimit,
    required int duration,
    required String imei,
  }) async {
    try {
      final data = {
        "alert_title": alertTitle,
        "speed_limit": speedLimit,
        "duration": duration,
        "imei": imei,
      };
      
      final response = await _remoteDataSource.createOverspeedAlert(data);
      return Right(response['message'] as String?);
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(FetchDataException(e.toString()));
    }
  }

  @override
  ResultFuture<List<OverspeedAlertModel>> getOverspeedAlerts(String imei) async {
    try {
      final response = await _remoteDataSource.getOverspeedAlerts(imei);
      final List data = response['data'] ?? [];
      final models = data.map((json) => OverspeedAlertModel.fromJson(json)).toList();
      return Right(models);
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(FetchDataException(e.toString()));
    }
  }
}
