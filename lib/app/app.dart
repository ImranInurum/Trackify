import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/app/cubit/app_cubit.dart';
import 'package:trackify/app/cubit/app_state.dart';

import 'package:trackify/core/config/theme_manager.dart';
import 'package:trackify/feature/onboarding/presentation/pages/splash.dart';
import 'package:trackify/l10n/app_localizations.dart';
import 'package:trackify/main.dart';
import 'package:trackify/core/widgets/global_no_internet_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) => MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: rootNavigatorKey,
        themeMode: state.themeMode,
        theme: ThemeManager.getApplicationLightTheme(state.dynamicTheme),
        darkTheme: ThemeManager.getApplicationDarkTheme(state.dynamicTheme),
        locale: state.locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: SplashScreen(),
        builder: (context, child) {
          return Stack(
            children: [
              if (child != null) child,
              if (!state.isConnected)
                const Positioned.fill(
                  child: GlobalNoInternetScreen(),
                ),
            ],
          );
        },
      ),
    );
  }
}
