class SaveHealthInsuranceUserEntity {
  final String id;
  final String name;
  final String mobile;
  final String email;

  const SaveHealthInsuranceUserEntity({
    required this.id,
    required this.name,
    required this.mobile,
    required this.email,
  });
}

class SaveHealthInsuranceInfoEntity {
  final String id;
  final String name;

  const SaveHealthInsuranceInfoEntity({
    required this.id,
    required this.name,
  });
}

class SaveHealthInsuranceEntity {
  final String id;
  final SaveHealthInsuranceUserEntity user;
  final String bloodGroup;
  final SaveHealthInsuranceInfoEntity healthInsurance;
  final String healthInsuranceCardNumber;
  final String policyNumber;
  final String createdAt;
  final String updatedAt;

  const SaveHealthInsuranceEntity({
    required this.id,
    required this.user,
    required this.bloodGroup,
    required this.healthInsurance,
    required this.healthInsuranceCardNumber,
    required this.policyNumber,
    required this.createdAt,
    required this.updatedAt,
  });
}
