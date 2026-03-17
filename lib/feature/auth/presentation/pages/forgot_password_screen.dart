import 'package:flutter/material.dart';

import '../../../../core/constants/app_images.dart';
import '../../../../core/widgets/custom_form_field.dart';
import '../../../../core/widgets/square_flat_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSubmitPressed(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement actual Forgot Password API call
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Password reset link sent to email (Mock)')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
        centerTitle: true,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.asset(AppImages.appLogo)),
            const SizedBox(height: 20),
            Text(
              "Reset Password",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              "Enter your email address and we will send you a link to reset your password.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                  ),
            ),
            const SizedBox(height: 25),
            CustomFormField(
              header: "Email",
              hint: 'example@test.com',
              value: _emailController,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return "Email is required";
                }
                return null;
              },
            ),
            const SizedBox(height: 35),
            CommonButton(
              onPressed: () => _onSubmitPressed(context),
              text: 'Send Reset Link',
            ),
          ],
        ),
      ),
    );
  }
}
