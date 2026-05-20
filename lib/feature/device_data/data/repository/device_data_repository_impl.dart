import 'package:fpdart/fpdart.dart';
import 'package:trackify/core/config/network/exceptions.dart';
import 'package:trackify/core/utils/typedefs.dart';
import '../../domain/entity/current_plan_entity.dart';
import '../../domain/entity/recharge_plan_entity.dart';
import '../../domain/repository/device_data_repository.dart';
import '../data_source/device_data_remote_data_source.dart';

class DeviceDataRepositoryImpl implements DeviceDataRepository {
  final DeviceDataRemoteDataSource remoteDataSource;

  DeviceDataRepositoryImpl(this.remoteDataSource);

  @override
  ResultFuture<List<RechargePlanEntity>> getRechargePlans() async {
    try {
      final models = await remoteDataSource.getRechargePlans();
      return Right(models);
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(FetchDataException(e.toString()));
    }
  }

  @override
  ResultFuture<CurrentPlanEntity> getCurrentDataPlan(String imei) async {
    try {
      final model = await remoteDataSource.getCurrentDataPlan(imei);
      return Right(model);
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(FetchDataException(e.toString()));
    }
  }
}
