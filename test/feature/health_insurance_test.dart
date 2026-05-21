import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trackify/core/config/network/base_api_service.dart';
import 'package:trackify/feature/health_insurance/data/local_data/health_insurance_local_data.dart';
import 'package:trackify/feature/health_insurance/data/model/health_insurance_model.dart';
import 'package:trackify/feature/health_insurance/data/model/save_health_insurance_model.dart';
import 'package:trackify/feature/health_insurance/data/remote_data/health_insurance_remote_data_source.dart';
import 'package:trackify/feature/health_insurance/data/repository_impl/health_insurance_repository_impl.dart';
import 'package:trackify/feature/health_insurance/domain/entities/health_insurance_entity.dart';
import 'package:trackify/feature/health_insurance/domain/entities/save_health_insurance_entity.dart';
import 'package:trackify/feature/health_insurance/domain/usecase/health_insurance_usecase.dart';
import 'package:trackify/feature/health_insurance/domain/usecase/save_health_insurance_usecase.dart';
import 'package:trackify/feature/health_insurance/domain/repository/heath_insurance_repository.dart';
import 'package:fpdart/fpdart.dart';

class MockBaseApiServices extends Mock implements BaseApiServices {}

class MockHealthInsuranceLocalDataSource extends Mock
    implements HealthInsuranceLocalDataSource {}

class MockHealthInsuranceRemoteDataSource extends Mock
    implements HealthInsuranceRemoteDataSource {}

class MockHealthInsuranceRepository extends Mock
    implements HealthInsuranceRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(const SaveHealthInsuranceRequest(
      userId: 'user_123',
      bloodGroup: 'O+',
      healthInsuranceId: 'ins_123',
      healthInsuranceCardNumber: 'CARD123',
      policyNumber: 'POL123',
    ));
  });

  group('Health Insurance API and Repository Integration Tests', () {
    late MockBaseApiServices mockApiServices;
    late HealthInsuranceRemoteDataSource remoteDataSource;
    late MockHealthInsuranceLocalDataSource mockLocalDataSource;
    late HealthInsuranceRepositoryImpl repository;

    setUp(() {
      mockApiServices = MockBaseApiServices();
      remoteDataSource = HealthInsuranceRemoteDataSource(mockApiServices);
      mockLocalDataSource = MockHealthInsuranceLocalDataSource();
      repository = HealthInsuranceRepositoryImpl(
        localDataSource: mockLocalDataSource,
        remoteDataSource: remoteDataSource,
      );
    });

    test('Remote Data Source saveHealthInsurance returns response model on success', () async {
      final request = const SaveHealthInsuranceRequest(
        userId: '651f82f80c6be812b1d3ef10',
        bloodGroup: 'O+',
        healthInsuranceId: '651f82f80c6be812b1d3ef12',
        healthInsuranceCardNumber: 'SH-9876-5432-10',
        policyNumber: 'POL-09876543',
      );

      final mockApiResponse = {
        "success": true,
        "message": "Health insurance saved successfully",
        "data": {
          "_id": "651f82f80c6be812b1d3ef19",
          "user": {
            "_id": "651f82f80c6be812b1d3ef10",
            "name": "John Doe",
            "mobile": "9876543210",
            "email": "john.doe@example.com"
          },
          "bloodGroup": "O+",
          "healthInsurance": {
            "_id": "651f82f80c6be812b1d3ef12",
            "name": "Star Health Insurance"
          },
          "healthInsuranceCardNumber": "SH-9876-5432-10",
          "policyNumber": "POL-09876543",
          "createdAt": "2026-05-20T09:52:35.000Z",
          "updatedAt": "2026-05-20T09:52:35.000Z"
        }
      };

      when(() => mockApiServices.getPostApiResponse(any(), any()))
          .thenAnswer((_) async => Right(mockApiResponse));

      final result = await remoteDataSource.saveHealthInsurance(request);

      expect(result.id, "651f82f80c6be812b1d3ef19");
      expect(result.user.name, "John Doe");
      expect(result.bloodGroup, "O+");
      expect(result.healthInsurance.name, "Star Health Insurance");
      expect(result.healthInsuranceCardNumber, "SH-9876-5432-10");
      expect(result.policyNumber, "POL-09876543");
    });

    test('Repository saveHealthInsurance propagates correct entity', () async {
      final request = const SaveHealthInsuranceRequest(
        userId: '651f82f80c6be812b1d3ef10',
        bloodGroup: 'O+',
        healthInsuranceId: '651f82f80c6be812b1d3ef12',
        healthInsuranceCardNumber: 'SH-9876-5432-10',
        policyNumber: 'POL-09876543',
      );

      final mockApiResponse = {
        "success": true,
        "message": "Health insurance saved successfully",
        "data": {
          "_id": "651f82f80c6be812b1d3ef19",
          "user": {
            "_id": "651f82f80c6be812b1d3ef10",
            "name": "John Doe",
            "mobile": "9876543210",
            "email": "john.doe@example.com"
          },
          "bloodGroup": "O+",
          "healthInsurance": {
            "_id": "651f82f80c6be812b1d3ef12",
            "name": "Star Health Insurance"
          },
          "healthInsuranceCardNumber": "SH-9876-5432-10",
          "policyNumber": "POL-09876543",
          "createdAt": "2026-05-20T09:52:35.000Z",
          "updatedAt": "2026-05-20T09:52:35.000Z"
        }
      };

      when(() => mockApiServices.getPostApiResponse(any(), any()))
          .thenAnswer((_) async => Right(mockApiResponse));

      when(() => mockLocalDataSource.getHealthInsuranceData()).thenAnswer((_) async => {
        "bloodGroup": ["O+"]
      });

      final result = await repository.saveHealthInsurance(request);

      expect(result, isA<SaveHealthInsuranceEntity>());
      expect(result.id, "651f82f80c6be812b1d3ef19");
      expect(result.healthInsurance.name, "Star Health Insurance");
    });
  });
}
