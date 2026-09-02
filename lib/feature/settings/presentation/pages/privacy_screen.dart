import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:trackify/feature/auth/presentation/cubit/auth_cubit.dart';
import 'package:trackify/feature/auth/presentation/cubit/auth_state.dart';
import 'package:trackify/feature/settings/presentation/pages/current_sessions_screen.dart';
import 'package:trackify/feature/settings/presentation/pages/delete_account_screen.dart';
import 'package:trackify/feature/settings/presentation/widgets/setting_list_tile.dart';
import 'package:trackify/l10n/app_localizations.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is ChangePasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password changed successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            l10n.privacy,
            style: TextStyle(
              fontSize: 20.0,
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          surfaceTintColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              SettingListTile(
                icon: Icons.lock,
                title: l10n.changePasswordTitle,
                subtitle: l10n.changePasswordSubtitle,
                showArrow: false,
                showIcon: true,
                onTap: () {
                  _showChangePasswordDialog(context, l10n);
                },
              ),
              SettingListTile(
                icon: Icons.history,
                title: l10n.currentSessions,
                subtitle: l10n.manageLoggedInDevices,
                showArrow: true,
                showIcon: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CurrentSessionsScreen(),
                    ),
                  );
                },
              ),
              SettingListTile(
                icon: Icons.person_remove,
                title: l10n.deleteAccountTitle,
                subtitle: l10n.deleteAccountSubtitle,
                showArrow: true,
                showIcon: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DeleteAccountScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context, AppLocalizations l10n) {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    String? oldPasswordError;
    String? newPasswordError;
    String? confirmPasswordError;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return BlocListener<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is ChangePasswordSuccess) {
                  Navigator.of(dialogContext).pop();
                } else if (state is ChangePasswordFailure) {
                  setState(() {
                    oldPasswordError = state.error.message;
                    newPasswordError = null;
                    confirmPasswordError = null;
                  });
                }
              },
              child: AlertDialog(
                backgroundColor: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                title: Text(
                  l10n.changePasswordTitle,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: oldPasswordController,
                      obscureText: true,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        hintText: l10n.oldPassword,
                        errorText: oldPasswordError,
                        hintStyle: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity( 0.5),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity( 0.5),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        contentPadding: const EdgeInsets.only(bottom: 8),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: newPasswordController,
                      obscureText: true,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        hintText: l10n.newPassword,
                        errorText: newPasswordError,
                        hintStyle: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity( 0.5),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity( 0.5),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        contentPadding: const EdgeInsets.only(bottom: 8),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        hintText: l10n.confirmNewPasswordTitle,
                        errorText: confirmPasswordError,
                        hintStyle: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity( 0.5),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity( 0.5),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        contentPadding: const EdgeInsets.only(bottom: 8),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
                actionsPadding: const EdgeInsets.only(
                  right: 16,
                  bottom: 12,
                  top: 12,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      l10n.cancel,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      final oldPassword = oldPasswordController.text;
                      final newPassword = newPasswordController.text;
                      final confirmPassword = confirmPasswordController.text;

                      setState(() {
                        oldPasswordError = null;
                        newPasswordError = null;
                        confirmPasswordError = null;
                      });

                      if (oldPassword.isEmpty) {
                        setState(() {
                          oldPasswordError = "Old password cannot be empty";
                        });
                        return;
                      }
                      if (newPassword.isEmpty) {
                        setState(() {
                          newPasswordError = "New password cannot be empty";
                        });
                        return;
                      }
                      if (newPassword.length < 6) {
                        setState(() {
                          newPasswordError = l10n.passwordMinLength;
                        });
                        return;
                      }
                      if (newPassword != confirmPassword) {
                        setState(() {
                          confirmPasswordError = l10n.passwordsDoNotMatch;
                        });
                        return;
                      }

                      final userId = AppPreference.instance.getSync(
                        key: AppPreference.KEY_USER_ID,
                      );
                      if (userId.isEmpty) {
                        setState(() {
                          oldPasswordError =
                              "User ID not found. Please log in again.";
                        });
                        return;
                      }

                      final body = {
                        "userId": userId,
                        "oldPassword": oldPassword,
                        "newPassword": newPassword,
                        "confirmPassword": confirmPassword,
                      };

                      BlocProvider.of<AuthCubit>(context).changePassword(body);
                    },
                    child: Text(
                      l10n.save,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
