import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/l10n/app_localizations.dart';

import '../../domain/entities/product_entity.dart';
import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';
import 'checkout_screen.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: colorScheme.onSurface,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: Text(l10n.product),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: false,
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoaded) {
            return ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.04,
                vertical: 12,
              ),
              itemCount: state.product.length,
              itemBuilder: (context, index) {
                final ProductEntity product = state.product[index];
                return _buildProductCard(context, product, isDark);
              },
            );
          }

          return const Center(child: TrackifyLoader());
        },
      ),
    );
  }

  Widget _buildProductCard(
      BuildContext context, ProductEntity product, bool isDark) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHigh.withValues(alpha: 0.6)
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? colorScheme.outline.withValues(alpha: 0.2)
              : colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER IMAGE & BADGES SECTION
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// PRODUCT IMAGE BOX WITH DISCOUNT BADGE
                  Stack(
                    children: [
                      Container(
                        height: 105,
                        width: 105,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.grey.shade900
                              : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Image.asset(
                          product.image,
                          fit: BoxFit.contain,
                        ),
                      ),
                      if (product.discount > 0)
                        Positioned(
                          top: 6,
                          left: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFE53935), Color(0xFFFF6B6B)],
                              ),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withValues(alpha: 0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              "${product.discount}% OFF",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(width: 14),

                  /// TITLE, TYPE & PRICING
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// DEVICE TYPE BADGE
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: colorScheme.primary.withValues(alpha: 0.25),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.sensors_rounded,
                                    size: 12,
                                    color: colorScheme.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    product.deviceType,
                                    style: TextStyle(
                                      color: colorScheme.primary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        /// TITLE
                        Text(
                          product.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 16.5,
                            fontWeight: FontWeight.bold,
                            height: 1.25,
                          ),
                        ),

                        const SizedBox(height: 10),

                        /// PRICING ROW
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              "₹${product.price}",
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (product.mrp > product.price)
                              Text(
                                "₹${product.mrp}",
                                style: TextStyle(
                                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                                  fontSize: 13,
                                  decoration: TextDecoration.lineThrough,
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

            /// FEATURES & COMPATIBILITY CONTAINER
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isDark
                    ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
                    : colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  /// VEHICLE COMPATIBILITY
                  Row(
                    children: [
                      Text(
                        product.idealText,
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: product.vehicleIcons
                              .map(
                                (e) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surface,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: colorScheme.outlineVariant
                                          .withValues(alpha: 0.4),
                                    ),
                                  ),
                                  child: Text(
                                    e,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  /// DELIVERY INFORMATION
                  Row(
                    children: [
                      Icon(
                        Icons.local_shipping_rounded,
                        color: Colors.green.shade600,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          product.deliveryText,
                          style: TextStyle(
                            color: isDark
                                ? Colors.green.shade300
                                : Colors.green.shade800,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// DESCRIPTION SECTION
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Text(
                product.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12.5,
                  height: 1.4,
                ),
              ),
            ),

            /// BUY NOW BUTTON
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.secondary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CheckoutScreen(),
                        ),
                      );
                    },
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.shopping_bag_outlined,
                            color: Colors.white,
                            size: 19,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Buy Now",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
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