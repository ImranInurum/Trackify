import 'package:flutter/material.dart';
import 'package:trackify/l10n/app_localizations.dart';

class CurrentSessionsScreen extends StatelessWidget {
  const CurrentSessionsScreen({super.key});

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
          l10n.currentSessions,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildActiveSessionItem(context, l10n),
            Container(
              width: double.infinity,
              color: Theme.of(context).dividerColor.withOpacity(0.5),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                l10n.otherDevices,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            _buildOtherSessionItem(
              context,
              l10n,
              deviceName: 'iQOO I2501',
              timeAgo: '6 months',
              lastUsed: '${l10n.lastUsed} 3 Jul 2026 at 10:37:36 AM.',
              osVersion: '${l10n.osLabel} Android 16',
            ),
            const Divider(height: 1, thickness: 1),
            _buildOtherSessionItem(
              context,
              l10n,
              deviceName: 'samsung SM-A346E',
              timeAgo: '3 months',
              lastUsed: '${l10n.lastUsed} 27 Jun 2026 at 03:38:27 PM.',
              osVersion: '${l10n.osLabel} Android 16',
            ),
            const Divider(height: 1, thickness: 1),
            _buildOtherSessionItem(
              context,
              l10n,
              deviceName: 'motorola moto g32',
              timeAgo: '1 day',
              lastUsed: '${l10n.lastUsed} 2 Jul 2026 at 06:57:42 PM.',
              osVersion: '${l10n.osLabel} Android 13',
            ),
            const Divider(height: 1, thickness: 1),
            _buildOtherSessionItem(
              context,
              l10n,
              deviceName: 'realme RMX3521',
              timeAgo: '3 months',
              lastUsed: '${l10n.lastUsed} 1 May 2026 at 06:12:02 PM.',
              osVersion: '${l10n.osLabel} Android 14',
            ),
            const Divider(height: 1, thickness: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveSessionItem(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.android, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), size: 30),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'samsung SM-M346B',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '2 months',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.activeOnThisDevice,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${l10n.lastUsed} 3 Jul 2026 at 10:37:25 AM.',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${l10n.osLabel} Android 16',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.public, size: 18, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                    const SizedBox(width: 6),
                    Text(
                      l10n.chromeNotificationDisabled,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtherSessionItem(
    BuildContext context,
    AppLocalizations l10n, {
    required String deviceName,
    required String timeAgo,
    required String lastUsed,
    required String osVersion,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.android, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), size: 30),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        deviceName,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      timeAgo,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  lastUsed,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  osVersion,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.public, size: 18, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                        const SizedBox(width: 6),
                        Text(
                          l10n.chromeNotificationDisabled,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 36,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Theme.of(context).colorScheme.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: Text(
                          l10n.logOut,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
