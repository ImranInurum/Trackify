import 'package:trackify/core/utils/typedefs.dart';
import '../entities/device_warranty_entity.dart';
import '../repository/device_warranty_repository.dart';

class GetDeviceWarrantyUseCase {
  final DeviceWarrantyRepository repository;

  GetDeviceWarrantyUseCase(this.repository);

  ResultFuture<DeviceWarrantyEntity> call(String imei) {
    return repository.getDeviceWarranty(imei);
  }
}
