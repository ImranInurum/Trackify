import 'dart:io';
import 'package:trackify/core/config/network/exceptions.dart';
import 'package:trackify/core/utils/typedefs.dart';
import '../entities/service_log_entity.dart';

abstract class ServiceLogsRepository {
  ResultFuture<List<ServiceLogEntity>> getServiceLogs({
    String? vehicleId,
    String? imei,
    String? startDate,
    String? endDate,
  });

  ResultVoid saveServiceLog({
    required String vehicleId,
    required String imei,
    required String serviceDate,
    required double amount,
    required List<File> images,
    String? centerName,
    String? contact,
    String? note,
  });
}
