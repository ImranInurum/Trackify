import 'package:flutter/material.dart';
import 'package:trackify/core/constants/app_images.dart';
import 'package:trackify/feature/profile/presentation/pages/profile_screen.dart';

import '../feature/map/presentation/pages/map_screen.dart';
import '../feature/statistics/presentation/pages/statistics_screen.dart';
import '../feature/trips/presentation/view/trip_screen.dart';

class AppNavigation extends StatefulWidget {
  static final GlobalKey<_AppNavigationState> navigationKey = GlobalKey<_AppNavigationState>();
  AppNavigation() : super(key: navigationKey);

  @override
  State<AppNavigation> createState() => _AppNavigationState();

  static void setIndex(int index) {
    navigationKey.currentState?._onTabTap(index);
  }
}

class _AppNavigationState extends State<AppNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const MapScreen(),
    const TripScreen(),
    const StatisticsScreen(),
    const ProfileScreen(),
  ];

  final List<String> _icons = [
    AppImages.homeIcon,
    AppImages.tripsIcon,
    AppImages.statesIcon,
    AppImages.profileIcon,
  ];

  void _onTabTap(int index) {
    if (_currentIndex == index) return;
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: ShapeDecoration(
          color: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(26),
              topRight: Radius.circular(26),
            ),
            side: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.5), width: 0.8),
          ),
          shadows: [
            BoxShadow(
              color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.3 : 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: Stack(
            children: [
              /// 🔵 INNER SHADOW (IMPORTANT: placed ABOVE)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: IgnorePointer(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 20,
                      decoration: BoxDecoration(
                        // border: Border(top: BorderSide(color: Colors.grey, width: 0.15)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 20,
                            offset: const Offset(1, 0),
                          ),
                        ],
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Theme.of(context).colorScheme.primaryContainer.withOpacity(0.02),
                            Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
                            Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SafeArea(
                top: false,
                child: SizedBox(
                  height: 64,
                  child: Row(
                    children: List.generate(
                      _icons.length,
                      (index) => Expanded(
                        child: _RippleNavItem(
                          assetPath: _icons[index],
                          isSelected: _currentIndex == index,
                          onTap: () => _onTabTap(index),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RippleNavItem extends StatefulWidget {
  final String assetPath;
  final bool isSelected;
  final VoidCallback onTap;

  const _RippleNavItem({
    required this.assetPath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_RippleNavItem> createState() => _RippleNavItemState();
}

class _RippleNavItemState extends State<_RippleNavItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rippleScale;
  late final Animation<double> _rippleOpacity;
  late final Animation<double> _iconScale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _rippleScale = Tween<double>(
      begin: 0.2,
      end: 1.8,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _rippleOpacity = Tween<double>(
      begin: 0.22,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _iconScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 0.92,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.92,
          end: 1.06,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.06,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
    ]).animate(_controller);
  }

  void _handleTap() {
    _controller.forward(from: 0);
    widget.onTap();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = widget.isSelected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSurface.withOpacity(0.4);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _handleTap,
      child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return SizedBox(
              width: 44,
              height: 44,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Transform.scale(
                    scale: _rippleScale.value,
                    child: Opacity(
                      opacity: _rippleOpacity.value,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Theme.of(context).colorScheme.primary, width: 1.2),
                        ),
                      ),
                    ),
                  ),
                  Transform.scale(
                    scale: _iconScale.value,
                    child: Image.asset(
                      widget.assetPath,
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                      color: iconColor,
                      colorBlendMode: BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
