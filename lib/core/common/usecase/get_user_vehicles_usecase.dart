import 'package:trackify/core/common/models/vehicle_list_model.dart';
import 'package:trackify/core/common/repositories/common_repository.dart';
import 'package:trackify/core/utils/typedefs.dart';

class GetUserVehiclesUsecase {
  final CommonRepository repository;

  GetUserVehiclesUsecase(this.repository);

  ResultFuture<VehicleListResponse> call() {
    return repository.getUserVehicles();
  }
}
