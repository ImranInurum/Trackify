import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/feature/add_vehicle_and_device/add_vehicle/domain/use_case/add_vehicle_use_case.dart';
import 'package:trackify/feature/document_folder/presentation/cubit/document_cubit.dart';
import 'package:trackify/feature/help_and_support/data/repository_impl/help_support_repository_impl.dart';
import 'package:trackify/feature/help_and_support/domain/use_case/help_support_use_case.dart';
import 'package:trackify/feature/help_and_support/presentation/cubit/help_support_cubit.dart';
import 'package:trackify/feature/map/data/repository/map_repository_impl.dart';
import 'package:trackify/feature/map/domain/usecase/map_case.dart';
import 'package:trackify/feature/map/presentation/cubit/map_cubit.dart';
import 'package:trackify/feature/my_garage/data/repository_impl/my_garage_repo_impl.dart';
import 'package:trackify/feature/my_garage/domain/use_case/my_garage_use_case.dart';
import 'package:trackify/feature/my_garage/presentation/cubit/my_garage_cubit.dart';
import 'package:trackify/feature/my_profile/data/respository_impl/my_profile_repository_impl.dart';
import 'package:trackify/feature/my_profile/domain/use_case/my_profile_use_case.dart';
import 'package:trackify/feature/my_profile/presentation/cubit/my_profile_cubit.dart';
import 'package:trackify/feature/profile/domain/use_case/profile_use_case.dart';
import 'package:trackify/feature/profile/presentation/cubit/profile_cubit.dart';
import 'package:trackify/feature/record_via_phone/data/repository/record_via_phone_repository_impl.dart';
import 'package:trackify/feature/record_via_phone/domain/usecase/record_via_phone_use_case.dart';
import 'package:trackify/feature/record_via_phone/presentation/cubit/record_via_phone_cubit.dart';
import 'package:trackify/feature/upgrade_to_plus/data/data_source/plus_membership_remote_data_source.dart';
import 'package:trackify/feature/upgrade_to_plus/data/repository/plus_membership_repository_impl.dart';
import 'package:trackify/feature/upgrade_to_plus/domain/usecase/get_plus_membership_details.dart';
import 'package:trackify/feature/upgrade_to_plus/presentation/cubit/upgrade_to_plus_cubit.dart';
import 'package:trackify/feature/video_tutorial/data/repository/tutorial_repository_impl.dart';
import 'package:trackify/feature/video_tutorial/domain/usecase/tutorial_usecase.dart';
import 'package:trackify/core/config/network/api_host.dart';

import 'package:trackify/app/app.dart';
import 'package:trackify/app/cubit/app_cubit.dart';
import 'package:trackify/feature/overspeed_alert/presentation/cubit/overspeed_alert_cubit.dart';
import 'package:trackify/core/services/connectivity_service.dart';
import 'package:trackify/core/services/location_service.dart';
import 'package:trackify/core/services/notification_service.dart';
import 'package:trackify/core/services/socket_service.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:trackify/feature/add_fuel/data/data_source/add_fuel_datasource.dart';
import 'package:trackify/feature/add_fuel/data/repository_impl/add_fuel_repository_impl.dart';
import 'package:trackify/feature/add_fuel/domain/usecase/add_fuel_usecase.dart';
import 'package:trackify/feature/add_fuel/presentation/cubit/add_fuel_cubit.dart';
import 'package:trackify/feature/add_vehicle_and_device/add_vehicle/data/repository/add_vehicle_repository_impl.dart';
import 'package:trackify/feature/add_vehicle_and_device/add_vehicle/presentation/cubit/add_vehicle_cubit.dart';
import 'package:trackify/feature/app_updates/data/data_source/update_remote_data.dart';
import 'package:trackify/feature/app_updates/domain/repositories/update_repository_impl.dart';
import 'package:trackify/feature/app_updates/domain/use_case/get_update_use_case.dart';
import 'package:trackify/feature/app_updates/presentiation/cubit/update_cubit.dart';

import 'package:trackify/feature/auth/data/repository/auth_repository_impl.dart';
import 'package:trackify/feature/auth/domain/usecase/auth_case.dart';
import 'package:trackify/feature/auth/presentation/cubit/auth_cubit.dart';
import 'package:trackify/feature/device_data/presentation/cubit/device_data_cubit.dart';
import 'package:trackify/feature/device_data/domain/usecase/get_recharge_plans_usecase.dart';
import 'package:trackify/feature/device_data/domain/usecase/get_current_data_plan_usecase.dart';
import 'package:trackify/feature/device_data/data/repository/device_data_repository_impl.dart';
import 'package:trackify/feature/device_data/data/data_source/device_data_remote_data_source.dart';
import 'package:trackify/feature/order_summary/data/data_source/order_summary_data_source.dart';
import 'package:trackify/feature/order_summary/data/repository_impl/order_summary_repository_impl.dart';
import 'package:trackify/feature/order_summary/domain/usecase/purchase_data_plan_usecase.dart';
import 'package:trackify/feature/order_summary/presentation/cubit/order_summary_cubit.dart';

import 'package:trackify/feature/device_warranty/presentation/cubit/device_warranty_cubit.dart';
import 'package:trackify/feature/device_warranty/domain/usecase/get_device_warranty_usecase.dart';
import 'package:trackify/feature/device_warranty/data/repository/device_warranty_repository_impl.dart';
import 'package:trackify/feature/device_warranty/data/data_source/device_warranty_data_source.dart';
import 'package:trackify/feature/document_folder/presentation/pages/document_screen.dart';
import 'package:trackify/feature/emergency_sos/data/data_source/emergency_alert_remote_data.dart';
import 'package:trackify/feature/emergency_sos/data/repository/emergency_alert_repository_impl.dart';
import 'package:trackify/feature/emergency_sos/domain/usecase/emergency_alert_usecase.dart';
import 'package:trackify/feature/emergency_sos/presentation/cubit/emergency_alert_cubit.dart';
import 'package:trackify/feature/emergency_sos/presentation/cubit/emergency_alert_state.dart' show EmergencySent;
import 'package:trackify/feature/geo_fence/presentation/cubit/geo_fence_cubit.dart';
import 'package:trackify/feature/get_more_out/data/repository/discover_repository_impl.dart';
import 'package:trackify/feature/get_more_out/data/repository/feature_repository_impl.dart';
import 'package:trackify/feature/get_more_out/data/repository/geo_fenc_repository_impl.dart';
import 'package:trackify/feature/get_more_out/domain/usecase/disover_usecase.dart';
import 'package:trackify/feature/get_more_out/domain/usecase/geo_fenc_usecase.dart';
import 'package:trackify/feature/get_more_out/domain/usecase/get_safey_usecase.dart';
import 'package:trackify/feature/get_more_out/presentation/cubit/discover_cubit.dart';
import 'package:trackify/feature/get_more_out/presentation/cubit/feature_cubit.dart';
import 'package:trackify/feature/get_more_out/presentation/cubit/geo_fenc_cubit.dart';
import 'package:trackify/feature/health_insurance/data/local_data/health_insurance_local_data.dart';
import 'package:trackify/feature/health_insurance/data/repository_impl/health_insurance_repository_impl.dart';
import 'package:trackify/feature/health_insurance/domain/usecase/health_insurance_usecase.dart';
import 'package:trackify/feature/health_insurance/presentation/cubit/health_insurance_cubit.dart';
import 'package:trackify/feature/my_garage/data/repository_impl/product_repository_impl.dart';
import 'package:trackify/feature/my_garage/domain/repository/product_repository.dart';
import 'package:trackify/feature/my_garage/domain/use_case/product_usecase.dart';
import 'package:trackify/feature/my_garage/presentation/cubit/product_cubit.dart';
import 'package:trackify/feature/service_logs/data/data_source/service_logs_remote_data_source.dart';
import 'package:trackify/feature/service_logs/data/repository/service_logs_repository_impl.dart';
import 'package:trackify/feature/service_logs/domain/usecase/get_service_logs_usecase.dart';
import 'package:trackify/feature/service_logs/domain/usecase/save_service_log_usecase.dart';
import 'package:trackify/feature/service_logs/presentation/cubit/service_logs_cubit.dart';
import 'package:trackify/feature/onboarding/data/repositories/splash_repository_impl.dart';
import 'package:trackify/feature/onboarding/domain/usecases/get_logo_usecase.dart';
import 'package:trackify/feature/onboarding/presentation/cubit/splash_cubit.dart';
import 'package:trackify/feature/device_installation/data/repository/device_installation_repository_impl.dart';
import 'package:trackify/feature/device_installation/domain/usecase/assign_device_use_case.dart';
import 'package:trackify/feature/device_installation/presentation/cubit/device_installation_cubit.dart';
import 'package:trackify/feature/safe_parking/presentation/cubit/safe_parking_cubit.dart';
import 'package:trackify/feature/trips/data/repository/ride_history_repository_impl.dart';
import 'package:trackify/feature/trips/domain/usecase/ride_history_use_case.dart';
import 'package:trackify/feature/trips/presentation/cubit/ride_history_cubit.dart';
import 'package:trackify/core/common/repositories/common_repo_impl.dart';
import 'package:trackify/feature/geo_fence/data/data_source/geo_fence_remote_data_source.dart';
import 'package:trackify/feature/geo_fence/data/repository/geo_fence_repository_impl.dart';
import 'package:trackify/feature/geo_fence/domain/usecase/get_geo_fence_usecase.dart';
import 'package:trackify/feature/geo_fence/domain/usecase/add_geo_fence_usecase.dart';
import 'package:trackify/feature/geo_fence/domain/usecase/delete_geo_fence_usecase.dart';
import 'package:trackify/core/common/usecase/get_user_vehicles_usecase.dart';
import 'package:trackify/core/config/network/network_api_service.dart';
import 'package:trackify/feature/overspeed_alert/data/data_source/overspeed_alert_remote_data_source.dart';
import 'package:trackify/feature/overspeed_alert/data/repository/overspeed_alert_repository_impl.dart';
import 'package:trackify/feature/overspeed_alert/domain/usecase/create_overspeed_alert_usecase.dart';
import 'package:trackify/feature/overspeed_alert/domain/usecase/get_overspeed_alerts_usecase.dart';

import 'package:trackify/feature/video_tutorial/data/datasource/tutorial_remote_data.dart';
import 'package:trackify/feature/video_tutorial/presentation/cubit/tutorial_cubit.dart';
import 'feature/get_more_out/data/data source/discover_data_source.dart';
import 'feature/get_more_out/data/data source/feature_local_data.dart';
import 'feature/get_more_out/data/data source/geo_fence_local_data.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await _setUp();

  runApp(
    MultiBlocProvider(providers: _buildBlocProviders(), child: const MyApp()),
  );
}

/// One-time app bootstrapping.
Future<void> _setUp() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppPreference.instance.init();
  await NotificationService.initialize();

  debugPrint('Trackify bootstrap completed');
}

List<BlocProvider> _buildBlocProviders() {
  final connectivityService = ConnectivityService();
  final locationService = LocationService();
  final socketService = SocketService();

  return [
    BlocProvider<AppCubit>(
      lazy: false,
      create: (_) => AppCubit(
        connectivityService: connectivityService,
        locationService: locationService,
        socketService: socketService,
      )..initialize(),
    ),
    BlocProvider<AuthCubit>(
      create: (_) => AuthCubit(AuthCase(AuthRepositoryImpl())),
    ),
    BlocProvider<MapCubit>(
      create: (_) => MapCubit(MapCase(MapRepositoryImpl())),
    ),
    BlocProvider<SplashCubit>(
      create: (_) => SplashCubit(GetLogoUseCase(SplashRepositoryImpl())),
    ),
    BlocProvider<AddVehicleCubit>(
      create: (_) =>
          AddVehicleCubit(AddVehicleUseCase(AddVehicleRepositoryImpl())),
    ),
    BlocProvider<ProfileCubit>(create: (_) => ProfileCubit(ProfileUseCase())),
    BlocProvider<RecordViaPhoneCubit>(
      create: (_) => RecordViaPhoneCubit(
        RecordViaPhoneUseCase(RecordViaPhoneRepositoryImpl()),
      ),
    ),
    BlocProvider<MyProfileCubit>(
      create: (_) =>
          MyProfileCubit(MyProfileUseCase(MyProfileRepositoryImpl())),
    ),
    BlocProvider<MyGarageCubit>(
      create: (_) => MyGarageCubit(MyGarageUseCase(MyGarageRepoImpl())),
    ),
    BlocProvider<HelpSupportCubit>(
      create: (_) =>
          HelpSupportCubit(HelpSupportUseCase(HelpSupportRepositoryImpl())),
    ),
    BlocProvider<DeviceInstallationCubit>(
      create: (_) => DeviceInstallationCubit(
        AssignDeviceUseCase(DeviceInstallationRepositoryImpl()),
      ),
    ),
    BlocProvider<RideHistoryCubit>(
      create: (_) => RideHistoryCubit(
        RideHistoryUseCase(RideHistoryRepositoryImpl()),
      ),
    ),
    BlocProvider<ServiceLogsCubit>(
      create: (_) => ServiceLogsCubit(
        GetUserVehiclesUsecase(CommonRepositoryImpl()),
        GetServiceLogsUsecase(
          ServiceLogsRepositoryImpl(
            ServiceLogsRemoteDataSource(NetworkApiService()),
          ),
        ),
        SaveServiceLogUsecase(
          ServiceLogsRepositoryImpl(
            ServiceLogsRemoteDataSource(NetworkApiService()),
          ),
        ),
      ),
    ),
    BlocProvider<OverspeedAlertCubit>(
      create: (_) {
        final repository = OverspeedAlertRepositoryImpl(
          OverspeedAlertRemoteDataSource(NetworkApiService()),
        );
        return OverspeedAlertCubit(
          getUserVehiclesUsecase: GetUserVehiclesUsecase(CommonRepositoryImpl()),
          createOverspeedAlertUsecase: CreateOverspeedAlertUsecase(repository),
          getOverspeedAlertsUsecase: GetOverspeedAlertsUsecase(repository),
        );
      },
    ),
    BlocProvider<DeviceDataCubit>(
      create: (_) {
        final repository = DeviceDataRepositoryImpl(
          DeviceDataRemoteDataSourceImpl(NetworkApiService()),
        );
        return DeviceDataCubit(
          GetRechargePlansUseCase(repository),
          GetCurrentDataPlanUseCase(repository),
        );
      },
    ),
    BlocProvider<DeviceWarrantyCubit>(
      create: (_) {
        final repository = DeviceWarrantyRepositoryImpl(
          DeviceWarrantyRemoteDataSourceImpl(NetworkApiService()),
        );
        return DeviceWarrantyCubit(
          GetDeviceWarrantyUseCase(repository),
        );
      },
    ),
    BlocProvider<OrderSummaryCubit>(
      create: (_) {
        final repository = OrderSummaryRepositoryImpl(
          OrderSummaryRemoteDataSourceImpl(NetworkApiService()),
        );
        return OrderSummaryCubit(
          PurchaseDataPlanUseCase(repository),
        );
      },
    ),
    BlocProvider<UpdateCubit>(
      create: (_) => UpdateCubit(
        GetUpdateUseCase(
          UpdateRepositoryImpl(
            UpdateRemoteDataSource(),
          ),
        ),
      ),
    ),
    BlocProvider<GeoFenceCubit>(
      create: (_) {
        final repository = GeoFenceRepositoryImpl(
          GeoFenceRemoteDataSource(NetworkApiService()),
        );
        return GeoFenceCubit(
          GetGeoFenceUseCase(repository),
          AddGeoFenceUseCase(repository),
          DeleteGeoFenceUseCase(repository),
        );
      },
    ),
    BlocProvider<EmergencyAlertCubit>(
      create: (_) => EmergencyAlertCubit(
        EmergencyAlertUsecase(
          EmergencyAlertRepositoryImpl(
            EmergencyAlertRemoteData(),
          ) ,
        ),
      ),
    ),

    BlocProvider<SafeParkingCubit>(
      create: (_) => SafeParkingCubit(),
    ),
    BlocProvider<UpgradeToPlusCubit>(
      create: (_) {
        final repository = PlusMembershipRepositoryImpl(
          PlusMembershipRemoteDataSourceImpl(
            baseUrl: ApiURL.baseURL,
          ),
        );
        return UpgradeToPlusCubit(
          getPlusMembershipDetails: GetPlusMembershipDetails(repository),
          repository: repository,
        )..getDetails();
      },
    ),
    BlocProvider<TutorialCubit>(
      create: (_) => TutorialCubit(
        GetTutorial(
          TutorialRepositoryImplement(
            TutorialRemoteData(),
          ),
        ),
      ),
    ),
    BlocProvider<DiscoverCubit>(

      create: (_) => DiscoverCubit(

        GetDiscoverUseCase(

          DiscoverRepositoryImpl(

            DiscoverDataSource(),

          ),
        ),
      ),
    ),


    BlocProvider(

      create: (_) => FeatureCubit(

        GetFeatureUseCase(

          FeatureRepositoryImpl(

            FeatureDataSource(),

          ),
        ),
      ),
    ),

    BlocProvider<GeoFenceIntroCubit>(
      create: (_) => GeoFenceIntroCubit(
        GetGeoFenceIntroUseCase(
          GeoFenceIntroRepositoryImpl(
            GeoFenceIntroDataSource(),
          ),
        ),
      ),
    ),
    BlocProvider<ProductCubit>(

      create: (_) => ProductCubit(
        GetProductsUsecase(
          ProductRepositoryImpl(),
        ),
      ),
    ),
    BlocProvider<HealthInsuranceCubit>(

      create: (_) => HealthInsuranceCubit(

        HealthInsuranceUseCase(

          HealthInsuranceRepositoryImpl(

            HealthInsuranceLocalDataSource(),
          ),
        ),
      )..getData(),
    ),
    BlocProvider<AddFuelCubit>(
      create: (_) => AddFuelCubit(
        AddFuelUseCase(
          AddFuelRepositoryImpl(
            AddFuelDataSource(),
          ),
        ),
      ),
    ),
  ];
}
