import 'package:trackify/core/utils/typedefs.dart';
import '../../data/model/overspeed_alert_model.dart';
import '../repository/overspeed_alert_repository.dart';

class GetOverspeedAlertsUsecase {
  final OverspeedAlertRepository _repository;

  GetOverspeedAlertsUsecase(this._repository);

  ResultFuture<List<OverspeedAlertModel>> call(String imei) {
    return _repository.getOverspeedAlerts(imei);
  }
}
