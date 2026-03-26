import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/app/cubit/app_cubit.dart';
import 'package:trackify/app/cubit/app_state.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:trackify/core/widgets/square_flat_button.dart';
import 'package:trackify/feature/auth/presentation/pages/signin_screen.dart';

import '../../../../l10n/app_localizations.dart';
import '../cubit/splash_cubit.dart';
import '../cubit/splash_state.dart';

class SelectLanguageScreen extends StatefulWidget {
  const SelectLanguageScreen({super.key});

  @override
  State<SelectLanguageScreen> createState() => _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
  final List<Map<String, dynamic>> _languages = [
    {'key': 'English', 'name': 'English', 'locale': const Locale('en')},
    {'key': 'Hindi', 'name': 'हिंदी', 'locale': const Locale('hi')},
    {'key': 'Arabic', 'name': 'العربية', 'locale': const Locale('ar')},
  ];

  String _selectedLanguageKey = 'English';

  void _saveLanguageAndContinue() async {
    await AppPreference.instance.set(
      key: AppPreference.KEY_SELECTED_LANGUAGE,
      value: _selectedLanguageKey,
    );
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;
    var selectedColor = theme.colorScheme.primaryContainer;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Opacity(
              opacity: 0.5, // Adjust opacity as needed (0.0 to 1.0)
              child: Image.asset(
                'assets/images/road.jpeg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: BlocBuilder<AppCubit, AppState>(
                builder: (context, appState) {
                  final l10n = AppLocalizations.of(context)!;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      BlocBuilder<SplashCubit, SplashState>(
                        builder: (context, state) {
                          if (state is SplashLoading) {
                            return const CircularProgressIndicator();
                          } else if (state is SplashLoaded &&
                              state.logo.path != null) {
                            return Image.network(
                              state.logo.path!,
                              height: 200,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
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
                      const SizedBox(height: 32),
                      Text(
                        l10n.selectLanguage,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: textColor.withOpacity(0.5), width: 1),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white
                              .withOpacity(0.1), // Optional blend background
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: _languages.map((lang) {
                            final isSelected =
                                appState.locale == lang['locale'];
                            return GestureDetector(
                              onTap: () {
                                context
                                    .read<AppCubit>()
                                    .changeLocale(lang['locale']);
                                setState(() {
                                  _selectedLanguageKey = lang['key']!;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                                color: Colors.transparent, // expand tap area
                                child: Text(
                                  lang['name']!,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        isSelected ? selectedColor : textColor,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      CommonButton(
                          text: l10n.letsGetStarted,
                          onPressed: () => _saveLanguageAndContinue()),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}