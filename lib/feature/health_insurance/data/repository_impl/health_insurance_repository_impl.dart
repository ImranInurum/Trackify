import 'package:trackify/feature/health_insurance/data/local_data/health_insurance_local_data.dart';
import 'package:trackify/feature/health_insurance/data/model/health_insurance_model.dart';
import 'package:trackify/feature/health_insurance/data/model/save_health_insurance_model.dart';
import 'package:trackify/feature/health_insurance/data/remote_data/health_insurance_remote_data_source.dart';
import 'package:trackify/feature/health_insurance/domain/entities/health_insurance_entity.dart';
import 'package:trackify/feature/health_insurance/domain/entities/save_health_insurance_entity.dart';
import 'package:trackify/feature/health_insurance/domain/repository/heath_insurance_repository.dart';

class HealthInsuranceRepositoryImpl implements HealthInsuranceRepository {
  final HealthInsuranceLocalDataSource localDataSource;
  final HealthInsuranceRemoteDataSource remoteDataSource;

  HealthInsuranceRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<HealthInsuranceEntity> getInsuranceData(String userId) async {
    // Blood groups are static — use local data
    final localData = await localDataSource.getHealthInsuranceData();
    final bloodGroup = List<String>.from(localData['bloodGroup'] ?? []);

    // Insurance list fetched from remote API
    List<HealthInsuranceOptionModel> insuranceOptions;
    try {
      insuranceOptions = await remoteDataSource.getHealthInsuranceOptions();
    } catch (_) {
      // Fallback to empty if API fails (since local data has no insurance list)
      insuranceOptions = [];
    }
    
    SaveHealthInsuranceResponseModel? savedData;
    try {
      savedData = await remoteDataSource.getSavedHealthInsurance(userId);
    } catch (_) {
      savedData = null;
    }

    return HealthInsuranceModel(
      bloodGroup: bloodGroup,
      insuranceList: insuranceOptions,
      savedData: savedData,
    );
  }

  @override
  Future<SaveHealthInsuranceEntity> saveHealthInsurance(
    SaveHealthInsuranceRequest request,
  ) async {
    return await remoteDataSource.saveHealthInsurance(request);
  }
}
