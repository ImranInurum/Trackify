import 'package:trackify/feature/health_insurance/domain/entities/health_insurance_entity.dart';
import 'package:trackify/feature/health_insurance/domain/repository/heath_insurance_repository.dart';

class HealthInsuranceUseCase {
  final HealthInsuranceRepository repository;

  HealthInsuranceUseCase(this.repository);

  Future<HealthInsuranceEntity>call ()async{
    return await repository.getInsuranceData();
  }
}