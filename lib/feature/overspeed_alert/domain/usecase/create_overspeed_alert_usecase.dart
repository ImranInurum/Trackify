import 'package:trackify/core/utils/typedefs.dart';
import '../repository/overspeed_alert_repository.dart';

class CreateOverspeedAlertUsecase {
  final OverspeedAlertRepository _repository;

  CreateOverspeedAlertUsecase(this._repository);

  ResultFuture<String?> call({
    required String alertTitle,
    required int speedLimit,
    required int duration,
    required String imei,
  }) {
    return _repository.createOverspeedAlert(
      alertTitle: alertTitle,
      speedLimit: speedLimit,
      duration: duration,
      imei: imei,
    );
  }
}
