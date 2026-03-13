import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/app/app_navigation.dart';
import 'package:trackify/app/cubit/app_cubit.dart';
import 'package:trackify/app/cubit/app_state.dart';
import 'package:trackify/feature/map/presentation/pages/full_screen_map.dart';

import '../core/theme/theme_manager.dart';
import '../feature/auth/presentation/pages/splash.dart';
import '../main.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) => MaterialApp(
        navigatorKey: rootNavigatorKey,
        // themeMode: state.themeMode,
        themeMode:ThemeMode.dark,
        theme: ThemeManager.getApplicationLightTheme(),
        darkTheme: ThemeManager.getApplicationDarkTheme(),
        home: SplashScreen(),
      ),
    );
  }
}
