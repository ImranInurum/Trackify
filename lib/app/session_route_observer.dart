import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/app/cubit/app_cubit.dart';
import 'package:trackify/feature/auth/presentation/pages/signin_screen.dart';
import 'package:trackify/feature/map/presentation/cubit/map_cubit.dart';
import 'package:trackify/feature/my_garage/presentation/cubit/my_garage_cubit.dart';
import 'package:trackify/feature/my_profile/presentation/cubit/my_profile_cubit.dart';
import 'package:trackify/feature/profile/presentation/cubit/profile_cubit.dart';
import 'package:trackify/feature/service_logs/presentation/cubit/service_logs_cubit.dart';
import 'package:trackify/main.dart';

class SessionRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _checkSession();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _checkSession();
  }

  Future<void> _checkSession() async {
    final context = rootNavigatorKey.currentContext;
    if (context == null || !context.mounted) return;

    final isExpired = await context.read<AppCubit>().isSessionExpired();
    
    if (isExpired && context.mounted) {
      await context.read<AppCubit>().logout();
      if (context.mounted) {
        context.read<ProfileCubit>().reset();
        context.read<MyProfileCubit>().reset();
        context.read<MapCubit>().reset();
        context.read<MyGarageCubit>().reset();
        context.read<ServiceLogsCubit>().reset();
        Navigator.of(
          context,
          rootNavigator: true,
        ).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const SignInScreen(),
          ),
          (Route<dynamic> route) => false,
        );
      }
    }
  }
}
