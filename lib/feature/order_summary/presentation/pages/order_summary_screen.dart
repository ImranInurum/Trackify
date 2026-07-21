import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/config/font_manager.dart';
import 'package:trackify/core/theme/app_colors.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:trackify/feature/order_summary/domain/entities/order_summary_entity.dart';
import 'package:trackify/feature/order_summary/presentation/cubit/order_summary_cubit.dart';
import 'package:trackify/feature/order_summary/presentation/cubit/order_summary_state.dart';
import '../../../../l10n/app_localizations.dart';

class OrderSummaryScreen extends StatelessWidget {
  final OrderSummaryEntity plan;

  const OrderSummaryScreen({
    super.key,
    required this.plan,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final color = theme.colorScheme;
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<OrderSummaryCubit, OrderSummaryState>(
      listener: (context, state) {
        if (state is OrderSummaryPurchaseSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        } else if (state is OrderSummaryPurchaseError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is OrderSummaryPurchaseLoading;
        return Scaffold(
          backgroundColor: color.surface,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: color.onSurface),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(l10n.orderSummary),
            centerTitle: false,
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      l10n.selectedPlan,
                      style: text.bodyLarge?.copyWith(
                        color: color.onSurface.withOpacity(0.5),
                        fontWeight: FontWeightManager.regular,
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// SELECTED PLAN CARD
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: color.primary.withOpacity(0.4),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: plan.validity.replaceAll(l10n.validity, '').trim(),
                                              style: text.titleLarge?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: color.onSurface,
                                              ),
                                            ),
                                            TextSpan(
                                              text: " ${l10n.validity}",
                                              style: text.bodyMedium?.copyWith(
                                                color: color.onSurface.withOpacity(0.5),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "${l10n.currencySymbol}${plan.price}",
                                        style: text.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: color.onSurface,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        "${l10n.currencySymbol}${plan.originalPrice}",
                                        style: text.bodySmall?.copyWith(
                                          decoration: TextDecoration.lineThrough,
                                          color: color.onSurface.withOpacity(0.4),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              ...plan.benefit.map((benefit) => Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.check, color: Colors.green, size: 18),
                                        const SizedBox(width: 8),
                                        Text(
                                          benefit,
                                          style: text.bodyMedium?.copyWith(
                                            color: color.onSurface.withOpacity(0.7),
                                            fontWeight: FontWeightManager.regular,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              const SizedBox(height: 12),
                              Center(
                                child: Text(
                                  l10n.greatSaving(plan.discount),
                                  style: text.bodyMedium?.copyWith(
                                    color: Colors.green,
                                    fontWeight: FontWeightManager.semibold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (plan.isCombo)
                          Positioned(
                            top: -12,
                            left: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.superCombo,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star, color: Colors.yellow, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    l10n.superComboPlan,
                                    style: text.labelSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeightManager.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    /// BILL SUMMARY CARD
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.billSummary,
                            style: text.titleMedium?.copyWith(
                              fontWeight: FontWeightManager.bold,
                              color: color.onSurface,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _billRow(l10n.planPrice, "${l10n.currencySymbol}${plan.originalPrice}", text, color),
                          const SizedBox(height: 12),
                          _billRow(l10n.discount, "-${l10n.currencySymbol}${plan.discount}", text, color, valueColor: Colors.green),
                          const SizedBox(height: 16),
                          const _DashedDivider(),
                          const SizedBox(height: 16),
                          _billRow(l10n.total, "${l10n.currencySymbol}${plan.price}", text, color, isBold: true),
                          const SizedBox(height: 12),
                          _billRow(l10n.gstTaxes, "${l10n.currencySymbol}${plan.gst}", text, color, labelColor: color.onSurface.withOpacity(0.5)),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n.toPay,
                                style: text.titleMedium?.copyWith(
                                  fontWeight: FontWeightManager.bold,
                                  color: color.primary,
                                ),
                              ),
                              Text(
                                "${l10n.currencySymbol}${plan.toPay}",
                                style: text.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: color.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.29),
                  ],
                ),
              ),

              /// BOTTOM PAY BUTTON
              Positioned(
                bottom: 20,
                left: size.width * 0.05,
                right: size.width * 0.05,
                child: SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: isLoading
                        ? null
                        : () {
                            final imei = AppPreference.instance.getSync(key: AppPreference.IMEI);
                            if (imei.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.errorImeiNotFound),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            context.read<OrderSummaryCubit>().purchaseDataPlan(
                                  imei: imei,
                                  planId: plan.id,
                                  paymentStatus: "paid",
                                  amountPaid: plan.toPay,
                                );
                          },
                    child: isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(color.onPrimary),
                            ),
                          )
                        : Text(
                            l10n.payAmount(plan.toPay.toString()),
                            style: text.titleMedium?.copyWith(
                              color: color.onPrimary,
                              fontWeight: FontWeightManager.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _billRow(String label, String value, TextTheme text, ColorScheme color,
      {Color? labelColor, Color? valueColor, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: text.bodyMedium?.copyWith(
            color: labelColor ?? color.onSurface.withOpacity(0.6),
            fontWeight: isBold ? FontWeightManager.bold : FontWeightManager.regular
          ),
        ),
        Text(
          value,
          style: text.bodyMedium?.copyWith(
            color: valueColor ?? color.onSurface,
            fontWeight: isBold ? FontWeight.bold : FontWeightManager.semibold,
          ),
        ),
      ],
    );
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 4.0;
        const dashHeight = 1.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return const SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Color(0xFFE0E0E0)),
              ),
            );
          }),
        );
      },
    );
  }
}
