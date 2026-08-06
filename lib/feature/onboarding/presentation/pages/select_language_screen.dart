import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/app/cubit/app_cubit.dart';
import 'package:trackify/app/cubit/app_state.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:trackify/core/widgets/square_flat_button.dart';
import 'package:trackify/feature/auth/presentation/pages/signin_screen.dart';

import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_languages.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/splash_cubit.dart';
import '../cubit/splash_state.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';

class SelectLanguageScreen extends StatefulWidget {
  const SelectLanguageScreen({super.key});

  @override
  State<SelectLanguageScreen> createState() => _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
  final _languages = AppLanguages.languages;
  String _selectedLanguageKey = 'English';

  void _saveLanguageAndContinue() async {
    final prefs = AppPreference.instance;

    await prefs.set(
      key: AppPreference.KEY_SELECTED_LANGUAGE,
      value: _selectedLanguageKey,
    );

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _backgroundImage(),
          _overlay(),
          SafeArea(
            child: BlocBuilder<SplashCubit, SplashState>(
              builder: (context, splashState) {
                if (splashState is SplashLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  );
                }

                return BlocBuilder<AppCubit, AppState>(
                  builder: (context, appState) {
                    final l10n = AppLocalizations.of(context)!;

                    if (splashState is SplashLoaded &&
                        splashState.logo.path != null &&
                        splashState.logo.path!.isNotEmpty) {
                      return CachedNetworkImage(
                        imageUrl: splashState.logo.path!,
                        placeholder: (context, url) => const Center(child: TrackifyLoader()),
                        errorWidget: (context, url, err) => _buildMainContent(
                          context,
                          theme,
                          appState,
                          l10n,
                          null,
                        ),
                        imageBuilder: (context, imageProvider) =>
                            _buildMainContent(
                              context,
                              theme,
                              appState,
                              l10n,
                              imageProvider,
                            ),
                      );
                    }

                    return _buildMainContent(
                      context,
                      theme,
                      appState,
                      l10n,
                      null,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(
    BuildContext context,
    ThemeData theme,
    AppState appState,
    AppLocalizations l10n,
    ImageProvider? imageProvider,
  ) {
    const primaryTextColor = Colors.white;
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.25),
            _buildLogo(theme.colorScheme, imageProvider),
            SizedBox(height: MediaQuery.of(context).size.height * 0.15),
            Text(
              l10n.selectLanguage,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: primaryTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Row(
                children: _languages.map((lang) {
                  final isSelected = appState.locale == lang['locale'];
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        context.read<AppCubit>().changeLocale(
                          lang['locale'] as Locale,
                          lang['key'] as String,
                        );
                        setState(() {
                          _selectedLanguageKey = lang['key'] as String;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          lang['name'] as String,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: isSelected
                                ? theme.colorScheme.primary
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            CommonButton(
              text: l10n.letsGetStarted,
              onPressed: () => _saveLanguageAndContinue(),
              borderRadius: 8,
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo(ColorScheme colorScheme, [ImageProvider? imageProvider]) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: imageProvider != null
          ? Image(image: imageProvider, height: 220, fit: BoxFit.contain)
          : Icon(
              Icons.track_changes_rounded,
              size: 88,
              color: colorScheme.primary,
            ),
    );
  }

  Widget _backgroundImage() {
    return Image.asset(AppImages.roadImage, fit: BoxFit.cover);
  }

  Widget _overlay() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final overlayTop = Colors.black.withValues(alpha: isDark ? 0.35 : 0.20);
    final overlayBottom = Colors.black.withValues(alpha: isDark ? 0.55 : 0.35);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            overlayTop,
            Colors.black.withValues(alpha: isDark ? 0.20 : 0.70),
            overlayBottom,
          ],
        ),
      ),
    );
  }
}
