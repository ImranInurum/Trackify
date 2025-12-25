import '../../../../core/utils/typedefs.dart';
import '../../data/entity/user_device_model.dart';
import '../repository/map_repository.dart';

class MapCase {
  final MapRepository mapRepository;
  MapCase(this.mapRepository);

  ResultFuture<UserDeviceList> fetchDeviceByUserId(Map<String, dynamic> body) {
    return mapRepository.getUserDevices(body);
  }
}
