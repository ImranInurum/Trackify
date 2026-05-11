import 'package:trackify/feature/health_insurance/domain/entities/health_insurance_entity.dart';

abstract class  HealthInsuranceRepository {
  Future<HealthInsuranceEntity> getInsuranceData();
}