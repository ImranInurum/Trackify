import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/app/cubit/app_cubit.dart';
import 'package:trackify/app/cubit/app_state.dart';

import '../core/config/theme_manager.dart';
import '../feature/auth/presentation/pages/splash.dart';
import '../main.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) => MaterialApp(
        navigatorKey: rootNavigatorKey,
        themeMode: state.themeMode,
        theme: ThemeManager.getApplicationLightTheme(),
        darkTheme: ThemeManager.getApplicationDarkTheme(),
        home: SplashScreen(),
      ),
    );
  }
}
