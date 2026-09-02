import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:trackify/feature/onboarding/presentation/cubit/splash_cubit.dart';
import 'package:trackify/feature/onboarding/presentation/cubit/splash_state.dart';

import '../../../../core/widgets/custom_form_field.dart';
import '../../../../core/widgets/square_flat_button.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'reset_password_screen.dart';
import '../../../../core/utils/validators.dart';
import '../../../../l10n/app_localizations.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;

  const OtpVerificationScreen({super.key, required this.email});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _onVerifyPressed(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().verifyOtp({
        "email": widget.email,
        "otp": _otpController.text.trim(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        if (state is ForgotPasswordOtpVerified) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.otpVerified)),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResetPasswordScreen(
                email: widget.email,
              ),
            ),
          );
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error.message??"")),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () => Navigator.maybePop(context),
          ),
        ),
        body: _body(),
      ),
    );
  }

  Widget _body() {
    final l10n = AppLocalizations.of(context)!;
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BlocBuilder<SplashCubit, SplashState>(
              builder: (context, splashState) {
                if (splashState is SplashLoaded &&
                    splashState.logo.path != null &&
                    splashState.logo.path!.isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 40),
                      child: Image.network(
                        splashState.logo.path!,
                        height: 180,
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                }
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Icon(
                      Icons.track_changes_rounded,
                      size: 88,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            Text(
              l10n.otpDesc(widget.email),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.6),
                  ),
            ),
            const SizedBox(height: 35),
            CustomFormField(
              header: l10n.otp,
              hint: l10n.otpHint,
              value: _otpController,
              keyboardType: TextInputType.number,
              validator: (value) => Validators.validateRequired(
                value,
                l10n.otpRequired,
              ),
            ),
            const SizedBox(height: 35),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return CommonButton(
                  onPressed: state is AuthLoading ? null : () => _onVerifyPressed(context),
                  text: l10n.verifyOtp,
                  isLoading: state is AuthLoading,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
