import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/location_sharing_cubit.dart';
import '../cubit/location_sharing_state.dart';
import 'package:trackify/core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

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
        shadowColor: Colors.black.withOpacity(0.1),
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
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.dark
                        ? const Color(0xFF1A1A1A)
                        : AppColors.dividerLight,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      color: theme.brightness == Brightness.dark
                          ? const Color(0xFF333333)
                          : theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: theme.brightness == Brightness.light
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    labelColor: colorScheme.primary,
                    unselectedLabelColor: theme.brightness == Brightness.dark 
                        ? Colors.white.withOpacity(0.6)
                        : theme.hintColor,
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
                    _buildHistoryView(context)
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

    if (item.isSharing) {
      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: const [
          LiveSharingLinkCard(
            title: '2 hours link',
            expiresIn: 'Expires in 1 hr 52 min',
            viewers: 0,
          ),
          SizedBox(height: 16),
          LiveSharingLinkCard(
            title: '2 hours link',
            expiresIn: 'Expires in 1 hr 51 min',
            viewers: 0,
          ),
        ],
      );
    }

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
              color: theme.brightness == Brightness.dark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.startSharingPhoneDesc,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.hintColor.withOpacity(0.7),
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryView(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_toggle_off_rounded,
            size: 80,
            color: theme.hintColor.withOpacity(0.2),
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
              color: theme.hintColor.withOpacity(0.6),
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
  final int viewers;

  const LiveSharingLinkCard({
    super.key,
    required this.title,
    required this.expiresIn,
    required this.viewers,
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
          color: theme.dividerColor.withOpacity(0.5),
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
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      expiresIn,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.hintColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.visibility,
                      size: 16,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$viewers',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.dark
                  ? const Color(0xFF1E1E1E)
                  : const Color(0xFFF5F5F5),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      // Stop sharing logic
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cancel_outlined, // Better matching icon for stop sharing if available
                          color: colorScheme.error,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Stop Sharing',
                          style: TextStyle(
                            color: colorScheme.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 20,
                  width: 1,
                  color: theme.dividerColor,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      // Share link logic
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.share_rounded,
                          color: colorScheme.primary,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Share location link',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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
