import 'package:flutter/material.dart';
import 'package:trackify/core/config/font_manager.dart';
import 'package:trackify/core/constants/app_images.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

class WarrantyScreen extends StatefulWidget {
  const WarrantyScreen({super.key});

  @override
  State<WarrantyScreen> createState() => _WarrantyScreenState();
}

class _WarrantyScreenState extends State<WarrantyScreen> {
  bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dark = isDark(context);
    return Scaffold(
      extendBody: true,
      backgroundColor:
      dark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor:
        dark ? AppColors.backgroundDark : AppColors.backgroundLight,
        elevation: 0,
        centerTitle: true,
        title: Text(
          l10n.warranty_title,
          style: TextStyle(
            color: dark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
            fontWeight: FontWeightManager.semibold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _topCard(dark),
            const SizedBox(height: 20),

            Text(
              l10n.warranty_benefitsTitle,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeightManager.semibold,
                color: dark
                    ? AppColors.textPrimaryDark.withOpacity(0.8)
                    : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 12),

            _benefitTile(
              highlightText: l10n.benefit1_highlight,
              normalText: l10n.benefit1_normal,
              icon: Icons.workspace_premium,
              dark: dark,
            ),
            _benefitTile(
              highlightText: l10n.benefit2_highlight,
              normalText: l10n.benefit2_normal,
              icon: Icons.settings,
              dark: dark,
            ),
            _benefitTile(
              highlightText: l10n.benefit3_highlight,
              normalText: l10n.benefit3_normal,
              icon: Icons.support_agent,
              dark: dark,
            ),
            _benefitTile(
              highlightText: l10n.benefit4_highlight,
              normalText: l10n.benefit4_normal,
              icon: Icons.credit_card,
              dark: dark,
            ),

            const Spacer(),

            _bottomButton(),
          ],
        ),
      ),
    );
  }

  ///  TOP CARD
  Widget _topCard(bool dark) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            AppColors.warrantyCardStart.withOpacity(0.9),
            AppColors.warrantyCardEnd,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           SizedBox(height: 18),

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
                  style:  TextStyle(
                    color: Colors.white,
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
              color: AppColors.inactiveMarker.withOpacity(0.8),
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
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "SP 125",
                      style: TextStyle(
                        color: Colors.white,
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
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 12),
                        children: [
                          const TextSpan(
                            text: "23 Feb 2027 ",
                            style: TextStyle(color: Colors.white),
                          ),
                          TextSpan(
                            text: "(301 days left)",
                            style: TextStyle(
                              color: AppColors.success,
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
          SizedBox(height: 9,),
        ],
      ),
    );
  }

  ///  BENEFIT TILE
  Widget _benefitTile({
    required String highlightText,
    required String normalText,
    required IconData icon,
    required bool dark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: dark
            ? AppColors.warrantyTileDark
            : AppColors.surfaceLight,
        border: Border.all(
          color: dark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.paletteTan.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.paletteTan,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  color: dark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
                children: [
                  TextSpan(
                    text: highlightText,
                    style: TextStyle(
                      color: AppColors.paletteTan,
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

  //Bottom button
  Widget _bottomButton() {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            AppColors.warrantyButtonEnd,
            AppColors.warrantyButtonStart.withOpacity(0.9),
          ],
        ),
      ),
      child: Center(
        child: RichText(
          text: TextSpan(
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(text: l10n.warranty_button),
              TextSpan(
                text: l10n.warranty_button_old,
                style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.black54,
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