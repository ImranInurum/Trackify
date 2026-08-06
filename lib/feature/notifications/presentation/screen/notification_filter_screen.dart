import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/notification_timeline_cubit.dart';

class NotificationFilterScreen extends StatefulWidget {
  final List<String> initialSelectedCategories;
  
  const NotificationFilterScreen({
    super.key, 
    required this.initialSelectedCategories,
  });

  @override
  State<NotificationFilterScreen> createState() => _NotificationFilterScreenState();
}

class _NotificationFilterScreenState extends State<NotificationFilterScreen> {
  List<String> _getNotificationTypes() => [
    "Motion Sensed",
    "Ignition Off",
    "Ignition On",
    "Accident Detected",
    "Stationary Fall Detected",
    "Power Supply Off",
    "Vehicle Switched Off",
    "Vehicle Switched On",
    "Power Supply On",
    "Vibration Sensed",
  ];

  List<Map<String, String>> _getDateOptions(AppLocalizations l10n) => [
    {"label": l10n.today, "count": "35"},
    {"label": l10n.thisMonth, "count": "534"},
    {"label": l10n.thisYear, "count": "2226"},
    {"label": l10n.all, "count": "2226"},
    {"label": l10n.customDates, "count": ""},
  ];

  late Set<String> selectedCategories;
  String? selectedDateRange;

  @override
  void initState() {
    super.initState();
    selectedCategories = Set.from(widget.initialSelectedCategories);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final secondaryColor = theme.colorScheme.secondary;
    final scaffoldBg = theme.scaffoldBackgroundColor;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final subTextColor = theme.textTheme.bodySmall?.color ?? Colors.grey;
    final l10n = AppLocalizations.of(context)!;
    
    final notificationTypes = _getNotificationTypes();
    final dateOptions = _getDateOptions(l10n);
    
    selectedDateRange ??= l10n.all;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: scaffoldBg,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.filters, ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.selectDateRange,
                    style: TextStyle(color: subTextColor, fontSize: 20.0),
                  ),
                  const SizedBox(height: 16),
                  PopupMenuButton<String>(
                    onSelected: (String value) {
                      setState(() {
                        selectedDateRange = value;
                      });
                    },
                    offset: const Offset(0, 30),
                    elevation: 4,
                    color: theme.cardColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    itemBuilder: (BuildContext context) {
                      return dateOptions.map((option) {
                        final label = option['label']!;
                        final count = option['count']!;
                        return PopupMenuItem<String>(
                          value: label,
                          child: Text(
                            count.isNotEmpty ? "$label ($count)" : label,
                            style: TextStyle(fontSize: 14, color: textColor),
                          ),
                        );
                      }).toList();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          selectedDateRange!,
                          style: TextStyle(color: primaryColor, fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.keyboard_arrow_down, color: primaryColor, size: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    l10n.notificationTypes,
                    style: TextStyle(color: subTextColor, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  ...notificationTypes.map((type) => _buildFilterItem(context, type, primaryColor, secondaryColor, textColor)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  context.read<NotificationTimelineCubit>().applyFilters(
                    categories: selectedCategories.toList(),
                    timePeriod: selectedDateRange!,
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: Text(
                  l10n.apply,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterItem(BuildContext context, String title, Color activeColor, Color secondaryColor, Color textColor) {
    final isSelected = selectedCategories.contains(title);
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedCategories.remove(title);
          } else {
            selectedCategories.add(title);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: theme.dividerColor, width: 1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 15, color: textColor),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isSelected ? activeColor : secondaryColor.withValues(alpha: 0.5),
                  width: 2,
                ),
                color: isSelected ? activeColor : Colors.transparent,
              ),
              child: isSelected 
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : null,
            ),
          ],
        ),
      ),
    );
  }
}
