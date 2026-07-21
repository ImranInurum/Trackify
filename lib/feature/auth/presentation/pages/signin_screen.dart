import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/feature/add_vehicle_and_device/choice_selector.dart';
import 'package:trackify/feature/auth/presentation/pages/signup_screen.dart';
import 'package:trackify/feature/onboarding/presentation/pages/select_language_screen.dart';

import '../../../../app/app_navigation.dart';
import '../../../../app/cubit/app_cubit.dart';
import '../../../../core/utils/shared_preferences.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_form_field.dart';
import '../../../../core/widgets/square_flat_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../map/presentation/cubit/map_cubit.dart';
import '../../../map/presentation/cubit/map_state.dart';
import '../../../onboarding/presentation/cubit/splash_cubit.dart';
import '../../../onboarding/presentation/cubit/splash_state.dart';
import '../../../onboarding/presentation/pages/select_language_screen.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'forgot_password_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trackify/core/constants/app_images.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';

class SignInScreen extends StatefulWidget {
  // final bool isFromSignUp;
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isNavigating = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  void _loadSavedCredentials() {
    final remember = AppPreference.instance.getBoolSync(
      key: AppPreference.KEY_REMEMBER_ME,
    );
    if (remember) {
      final savedEmail = AppPreference.instance.getSync(
        key: AppPreference.KEY_SAVED_EMAIL,
      );
      final savedPassword = AppPreference.instance.getSync(
        key: AppPreference.KEY_SAVED_PASSWORD,
      );
      setState(() {
        _rememberMe = true;
        if (savedEmail.isNotEmpty) _emailController.text = savedEmail;
        if (savedPassword.isNotEmpty) _passwordController.text = savedPassword;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      if (_rememberMe) {
        AppPreference.instance.setBool(
          key: AppPreference.KEY_REMEMBER_ME,
          value: true,
        );
        AppPreference.instance.set(
          key: AppPreference.KEY_SAVED_EMAIL,
          value: _emailController.text.trim(),
        );
        AppPreference.instance.set(
          key: AppPreference.KEY_SAVED_PASSWORD,
          value: _passwordController.text.trim(),
        );
      } else {
        AppPreference.instance.setBool(
          key: AppPreference.KEY_REMEMBER_ME,
          value: false,
        );
        AppPreference.instance.clearByKey(key: AppPreference.KEY_SAVED_EMAIL);
        AppPreference.instance.clearByKey(key: AppPreference.KEY_SAVED_PASSWORD);
      }
      final body = {
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
      };
      context.read<AuthCubit>().loginUser(body);
    }
  }

  // void _onLoginPressed(BuildContext context) {
  //   // TEMP: bypass login API
  //   Navigator.of(context).pushReplacement(
  //     MaterialPageRoute(builder: (context) => AppNavigation()),
  //   );
  //   // if (_formKey.currentState?.validate() ?? false) {
  //   //
  //   //
  //   //
  //   // }
  // }

  Widget _buildLogo(SplashState state, ColorScheme colorScheme) {
    return Center(
      child:
          (state is SplashLoaded &&
              state.logo.path != null &&
              state.logo.path!.isNotEmpty)
          ? CachedNetworkImage(
              imageUrl: state.logo.path!,
              height: MediaQuery.of(context).size.height < 700 ? 100 : 130,
              fit: BoxFit.contain,
              placeholder: (context, url) => const Center(child: TrackifyLoader()),
              errorWidget: (context, url, error) => Icon(
                Icons.track_changes_rounded,
                size: 64,
                color: colorScheme.primary,
              ),
            )
          : Icon(
              Icons.track_changes_rounded,
              size: 64,
              color: colorScheme.primary,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return PopScope(
      canPop: Navigator.of(context).canPop(),
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const SelectLanguageScreen()),
        );
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const SelectLanguageScreen(),
                  ),
                );
              }
            },
          ),
        ),
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) async {
            final l10n = AppLocalizations.of(context)!;
            if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.welcome(state.user.user?.email ?? '')),
                ),
              );

              final userId = state.user.user?.id ?? "";
              if (userId.isEmpty) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l10n.loginFailed)));
                await AppPreference.instance.clearAll();
                return;
              }

              setState(() {
                _isNavigating = true;
              });

              // Load user session details into AppCubit
              await context.read<AppCubit>().loadUserSession();
              if (!context.mounted) return;

              // Fetch vehicles to determine navigation
              await context.read<MapCubit>().fetchVehicles();
              if (!context.mounted) return;

              final mapState = context.read<MapCubit>().state;
              if (mapState is MapLoaded &&
                  (mapState.vehicleList.vehicles?.isNotEmpty ?? false)) {
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
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error.message)));
            }
          },
          builder: (context, state) {
            final l10n = AppLocalizations.of(context)!;
            return BlocBuilder<SplashCubit, SplashState>(
              builder: (context, splashState) {
                return SafeArea(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildLogo(splashState, colorScheme),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              l10n.email,
                              style: textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomFormField(
                            header: '',
                            hint: l10n.emailHint,
                            value: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: (value) => Validators.validateEmail(
                              value,
                              l10n.emailRequired,
                              l10n.invalidEmail,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              l10n.password,
                              style: textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomFormField(
                            header: '',
                            hint: l10n.passwordHint,
                            value: _passwordController,
                            isPassword: true,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                            validator: (value) => Validators.validatePassword(
                              value,
                              l10n.passwordRequired,
                              l10n.passwordMinLength,
                              minLength: 6,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: Checkbox(
                                      value: _rememberMe,
                                      activeColor: colorScheme.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      onChanged: (val) {
                                        setState(() {
                                          _rememberMe = val ?? false;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _rememberMe = !_rememberMe;
                                      });
                                    },
                                    child: Text(
                                      'Remember Me',
                                      style: textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPasswordScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  l10n.forgotPassword,
                                  style: TextStyle(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          CommonButton(
                            onPressed: (state is AuthLoading || _isNavigating)
                                ? null
                                : () => _onLoginPressed(context),
                            text: l10n.signIn,
                            borderRadius: 8,
                            isLoading: state is AuthLoading || _isNavigating,
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              const Expanded(child: Divider()),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  l10n.or,
                                  style: TextStyle(color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withOpacity(0.5),
                                  ),
                                ),
                              ),
                              const Expanded(child: Divider()),
                            ],
                          ),
                          const SizedBox(height: 20),
                          OutlinedButton(
                            onPressed: (state is AuthLoading || _isNavigating)
                                ? null
                                : () =>
                                    context.read<AuthCubit>().loginWithGoogle(),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              side: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.15),
                                width: 1.2,
                              ),
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .surface,
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  AppImages.googleIcon,
                                  height: 22,
                                  width: 22,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Continue with Google',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  l10n.dontHaveAccount,
                                  style: TextStyle(color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SignUpScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    l10n.signUp,
                                    style: TextStyle(color: colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
