import 'package:flutter/material.dart';
import 'package:trackify/core/config/font_manager.dart';
import 'package:trackify/feature/device_warranty/domain/entities/device_warranty_entity.dart';
import 'package:trackify/feature/order_summary/domain/entities/order_summary_entity.dart';
import 'package:trackify/feature/order_summary/presentation/pages/order_summary_screen.dart';

import '../../../l10n/app_localizations.dart';

class DeviceWarrantyConfirmScreen extends StatefulWidget {
  final DeviceWarrantyEntity warrantyData;

  const DeviceWarrantyConfirmScreen({
    super.key,
    required this.warrantyData,
  });

  @override
  State<DeviceWarrantyConfirmScreen> createState() =>
      _DeviceWarrantyConfirmScreenState();
}

class _DeviceWarrantyConfirmScreenState
    extends State<DeviceWarrantyConfirmScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: colorScheme.onSurface,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.extendedWarranty,
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeightManager.semibold,
            fontSize: 18,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            _deviceInfoCard(theme, colorScheme, l10n),
            const SizedBox(height: 24),
            _paymentSummaryCard(theme, colorScheme, l10n),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: _bottomButton(theme, colorScheme, l10n),
            ),
          ],
        ),
      ),
    );
  }

  Widget _deviceInfoCard(
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    final offer = widget.warrantyData.offer;
    final vehicle = widget.warrantyData.vehicle;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                offer?.planName ?? l10n.yearExtendedWarranty,
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                '${l10n.currencySymbol}${offer?.originalPrice.toInt() ?? 730}',
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                  fontSize: 13,
                  decoration: TextDecoration.lineThrough,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                vehicle?.displayName ?? '${l10n.vehicleNamePlaceholder}(${l10n.vehicleNumberPlaceholder})',
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                '${l10n.currencySymbol}${offer?.offerPrice.toInt() ?? 365}',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            offer?.productName ?? 'Trackify Lite',
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.5),
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentSummaryCard(
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    final offer = widget.warrantyData.offer;
    final vehicle = widget.warrantyData.vehicle;
    final discount = (offer?.originalPrice ?? 730) - (offer?.offerPrice ?? 365);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            l10n.paymentSummary,
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: colorScheme.onSurface.withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    vehicle?.displayName ?? '${l10n.vehicleNamePlaceholder} (${l10n.vehicleNumberPlaceholder})',
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.8),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${l10n.currencySymbol}${offer?.originalPrice.toInt() ?? 730}',
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.8),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                offer?.productName ?? 'Trackify Lite',
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.boosterOffer,
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    '-${l10n.currencySymbol}${discount.toInt()}',
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final boxWidth = constraints.constrainWidth();
                  const dashWidth = 4.0;
                  const dashHeight = 1.0;
                  const dashSpace = 2.0;
                  final dashCount = (boxWidth / (dashWidth + dashSpace)).floor();
                  return Flex(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    direction: Axis.horizontal,
                    children: List.generate(dashCount, (_) {
                      return SizedBox(
                        width: dashWidth,
                        height: dashHeight,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: colorScheme.onSurface.withValues(alpha: 0.2),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.toPay,
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${l10n.currencySymbol}${offer?.offerPrice.toInt() ?? 365}',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bottomButton(
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    final offer = widget.warrantyData.offer;

    return Container(
      width: double.infinity,
      height: 45,
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
          onTap: () {
            if (offer != null) {
              final discount = (offer.originalPrice - offer.offerPrice).toInt();
              final orderSummaryPlan = OrderSummaryEntity(
                id: offer.planId,
                title: offer.planName,
                validity: "${offer.durationMonths} Months",
                price: offer.offerPrice.toInt(),
                originalPrice: offer.originalPrice.toInt(),
                discount: discount,
                gst: 0,
                toPay: offer.offerPrice.toInt(),
                benefit: offer.benefits.map((b) => b.title).toList(),
                isCombo: false,
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderSummaryScreen(plan: orderSummaryPlan),
                ),
              ).then((success) {
                if (success == true && mounted) {
                  Navigator.pop(context, true);
                }
              });
            }
          },
          borderRadius: BorderRadius.circular(8),
          child: Center(
            child: Text(
              l10n.amountPayable('${l10n.currencySymbol}${offer?.offerPrice.toInt() ?? 365}'),
              style: TextStyle(
                color: colorScheme.onTertiary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
