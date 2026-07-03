import 'package:trackify/feature/health_insurance/domain/entities/save_health_insurance_entity.dart';

class HealthInsuranceOptionEntity {
  final String id;
  final String name;

  const HealthInsuranceOptionEntity({
    required this.id,
    required this.name,
  });
}

class HealthInsuranceEntity {
  final List<String> bloodGroup;
  final List<HealthInsuranceOptionEntity> insuranceList;
  final SaveHealthInsuranceEntity? savedData;

  HealthInsuranceEntity({
    required this.bloodGroup,
    required this.insuranceList,
    this.savedData,
  });
}
