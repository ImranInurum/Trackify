import 'package:flutter/material.dart';
import 'package:trackify/core/widgets/option_tile.dart';

import '../../feature/map/data/entity/user_device_model.dart';

class DraggableAppBar extends StatefulWidget {
  final List<Widget>? actions;
  final double collapsedHeight;
  final double expandedHeight;
  final Color? backgroundColor;
  final List<UserDevices>? devices;

  const DraggableAppBar({
    super.key,
    this.actions,
    this.collapsedHeight = 70,
    this.expandedHeight = 120,
    this.backgroundColor,
    this.devices,
  });

  @override
  State<DraggableAppBar> createState() => _DraggableAppBarBarState();
}

class _DraggableAppBarBarState extends State<DraggableAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _heightAnimation =
        Tween<double>(begin: widget.collapsedHeight, end: widget.expandedHeight).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOut),
        )..addListener(() {
          setState(() {});
        });
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    final devices = widget.devices ?? [];
    final height = _heightAnimation.value;

    return GestureDetector(
      onTap: _toggleExpand,
      behavior: HitTestBehavior.translucent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        height: height + topInset,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              (widget.backgroundColor ??
                  Theme.of(context).colorScheme.secondaryContainer),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.3, 1.0], // 70% white, 30% your theme color
          ),
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
          padding: EdgeInsets.only(top: topInset),
          child: Column(
            children: [
              if (devices.isNotEmpty)
                Flexible(
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
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
                        trailing: SizedBox(),
                        onTap: () {},
                      );
                    },
                  ),
                )
              else
                Flexible(
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
