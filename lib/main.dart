import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/feature/add_vehicle_and_device/add_vehicle/domain/use_case/add_vehicle_use_case.dart';
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

import 'app/app.dart';
import 'app/cubit/app_cubit.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/location_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/socket_service.dart';
import 'core/utils/shared_preferences.dart';
import 'feature/add_vehicle_and_device/add_vehicle/data/repository/add_vehicle_repository_impl.dart';
import 'feature/add_vehicle_and_device/add_vehicle/presentation/cubit/add_vehicle_cubit.dart';
import 'feature/auth/data/repository/auth_repository_impl.dart';
import 'feature/auth/domain/usecase/auth_case.dart';
import 'feature/auth/presentation/cubit/auth_cubit.dart';
import 'feature/onboarding/data/repositories/splash_repository_impl.dart';
import 'feature/onboarding/domain/usecases/get_logo_usecase.dart';
import 'feature/onboarding/presentation/cubit/splash_cubit.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await _setUp();

  runApp(MultiBlocProvider(providers: _buildBlocProviders(), child: const MyApp()));
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
    BlocProvider<AuthCubit>(create: (_) => AuthCubit(AuthCase(AuthRepositoryImpl()))),
    BlocProvider<MapCubit>(create: (_) => MapCubit(MapCase(MapRepositoryImpl()))),
    BlocProvider<SplashCubit>(
      create: (_) => SplashCubit(GetLogoUseCase(SplashRepositoryImpl())),
    ),
    BlocProvider<AddVehicleCubit>(
      create: (_) => AddVehicleCubit(AddVehicleUseCase(AddVehicleRepositoryImpl())),
    ),
    BlocProvider<ProfileCubit>(create: (_) => ProfileCubit(ProfileUseCase())),
    BlocProvider<RecordViaPhoneCubit>(
      create: (_) =>
          RecordViaPhoneCubit(RecordViaPhoneUseCase(RecordViaPhoneRepositoryImpl())),
    ),
    BlocProvider<MyProfileCubit>(
      create: (_) => MyProfileCubit(MyProfileUseCase(MyProfileRepositoryImpl())),
    ),
    BlocProvider<MyGarageCubit>(
      create: (_) => MyGarageCubit(MyGarageUseCase(MyGarageRepoImpl())),
    ),
    BlocProvider<HelpSupportCubit>(
      create: (_) => HelpSupportCubit(HelpSupportUseCase(HelpSupportRepositoryImpl())),
    ),
  ];
}
