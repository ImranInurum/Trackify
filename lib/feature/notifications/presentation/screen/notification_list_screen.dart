import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/l10n/app_localizations.dart';
import '../cubit/notification_cubit.dart';
import '../cubit/notification_state.dart';
import '../widget/notification_card.dart';
import '../../data/repository/notification_repository_impl.dart';
import '../../../../core/widgets/trackify_loader.dart';

class NotificationListScreen extends StatelessWidget {
  const NotificationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) =>
          NotificationCubit(NotificationRepositoryImpl())..fetchNotifications(),
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            titleSpacing: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: theme.colorScheme.onSurface,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(l10n.notifications),
            centerTitle: false,
            actions: [
              BlocBuilder<NotificationCubit, NotificationState>(
                builder: (context, state) {
                  if (state is NotificationLoaded &&
                      (state.notificationModel.data?.isNotEmpty ?? false)) {
                    return IconButton(
                      tooltip: 'Delete All',
                      icon: Icon(Icons.delete_sweep_outlined,
                          color: Colors.red.shade400),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Delete All Notifications'),
                            content: const Text(
                                'Are you sure you want to delete all notifications?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(true),
                                child: Text('Delete All',
                                    style: TextStyle(
                                        color: Colors.red.shade600)),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true && context.mounted) {
                          final cubit = context.read<NotificationCubit>();
                          await cubit.deleteAllNotifications();
                          if (context.mounted) cubit.fetchNotifications();
                        }
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
          body: BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              if (state is NotificationLoading) {
                return const Center(child: TrackifyLoader(animated: true));
              } else if (state is NotificationError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        color: theme.colorScheme.error,
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<NotificationCubit>().fetchNotifications(),
                        child: Text(l10n.retry),
                      ),
                    ],
                  ),
                );
              } else if (state is NotificationLoaded) {
                final notifications = state.notificationModel.data ?? [];

                if (notifications.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () =>
                        context.read<NotificationCubit>().fetchNotifications(),
                    child: LayoutBuilder(
                      builder: (context, constraints) => SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.notifications_off_outlined,
                                  color: theme.hintColor.withOpacity(0.4),
                                  size: 80,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  l10n.noNotifications,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: theme.hintColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () =>
                      context.read<NotificationCubit>().fetchNotifications(),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      return NotificationCard(
                        notification: notifications[index],
                        onDeleted: () {
                          context.read<NotificationCubit>().fetchNotifications();
                        },
                      );
                    },
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}