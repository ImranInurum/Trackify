import 'package:trackify/core/utils/typedefs.dart';
import '../../data/entity/assign_device_request.dart';
import '../repository/device_installation_repository.dart';

class AssignDeviceUseCase {
  final DeviceInstallationRepository _repository;

  AssignDeviceUseCase(this._repository);

  ResultFuture<dynamic> assignDevice({required AssignDeviceRequest request}) {
    return _repository.assignDevice(request);
  }

  ResultFuture<String?> checkImeiAssigned(String imei) {
    return _repository.checkImeiAssigned(imei);
  }
}
