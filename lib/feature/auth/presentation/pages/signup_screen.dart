import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/feature/auth/presentation/pages/signin_screen.dart';
import 'package:trackify/feature/onboarding/presentation/cubit/splash_cubit.dart';
import 'package:trackify/feature/onboarding/presentation/cubit/splash_state.dart';

import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_form_field.dart';
import '../../../../core/widgets/square_flat_button.dart';
import 'package:trackify/l10n/app_localizations.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _onSignUpPressed(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_formKey.currentState?.validate() ?? false) {
      final body = <String, dynamic>{
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
        'confirm_password': _confirmPasswordController.text.trim(),
        'role': 'customer',
      };

      context.read<AuthCubit>().registerUser(body);
    }
  }

  Widget _buildLogo(SplashState state) {
    if (state is SplashLoaded &&
        state.logo.path != null &&
        state.logo.path!.isNotEmpty) {
      return Container(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: CachedNetworkImage(
          imageUrl: state.logo.path!,
          height: 140, // Reduced from 220
          fit: BoxFit.contain,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          errorWidget: (context, url, error) => Icon(
            Icons.track_changes_rounded,
            size: 60, // Reduced from 88
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }
    return Icon(
      Icons.track_changes_rounded,
      size: 60, // Reduced from 88
      color: Theme.of(context).colorScheme.primary,
    );
  }

  Widget _buildFieldLabel(String label, TextTheme textTheme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
    );
  }

  void _showThankYouDialog(BuildContext context, String userName) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          elevation: 12,
          backgroundColor: theme.cardColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Success Icon Badge using ThemeData primary color
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.14),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: colorScheme.primary,
                    size: 46,
                  ),
                ),
                const SizedBox(height: 20),

                // Welcome Title using ThemeData text & onSurface color
                Text(
                  userName.isNotEmpty
                      ? l10n.welcomeUser(userName)
                      : l10n.welcomeToTrackify,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),

                // Subtitle using ThemeData onSurface color with opacity
                Text(
                  l10n.thankYouForRegisteringDesc,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 26),

                // Action Button using ThemeData primary and onPrimary colors
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const SignInScreen(),
                        ),
                      );
                    },
                    icon: Icon(Icons.arrow_forward_rounded, size: 18, color: colorScheme.onPrimary),
                    label: Text(
                      l10n.continueToSignIn,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          final l10n = AppLocalizations.of(context)!;
          if (state is RegisterSuccess) {
            _showThankYouDialog(context, _nameController.text.trim());
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error.message ?? l10n.signUpFailed)),
            );
          }
        },
        builder: (context, state) {
          final l10n = AppLocalizations.of(context)!;
          return BlocBuilder<SplashCubit, SplashState>(
            builder: (context, splashState) {
              final theme = Theme.of(context);
              final textTheme = theme.textTheme;
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildLogo(splashState),
                      const SizedBox(height: 10),
                      _buildFieldLabel(l10n.name, textTheme),
                      const SizedBox(height: 8),
                      CustomFormField(
                        header: '',
                        hint: l10n.nameHint,
                        value: _nameController,
                        focusNode: _nameFocusNode,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_emailFocusNode);
                        },
                        validator: (value) => Validators.validateRequired(
                          value,
                          l10n.nameRequired,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildFieldLabel(l10n.email, textTheme),
                      const SizedBox(height: 8),
                      CustomFormField(
                        header: '',
                        hint: l10n.emailHint,
                        value: _emailController,
                        focusNode: _emailFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_passwordFocusNode);
                        },
                        validator: (value) => Validators.validateEmail(
                          value,
                          l10n.emailRequired,
                          l10n.invalidEmail,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildFieldLabel(l10n.password, textTheme),
                      const SizedBox(height: 8),
                      CustomFormField(
                        header: '',
                        hint: l10n.passwordHint,
                        value: _passwordController,
                        focusNode: _passwordFocusNode,
                        isPassword: true,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
                        },
                        validator: (value) => Validators.validatePassword(
                          value,
                          l10n.passwordRequired,
                          l10n.passwordMinLength,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildFieldLabel("Confirm Password", textTheme),
                      const SizedBox(height: 8),
                      CustomFormField(
                        header: '',
                        hint: "Confirm your password",
                        value: _confirmPasswordController,
                        focusNode: _confirmPasswordFocusNode,
                        isPassword: true,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please confirm your password";
                          }
                          if (value != _passwordController.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      CommonButton(
                        onPressed: state is AuthLoading
                            ? null
                            : () => _onSignUpPressed(context),
                        text: l10n.createAccount,
                        borderRadius: 8,
                        isLoading: state is AuthLoading,
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.alreadyHaveAccount,
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                l10n.signIn,
                                style: TextStyle(color: Theme.of(context).colorScheme.primary,
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
              );
            },
          );
        },
      ),
    );
  }
}
