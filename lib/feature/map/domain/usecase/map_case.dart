import 'package:trackify/feature/map/data/entity/user_vehicles.dart';

import '../../../../core/utils/typedefs.dart';
import '../repository/map_repository.dart';

class MapCase {
  final MapRepository mapRepository;
  MapCase(this.mapRepository);

  ResultFuture<UserVehicles> fetchVehiclesByUserId() {
    return mapRepository.getUserVehicles();
  }
}
