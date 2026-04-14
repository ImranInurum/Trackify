import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/feature/add_vehicle_and_device/choice_selector.dart';
import 'package:trackify/feature/auth/presentation/pages/signup_screen.dart';
import 'package:trackify/feature/onboarding/presentation/pages/select_language_screen.dart';

import '../../../../app/app_navigation.dart';
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child:
            (state is SplashLoaded &&
                state.logo.path != null &&
                state.logo.path!.isNotEmpty)
            ? CachedNetworkImage(
                imageUrl: state.logo.path!,
                height: 220,
                fit: BoxFit.contain,
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator(color: colorScheme.primary)),
                errorWidget: (context, url, error) => Icon(
                  Icons.track_changes_rounded,
                  size: 88,
                  color: colorScheme.primary,
                ),
              )
            : Icon(Icons.track_changes_rounded, size: 88, color: colorScheme.primary),
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.black87),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const SelectLanguageScreen()),
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
                SnackBar(content: Text(l10n.welcome(state.user.user?.email ?? ''))),
              );

              final userId = state.user.user?.id ?? "";
              if (userId.isEmpty) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l10n.loginFailed)));
                await AppPreference.instance.clearAll();
                return;
              }

              // Fetch vehicles to determine navigation
              await context.read<MapCubit>().fetchVehicles();
              if (!context.mounted) return;

              final mapState = context.read<MapCubit>().state;
              if (mapState is MapLoaded &&
                  (mapState.vehicleList.vehicles?.isNotEmpty ?? false)) {
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
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildLogo(splashState, colorScheme),
                            const SizedBox(height: 60),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                l10n.email,
                                style: textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            CustomFormField(
                              header: '',
                              hint: l10n.emailHint,
                              value: _emailController,
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
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            CustomFormField(
                              header: '',
                              hint: l10n.passwordHint,
                              value: _passwordController,
                              isPassword: true,
                              validator: (value) => Validators.validatePassword(
                                value,
                                l10n.passwordRequired,
                                l10n.passwordMinLength,
                                minLength: 6,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const ForgotPasswordScreen(),
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
                            ),
                            const SizedBox(height: 32),
                            if (state is AuthLoading)
                              const Center(child: CircularProgressIndicator())
                            else
                              CommonButton(
                                onPressed: () => _onLoginPressed(context),
                                text: l10n.signIn,
                                borderRadius: 8,
                              ),
                            const SizedBox(height: 32),
                            Row(
                              children: [
                                const Expanded(child: Divider()),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    l10n.or,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ),
                                const Expanded(child: Divider()),
                              ],
                            ),
                            const SizedBox(height: 32),
                            InkWell(
                              onTap: () => context.read<AuthCubit>().loginWithGoogle(),
                              child: Center(
                                child: Text(
                                  'Login with Google',
                                  style: TextStyle(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    l10n.dontHaveAccount,
                                    style: const TextStyle(color: Colors.black87),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => const SignUpScreen(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      l10n.signUp,
                                      style: TextStyle(
                                        color: colorScheme.primary,
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
