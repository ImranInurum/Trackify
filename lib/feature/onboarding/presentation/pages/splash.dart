import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:trackify/feature/add_vehicle_and_device/choice_selector.dart';
import 'package:trackify/feature/auth/presentation/pages/signin_screen.dart';
import 'package:trackify/feature/map/presentation/cubit/map_cubit.dart';
import 'package:trackify/feature/map/presentation/cubit/map_state.dart';
import 'package:trackify/feature/onboarding/presentation/cubit/splash_cubit.dart';
import 'package:trackify/feature/onboarding/presentation/pages/select_language_screen.dart';

import '../../../../app/app_navigation.dart';
import '../../../../app/cubit/app_cubit.dart';

import 'dart:async';
import '../../../../core/widgets/trackify_splash.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Completer<void> _animationCompleter = Completer<void>();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final logoFetch = context.read<SplashCubit>().fetchLogo();
    context.read<AppCubit>().fetchTheme();

    // Init SharedPreferences singleton
    await AppPreference.instance.init();
    if (!mounted) return;

    final prefs = AppPreference.instance;

    final selectedLanguage = await prefs.get(key: AppPreference.KEY_SELECTED_LANGUAGE);
    final token = await prefs.get(key: AppPreference.KEY_TOKEN);
    final userId = await prefs.get(key: AppPreference.KEY_USER_ID);

    if (token.isNotEmpty) {
      ApiURL.updateAuthToken(token);
    }

    // Wait for both the minimum splash animation time and the logo fetch to finish
    await Future.wait([_animationCompleter.future, logoFetch]);

    if (!mounted) return;

    if (selectedLanguage.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SelectLanguageScreen()),
      );
      return;
    }

    if (token.isEmpty || userId.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SignInScreen()),
      );
      return;
    }

    await context.read<MapCubit>().fetchVehicles();
    if (!mounted) return;

    final mapState = context.read<MapCubit>().state;
    if (mapState is MapLoaded && (mapState.vehicleList.vehicles?.isNotEmpty ?? false)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AppNavigation()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ChoiceSelector()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TrackifySplash(
      onFinished: () {
        if (!_animationCompleter.isCompleted) {
          _animationCompleter.complete();
        }
      },
    );
  }
}
