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

  HealthInsuranceEntity({
    required this.bloodGroup,
    required this.insuranceList,
  });
}
