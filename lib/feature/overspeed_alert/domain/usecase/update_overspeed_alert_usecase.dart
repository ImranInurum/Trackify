import 'package:trackify/core/utils/typedefs.dart';
import '../repository/overspeed_alert_repository.dart';

class UpdateOverspeedAlertUsecase {
  final OverspeedAlertRepository repository;

  UpdateOverspeedAlertUsecase(this.repository);

  ResultFuture<String> call({
    required String id,
    required String alertTitle,
    required int speedLimit,
    required int duration,
    required String imei,
  }) {
    return repository.updateOverspeedAlert(
      id: id,
      alertTitle: alertTitle,
      speedLimit: speedLimit,
      duration: duration,
      imei: imei,
    );
  }
}
