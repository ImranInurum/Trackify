import 'dart:io';
import 'package:trackify/core/utils/typedefs.dart';
import '../repository/service_logs_repository.dart';

class UpdateServiceLogUsecase {
  final ServiceLogsRepository _repository;

  UpdateServiceLogUsecase(this._repository);

  ResultVoid call({
    required String id,
    String? serviceDate,
    double? amount,
    File? image,
    String? centerName,
    String? note,
  }) {
    return _repository.updateServiceLog(
      id: id,
      serviceDate: serviceDate,
      amount: amount,
      image: image,
      centerName: centerName,
      note: note,
    );
  }
}
