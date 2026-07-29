import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/service_log_entity.dart';

class ServiceLogCard extends StatelessWidget {
  final ServiceLogEntity log;
  final VoidCallback? onTap;

  const ServiceLogCard({
    super.key,
    required this.log,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Format date from "2026-05-04T00:00:00.000Z" to "6th Jul '26"
    String formattedDate = '';
    try {
      if (log.serviceDate != null) {
        final date = DateTime.parse(log.serviceDate!);
        formattedDate = DateFormat('dd/MM/yyyy').format(date);
      }
    } catch (e) {
      formattedDate = log.serviceDate ?? '';
    }

    final amountStr = log.amount?.toStringAsFixed(0) ?? '0';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark 
            ? theme.cardColor 
            : const Color(0xFFEEEEEE), // Light grey background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // Image Placeholder
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1), width: 1),
                    image: log.billImages != null && log.billImages!.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(log.billImages!.first),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: log.billImages == null || log.billImages!.isEmpty
                      ? Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.grey.withOpacity(0.5),
                          size: 28,
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.edit_document,
                            size: 18,
                            color: theme.colorScheme.onSurface.withOpacity(0.9),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              "Service Date: $formattedDate",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface.withOpacity(0.9),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.sell,
                            size: 18,
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Amount: ₹$amountStr",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Arrow
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
