import 'package:trackify/feature/health_insurance/data/local_data/health_insurance_local_data.dart';
import 'package:trackify/feature/health_insurance/data/model/health_insurance_model.dart';
import 'package:trackify/feature/health_insurance/domain/entities/health_insurance_entity.dart';
import 'package:trackify/feature/health_insurance/domain/repository/heath_insurance_repository.dart';

class HealthInsuranceRepositoryImpl implements HealthInsuranceRepository{

  final HealthInsuranceLocalDataSource localDataSource;

  HealthInsuranceRepositoryImpl(this.localDataSource);

  @override
  Future<HealthInsuranceEntity> getInsuranceData() async {
      final response = await localDataSource.getHealthInsuranceData();
      return HealthInsuranceModel.fromMap(response);
    
  }

}