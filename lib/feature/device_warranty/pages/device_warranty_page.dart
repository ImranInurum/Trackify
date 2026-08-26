import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:trackify/core/config/font_manager.dart';
import 'package:trackify/core/constants/app_images.dart';
import 'package:trackify/core/theme/app_colors.dart';
import 'package:trackify/feature/device_warranty/presentation/cubit/device_warranty_cubit.dart';
import 'package:trackify/feature/device_warranty/presentation/cubit/device_warranty_state.dart';
import 'package:trackify/feature/device_warranty/domain/entities/device_warranty_entity.dart';
import '../../../l10n/app_localizations.dart';
import 'device_warranty_confirm_screen.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';

class WarrantyScreen extends StatefulWidget {
  const WarrantyScreen({super.key});

  @override
  State<WarrantyScreen> createState() => _WarrantyScreenState();
}

class _WarrantyScreenState extends State<WarrantyScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DeviceWarrantyCubit>().load();
  }

  List<Map<String, dynamic>> _getBenefits(AppLocalizations l10n) => [
    {
      "highlight": l10n.benefit1_highlight,
      "normal": l10n.benefit1_normal,
      "icon": Icons.autorenew_rounded,
    },
    {
      "highlight": l10n.benefit2_highlight,
      "normal": l10n.benefit2_normal,
      "icon": Icons.build_circle_outlined,
    },
    {
      "highlight": l10n.benefit3_highlight,
      "normal": l10n.benefit3_normal,
      "icon": Icons.support_agent_rounded,
    },
    {
      "highlight": l10n.benefit4_highlight,
      "normal": l10n.benefit4_normal,
      "icon": Icons.verified_user_outlined,
    },
  ];

  IconData _getBenefitIcon(int index) {
    switch (index) {
      case 0:
        return Icons.autorenew_rounded;
      case 1:
        return Icons.build_circle_outlined;
      case 2:
        return Icons.support_agent_rounded;
      case 3:
        return Icons.verified_user_outlined;
      default:
        return Icons.check_circle_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? theme.scaffoldBackgroundColor : const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: isDark ? theme.scaffoldBackgroundColor : const Color(0xFFF7F9FC),
        elevation: 0,
        centerTitle: false,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: colorScheme.onSurface,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          l10n.warranty_title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: colorScheme.onSurface,
          ),
        ),
      ),
      body: BlocBuilder<DeviceWarrantyCubit, DeviceWarrantyState>(
        builder: (context, state) {
          if (state is DeviceWarrantyLoading || state is DeviceWarrantyInitial) {
            return const Center(child: TrackifyLoader());
          }

          if (state is DeviceWarrantyError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      color: colorScheme.error,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => context.read<DeviceWarrantyCubit>().load(),
                      icon: const Icon(Icons.refresh_rounded),
                      label: Text(l10n.retry),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is DeviceWarrantyLoaded) {
            final warrantyData = state.warranty;
            final offer = warrantyData.offer;

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _topCard(l10n, theme, colorScheme, warrantyData, isDark),
                        const SizedBox(height: 28),

                        Text(
                          l10n.warranty_benefitsTitle,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 14),

                        /// 🔹 BENEFITS LIST
                        if (offer != null && offer.benefits.isNotEmpty)
                          ...offer.benefits.asMap().entries.map(
                            (entry) {
                              final index = entry.key;
                              final benefit = entry.value;
                              return _benefitTile(
                                theme: theme,
                                colorScheme: colorScheme,
                                isDark: isDark,
                                highlightText: "${benefit.title} ",
                                normalText: benefit.subtitle,
                                icon: _getBenefitIcon(index),
                              );
                            },
                          )
                        else
                          ..._getBenefits(l10n).map(
                            (benefit) => _benefitTile(
                              theme: theme,
                              colorScheme: colorScheme,
                              isDark: isDark,
                              highlightText: benefit['highlight'] as String,
                              normalText: benefit['normal'] as String,
                              icon: benefit['icon'] as IconData,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (offer != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: isDark ? colorScheme.surface : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
                          blurRadius: 16,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: _bottomButton(l10n, theme, colorScheme, warrantyData),
                    ),
                  ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// TOP CARD
  Widget _topCard(
    AppLocalizations l10n,
    ThemeData theme,
    ColorScheme colorScheme,
    DeviceWarrantyEntity warrantyData,
    bool isDark,
  ) {
    final offer = warrantyData.offer;
    final vehicle = warrantyData.vehicle;
    final warranty = warrantyData.warranty;

    Widget imageWidget;
    if (offer != null && offer.productImage.isNotEmpty) {
      imageWidget = CachedNetworkImage(
        imageUrl: offer.productImage,
        height: 80,
        width: 80,
        fit: BoxFit.contain,
        placeholder: (context, url) => const SizedBox(
          height: 80,
          width: 80,
          child: Center(child: TrackifyLoader()),
        ),
        errorWidget: (context, url, error) => Image.asset(
          AppImages.installDevices,
          height: 80,
          width: 80,
          fit: BoxFit.contain,
        ),
      );
    } else {
      imageWidget = Image.asset(
        AppImages.installDevices,
        height: 80,
        width: 80,
        fit: BoxFit.contain,
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDark ? colorScheme.surface : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDark ? colorScheme.outline.withOpacity(0.2) : const Color(0xFFE8EEF5),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? colorScheme.onSurface.withOpacity(0.05) : const Color(0xFFF3F7FA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: imageWidget,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  offer?.title.isNotEmpty == true ? offer!.title : l10n.warranty_extend,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? colorScheme.onSurface.withOpacity(0.08) : const Color(0xFFF0F5FA),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? Colors.transparent : const Color(0xFFE2ECF5),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.warranty_vehicle.toUpperCase(),
                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.5),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        vehicle?.displayName ?? l10n.vehicleNamePlaceholder,
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 36,
                  width: 1,
                  color: isDark ? colorScheme.outline.withOpacity(0.2) : const Color(0xFFCBD5E1),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.warranty_expiry.toUpperCase(),
                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.5),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          Text(
                            warranty?.expiryDateText ?? '--',
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          if ((warranty?.daysLeft ?? 0) > 0 && (warranty?.daysLeftText.isNotEmpty == true))
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFECFDF5),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFFA7F3D0)),
                              ),
                              child: Text(
                                warranty!.daysLeftText,
                                style: const TextStyle(
                                  color: Color(0xFF059669),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          else if ((warranty?.daysLeft ?? 0) <= 0)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF2F2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFFFECACA)),
                              ),
                              child: Text(
                                l10n.expired,
                                style: TextStyle(
                                  color: colorScheme.error,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
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
          ),
        ],
      ),
    );
  }

  /// BENEFIT TILE
  Widget _benefitTile({
    required ThemeData theme,
    required ColorScheme colorScheme,
    required bool isDark,
    required String highlightText,
    required String normalText,
    required IconData icon,
  }) {
    final primaryAccent = isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: isDark ? colorScheme.surface : Colors.white,
        border: Border.all(
          color: isDark ? colorScheme.outline.withOpacity(0.2) : const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isDark ? primaryAccent.withOpacity(0.15) : const Color(0xFFE0F2FE),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: primaryAccent, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurface,
                  height: 1.35,
                  fontFamily: FontFamilyManager.fontFamily,
                ),
                children: [
                  TextSpan(
                    text: highlightText,
                    style: TextStyle(
                      color: primaryAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: normalText,
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.85),
                      fontWeight: FontWeight.w500,
                    ),
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
    DeviceWarrantyEntity warrantyData,
  ) {
    final offer = warrantyData.offer;
    if (offer == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0284C7),
            Color(0xFF0369A1),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0284C7).withOpacity(0.35),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DeviceWarrantyConfirmScreen(warrantyData: warrantyData),
              ),
            ).then((success) {
              if (success == true && mounted) {
                context.read<DeviceWarrantyCubit>().load();
              }
            });
          },
          borderRadius: BorderRadius.circular(14),
          child: Center(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 0.2,
                  fontFamily: FontFamilyManager.fontFamily,
                ),
                children: [
                  TextSpan(text: "Extend warranty now @ ${l10n.currencySymbol}${offer.offerPrice.toInt()} "),
                  TextSpan(
                    text: "${l10n.currencySymbol}${offer.originalPrice.toInt()}",
                    style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.white.withOpacity(0.7),
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
