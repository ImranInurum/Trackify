import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/constants/app_images.dart';
import 'package:trackify/l10n/app_localizations.dart';

import '../cubit/safe_parking_cubit.dart';

class SafeParkingScreen extends StatelessWidget {
  const SafeParkingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;
    final text = theme.textTheme;
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;

    return BlocProvider(
      create: (_) => SafeParkingCubit(),
      child: Builder(
        builder: (context) {
          final state = context.watch<SafeParkingCubit>().state;
          final cubit = context.read<SafeParkingCubit>();

          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,

            /// 🔥 APP BAR
            appBar: AppBar(
              backgroundColor: theme.scaffoldBackgroundColor,
              elevation: 0,
              centerTitle: false,
              title: Text(l10n.safeParking),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  size: 20,
                  color: color.onSurface,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: color.primary.withValues(alpha: 0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      l10n.schedule,
                      style: text.labelMedium?.copyWith(
                        color: color.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              ],
            ),

            /// 🔥 BODY
            body: Column(
              children: [
                const SizedBox(height: 20),

                /// Illustration
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: 220,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          color.primaryContainer,
                          color.surface,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Center(
                        child: Image.asset(
                          width: double.infinity,
                          AppImages.safeParking,
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  ),
                ),


                const SizedBox(height: 20),

                /// Title
                Text(
                  l10n.setupSafeParking,
                  style: text.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                /// Subtitle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    l10n.safeParkingSubtitle,
                    textAlign: TextAlign.center,
                    style: text.bodyMedium?.copyWith(
                      color: color.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),

                const Spacer(),

                /// 🔥 CUBIT BUTTON
                GestureDetector(
                  onTap: cubit.toggle,
                  child: Container(
                    height: 180,
                    width: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: state.isActivated
                            ? [
                          color.primary,
                          color.primary.withValues(alpha: 0.7),
                        ]
                            : isDark
                            ? [
                          color.surfaceContainerHighest,
                          color.surface,
                        ]
                            : [
                          color.surfaceContainerHighest,
                          color.surface,
                        ],
                      ),
                      border: Border.all(
                        color: color.primary,
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        state.isActivated
                            ? l10n.activated
                            : l10n.activate,
                        style: text.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: state.isActivated
                              ? color.onPrimary
                              : color.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 60),
              ],
            ),
          );
        },
      ),
    );
  }
}
