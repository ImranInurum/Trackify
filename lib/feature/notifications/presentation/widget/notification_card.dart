import 'package:flutter/material.dart';
import 'package:trackify/core/utils/flutter_compat_extensions.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../data/entity/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationData notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>();

    // Determine icon based on title
    IconData iconData = Icons.notifications_active_outlined;
    Color iconColor = theme.primaryColor;

    if (notification.title?.toLowerCase().contains("vehicle") ?? false) {
      iconData = Icons.directions_car_filled_outlined;
      iconColor = appColors?.info ?? Colors.blue;
    } else if (notification.title?.toLowerCase().contains("alert") ?? false) {
      iconData = Icons.warning_amber_rounded;
      iconColor = appColors?.warning ?? Colors.orange;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: theme.dividerColor,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: iconColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(iconData, color: iconColor, size: 24),
                    ),
                    if (notification.createdAt != null)
                      Text(
                        _formatDate(notification.createdAt!),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.hintColor,
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(

                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                Text(
                                  notification.title ?? "Notification",
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  notification.vehicleId?.vehicleNumber != null ? ' (${notification.vehicleId!.vehicleNumber})' : '',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: theme.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notification.description ?? "",
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  }

  String _formatDate(String dateStr) {
    try {
      final dateTime = DateTime.parse(dateStr).toLocal();
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 60) {
        return "${difference.inMinutes}m ago";
      } else if (difference.inHours < 24) {
        return "${difference.inHours}h ago";
      } else if (difference.inDays < 7) {
        return "${difference.inDays}d ago";
      } else {
        return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
      }
    } catch (e) {
      return "";
    }
  }

