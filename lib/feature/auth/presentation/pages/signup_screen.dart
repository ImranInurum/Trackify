import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/feature/auth/presentation/pages/signin_screen.dart';

import '../../../../core/constants/app_images.dart';
import '../../../../core/widgets/custom_form_field.dart';
import '../../../../core/widgets/square_flat_button.dart';
import '../../../../l10n/app_localizations.dart';
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
  String? _selectedRole;

  final List<String> roles = ["admin", "customer"];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignUpPressed(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedRole == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.roleRequired)));
        return;
      }

      final body = {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
        'role': _selectedRole!,
      };

      context.read<AuthCubit>().registerUser(body); // assuming registerUser exists
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: _body());
  }

  Widget _body() {
    return BlocConsumer<AuthCubit, AuthState>(
      builder: (BuildContext context, state) {
        final l10n = AppLocalizations.of(context)!;
        return Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(AppImages.appLogo),
                CustomFormField(
                  header: l10n.name,
                  hint: l10n.nameHint,
                  value: _nameController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return l10n.nameRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                // 🔹 Email
                CustomFormField(
                  header: l10n.email,
                  hint: l10n.emailHint,
                  value: _emailController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return l10n.emailRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                // 🔹 Password
                CustomFormField(
                  header: l10n.password,
                  hint: l10n.passwordHint,
                  value: _passwordController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return l10n.passwordRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedRole,
                        decoration: InputDecoration(
                          labelText: l10n.role,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: roles
                            .map(
                              (role) => DropdownMenuItem<String>(
                                value: role,
                                child: Text(role.toUpperCase()),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() => _selectedRole = value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.roleRequired;
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // 🔹 Sign Up Button
                CommonButton(
                  onPressed: () => _onSignUpPressed(context),
                  text: l10n.createAccount,
                ),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        if (state is RegisterSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.registerSuccess)),
          );

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const SignInScreen()),
          );
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error.message ?? l10n.signUpFailed)),
          );
        }
      },
    );
  }
}
