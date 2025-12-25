import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app/app.dart';
import 'app/cubit/app_cubit.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/location_service.dart';
import 'core/services/socket_service.dart';
import 'feature/auth/data/repository/auth_repository_impl.dart';
import 'feature/auth/domain/usecase/auth_case.dart';
import 'feature/auth/presentation/cubit/auth_cubit.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
      ],
      child: MyApp(),
    ),
  );
}
