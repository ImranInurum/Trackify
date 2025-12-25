import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
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

  final _pages = [const MapScreen(), const ProfilePlaceholder(),const SettingsPlaceholder()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      extendBody: true,
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchColor: Theme.of(context).colorScheme.secondary,
        color: Theme.of(context).colorScheme.background,
        notchBottomBarController: _controller,
        bottomBarItems: const [
          BottomBarItem(
            inActiveItem: Icon(Icons.map, color: Colors.blueGrey),
            activeItem: Icon(Icons.map_outlined, color: Colors.blueAccent),
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.person, color: Colors.blueGrey),
            activeItem: Icon(Icons.person, color: Colors.blueAccent),
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.settings, color: Colors.blueGrey),
            activeItem: Icon(Icons.settings, color: Colors.blueAccent),
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
