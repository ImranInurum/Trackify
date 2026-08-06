import 'package:flutter/material.dart';
import 'package:trackify/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/app/cubit/app_cubit.dart';
import 'package:trackify/app/cubit/app_state.dart';
import 'package:trackify/feature/auth/presentation/pages/signin_screen.dart';
import 'package:trackify/core/widgets/loading_screen_ol.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.deleteAccountTitle, ),
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<AppCubit, AppState>(
                builder: (context, appState) {
                  final userName = appState.userData?.name ?? l10n.guest;
                  return RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                      children: [
                        TextSpan(text: '${l10n.hi} '),
                        TextSpan(
                          text: userName,
                          style: TextStyle(fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              ),
              const SizedBox(height: 8),
              Text(
                l10n.sorryToSeeYouGo,
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                l10n.note,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(height: 12),
              _buildBulletPoint(
                context,
                l10n.deleteAccountNote1,
              ),
              const SizedBox(height: 8),
              _buildBulletPoint(
                context,
                l10n.deleteAccountNote2,
              ),
              const SizedBox(height: 32),
              Text(
                l10n.deleteAccountExplanationPrompt,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                maxLines: 1,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: l10n.explanationOptionalHint,
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: TextButton(
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, l10n);
                  },
                  child: Text(
                    l10n.deleteAccountTitle,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                  children: [
                    TextSpan(text: l10n.deleteWarningPart1),
                    TextSpan(
                      text: l10n.terminated,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                    TextSpan(text: l10n.deleteWarningPart2),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6, right: 10, left: 4),
          child: CircleAvatar(
            radius: 3,
            backgroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          title: null,
          content: Text(
            l10n.confirmDeleteAccount,
            style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          actionsPadding: const EdgeInsets.only(right: 16, bottom: 12),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                l10n.cancel,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                final navigator = Navigator.of(context, rootNavigator: true);
                final appCubit = context.read<AppCubit>();
                final userId = appCubit.state.userData?.id;

                Navigator.of(dialogContext).pop();

                if (userId == null || userId.isEmpty) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text(l10n.deleteAccountFailedNoUser),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                  return;
                }

                LoadingScreenOL().show();
                final result = await appCubit.deleteAccount(userId);
                LoadingScreenOL().hide();

                result.fold(
                  (failure) {
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Text(l10n.errorDeletingAccount(failure.message)),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  },
                  (_) {
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Text(l10n.deleteAccountSuccess),
                        backgroundColor: Colors.green,
                      ),
                    );
                    navigator.pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const SignInScreen(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                );
              },
              child: Text(
                l10n.delete,
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
