import 'package:trackify/feature/health_insurance/domain/entities/save_health_insurance_entity.dart';

class SaveHealthInsuranceRequest {
  final String userId;
  final String bloodGroup;
  final String healthInsuranceId;
  final String healthInsuranceCardNumber;
  final String policyNumber;

  const SaveHealthInsuranceRequest({
    required this.userId,
    required this.bloodGroup,
    required this.healthInsuranceId,
    required this.healthInsuranceCardNumber,
    required this.policyNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'bloodGroup': bloodGroup,
      'healthInsuranceId': healthInsuranceId,
      'healthInsuranceCardNumber': healthInsuranceCardNumber,
      'policyNumber': policyNumber,
    };
  }
}

class SaveHealthInsuranceResponseModel extends SaveHealthInsuranceEntity {
  const SaveHealthInsuranceResponseModel({
    required super.id,
    required super.user,
    required super.bloodGroup,
    required super.healthInsurance,
    required super.healthInsuranceCardNumber,
    required super.policyNumber,
    required super.createdAt,
    required super.updatedAt,
  });

  factory SaveHealthInsuranceResponseModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>? ?? {};
    final healthInsJson = json['healthInsurance'] as Map<String, dynamic>? ?? {};

    return SaveHealthInsuranceResponseModel(
      id: json['_id'] as String? ?? '',
      user: SaveHealthInsuranceUserEntity(
        id: userJson['_id'] as String? ?? '',
        name: userJson['name'] as String? ?? '',
        mobile: userJson['mobile'] as String? ?? '',
        email: userJson['email'] as String? ?? '',
      ),
      bloodGroup: json['bloodGroup'] as String? ?? '',
      healthInsurance: SaveHealthInsuranceInfoEntity(
        id: healthInsJson['_id'] as String? ?? '',
        name: healthInsJson['name'] as String? ?? '',
      ),
      healthInsuranceCardNumber: json['healthInsuranceCardNumber'] as String? ?? '',
      policyNumber: json['policyNumber'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }
}
