import 'package:trackify/feature/emergency_sos/domain/entities/emergency_alert_entities.dart';

class EmergencyAlertModel extends EmergencyAlertEntities{
  EmergencyAlertModel({
    required super.success,
    required super.message});

  factory EmergencyAlertModel.fromJson(
      Map<String,dynamic>json){
    return EmergencyAlertModel(
        success: json['success'],
        message: json['message'],
    );
  }




}