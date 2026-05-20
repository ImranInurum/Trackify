import 'package:trackify/core/utils/typedefs.dart';
import '../entities/device_warranty_entity.dart';

abstract class DeviceWarrantyRepository {
  ResultFuture<DeviceWarrantyEntity> getDeviceWarranty(String imei);
}
