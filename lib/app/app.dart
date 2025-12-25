import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/app/cubit/app_cubit.dart';
import 'package:trackify/app/cubit/app_state.dart';
import 'package:trackify/core/theme/app_theme.dart';
import 'package:trackify/feature/auth/presentation/pages/signin_screen.dart';

import '../feature/auth/data/repository/auth_repository_impl.dart';
import '../feature/auth/domain/usecase/auth_case.dart';
import '../feature/auth/presentation/cubit/auth_cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) => MaterialApp(
        themeMode: state.themeMode,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: const SignInScreen(),
      ),
    );
  }
}
