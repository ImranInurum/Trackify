import 'package:trackify/core/utils/typedefs.dart';

import '../../data/entity/assign_device_request.dart';


abstract class DeviceInstallationRepository {
  ResultFuture<dynamic> assignDevice(AssignDeviceRequest request);
  ResultFuture<bool> checkImeiAssigned(String imei);
}
