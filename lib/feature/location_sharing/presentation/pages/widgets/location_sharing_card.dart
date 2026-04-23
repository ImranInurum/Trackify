import 'package:flutter/material.dart';
import 'package:trackify/core/theme/app_colors.dart';
import 'package:trackify/feature/location_sharing/presentation/cubit/location_sharing_state.dart';
import '../../../../../l10n/app_localizations.dart';

class LocationSharingCard extends StatelessWidget {
  final LocationSharingItem item;
  final VoidCallback onShareTap;
  final VoidCallback onCardTap;

  const LocationSharingCard({
    super.key,
    required this.item,
    required this.onShareTap,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      color: theme.brightness == Brightness.dark
          ? AppColors.cardDark
          : theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onCardTap,
        borderRadius: BorderRadius.circular(14),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: theme.brightness == Brightness.dark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: theme.hintColor.withOpacity(0.5),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        item.isPhone
                            ? Icons.phone_android_rounded
                            : Icons.share_rounded,
                        size: 18,
                        color: theme.hintColor.withOpacity(0.6),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        item.subtitle ?? '',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.hintColor.withOpacity(0.8),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: theme.brightness == Brightness.dark
                  ? AppColors.dividerDark
                  : theme.dividerColor,
            ),
            Container(
              color: theme.canvasColor,
              width: double.infinity,
              height: 50,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: TextButton(
                  onPressed: onShareTap,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.share_rounded,
                        size: 20,
                        color: item.isSharing
                            ? colorScheme.error
                            : colorScheme.primary,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        item.isSharing ? l10n.stopSharing : l10n.shareLocation,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: item.isSharing
                              ? colorScheme.error
                              : colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
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
    );
  }
}
