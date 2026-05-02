import 'package:trackify/feature/emergency_sos/data/data_source/emergency_alert_remote_data.dart';
import 'package:trackify/feature/emergency_sos/domain/entities/emergency_alert_entities.dart';
import 'package:trackify/feature/emergency_sos/domain/repository/emergency_alert_repository.dart';

class EmergencyAlertRepositoryImpl implements EmergencyAlertRepository{

  final EmergencyAlertRemoteData remoteData;

  EmergencyAlertRepositoryImpl(this.remoteData);


  @override
  Future<EmergencyAlertEntities> sendAlert() {
    return remoteData.sendAlert();
  }


}