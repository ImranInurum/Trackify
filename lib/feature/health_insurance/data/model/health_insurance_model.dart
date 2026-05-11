import 'package:trackify/feature/health_insurance/domain/entities/health_insurance_entity.dart';

class HealthInsuranceModel extends HealthInsuranceEntity{
  HealthInsuranceModel({
  required super.bloodGroup,
  required super.insuranceList
  });

  factory HealthInsuranceModel.fromMap(Map<String,dynamic>map){
    return HealthInsuranceModel(
        bloodGroup: List<String>.from(map['bloodGroup']),
        insuranceList: List<String>.from(map['insuranceList']

        ));
  }

}