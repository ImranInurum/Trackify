import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:trackify/feature/auth/presentation/pages/signup_screen.dart';

import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_form_field.dart';
import '../../../../core/widgets/square_flat_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../app/app_navigation.dart';
import '../../../onboarding/presentation/cubit/splash_cubit.dart';
import '../../../onboarding/presentation/cubit/splash_state.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'forgot_password_screen.dart';

class SignInScreen extends StatefulWidget {
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
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(color: colorScheme.primary),
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.track_changes_rounded,
                  size: 88,
                  color: colorScheme.primary,
                ),
              )
            : Icon(
                Icons.track_changes_rounded,
                size: 88,
                color: colorScheme.primary,
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          final l10n = AppLocalizations.of(context)!;
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.welcome(state.user.user?.email ?? ''))),
            );
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const AppNavigation()),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error.message ?? l10n.loginFailed)),
            );
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
                              "Please enter a valid email address",
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
                              l10n.passwordMinLength ??
                                  "Password must be at least 6 characters",
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
                            const Center(
                              child: CircularProgressIndicator(),
                            )
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
    );
  }
}
