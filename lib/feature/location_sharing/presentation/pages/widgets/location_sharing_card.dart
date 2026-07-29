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

      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),

      elevation: 0,

      color: theme.brightness == Brightness.dark
          ? AppColors.cardDark
          : theme.cardColor,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),

      child: InkWell(

        onTap: onCardTap,

        borderRadius: BorderRadius.circular(14),

        child: Column(

          children: [

            Padding(

              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                16,
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.isSharing) ...[
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          l10n.sharingActive,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.isPhone ? l10n.yourPhoneLocation : item.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
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
                        Icons.share_rounded,
                        size: 14,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.isSharing ? '1 active sharing' : '0 active sharing',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontSize: 13,
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

              color: theme.brightness ==
                  Brightness.dark
                  ? AppColors.dividerDark
                  : theme.dividerColor,
            ),

            Container(

              color: theme.canvasColor,

              width: double.infinity,
              height: 50,

              child: Padding(

                padding:
                const EdgeInsets.symmetric(
                  vertical: 4,
                ),

                child: TextButton(

                  onPressed: onShareTap,

                  style: TextButton.styleFrom(

                    padding:
                    const EdgeInsets.symmetric(
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
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        l10n.shareLocation,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colorScheme.primary,
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