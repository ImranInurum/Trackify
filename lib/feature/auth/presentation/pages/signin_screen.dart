import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/app_navigation.dart';
import '../../../../core/widgets/custom_form_field.dart';
import '../../../../core/widgets/square_flat_button.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: _body());
  }

  Widget _body() {
    return BlocConsumer<AuthCubit, AuthState>(
      builder: (BuildContext context,state) {
       return Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomFormField(
                  header: "Email",
                  hint: 'example@test.com',
                  value: _emailController,
                  validator: (value) {
                    if(value?.isEmpty ?? true){
                      return "Email required";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15,),
                CustomFormField(header: 'Password', hint: '******', value: _passwordController,           validator: (value) {
                  if(value?.isEmpty ?? true){
                    return "Password required";
                  }
                  return null;
                },),
                SizedBox(height: 15,),
                SquareFlatButton(
                  onPressed: () =>  _onLoginPressed(context),
                  text: 'Sign In',
                ),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Welcome ${state.user.user?.email ?? ''}!')),
          );

          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AppNavigation(),));
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error.message ?? 'Login failed')),
          );
        }
      },
    );
  }
}
