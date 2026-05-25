import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trackify/feature/auth/presentation/pages/signin_screen.dart';
import 'package:trackify/feature/onboarding/presentation/cubit/splash_cubit.dart';
import 'package:trackify/feature/onboarding/presentation/cubit/splash_state.dart';

import '../../../../core/utils/validators.dart';
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
  final _mobileController = TextEditingController();
  final _countryController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();

  File? _userProfile;
  final ValueNotifier<String?> selectedRoleNotifier = ValueNotifier<String?>(null);
  String? _selectedRole;

  final List<String> roles = ["admin", "customer"];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _mobileController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _userProfile = File(pickedFile.path);
      });
    }
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

      final body = <String, dynamic>{
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
        'role': _selectedRole!,
        'mobile_number': _mobileController.text.trim(),
        'country': _countryController.text.trim(),
        'state': _stateController.text.trim(),
        'city': _cityController.text.trim(),
      };

      if (_userProfile != null) {
        body['userProfileBytes'] = _userProfile!.readAsBytesSync();
        body['userProfileName'] = _userProfile!.path.split('/').last;
      }

      context.read<AuthCubit>().registerUser(body); // assuming registerUser exists
    }
  }

  Widget _buildLogo(SplashState state) {
    if (state is SplashLoaded && state.logo.path != null && state.logo.path!.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: CachedNetworkImage(
          imageUrl: state.logo.path!,
          height: 220,
          fit: BoxFit.contain,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          errorWidget: (context, url, error) => Icon(
            Icons.track_changes_rounded,
            size: 88,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }
    return Icon(
      Icons.track_changes_rounded,
      size: 88,
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
          icon: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          final l10n = AppLocalizations.of(context)!;
          if (state is RegisterSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(l10n.registerSuccess)));
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const SignInScreen()),
            );
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
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 10),
                        _buildLogo(splashState),
                        const SizedBox(height: 20),
                        Center(
                          child: GestureDetector(
                            onTap: _pickProfileImage,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Theme.of(context).cardColor,
                              backgroundImage: _userProfile != null
                                  ? FileImage(_userProfile!)
                                  : null,
                              child: _userProfile == null
                                  ? Icon(
                                      Icons.camera_alt,
                                      size: 40,
                                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            l10n.selectProfileImage,
                            style: textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildFieldLabel(l10n.name, textTheme),
                        const SizedBox(height: 8),
                        CustomFormField(
                          header: '',
                          hint: l10n.nameHint,
                          value: _nameController,
                          keyboardType: TextInputType.name,
                          validator: (value) =>
                              Validators.validateRequired(value, l10n.nameRequired),
                        ),
                        const SizedBox(height: 20),
                        _buildFieldLabel(l10n.email, textTheme),
                        const SizedBox(height: 8),
                        CustomFormField(
                          header: '',
                          hint: l10n.emailHint,
                          value: _emailController,
                          keyboardType: TextInputType.emailAddress,
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
                          isPassword: true,
                          validator: (value) => Validators.validatePassword(
                            value,
                            l10n.passwordRequired,
                            l10n.passwordMinLength,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildFieldLabel(l10n.mobileNumber, textTheme),
                        const SizedBox(height: 8),
                        CustomFormField(
                          header: '',
                          hint: l10n.mobileNumberHint,
                          value: _mobileController,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          validator: (value) => Validators.validatePhone(
                            value,
                            l10n.mobileNumberRequired,
                            l10n.invalidMobileNumber,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildFieldLabel(l10n.country, textTheme),
                        const SizedBox(height: 8),
                        CustomFormField(
                          header: '',
                          hint: l10n.countryHint,
                          value: _countryController,
                          keyboardType: TextInputType.text,
                          validator: (value) =>
                              Validators.validateRequired(value, l10n.countryRequired),
                        ),
                        const SizedBox(height: 20),
                        _buildFieldLabel(l10n.state, textTheme),
                        const SizedBox(height: 8),
                        CustomFormField(
                          header: '',
                          hint: l10n.stateHint,
                          value: _stateController,
                          keyboardType: TextInputType.text,
                          validator: (value) =>
                              Validators.validateRequired(value, l10n.stateRequired),
                        ),
                        const SizedBox(height: 20),
                        _buildFieldLabel(l10n.city, textTheme),
                        const SizedBox(height: 8),
                        CustomFormField(
                          header: '',
                          hint: l10n.cityHint,
                          value: _cityController,
                          keyboardType: TextInputType.text,
                          validator: (value) =>
                              Validators.validateRequired(value, l10n.cityRequired),
                        ),
                        const SizedBox(height: 20),
                        _buildFieldLabel(l10n.role, textTheme),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: DropdownButtonFormField2<String>(
                            isExpanded: true,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            valueListenable: selectedRoleNotifier,
                            decoration: InputDecoration(
                              hintText: l10n.selectRoleHint,
                              filled: true,
                              fillColor: theme.inputDecorationTheme.fillColor ?? theme.cardColor,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 0,
                                vertical: 14,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Theme.of(context).dividerColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Theme.of(context).dividerColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 1.5,
                                ),
                              ),
                            ),
                            iconStyleData: IconStyleData(
                              icon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                size: 24,
                              ),
                            ),
                            dropdownStyleData: DropdownStyleData(
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              offset: const Offset(0, 6),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            items: roles.map((role) {
                              return DropdownItem<String>(
                                value: role, // if error, change this to: id: role
                                child: Text(
                                  role == 'admin' ? l10n.roleAdmin : l10n.roleCustomer,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              selectedRoleNotifier.value = value;
                              _selectedRole = selectedRoleNotifier.value;
                            },
                            validator: (value) =>
                                Validators.validateRequired(value, l10n.roleRequired),
                          ),
                        ),
                        const SizedBox(height: 32),
                        CommonButton(
                          onPressed: state is AuthLoading ? null : () => _onSignUpPressed(context),
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
                                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  l10n.signIn,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
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
    );
  }
}
