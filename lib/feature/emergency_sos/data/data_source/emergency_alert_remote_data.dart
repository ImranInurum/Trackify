import 'package:trackify/feature/emergency_sos/data/model/emergency_alert_model.dart';
import 'package:trackify/feature/emergency_sos/domain/entities/emergency_alert_entities.dart';

class EmergencyAlertRemoteData {
  Future<EmergencyAlertEntities>sendAlert() async {
    
    await Future.delayed(
        Duration(seconds: 2));
    
    return EmergencyAlertModel(
        success: true,
        message: "Alert sent Successfully");
    
  }
}