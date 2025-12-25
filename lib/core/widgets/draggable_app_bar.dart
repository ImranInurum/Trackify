import 'package:flutter/material.dart';

class TopDraggableAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final double collapsedHeight;
  final double expandedHeight;
  final Color? backgroundColor;

  const TopDraggableAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.collapsedHeight = 100,
    this.expandedHeight = 200,
    this.backgroundColor,
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
    // ✅ Correct direction: drag down → collapse, drag up → expand
    setState(() {
      _height -= details.delta.dy;
      _height = _height.clamp(widget.collapsedHeight, widget.expandedHeight);
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    final midpoint =
        (widget.collapsedHeight + widget.expandedHeight) / 2;

    final target = _height > midpoint
        ? widget.expandedHeight
        : widget.collapsedHeight;

    _heightAnimation = Tween<double>(
      begin: _height,
      end: target,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: _height,
      decoration: BoxDecoration(
        color: widget.backgroundColor ??
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
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onVerticalDragUpdate: _onVerticalDragUpdate,
        onVerticalDragEnd: _onVerticalDragEnd,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          if (widget.subtitle != null)
                            Text(
                              widget.subtitle!,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                        ],
                      ),
                    ),
                    if (widget.actions != null)
                      Row(children: widget.actions!),
                  ],
                ),
              ),
            ),
            // Handle at the bottom
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
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
