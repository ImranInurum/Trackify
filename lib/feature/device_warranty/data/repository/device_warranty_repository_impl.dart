import 'package:fpdart/fpdart.dart';
import 'package:trackify/core/config/network/exceptions.dart';
import 'package:trackify/core/utils/typedefs.dart';
import '../../domain/entities/device_warranty_entity.dart';
import '../../domain/entities/warranty_payment_summary_entity.dart';
import '../../domain/entities/extend_warranty_entity.dart';
import '../../domain/repository/device_warranty_repository.dart';
import '../data_source/device_warranty_data_source.dart';
import '../model/warranty_payment_summary_model.dart';
import '../model/extend_warranty_model.dart';
import '../model/warranty_status_model.dart';
import '../model/verify_payment_model.dart';

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

  @override
  ResultFuture<WarrantyPaymentSummaryEntity> getWarrantyPaymentSummary(
    WarrantyPaymentSummaryRequest request,
  ) async {
    try {
      final model = await remoteDataSource.getWarrantyPaymentSummary(request);
      return Right(model);
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(FetchDataException(e.toString()));
    }
  }

  @override
  ResultFuture<ExtendWarrantyEntity> extendWarranty(
    ExtendWarrantyRequest request,
  ) async {
    try {
      final model = await remoteDataSource.extendWarranty(request);
      return Right(model);
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(FetchDataException(e.toString()));
    }
  }

  @override
  ResultFuture<void> verifyPayment(VerifyPaymentRequest request) async {
    try {
      await remoteDataSource.verifyPayment(request);
      return const Right(null);
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(FetchDataException(e.toString()));
    }
  }

  @override
  ResultFuture<WarrantyStatusModel> getDeviceWarrantyStatus(String imei) async {
    try {
      final model = await remoteDataSource.getDeviceWarrantyStatus(imei);
      return Right(model);
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(FetchDataException(e.toString()));
    }
  }
}
