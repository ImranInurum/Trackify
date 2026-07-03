import 'package:trackify/feature/health_insurance/domain/entities/health_insurance_entity.dart';

class HealthInsuranceOptionModel extends HealthInsuranceOptionEntity {
  const HealthInsuranceOptionModel({
    required super.id,
    required super.name,
  });

  factory HealthInsuranceOptionModel.fromJson(Map<String, dynamic> json) {
    return HealthInsuranceOptionModel(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }
}

class HealthInsuranceModel extends HealthInsuranceEntity {
  HealthInsuranceModel({
    required super.bloodGroup,
    required super.insuranceList,
    super.savedData,
  });

  factory HealthInsuranceModel.fromMap(Map<String, dynamic> map) {
    final bloodGroupList = List<String>.from(map['bloodGroup'] ?? []);
    final optionsList = (map['insuranceList'] as List<dynamic>? ?? [])
        .map((e) => HealthInsuranceOptionModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return HealthInsuranceModel(
      bloodGroup: bloodGroupList,
      insuranceList: optionsList,
    );
  }
}
