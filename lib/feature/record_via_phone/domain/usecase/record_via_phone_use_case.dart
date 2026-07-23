import 'package:trackify/core/utils/typedefs.dart';
import 'package:trackify/feature/record_via_phone/data/model/device_data_by_date_response.dart';
import 'package:trackify/feature/record_via_phone/domain/repository/record_via_phone_repository.dart';

class RecordViaPhoneUseCase {
  final RecordViaPhoneRepository recordViaPhoneRepository;

  RecordViaPhoneUseCase(this.recordViaPhoneRepository);

  ResultFuture<DeviceDataByDateResponse> fetchDeviceDataByDate(
    Map<String, dynamic> body,
  ) {
    return recordViaPhoneRepository.getDeviceDataByDate(body);
  }

  ResultFuture<void> saveRideModeOnline(Map<String, dynamic> body) {
    return recordViaPhoneRepository.saveRideModeOnline(body);
  }

  ResultFuture<dynamic> getOnlinePastRides(String userId) {
    return recordViaPhoneRepository.getOnlinePastRides(userId);
  }
}
