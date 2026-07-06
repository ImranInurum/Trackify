import 'package:trackify/core/utils/typedefs.dart';
import '../repository/device_warranty_repository.dart';
import '../../data/model/warranty_status_model.dart';

class GetDeviceWarrantyStatus {
  final DeviceWarrantyRepository _repository;

  GetDeviceWarrantyStatus(this._repository);

  ResultFuture<WarrantyStatusModel> call(String imei) async {
    return await _repository.getDeviceWarrantyStatus(imei);
  }
}
