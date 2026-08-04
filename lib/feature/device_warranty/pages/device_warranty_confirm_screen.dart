import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/config/network/api_host.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:trackify/feature/device_warranty/domain/entities/device_warranty_entity.dart';
import 'package:trackify/feature/device_warranty/domain/entities/warranty_payment_summary_entity.dart';
import 'package:trackify/feature/device_warranty/presentation/cubit/warranty_payment_summary_cubit.dart';
import 'package:trackify/feature/device_warranty/presentation/cubit/warranty_payment_summary_state.dart';
import 'package:trackify/feature/device_warranty/presentation/cubit/extend_warranty_cubit.dart';
import 'package:trackify/feature/device_warranty/presentation/cubit/extend_warranty_state.dart';

import '../../../l10n/app_localizations.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';
import 'package:trackify/core/widgets/loading_screen_ol.dart';
import 'package:trackify/app/app_navigation.dart';

class DeviceWarrantyConfirmScreen extends StatefulWidget {
  final DeviceWarrantyEntity warrantyData;

  const DeviceWarrantyConfirmScreen({super.key, required this.warrantyData});

  @override
  State<DeviceWarrantyConfirmScreen> createState() =>
      _DeviceWarrantyConfirmScreenState();
}

class _DeviceWarrantyConfirmScreenState
    extends State<DeviceWarrantyConfirmScreen> {
  late Razorpay _razorpay;
  WarrantyPaymentSummaryEntity? _summaryData;

  static const String _razorpayKey = ApiURL.razorpayKey;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    final imei = widget.warrantyData.vehicle?.imei.isNotEmpty == true
        ? widget.warrantyData.vehicle!.imei
        : AppPreference.instance.getSync(key: AppPreference.IMEI);
    final planId = widget.warrantyData.offer?.planId ?? '';
    context.read<WarrantyPaymentSummaryCubit>().load(
      imei: imei,
      planId: planId,
    );
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  String? _currentOrderId;

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    if (!mounted) return;
    context.read<ExtendWarrantyCubit>().verifyPayment(
      razorpayOrderId: response.orderId ?? _currentOrderId ?? '',
      razorpayPaymentId: response.paymentId ?? '',
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment failed: ${response.message ?? 'Unknown error'}'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('External wallet: ${response.walletName}')),
    );
  }

  void _openRazorpay(
    WarrantyPaymentSummaryEntity summaryData,
    String? orderId,
  ) {
    final selectedPlan = summaryData.selectedPlan;
    final amountInPaise = ((selectedPlan?.offerPrice ?? 0) * 100).toInt();
    final contact =
        AppPreference.instance.getSync(key: AppPreference.KEY_USER_MOBILE) ??
        '';
    final email =
        AppPreference.instance.getSync(key: AppPreference.KEY_USER_Email) ?? '';
    final options = <String, dynamic>{
      'key': _razorpayKey,
      'amount': amountInPaise,
      'name': 'Trackify',
      'description': selectedPlan?.planName ?? 'Extended Warranty',
      'prefill': {'contact': '', 'email': email},
      'external': {
        'wallets': ['paytm'],
      },
    };

    if (orderId != null && orderId.isNotEmpty) {
      options['order_id'] = orderId;
    }

    _razorpay.open(options);
  }

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
        title: Text(l10n.extendedWarranty),
      ),
      body: BlocListener<ExtendWarrantyCubit, ExtendWarrantyState>(
        listener: (context, extendState) {
              if (extendState is VerifyPaymentSuccess) {
                LoadingScreenOL().hide();
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        PaymentSuccessOverlay(
                      message: extendState.message,
                      onComplete: () {
                        // Fully reset the app navigation so that ALL screens (Map, Profile, etc.) 
                        // rebuild from scratch and pick up the updated warranty state.
                        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const AppNavigation()),
                          (route) => false,
                        );
                      },
                    ),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ),
                );
              }

              if (extendState is ExtendWarrantySuccess) {
                LoadingScreenOL().hide();
                
                // Open Razorpay after backend order is created
                _currentOrderId = extendState.extendedWarranty.razorpayOrderId;
                _openRazorpay(
                  _summaryData!,
                  extendState.extendedWarranty.razorpayOrderId,
                );
              } else if (extendState is ExtendWarrantyError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(extendState.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
        },
        child:
            BlocBuilder<
              WarrantyPaymentSummaryCubit,
              WarrantyPaymentSummaryState
            >(
              builder: (context, state) {
                if (state is WarrantyPaymentSummaryLoading ||
                    state is WarrantyPaymentSummaryInitial) {
                  return const Center(child: TrackifyLoader());
                }

                if (state is WarrantyPaymentSummaryError) {
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
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.7,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              final imei =
                                  widget
                                          .warrantyData
                                          .vehicle
                                          ?.imei
                                          .isNotEmpty ==
                                      true
                                  ? widget.warrantyData.vehicle!.imei
                                  : AppPreference.instance.getSync(
                                      key: AppPreference.IMEI,
                                    );
                              final planId =
                                  widget.warrantyData.offer?.planId ?? '';
                              context.read<WarrantyPaymentSummaryCubit>().load(
                                imei: imei,
                                planId: planId,
                              );
                            },
                            icon: const Icon(Icons.refresh_rounded),
                            label: Text(l10n.retry),
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

                if (state is WarrantyPaymentSummaryLoaded) {
                  final summaryData = state.paymentSummary;
                  _summaryData = summaryData;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        _deviceInfoCard(theme, colorScheme, l10n, summaryData),
                        const SizedBox(height: 24),
                        _paymentSummaryCard(
                          theme,
                          colorScheme,
                          l10n,
                          summaryData,
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: _bottomButton(
                            theme,
                            colorScheme,
                            l10n,
                            summaryData,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
      ),
    );
  }

  Widget _deviceInfoCard(
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations l10n,
    WarrantyPaymentSummaryEntity summaryData,
  ) {
    final selectedPlan = summaryData.selectedPlan;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5), width: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedPlan?.planName ?? l10n.yearExtendedWarranty,
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                '${l10n.currencySymbol}${selectedPlan?.originalPrice.toInt() ?? 730}',
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
                selectedPlan?.displayName ??
                    '${l10n.vehicleNamePlaceholder}(${l10n.vehicleNumberPlaceholder})',
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                '${l10n.currencySymbol}${selectedPlan?.offerPrice.toInt() ?? 365}',
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
            selectedPlan?.productName ?? 'Trackify Lite',
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
    WarrantyPaymentSummaryEntity summaryData,
  ) {
    final payment = summaryData.paymentSummary;

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
            border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5), width: 0.5),
            borderRadius: BorderRadius.circular(8),
            
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    payment?.vehicleText ??
                        '${l10n.vehicleNamePlaceholder} (${l10n.vehicleNumberPlaceholder})',
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.8),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${l10n.currencySymbol}${payment?.originalPrice.toInt() ?? 730}',
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
                payment?.productName ?? 'Trackify Lite',
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
                    payment?.discountText ?? l10n.boosterOffer,
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    '-${l10n.currencySymbol}${payment?.discountAmount.toInt() ?? 0}',
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
                  final dashCount = (boxWidth / (dashWidth + dashSpace))
                      .floor();
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
                    '${l10n.currencySymbol}${payment?.payableAmount.toInt() ?? 365}',
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
    WarrantyPaymentSummaryEntity summaryData,
  ) {
    final selectedPlan = summaryData.selectedPlan;

    return BlocBuilder<ExtendWarrantyCubit, ExtendWarrantyState>(
      builder: (context, extendState) {
        final isExtending = extendState is ExtendWarrantyLoading;

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
              onTap: isExtending || selectedPlan == null
                  ? null
                  : () {
                      final imei =
                          widget.warrantyData.vehicle?.imei.isNotEmpty == true
                          ? widget.warrantyData.vehicle!.imei
                          : AppPreference.instance.getSync(
                              key: AppPreference.IMEI,
                            );
                      context.read<ExtendWarrantyCubit>().extendWarranty(
                        imei: imei,
                        planId: selectedPlan.planId,
                        paymentMethod: "Razorpay",
                        amountPaid: selectedPlan.offerPrice,
                      );
                    },
              borderRadius: BorderRadius.circular(8),
              child: Center(
                child: isExtending
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.onTertiary,
                          ),
                        ),
                      )
                    : Text(
                        summaryData.buttonText.isNotEmpty
                            ? summaryData.buttonText
                            : l10n.amountPayable(
                                '${l10n.currencySymbol}${selectedPlan?.offerPrice.toInt() ?? 365}',
                              ),
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
      },
    );
  }
}

class PaymentSuccessOverlay extends StatefulWidget {
  final String message;
  final VoidCallback onComplete;

  const PaymentSuccessOverlay({
    super.key,
    required this.message,
    required this.onComplete,
  });

  @override
  State<PaymentSuccessOverlay> createState() => _PaymentSuccessOverlayState();
}

class _PaymentSuccessOverlayState extends State<PaymentSuccessOverlay> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        widget.onComplete();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 600),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    size: 120,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    widget.message.isNotEmpty
                        ? widget.message
                        : "Payment Verified Successfully!",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
