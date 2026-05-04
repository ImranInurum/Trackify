import 'package:trackify/core/utils/typedefs.dart';
import '../../data/model/overspeed_alert_model.dart';

abstract class OverspeedAlertRepository {
  ResultFuture<String?> createOverspeedAlert({
    required String alertTitle,
    required int speedLimit,
    required int duration,
    required String imei,
  });

  ResultFuture<List<OverspeedAlertModel>> getOverspeedAlerts(String imei);
}
