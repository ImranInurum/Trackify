import 'package:flutter/material.dart';
import 'package:trackify/core/config/font_manager.dart';
import 'package:trackify/core/constants/app_images.dart';
import '../../../l10n/app_localizations.dart';

class WarrantyScreen extends StatefulWidget {
  const WarrantyScreen({super.key});

  @override
  State<WarrantyScreen> createState() => _WarrantyScreenState();
}

class _WarrantyScreenState extends State<WarrantyScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          l10n.warranty_title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeightManager.semibold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _topCard(l10n, theme, colorScheme),
            const SizedBox(height: 20),

            Text(
              l10n.warranty_benefitsTitle,
              style: theme.textTheme.titleSmall?.copyWith(
                fontSize: 16,
                fontWeight: FontWeightManager.semibold,
                color: colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 12),

            _benefitTile(
              theme: theme,
              colorScheme: colorScheme,
              highlightText: l10n.benefit1_highlight,
              normalText: l10n.benefit1_normal,
              icon: Icons.workspace_premium,
            ),
            _benefitTile(
              theme: theme,
              colorScheme: colorScheme,
              highlightText: l10n.benefit2_highlight,
              normalText: l10n.benefit2_normal,
              icon: Icons.settings,
            ),
            _benefitTile(
              theme: theme,
              colorScheme: colorScheme,
              highlightText: l10n.benefit3_highlight,
              normalText: l10n.benefit3_normal,
              icon: Icons.support_agent,
            ),
            _benefitTile(
              theme: theme,
              colorScheme: colorScheme,
              highlightText: l10n.benefit4_highlight,
              normalText: l10n.benefit4_normal,
              icon: Icons.credit_card,
            ),

            const Spacer(),

            _bottomButton(l10n, theme, colorScheme),
          ],
        ),
      ),
    );
  }

  /// TOP CARD
  Widget _topCard(
    AppLocalizations l10n,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    // Darker tonal end for the gradient — derived from primary, no static hex
    final gradientEnd = Color.alphaBlend(
      colorScheme.onSurface.withValues(alpha: 0.35),
      colorScheme.primary,
    );

    return Container(
      height: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [colorScheme.primaryContainer, gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 18),

          Row(
            children: [
              Image.asset(
                AppImages.installDevices,
                height: 150,
                width: 175,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.warranty_extend,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeightManager.semibold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),

          const Spacer(),

          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.warranty_vehicle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onPrimary.withValues(alpha: 0.7),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'SP 125',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeightManager.semibold,
                      ),
                    ),
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      l10n.warranty_expiry,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onPrimary.withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 12),
                        children: [
                          TextSpan(
                            text: '23 Feb 2027 ',
                            style: TextStyle(color: colorScheme.onPrimary),
                          ),
                          TextSpan(
                            text: '(301 days left)',
                            style: TextStyle(
                              color: colorScheme.secondary,
                              fontWeight: FontWeightManager.regular,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 9),
        ],
      ),
    );
  }

  /// BENEFIT TILE
  Widget _benefitTile({
    required ThemeData theme,
    required ColorScheme colorScheme,
    required String highlightText,
    required String normalText,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colorScheme.surfaceContainerHighest,
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: colorScheme.tertiary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: colorScheme.tertiary, size: 18),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: RichText(
              text: TextSpan(
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 14,
                  color: colorScheme.onSurface,
                ),
                children: [
                  TextSpan(
                    text: highlightText,
                    style: TextStyle(
                      color: colorScheme.tertiary,
                      fontWeight: FontWeightManager.semibold,
                    ),
                  ),
                  TextSpan(text: normalText),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// BOTTOM BUTTON
  Widget _bottomButton(
    AppLocalizations l10n,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            colorScheme.tertiaryContainer,
            colorScheme.tertiary,
          ],
        ),
      ),
      child: Center(
        child: RichText(
          text: TextSpan(
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onTertiary,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(text: l10n.warranty_button),
              TextSpan(
                text: l10n.warranty_button_old,
                style: TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: colorScheme.onTertiary.withValues(alpha: 0.54),
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}