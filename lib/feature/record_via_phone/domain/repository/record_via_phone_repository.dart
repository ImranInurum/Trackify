import '../../../../core/utils/typedefs.dart';
import '../../../record_via_phone/data/model/device_data_by_date_response.dart';

abstract interface class RecordViaPhoneRepository {
  ResultFuture<DeviceDataByDateResponse> getDeviceDataByDate(Map<String, dynamic> body);
}
