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
  List<Map<String, dynamic>> _getBenefits() => [
    {
      "highlight": "Guaranteed replacement",
      "normal": " in case of failure",
      "icon": Icons.cached_rounded,
    },
    {
      "highlight": "Save upto ₹1200",
      "normal": " on device repair",
      "icon": Icons.settings_outlined,
    },
    {
      "highlight": "Instant support",
      "normal": " for device related issues",
      "icon": Icons.person_outline_rounded,
    },
    {
      "highlight": "Free extended subscription upto ₹2000",
      "normal": " for faulty period",
      "icon": Icons.subtitles_outlined,
    },
  ];

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: colorScheme.onSurface, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.warranty_title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeightManager.semibold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _topCard(l10n, theme, colorScheme),
                  const SizedBox(height: 32),

                  Text(
                    l10n.warranty_benefitsTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeightManager.regular,
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// 🔹 BENEFITS LIST (Simulating API Data)
                  ..._getBenefits().map((benefit) => _benefitTile(
                        theme: theme,
                        colorScheme: colorScheme,
                        highlightText: benefit['highlight'] as String,
                        normalText: benefit['normal'] as String,
                        icon: benefit['icon'] as IconData,
                      )),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: _bottomButton(l10n, theme, colorScheme),
          ),
        ],
      ),
    );
  }

  /// TOP CARD
  Widget _topCard(
    AppLocalizations l10n,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.surfaceContainerLow,
            colorScheme.surface,
          ],
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                AppImages.installDevices,
                height: 120,
                width: 120,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  l10n.warranty_extend,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.warranty_vehicle,
                        style: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'SP 125',
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.warranty_expiry,
                        style: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 6),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '23 Feb 2027 ',
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            TextSpan(
                              text: '(301 days left)',
                              style: TextStyle(
                                color: colorScheme.secondary.withValues(alpha: 0.7),
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colorScheme.surface,
        border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: colorScheme.tertiary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurface,
                  height: 1.3,
                ),
                children: [
                  TextSpan(
                    text: highlightText,
                    style: TextStyle(
                      color: colorScheme.tertiary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: normalText,
                    style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.9)),
                  ),
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
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [
            colorScheme.tertiary.withValues(alpha: 0.8),
            colorScheme.tertiary,
          ],
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(8),
          child: Center(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: colorScheme.onTertiary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                children: [
                  TextSpan(text: l10n.warranty_button),
                  TextSpan(
                    text: l10n.warranty_button_old,
                    style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: colorScheme.onTertiary.withValues(alpha: 0.4),
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
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
}