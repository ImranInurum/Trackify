import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:trackify/core/config/font_manager.dart';
import 'package:trackify/core/constants/app_images.dart';
import 'package:trackify/feature/device_warranty/presentation/cubit/device_warranty_cubit.dart';
import 'package:trackify/feature/device_warranty/presentation/cubit/device_warranty_state.dart';
import 'package:trackify/feature/device_warranty/domain/entities/device_warranty_entity.dart';
import '../../../l10n/app_localizations.dart';
import 'device_warranty_confirm_screen.dart';

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
      "icon": Icons.cached_rounded,
    },
    {
      "highlight": l10n.benefit2_highlight,
      "normal": l10n.benefit2_normal,
      "icon": Icons.settings_outlined,
    },
    {
      "highlight": l10n.benefit3_highlight,
      "normal": l10n.benefit3_normal,
      "icon": Icons.person_outline_rounded,
    },
    {
      "highlight": l10n.benefit4_highlight,
      "normal": l10n.benefit4_normal,
      "icon": Icons.subtitles_outlined,
    },
  ];

  IconData _getBenefitIcon(int index) {
    switch (index) {
      case 0:
        return Icons.cached_rounded;
      case 1:
        return Icons.settings_outlined;
      case 2:
        return Icons.person_outline_rounded;
      case 3:
        return Icons.subtitles_outlined;
      default:
        return Icons.check_circle_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: colorScheme.onSurface,
            size: 20,
          ),
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
      body: BlocBuilder<DeviceWarrantyCubit, DeviceWarrantyState>(
        builder: (context, state) {
          if (state is DeviceWarrantyLoading || state is DeviceWarrantyInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
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
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => context.read<DeviceWarrantyCubit>().load(),
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text("Retry"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
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
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _topCard(l10n, theme, colorScheme, warrantyData),
                        const SizedBox(height: 24),

                        Text(
                          l10n.warranty_benefitsTitle,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeightManager.regular,
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 16),

                        /// 🔹 BENEFITS LIST
                        if (offer != null && offer.benefits.isNotEmpty)
                          ...offer.benefits.asMap().entries.map(
                            (entry) {
                              final index = entry.key;
                              final benefit = entry.value;
                              return _benefitTile(
                                theme: theme,
                                colorScheme: colorScheme,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    child: _bottomButton(l10n, theme, colorScheme, warrantyData),
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
  ) {
    final offer = warrantyData.offer;
    final vehicle = warrantyData.vehicle;
    final warranty = warrantyData.warranty;

    Widget imageWidget;
    if (offer != null && offer.productImage.isNotEmpty) {
      imageWidget = CachedNetworkImage(
        imageUrl: offer.productImage,
        height: 100,
        width: 100,
        fit: BoxFit.contain,
        placeholder: (context, url) => const SizedBox(
          height: 100,
          width: 100,
          child: Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: (context, url, error) => Image.asset(
          AppImages.installDevices,
          height: 100,
          width: 100,
          fit: BoxFit.contain,
        ),
      );
    } else {
      imageWidget = Image.asset(
        AppImages.installDevices,
        height: 100,
        width: 100,
        fit: BoxFit.contain,
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: colorScheme.surface,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              imageWidget,
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  offer?.title.isNotEmpty == true ? offer!.title : l10n.warranty_extend,
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.9),
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
                        vehicle?.displayName ?? l10n.vehicleNamePlaceholder,
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
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
                              text: '${warranty?.expiryDateText ?? '--'} ',
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                            TextSpan(
                              text: warranty?.daysLeftText.isNotEmpty == true
                                  ? '(${warranty!.daysLeftText})'
                                  : '',
                              style: TextStyle(
                                color: const Color(0xFF81C784),
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
        color: theme.scaffoldBackgroundColor,
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.tertiary.withValues(alpha: 0.1),
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
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.9),
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
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [
            colorScheme.tertiary.withValues(alpha: 0.9),
            colorScheme.tertiary,
          ],
        ),
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
          borderRadius: BorderRadius.circular(8),
          child: Center(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
                children: [
                  TextSpan(text: "Extend warranty now @ ${l10n.currencySymbol}${offer.offerPrice.toInt()} "),
                  TextSpan(
                    text: "${l10n.currencySymbol}${offer.originalPrice.toInt()}",
                    style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.black.withValues(alpha: 0.5),
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
