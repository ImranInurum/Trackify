import 'package:trackify/feature/health_insurance/data/model/save_health_insurance_model.dart';
import 'package:trackify/feature/health_insurance/domain/entities/save_health_insurance_entity.dart';
import 'package:trackify/feature/health_insurance/domain/repository/heath_insurance_repository.dart';

class SaveHealthInsuranceUseCase {
  final HealthInsuranceRepository repository;

  SaveHealthInsuranceUseCase(this.repository);

  Future<SaveHealthInsuranceEntity> call(SaveHealthInsuranceRequest request) async {
    return await repository.saveHealthInsurance(request);
  }
}
