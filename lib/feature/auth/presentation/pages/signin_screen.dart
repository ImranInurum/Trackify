import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/constants/app_images.dart';
import 'package:trackify/feature/auth/presentation/pages/signup_screen.dart';

import '../../../../app/app_navigation.dart';
import '../../../../core/widgets/custom_form_field.dart';
import '../../../../core/widgets/square_flat_button.dart';
import 'device_list_screen.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: _body());
  }

  Widget _body() {
    return BlocConsumer<AuthCubit, AuthState>(
      builder: (BuildContext context, state) {
        return Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(AppImages.appLogo),
                  const SizedBox(height: 20),
                  CustomFormField(
                    header: "Email",
                    hint: 'example@test.com',
                    value: _emailController,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return "Email required";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  CustomFormField(
                    header: 'Password',
                    hint: '******',
                    value: _passwordController,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return "Password required";
                      }
                      return null;
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CommonButton(
                    onPressed: () => _onLoginPressed(context),
                    text: 'Sign In',
                  ),
                  Row(
                    children: [
                      Expanded(
                          child:
                              Divider(color: Colors.grey[300], thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("or",
                            style: TextStyle(color: Colors.grey[600])),
                      ),
                      Expanded(
                          child:
                              Divider(color: Colors.grey[300], thickness: 1)),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.black87),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => SignUpScreen()),
                            );
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Welcome ${state.user.user?.email ?? ''}!')),
          );

          Navigator.of(
            context,
          ).pushReplacement(MaterialPageRoute(
              builder: (context) => const DeviceListScreen()));
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(
              SnackBar(content: Text(state.error.message ?? 'Login failed')));
        }
      },
    );
  }
}
