import '../../../../core/utils/typedefs.dart';
import '../../data/entity/user_device_model.dart';

abstract interface class MapRepository {
  ResultFuture<UserDeviceList> getUserDevices(Map<String, dynamic> body);
}
