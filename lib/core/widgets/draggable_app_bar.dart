import 'package:flutter/material.dart';
import 'package:trackify/core/widgets/option_tile.dart';

import '../../feature/map/data/entity/user_device_model.dart';

class TopDraggableAppBar extends StatefulWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final double collapsedHeight;
  final double expandedHeight;
  final Color? backgroundColor;

  final List<UserDevices>? devices;

  const TopDraggableAppBar({
    super.key,
    this.actions,
    this.collapsedHeight = 100,
    this.expandedHeight = 300,
    this.backgroundColor,
    this.devices,
  });

  @override
  State<TopDraggableAppBar> createState() => _TopDraggableAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(collapsedHeight);
}

class _TopDraggableAppBarState extends State<TopDraggableAppBar>
    with SingleTickerProviderStateMixin {
  late double _height;
  late AnimationController _controller;
  late Animation<double> _heightAnimation;

  @override
  void initState() {
    super.initState();
    _height = widget.collapsedHeight;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _height -= details.delta.dy;
      _height = _height.clamp(widget.collapsedHeight, widget.expandedHeight);
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    final midpoint = (widget.collapsedHeight + widget.expandedHeight) / 2;
    final target = _height > midpoint ? widget.expandedHeight : widget.collapsedHeight;

    _heightAnimation = Tween<double>(
      begin: _height,
      end: target,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller
      ..reset()
      ..forward();

    _heightAnimation.addListener(() {
      setState(() {
        _height = _heightAnimation.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    final devices = widget.devices ?? [];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: _height + topPadding,
      decoration: BoxDecoration(
        color:
            widget.backgroundColor ??
            Theme.of(context).colorScheme.background ??
            Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onVerticalDragUpdate: _onVerticalDragUpdate,
          onVerticalDragEnd: _onVerticalDragEnd,
          child: Column(
            children: [
              if (devices.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: devices.length,
                    itemBuilder: (context, index) {
                      final device = devices[index];
                      return OptionTile(
                        leading: const Icon(
                          Icons.pedal_bike,
                          size: 32,
                          color: Colors.green,
                        ),
                        title: device.deviceName ?? "Unnamed Device",
                        subtitle: device.imei ?? "No IMEI",
                        showDivider: index != devices.length - 1,
                        onTap: () {
                          print("Tapped ${device.deviceName}");
                          // Optional: call a callback here if needed later
                        },
                      );
                    },
                  ),
                )
              else
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            "No Device Found",
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (widget.actions != null) Row(children: widget.actions!),
                      ],
                    ),
                  ),
                ),
              // Handle bar at bottom
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 10, top: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).hintColor.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
