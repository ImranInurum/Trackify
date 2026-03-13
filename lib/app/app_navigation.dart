import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';

import '../feature/map/presentation/pages/map_screen.dart';
import '../feature/profile/presentation/pages/profile_screen.dart';
import '../feature/settings/presentation/pages/settings.dart';

class AppNavigation extends StatefulWidget {
  const AppNavigation({super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  final NotchBottomBarController _controller = NotchBottomBarController(index: 0);
  int _currentIndex = 0;

  final _pages = [
    const MapScreen(),
    const ProfilePlaceholder(),
    const SettingsPlaceholder(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      extendBody: true,
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchColor: Theme.of(context).colorScheme.secondaryContainer,
        color: Theme.of(context).colorScheme.primaryContainer,

        notchBottomBarController: _controller,
        bottomBarItems: [
          BottomBarItem(
            inActiveItem: Icon(
              Icons.map,
              color: Theme.of(context).colorScheme.secondaryContainer,
            ),
            activeItem: Icon(
              Icons.map_outlined,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
          ),
          BottomBarItem(
            inActiveItem: Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.secondaryContainer,
            ),
            activeItem: Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
          ),
          BottomBarItem(
            inActiveItem: Icon(
              Icons.settings,
              color: Theme.of(context).colorScheme.secondaryContainer,
            ),
            activeItem: Icon(
              Icons.settings,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
          ),
        ],
        onTap: (int value) {
          setState(() {
            _currentIndex = value;
          });
        },
        kIconSize: 24.0,
        kBottomRadius: 28.0,
      ),
    );
  }
}
