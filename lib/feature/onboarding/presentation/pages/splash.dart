import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:trackify/feature/auth/presentation/pages/device_list_screen.dart';
import 'package:trackify/feature/auth/presentation/pages/signin_screen.dart';
import 'package:trackify/feature/onboarding/presentation/cubit/splash_cubit.dart';
import 'package:trackify/feature/onboarding/presentation/cubit/splash_state.dart';
import 'package:trackify/feature/onboarding/presentation/pages/select_language_screen.dart';
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

    // Wait for a brief moment to show splash effect (optional)
    await Future.delayed(const Duration(milliseconds: 2000));

    // Initialize SharedPreferences (singleton)
    await AppPreference.instance.init();

    // Check saved token
    final token =
        await AppPreference.instance.get(key: AppPreference.KEY_TOKEN);

    // Check saved language
    final selectedLanguage = await AppPreference.instance
        .get(key: AppPreference.KEY_SELECTED_LANGUAGE);

    // Decide navigation
    if (!mounted) return;

    if (selectedLanguage.isEmpty) {
      // First time user -> go to Select Language
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SelectLanguageScreen()),
      );
    } else if (token.isNotEmpty) {
      // User already logged in -> go to Device List Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DeviceListScreen()),
      );
    } else {
      // No token -> go to SignIn
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SignInScreen()),
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
            if (state is SplashLoading){
              return const CircularProgressIndicator();
            }
           else if (state is SplashLoaded && state.logo.path != null) {
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
