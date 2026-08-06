import 'package:trackify/core/utils/typedefs.dart';
import '../entities/service_log_entity.dart';
import '../repository/service_logs_repository.dart';

class GetServiceLogsUsecase {
  final ServiceLogsRepository _repository;

  GetServiceLogsUsecase(this._repository);

  ResultFuture<List<ServiceLogEntity>> call({
    String? vehicleId,
    String? imei,
    String? startDate,
    String? endDate,
  }) {
    return _repository.getServiceLogs(
      vehicleId: vehicleId,
      imei: imei,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
