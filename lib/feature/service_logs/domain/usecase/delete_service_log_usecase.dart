import 'package:trackify/core/utils/typedefs.dart';
import '../repository/service_logs_repository.dart';

class DeleteServiceLogUsecase {
  final ServiceLogsRepository _repository;

  DeleteServiceLogUsecase(this._repository);

  ResultVoid call(String id) {
    return _repository.deleteServiceLog(id);
  }
}
