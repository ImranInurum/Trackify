import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trackify/core/config/font_manager.dart';
import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/network_api_service.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  bool _isLoading = true;
  String? _error;
  List<dynamic> _orders = [];

  @override
  void initState() {
    super.initState();
    _fetchUserOrders();
  }

  Future<void> _fetchUserOrders() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final userId = await AppPreference.instance.get(key: AppPreference.KEY_USER_ID);

      if (userId.isEmpty) {
        setState(() {
          _isLoading = false;
          _orders = [];
        });
        return;
      }

      final response = await NetworkApiService().getGetApiResponse(
        "${ApiURL.baseURL}/api/product-catalog/user-orders/$userId",
      );

      response.fold(
        (failure) {
          setState(() {
            _isLoading = false;
            _error = failure.message;
          });
        },
        (data) {
          if (data != null && data['success'] == true && data['data'] is List) {
            setState(() {
              _orders = data['data'];
              _isLoading = false;
            });
          } else {
            setState(() {
              _isLoading = false;
              _error = data?['message'] ?? 'No orders found';
            });
          }
        },
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'delivered':
        return const Color(0xFF10B981);
      case 'contacted':
      case 'dispatched':
      case 'out for delivery':
        return const Color(0xFF0284C7);
      case 'cancelled':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFFF59E0B);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: colorScheme.onSurface,
            size: 18,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "My Device Orders",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: FontFamilyManager.fontFamily,
            color: colorScheme.onSurface,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: TrackifyLoader())
          : _orders.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F2FE),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.local_shipping_outlined,
                            size: 48,
                            color: Color(0xFF0284C7),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "No Device Orders Yet",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Your ordered Trackify GPS devices and delivery status will appear here after you place an order.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.4,
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchUserOrders,
                  color: const Color(0xFF0284C7),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _orders.length,
                    itemBuilder: (context, index) {
                      final order = _orders[index];
                      final status = order['status'] ?? 'Pending';
                      final statusColor = _getStatusColor(status);
                      final createdAt = order['createdAt'] != null
                          ? DateTime.tryParse(order['createdAt'])
                          : null;
                      final formattedDate = createdAt != null
                          ? DateFormat('dd MMM yyyy, hh:mm a').format(createdAt)
                          : '';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? theme.cardColor : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark
                                ? colorScheme.outline.withOpacity(0.15)
                                : const Color(0xFFE2E8F0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE0F2FE),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.router_outlined,
                                        color: Color(0xFF0284C7),
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      order['productTitle'] ?? 'Trackify Device',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: statusColor.withOpacity(0.4)),
                                  ),
                                  child: Text(
                                    status.toUpperCase(),
                                    style: TextStyle(
                                      color: statusColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Amount Paid",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: colorScheme.onSurface.withOpacity(0.55),
                                  ),
                                ),
                                Text(
                                  "₹${order['price'] ?? 0}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0284C7),
                                  ),
                                ),
                              ],
                            ),
                            if (formattedDate.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Order Date",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: colorScheme.onSurface.withOpacity(0.55),
                                    ),
                                  ),
                                  Text(
                                    formattedDate,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: colorScheme.onSurface.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (order['notes'] != null &&
                                order['notes'].toString().isNotEmpty) ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: Divider(
                                  height: 1,
                                  color: isDark
                                      ? colorScheme.outline.withOpacity(0.15)
                                      : const Color(0xFFE2E8F0),
                                ),
                              ),
                              Text(
                                "Shipping & Payment Details",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                order['notes'].toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  height: 1.3,
                                  color: colorScheme.onSurface.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
