import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:trackify/core/config/network/exceptions.dart';
import 'package:trackify/core/utils/typedefs.dart';
import '../../domain/entities/service_log_entity.dart';
import '../../domain/repository/service_logs_repository.dart';
import '../data_source/service_logs_remote_data_source.dart';
import '../model/service_log_model.dart';

class ServiceLogsRepositoryImpl implements ServiceLogsRepository {
  final ServiceLogsRemoteDataSource _remoteDataSource;

  ServiceLogsRepositoryImpl(this._remoteDataSource);

  @override
  ResultFuture<List<ServiceLogEntity>> getServiceLogs({
    String? vehicleId,
    String? imei,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final models = await _remoteDataSource.getServiceLogs(
        vehicleId: vehicleId,
        imei: imei,
        startDate: startDate,
        endDate: endDate,
      );
      return Right(models);
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(FetchDataException(e.toString()));
    }
  }

  @override
  ResultVoid saveServiceLog({
    required String vehicleId,
    required String imei,
    required String serviceDate,
    required double amount,
    required List<File> images,
    String? centerName,
    String? contact,
    String? note,
  }) async {
    try {
      final model = ServiceLogModel(
        vehicleId: vehicleId,
        imei: imei,
        serviceDate: serviceDate,
        amount: amount,
        centerName: centerName,
        contact: contact,
        note: note,
        billImages: images.map((e) => e.path).toList(),
      );
      await _remoteDataSource.saveServiceLog(model.toJson());
      return const Right(null);
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(FetchDataException(e.toString()));
    }
  }

  @override
  ResultVoid updateServiceLog({
    required String id,
    String? serviceDate,
    double? amount,
    File? image,
    String? centerName,
    String? note,
  }) async {
    try {
      final Map<String, dynamic> data = {};
      if (serviceDate != null) data['service_date'] = serviceDate;
      if (amount != null) data['billing_amount'] = amount;
      if (centerName != null) data['service_center_name'] = centerName;
      if (note != null) data['additional_note'] = note;
      if (image != null) data['service_bill_image'] = image.path;

      await _remoteDataSource.updateServiceLog(id, data);
      return const Right(null);
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(FetchDataException(e.toString()));
    }
  }

  @override
  ResultVoid deleteServiceLog(String id) async {
    try {
      await _remoteDataSource.deleteServiceLog(id);
      return const Right(null);
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(FetchDataException(e.toString()));
    }
  }
}
