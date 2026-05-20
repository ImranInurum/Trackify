import 'package:fpdart/fpdart.dart';
import 'package:trackify/core/config/network/exceptions.dart';
import 'package:trackify/core/utils/typedefs.dart';
import '../../domain/entities/device_warranty_entity.dart';
import '../../domain/repository/device_warranty_repository.dart';
import '../data_source/device_warranty_data_source.dart';

class DeviceWarrantyRepositoryImpl implements DeviceWarrantyRepository {
  final DeviceWarrantyRemoteDataSource remoteDataSource;

  DeviceWarrantyRepositoryImpl(this.remoteDataSource);

  @override
  ResultFuture<DeviceWarrantyEntity> getDeviceWarranty(String imei) async {
    try {
      final model = await remoteDataSource.getDeviceWarranty(imei);
      return Right(model);
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(FetchDataException(e.toString()));
    }
  }
}
