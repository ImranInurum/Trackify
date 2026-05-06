import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/notification_timeline_cubit.dart';
import '../state/notification_timeline_state.dart';
import 'notification_filter_screen.dart';

class NotificationTimelineScreen extends StatelessWidget {
  const NotificationTimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationTimelineCubit()..fetchTimeline(),
      child: const NotificationTimelineView(),
    );
  }
}

class NotificationTimelineView extends StatefulWidget {
  const NotificationTimelineView({super.key});

  @override
  State<NotificationTimelineView> createState() => _NotificationTimelineViewState();
}

class _NotificationTimelineViewState extends State<NotificationTimelineView> {
  late ScrollController _scrollController;
  final ValueNotifier<String> _stickyDateNotifier = ValueNotifier("");
  final ValueNotifier<double> _headerOffsetNotifier = ValueNotifier(0.0);
  
  Map<String, double> dateOffsets = {};
  List<String> dates = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _stickyDateNotifier.dispose();
    _headerOffsetNotifier.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (dates.isEmpty) return;

    double scrollOffset = _scrollController.offset;
    String activeDate = dates.first;
    double headerPushOffset = 0.0;

    for (int i = 0; i < dates.length; i++) {
      double currentPos = dateOffsets[dates[i]] ?? 0.0;
      if (scrollOffset >= currentPos - 10) {
        activeDate = dates[i];
      }
      
      // Calculate pushing effect
      if (i > 0) {
        double nextPos = dateOffsets[dates[i]] ?? 0.0;
        double distance = nextPos - scrollOffset;
        if (distance > 0 && distance < 60) {
          headerPushOffset = distance - 60;
        }
      }
    }

    if (_stickyDateNotifier.value != activeDate) {
      _stickyDateNotifier.value = activeDate;
    }
    if (_headerOffsetNotifier.value != headerPushOffset) {
      _headerOffsetNotifier.value = headerPushOffset;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = theme.scaffoldBackgroundColor;
    final lineColor = theme.dividerColor;
    final dotColor = theme.primaryColor;
    final primaryTextColor = theme.textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black);
    final secondaryTextColor = theme.textTheme.bodySmall?.color ?? Colors.grey;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Text(
          "Notifications",
          style: TextStyle(
            color: primaryTextColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt_rounded, color: primaryTextColor, size: 26),
            onPressed: () => _navigateToFilter(context),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: BlocBuilder<NotificationTimelineCubit, NotificationTimelineState>(
        builder: (context, state) {
          if (state is NotificationTimelineLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is NotificationTimelineLoaded) {
            final items = state.notifications;
            
            if (items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_off_outlined, size: 64, color: secondaryTextColor.withOpacity(0.5)),
                    const SizedBox(height: 16),
                    Text(
                      "No records found",
                      style: TextStyle(
                        fontSize: 16,
                        color: secondaryTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }

            // Group and prepare offsets
            _calculateGroupedOffsets(items);

            return Stack(
              children: [
                ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(top: 10),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final date = item.time.split(', ').last;
                    final isFirstInDate = index == 0 || items[index - 1].time.split(', ').last != date;
                    final isLast = index == items.length - 1;

                    return Column(
                      children: [
                        if (isFirstInDate) 
                          _buildDateDivider(context, date,12,3),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: _buildTimelineItem(
                            context,
                            item,
                            isLast,
                            lineColor,
                            dotColor,
                            primaryTextColor,
                            secondaryTextColor,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                // The Sticky Header
                ValueListenableBuilder<double>(
                  valueListenable: _headerOffsetNotifier,
                  builder: (context, offset, _) {
                    return Positioned(
                      top: offset,
                      left: 0,
                      right: 0,
                      child: ValueListenableBuilder<String>(
                        valueListenable: _stickyDateNotifier,
                        builder: (context, date, _) {
                          return Container(
                            color: bgColor,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: _buildDateDivider(context, date,14,6),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _calculateGroupedOffsets(List<dynamic> items) {
    dateOffsets.clear();
    dates.clear();
    double currentOffset = 0;
    String? lastDate;

    for (int i = 0; i < items.length; i++) {
      final date = items[i].time.split(', ').last;
      if (date != lastDate) {
        dates.add(date);
        dateOffsets[date] = currentOffset;
        currentOffset += 64; // Approx height of divider + padding
        lastDate = date;
      }
      currentOffset += 88; // Approx height of notification item
    }
    
    if (dates.isNotEmpty && _stickyDateNotifier.value == "") {
      _stickyDateNotifier.value = dates.first;
    }
  }

  Widget _buildDateDivider(BuildContext context, String date,double hPadding,double vPadding) {
    final theme = Theme.of(context);
    return Center(
      child: Container(
        padding:  EdgeInsets.symmetric(horizontal: hPadding, vertical: vPadding),
        decoration: BoxDecoration(
          color: theme.primaryColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          date,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context,
    dynamic item,
    bool isLast,
    Color lineColor,
    Color dotColor,
    Color primaryTextColor,
    Color secondaryTextColor,
  ) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              const SizedBox(height: 6),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1.5,
                    color: lineColor,
                  ),
                )
              else
                const SizedBox(height: 40),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.time.split(',').first,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: primaryTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.description,
                  style: TextStyle(
                    fontSize: 15,
                    color: secondaryTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToFilter(BuildContext context) {
    final cubit = context.read<NotificationTimelineCubit>();
    final state = cubit.state;
    List<String> currentCategories = [];
    if (state is NotificationTimelineLoaded) {
      currentCategories = state.selectedCategories;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => BlocProvider.value(
          value: cubit,
          child: NotificationFilterScreen(
            initialSelectedCategories: currentCategories,
          ),
        ),
      ),
    );
  }
}
