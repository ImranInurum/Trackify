import 'dart:io';
import 'package:trackify/core/utils/typedefs.dart';
import '../repository/service_logs_repository.dart';

class SaveServiceLogUsecase {
  final ServiceLogsRepository _repository;

  SaveServiceLogUsecase(this._repository);

  ResultVoid call({
    required String vehicleId,
    required String imei,
    required String serviceDate,
    required double amount,
    required List<File> images,
    String? centerName,
    String? contact,
    String? note,
  }) {
    return _repository.saveServiceLog(
      vehicleId: vehicleId,
      imei: imei,
      serviceDate: serviceDate,
      amount: amount,
      images: images,
      centerName: centerName,
      contact: contact,
      note: note,
    );
  }
}
