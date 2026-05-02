import 'package:trackify/core/utils/typedefs.dart';
import 'package:trackify/feature/emergency_sos/domain/entities/emergency_alert_entities.dart';
import 'package:trackify/feature/emergency_sos/domain/repository/emergency_alert_repository.dart';

class EmergencyAlertUsecase {
  final EmergencyAlertRepository repository;

  EmergencyAlertUsecase(this.repository);

 Future<EmergencyAlertEntities>call(){
   return repository.sendAlert();
 }
}