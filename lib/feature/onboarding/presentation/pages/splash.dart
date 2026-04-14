import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:trackify/feature/add_vehicle_and_device/choice_selector.dart';
import 'package:trackify/feature/auth/presentation/pages/signin_screen.dart';
import 'package:trackify/feature/map/presentation/cubit/map_cubit.dart';
import 'package:trackify/feature/map/presentation/cubit/map_state.dart';
import 'package:trackify/feature/onboarding/presentation/cubit/splash_cubit.dart';
import 'package:trackify/feature/onboarding/presentation/cubit/splash_state.dart';
import 'package:trackify/feature/onboarding/presentation/pages/select_language_screen.dart';

import '../../../../app/app_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Start fetching logo early so it's ready when we navigate
    final logoFetch = context.read<SplashCubit>().fetchLogo();

    // Ensure splash shows for at least 2 seconds
    final splashWait = Future.delayed(const Duration(milliseconds: 2000));

    final prefs = AppPreference.instance;

    final selectedLanguage = await prefs.get(key: AppPreference.KEY_SELECTED_LANGUAGE);
    final token = await prefs.get(key: AppPreference.KEY_TOKEN);
    final userId = await prefs.get(key: AppPreference.KEY_USER_ID);

    if (token.isNotEmpty) {
      ApiURL.updateAuthToken(token);
    }

    // Wait for both the minimum splash time and the logo fetch to finish
    await Future.wait([splashWait, logoFetch]);

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
        MaterialPageRoute(builder: (_) => const AppNavigation()),
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: BlocBuilder<SplashCubit, SplashState>(
          builder: (context, state) {
            if (state is SplashLoading) {
              return const CircularProgressIndicator();
            }

            if (state is SplashLoaded && state.logo.path != null) {
              return Image.network(
                state.logo.path!,
                height: 120,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.track_changes,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
              );
            } else {
              return Icon(
                Icons.track_changes,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              );
            }
          },
        ),
      ),
    );
  }
}
