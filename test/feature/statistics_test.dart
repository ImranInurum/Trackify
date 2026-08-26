import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:trackify/core/config/network/base_api_service.dart';
import 'package:trackify/core/common/models/vehicle_list_model.dart';
import 'package:trackify/core/common/usecase/get_user_vehicles_usecase.dart';
import 'package:trackify/feature/statistics/data/data_source/statistics_remote_data_source.dart';
import 'package:trackify/feature/statistics/data/model/statistics_request_model.dart';
import 'package:trackify/feature/statistics/data/model/statistics_response_model.dart';
import 'package:trackify/feature/statistics/data/repository/statistics_repository_impl.dart';
import 'package:trackify/feature/statistics/presentation/cubit/statistics_cubit.dart';
import 'package:trackify/feature/statistics/presentation/cubit/statistics_state.dart';

class MockBaseApiServices extends Mock implements BaseApiServices {}

class MockGetUserVehiclesUsecase extends Mock
    implements GetUserVehiclesUsecase {}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await AppPreference.instance.init();
    Hive.init('./test_hive');
    if (!Hive.isBoxOpen('map_cache')) {
      await Hive.openBox('map_cache');
    }
    registerFallbackValue(
      const StatisticsRequestModel(imei: '123456789012345', date: '2026-05-21'),
    );
  });

  group('Statistics API, Models, and BLoC Tests', () {
    late MockBaseApiServices mockApiServices;
    late StatisticsRemoteDataSource remoteDataSource;
    late StatisticsRepositoryImpl repository;

    final mockResponseJson = {
      "success": true,
      "message": "Statistics fetched successfully",
      "data": {
        "selectedDate": {
          "date": "2026-05-21",
          "displayText": "May 21 (Today)",
          "previousDate": "2026-05-20",
          "nextDate": "2026-05-22",
        },
        "vehicle": {
          "_id": "60d0fe4f5311236168a109ca",
          "userId": "60d0fe4f5311236168a109cb",
          "imei": "123456789012345",
          "vehicleName": "Model S",
          "vehicleNumber": "CA123456",
          "displayName": "Model S CA123456",
        },
        "ridingBehaviour": {
          "score": 95,
          "scoreText": "95%",
          "statusText": "Excellent",
          "comparisonText": "+5% vs previous period",
        },
        "journey": {
          "distanceTravelled": 25.4,
          "distanceTravelledText": "25.4 km",
          "timeDurationMinutes": 45,
          "timeDurationText": "45m",
          "distanceComparisonText": "+10% vs previous period",
          "durationComparisonText": "+8% vs previous period",
        },
        "speed": {
          "averageSpeed": 45.2,
          "averageSpeedText": "45.2 km/hr",
          "topSpeed": 85,
          "topSpeedText": "85.0 km/hr",
          "averageSpeedComparisonText": "+3% vs previous period",
          "topSpeedComparisonText": "+12% vs previous period",
        },
        "fuel": {
          "fuelConsumed": 2.1,
          "fuelConsumedText": "2.1 L",
          "fuelCost": 210,
          "fuelCostText": "₹210.0",
          "fuelConsumedComparisonText": "-2% vs previous period",
          "fuelCostComparisonText": "-2% vs previous period",
        },
      },
    };

    setUp(() {
      mockApiServices = MockBaseApiServices();
      remoteDataSource = StatisticsRemoteDataSourceImpl(mockApiServices);
      repository = StatisticsRepositoryImpl(remoteDataSource);
    });

    test('StatisticsResponseModel parses correct data types from JSON', () {
      final parsed = StatisticsResponseModel.fromJson(mockResponseJson);

      expect(parsed.success, isTrue);
      expect(parsed.message, "Statistics fetched successfully");
      expect(parsed.data?.vehicle?.imei, "123456789012345");
      expect(parsed.data?.ridingBehaviour?.score, 95);
      expect(parsed.data?.journey?.distanceTravelled, 25.4);
      expect(parsed.data?.speed?.topSpeed, 85.0);
      expect(parsed.data?.fuel?.fuelCost, 210.0);
    });

    test(
      'StatisticsRemoteDataSource getStatistics fetches remote data on success',
      () async {
        when(
          () => mockApiServices.getGetApiResponse(any()),
        ).thenAnswer((_) async => Right(mockResponseJson));

        final result = await remoteDataSource.getStatistics(
          const StatisticsRequestModel(
            imei: '123456789012345',
            date: '2026-05-21',
          ),
        );

        expect(result, isA<Map<String, dynamic>>());
        expect(result['success'], isTrue);
      },
    );

    test(
      'StatisticsRepositoryImpl returns right with model on success',
      () async {
        when(
          () => mockApiServices.getGetApiResponse(any()),
        ).thenAnswer((_) async => Right(mockResponseJson));

        final result = await repository.getStatistics(
          const StatisticsRequestModel(
            imei: '123456789012345',
            date: '2026-05-21',
          ),
        );

        expect(result.isRight(), isTrue);
        result.fold((failure) => fail('Should be a Right'), (model) {
          expect(model.data?.vehicle?.vehicleName, "Model S");
        });
      },
    );

    test('StatisticsCubit state progression flows correctly', () async {
      final mockUsecase = MockGetUserVehiclesUsecase();
      final cubit = StatisticsCubit(
        getUserVehiclesUsecase: mockUsecase,
        repository: repository,
      );

      final mockVehicleListResponse = VehicleListResponse(
        status: true,
        message: 'Success',
        vehicles: [
          Vehicle(id: '1', imei: '123456789012345', vehicleMaker: 'Model S'),
        ],
      );

      when(
        () => mockUsecase.call(),
      ).thenAnswer((_) async => Right(mockVehicleListResponse));
      when(
        () => mockApiServices.getGetApiResponse(any()),
      ).thenAnswer((_) async => Right(mockResponseJson));

      final states = <StatisticsState>[];
      cubit.stream.listen(states.add);

      await cubit.fetchInitialData(targetDate: DateTime(2026, 5, 21));

      // Allow async code to resolve
      await Future.delayed(const Duration(milliseconds: 50));

      expect(states.isNotEmpty, isTrue);
      expect(states.first, isA<StatisticsLoading>());
      expect(states.last, isA<StatisticsLoaded>());

      final loadedState = states.last as StatisticsLoaded;
      expect(loadedState.statistics.data?.ridingBehaviour?.score, 95);
      expect(loadedState.selectedVehicle?.imei, "123456789012345");
    });

    group('StatisticsRequestModel json serializations', () {
      test('toJson maps correct properties', () {
        const req = StatisticsRequestModel(imei: '123', date: '2026-05-21');
        final json = req.toJson();
        expect(json['imei'], '123');
        expect(json['date'], '2026-05-21');
      });
    });
  });
}
