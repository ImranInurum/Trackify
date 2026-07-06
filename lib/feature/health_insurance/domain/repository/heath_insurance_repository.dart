import 'package:trackify/feature/health_insurance/domain/entities/health_insurance_entity.dart';
import 'package:trackify/feature/health_insurance/data/model/save_health_insurance_model.dart';
import 'package:trackify/feature/health_insurance/domain/entities/save_health_insurance_entity.dart';

abstract class HealthInsuranceRepository {
  Future<HealthInsuranceEntity> getInsuranceData(String userId);
  Future<SaveHealthInsuranceEntity> saveHealthInsurance(
    SaveHealthInsuranceRequest request,
  );
}
