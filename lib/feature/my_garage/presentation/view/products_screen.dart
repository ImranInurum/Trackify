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

  late final l10n = AppLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: colorScheme.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title:  Text(l10n.product),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: false,
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoaded) {
            return ListView.builder(
              itemCount: state.product.length,
              itemBuilder: (context, index) {
                final ProductEntity product = state.product[index];

                return Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: size.width * 0.04,
                    vertical: size.height * 0.012,
                  ),
                  padding: EdgeInsets.all(size.width * 0.04),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// TOP SECTION
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// PRODUCT IMAGE
                          Container(
                            height: size.width * 0.23,
                            width: size.width * 0.23,
                            padding: EdgeInsets.all(size.width * 0.025),
                            decoration: BoxDecoration(
                              color: Colors.white, // Keep image background white if it's a product box
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Image.asset(
                              product.image,
                              fit: BoxFit.contain,
                            ),
                          ),

                          SizedBox(width: size.width * 0.03),

                          /// RIGHT SIDE
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// TITLE + DEVICE TYPE
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        product.title,
                                        style: TextStyle(
                                          color: colorScheme.onSurface,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),

                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colorScheme.tertiaryContainer,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        product.deviceType,
                                        style: TextStyle(
                                          color: colorScheme.onTertiaryContainer,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: size.height * 0.012),

                                /// PRICE ROW
                                Row(
                                  children: [
                                    Text(
                                      "₹${product.price}",
                                      style: TextStyle(
                                        color: colorScheme.onSurface,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    SizedBox(width: size.width * 0.02),

                                    Text(
                                      "MRP: ₹${product.mrp}",
                                      style: TextStyle(
                                        color: colorScheme.onSurfaceVariant,
                                        fontSize: 13,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),

                                    SizedBox(width: size.width * 0.02),

                                    Text(
                                      "${product.discount}% OFF",
                                      style: const TextStyle(
                                        color: Colors.green, // Often kept green for success/positive
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: size.height * 0.01),

                                /// IDEAL FOR
                                Row(
                                  children: [
                                    Text(
                                      product.idealText,
                                      style: TextStyle(
                                        color: colorScheme.onSurfaceVariant,
                                        fontSize: 14,
                                      ),
                                    ),

                                    SizedBox(width: size.width * 0.010),

                                    ...product.vehicleIcons.map(
                                      (e) => Padding(
                                        padding: const EdgeInsets.only(right: 6),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: colorScheme.surface,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            e,
                                            style: const TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: size.height * 0.012),

                                /// DELIVERY
                                Row(
                                  children: [
                                    Icon(
                                      Icons.local_shipping_outlined,
                                      color: colorScheme.onSurfaceVariant,
                                      size: 18,
                                    ),

                                    SizedBox(width: size.width * 0.02),

                                    Expanded(
                                      child: Text(
                                        product.deliveryText,
                                        style: TextStyle(
                                          color: colorScheme.onSurfaceVariant,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
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

                      SizedBox(height: size.height * 0.018),

                      Divider(color: colorScheme.outlineVariant),

                      SizedBox(height: size.height * 0.018),

                      /// DESCRIPTION
                      Text(
                        product.description,
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),

                      SizedBox(height: size.height * 0.018),

                      /// BUY BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: size.height * 0.05,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CheckoutScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Text(
                            "Buy now",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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

          return const Center(child: TrackifyLoader());
        },
      ),
    );
  }
}