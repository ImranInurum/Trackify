import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:trackify/feature/add_vehicle_and_device/choice_selector.dart';
import 'package:trackify/feature/auth/presentation/pages/signin_screen.dart';
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
    context.read<SplashCubit>().fetchLogo();

    // Brief splash display
    await Future.delayed(const Duration(milliseconds: 2000));

    // Init SharedPreferences singleton
    await AppPreference.instance.init();
    if (!mounted) return;

    final prefs = AppPreference.instance;

    // ── Step 1: Language check ────────────────────────────────────────────────
    final selectedLanguage = await prefs.get(key: AppPreference.KEY_SELECTED_LANGUAGE);
    if (!mounted) return;

    // ── Step 2: Token check ───────────────────────────────────────────────────
    final token = await prefs.get(key: AppPreference.KEY_TOKEN);
    if (!mounted) return;

    if (selectedLanguage.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SelectLanguageScreen()),
      );
      return;
    }

    if (token.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SignInScreen()),
      );
      return;
    }

    // Check setup completion if already signed in
    final setupFlag = await prefs.getBoolNullable(key: AppPreference.KEY_SETUP_COMPLETE);
    final setupComplete = setupFlag ?? false;
    if (!mounted) return;

    if (!setupComplete) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ChoiceSelector()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AppNavigation()),
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
            } else if (state is SplashLoaded && state.logo.path != null) {
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
