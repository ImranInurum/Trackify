import 'package:trackify/feature/emergency_sos/domain/entities/emergency_alert_entities.dart';

abstract class EmergencyAlertRepository {
  Future<EmergencyAlertEntities>sendAlert();
}