import 'package:flutter/material.dart';
import 'package:trackify/core/utils/flutter_compat_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/location_sharing_cubit.dart';
import 'package:share_plus/share_plus.dart';
import '../cubit/location_sharing_state.dart';
import '../cubit/live/location_sharing_live_cubit.dart';
import '../cubit/live/location_sharing_live_state.dart';
import '../cubit/history/location_sharing_history_cubit.dart';
import '../cubit/history/location_sharing_history_state.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class LocationSharingDetailScreen extends StatefulWidget {
  final LocationSharingItem item;

  const LocationSharingDetailScreen({super.key, required this.item});

  @override
  State<LocationSharingDetailScreen> createState() =>
      _LocationSharingDetailScreenState();
}

class _LocationSharingDetailScreenState
    extends State<LocationSharingDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 1,
        shadowColor: Colors.black.withOpacity( 0.1),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: colorScheme.onSurface,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.item.name,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: BlocBuilder<LocationSharingCubit, LocationSharingState>(
        builder: (context, state) {
          LocationSharingItem currentItem = widget.item;
          if (state is LocationSharingLoaded) {
            currentItem = state.items.firstWhere(
              (i) => i.id == widget.item.id,
              orElse: () => widget.item,
            );
          }

          return Column(
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.dark
                        ? theme.colorScheme.surfaceVariant
                        : theme.colorScheme.onSurface.withOpacity( 0.05),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorPadding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 2,
                    ),
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      color: theme.brightness == Brightness.dark
                          ? theme.colorScheme.surfaceVariant
                          : theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: theme.brightness == Brightness.light
                          ? [
                              BoxShadow(
                                color: theme.shadowColor.withOpacity( 0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    labelColor: colorScheme.primary,
                    unselectedLabelColor: theme.hintColor,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      letterSpacing: 0.8,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      letterSpacing: 0.8,
                    ),
                    tabs: [
                      Tab(text: l10n.liveTab),
                      Tab(text: l10n.historyTab),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildLiveView(context, currentItem),
                    _buildHistoryView(context),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLiveView(BuildContext context, LocationSharingItem item) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<LocationSharingLiveCubit, LocationSharingLiveState>(
      builder: (context, state) {
        if (state is LocationSharingLiveLoading &&
            state is! LocationSharingLiveLoaded) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is LocationSharingLiveLoaded) {
          if (state.items.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Illustration (Motorcyclist)
                  Container(
                    height: 220,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/bg_bike.png',
                        fit: theme.brightness == Brightness.dark
                            ? BoxFit.contain
                            : BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.noLiveLocationShared,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.startSharingPhoneDesc,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.hintColor.withOpacity( 0.7),
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final shareItem = state.items[index];
              String expiresInText = 'Expires soon';
              if (shareItem.expiresAt != null) {
                final now = DateTime.now();
                final expiresAt = shareItem.expiresAt!.toLocal();
                final difference = expiresAt.difference(now);
                if (!difference.isNegative) {
                  final hours = difference.inHours;
                  final minutes = difference.inMinutes % 60;
                  if (hours > 0) {
                    expiresInText = 'Expires in $hours hr $minutes min';
                  } else {
                    expiresInText = 'Expires in $minutes min';
                  }
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: LiveSharingLinkCard(
                  title: shareItem.expiresInHours == -30 
                      ? '30 minutes link' 
                      : l10n.hoursLink(shareItem.expiresInHours.toString()),
                  expiresIn: expiresInText,
                  onStopSharing: () =>
                      _showStopSharingDialog(context, shareItem.token),
                  onShareLink: () {
                    if (shareItem.webLink.isNotEmpty) {
                      Share.share(shareItem.webLink);
                    }
                  },
                ),
              );
            },
          );
        } else if (state is LocationSharingLiveError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildHistoryView(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<
      LocationSharingHistoryCubit,
      LocationSharingHistoryState
    >(
      builder: (context, state) {
        if (state is LocationSharingHistoryLoading &&
            state is! LocationSharingHistoryLoaded) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is LocationSharingHistoryLoaded) {
          if (state.items.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history_toggle_off_rounded,
                    size: 80,
                    color: theme.hintColor.withOpacity( 0.2),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.noHistoryAvailable,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.hintColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.historyDesc,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.hintColor.withOpacity( 0.6),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final shareItem = state.items[index];
              String expiredText = 'Expired';
              if (shareItem.endDate != null) {
                final date = shareItem.endDate!.toLocal();
                final formattedTime = DateFormat(
                  'h:mma',
                ).format(date).toLowerCase();
                final formattedDate = DateFormat('dd/MM/yyyy').format(date);
                expiredText = 'Expired on $formattedTime, $formattedDate';
              } else if (shareItem.stoppedAt != null) {
                final date = shareItem.stoppedAt!.toLocal();
                final formattedTime = DateFormat(
                  'h:mma',
                ).format(date).toLowerCase();
                final formattedDate = DateFormat('dd/MM/yyyy').format(date);
                expiredText = 'Expired on $formattedTime, $formattedDate';
              } else if (shareItem.expiresAt != null) {
                final date = shareItem.expiresAt!.toLocal();
                final formattedTime = DateFormat(
                  'h:mma',
                ).format(date).toLowerCase();
                final formattedDate = DateFormat('dd/MM/yyyy').format(date);
                expiredText = 'Expired on $formattedTime, $formattedDate';
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: HistorySharingLinkCard(
                  title: shareItem.expiresInHours == -30
                      ? '30 minutes link'
                      : '${shareItem.expiresInHours} hours link',
                  expiredText: expiredText,
                ),
              );
            },
          );
        } else if (state is LocationSharingHistoryError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _showStopSharingDialog(BuildContext context, String token) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: theme.dialogBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          content: Text(
            AppLocalizations.of(
              context,
            )!.stopSharingConfirmation(widget.item.name),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity( 0.6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<LocationSharingLiveCubit>().stopSharing(
                  token,
                  onSuccess: () {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppLocalizations.of(context)!.sharingStoppedSuccessfully),
                        ),
                      );
                      // Refresh the main screen item count
                      context
                          .read<LocationSharingCubit>()
                          .fetchActiveShareCount(widget.item);
                    }
                  },
                  onError: (msg) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(msg),
                          backgroundColor: theme.colorScheme.error,
                        ),
                      );
                    }
                  },
                );
              },
              child: Text(
                AppLocalizations.of(context)!.stopSharing,
                style: TextStyle(
                  color: theme.colorScheme.primary,
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

class HistorySharingLinkCard extends StatelessWidget {
  final String title;
  final String expiredText;

  const HistorySharingLinkCard({
    super.key,
    required this.title,
    required this.expiredText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity( 0.5),
          width: 0.5,
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            expiredText,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.hintColor.withOpacity( 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class LiveSharingLinkCard extends StatelessWidget {
  final String title;
  final String expiresIn;
  final VoidCallback? onStopSharing;
  final VoidCallback? onShareLink;

  const LiveSharingLinkCard({
    super.key,
    required this.title,
    required this.expiresIn,
    this.onStopSharing,
    this.onShareLink,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity( 0.5),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      expiresIn,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.hintColor.withOpacity( 0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (onStopSharing != null || onShareLink != null)
            Material(
              color: theme.brightness == Brightness.dark
                  ? theme.colorScheme.surfaceVariant
                  : theme.colorScheme.onSurface.withOpacity( 0.05),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              child: Row(
                children: [
                  if (onStopSharing != null)
                    Expanded(
                      child: InkWell(
                        onTap: onStopSharing,
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.share_location,
                                color: colorScheme.error,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                AppLocalizations.of(context)!.stopSharing,
                                style: TextStyle(
                                  color: colorScheme.error,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (onStopSharing != null && onShareLink != null)
                    Container(height: 20, width: 1, color: theme.dividerColor),
                  if (onShareLink != null)
                    Expanded(
                      child: InkWell(
                        onTap: onShareLink,
                        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.share_rounded,
                                color: theme.colorScheme.primary,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                AppLocalizations.of(context)!.shareLocationLink,
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
