import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/feature/map/data/repository/map_repository_impl.dart';
import 'package:trackify/feature/map/domain/usecase/map_case.dart';
import 'package:trackify/feature/map/presentation/cubit/map_cubit.dart';

import 'app/app.dart';
import 'app/cubit/app_cubit.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/location_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/socket_service.dart';
import 'core/utils/shared_preferences.dart';
import 'feature/auth/data/repository/auth_repository_impl.dart';
import 'feature/auth/domain/usecase/auth_case.dart';
import 'feature/auth/presentation/cubit/auth_cubit.dart';
import 'feature/onboarding/data/repositories/splash_repository_impl.dart';
import 'feature/onboarding/domain/usecases/get_logo_usecase.dart';
import 'feature/onboarding/presentation/cubit/splash_cubit.dart';
import 'feature/add_vehicle_and_device/add_vehicle/data/repository/add_vehicle_repository_impl.dart';
import 'feature/add_vehicle_and_device/add_vehicle/presentation/cubit/add_vehicle_cubit.dart';
import 'feature/add_vehicle_and_device/add_vehicle/presentation/cubit/vehicle_list_cubit.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppPreference.instance.init();
  await NotificationService.initialize();
  final connectivityService = ConnectivityService();
  final locationService = LocationService();
  final socketService = SocketService();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (context) => AppCubit(
            connectivityService: connectivityService,
            locationService: locationService,
            socketService: socketService,
          )..initialize(),
        ),
        BlocProvider(create: (_) => AuthCubit(AuthCase(AuthRepositoryImpl()))),
        BlocProvider(create: (_) => MapCubit(MapCase(MapRepositoryImpl()))),
        BlocProvider(create: (_) => SplashCubit(GetLogoUseCase(SplashRepositoryImpl()))),
        BlocProvider(create: (_) => AddVehicleCubit(AddVehicleRepositoryImpl())),
        BlocProvider(create: (_) => VehicleListCubit(AddVehicleRepositoryImpl())),
      ],
      child: MyApp(),
    ),
  );
}
