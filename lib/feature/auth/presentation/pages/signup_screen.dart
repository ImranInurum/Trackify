import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/theme/app_colors.dart';
import 'package:trackify/feature/auth/presentation/pages/signin_screen.dart';

import '../../../../core/constants/app_images.dart';
import '../../../../core/widgets/custom_form_field.dart';
import '../../../../core/widgets/square_flat_button.dart';
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

  final List<String> roles = ['admin', 'user', 'manager'];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignUpPressed(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedRole == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Please select a role")));
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
    return Scaffold(appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
    ), body: _body());
  }

  Widget _body() {
    return BlocConsumer<AuthCubit, AuthState>(
      builder: (BuildContext context, state) {
        return Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(AppImages.appLogo),
                CustomFormField(
                  header: "Name",
                  hint: 'John Doe',
                  value: _nameController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return "Name is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                // 🔹 Email
                CustomFormField(
                  header: "Email",
                  hint: 'john@gmail.com',
                  value: _emailController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return "Email is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                // 🔹 Password
                CustomFormField(
                  header: "Password",
                  hint: '******',
                  value: _passwordController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return "Password is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                   dropdownColor: Theme.of(context).colorScheme.background,
                        value: _selectedRole,

                        decoration: InputDecoration(
                          labelText: "Role",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: roles
                            .map(
                              (role) => DropdownMenuItem<String>(
                                value: role,
                                child: Text(role.toUpperCase(),

                                ),

                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() => _selectedRole = value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select a role";
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
                  text: 'Create Account',
                ),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is RegisterSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User Registered Successfully Please Login')),
          );

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const SignInScreen()),
          );
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error.message ?? 'Sign up failed')),
          );
        }
      },
    );
  }
}
