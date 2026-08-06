import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:trackify/core/constants/app_images.dart';
import 'package:trackify/feature/profile/presentation/pages/profile_screen.dart';
import 'package:trackify/core/utils/shared_preferences.dart';

import '../feature/map/presentation/pages/map_screen.dart';
import '../feature/statistics/presentation/pages/statistics_screen.dart';
import '../feature/trips/presentation/view/trip_screen.dart';
import '../feature/product_over_view/product_screen.dart';
import '../feature/device_warranty/pages/device_warranty_page.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/app/cubit/app_cubit.dart';
import 'package:trackify/feature/auth/presentation/pages/signin_screen.dart';
import 'package:trackify/feature/map/presentation/cubit/map_cubit.dart';
import 'package:trackify/feature/my_garage/presentation/cubit/my_garage_cubit.dart';
import 'package:trackify/feature/my_profile/presentation/cubit/my_profile_cubit.dart';
import 'package:trackify/feature/profile/presentation/cubit/profile_cubit.dart';
import 'package:trackify/feature/service_logs/presentation/cubit/service_logs_cubit.dart';
import 'package:trackify/app/session_route_observer.dart';

class AppNavigation extends StatefulWidget {
  static _AppNavigationState? currentState;
  static final ValueNotifier<int> currentTabNotifier = ValueNotifier<int>(0);

  const AppNavigation({super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();

  static void setIndex(int index) {
    currentState?._onTabTap(index);
  }

  static void refreshNavigationState() {
    currentState?._refreshState();
  }
}

class _AppNavigationState extends State<AppNavigation> {
  int _currentIndex = 0;
  bool _previousHasDevice = false;
  bool _previousIsWarrantyExpired = false;

  late final List<GlobalKey<NavigatorState>> _navigatorKeys;
  late final GlobalKey<NavigatorState> _productNavigatorKey;
  late final GlobalKey<NavigatorState> _warrantyNavigatorKey;

  @override
  void initState() {
    super.initState();
    AppNavigation.currentState = this;
    _previousHasDevice = _hasDevice;
    _previousIsWarrantyExpired = _isWarrantyExpired;
    _navigatorKeys = List.generate(4, (index) => GlobalKey<NavigatorState>());
    _productNavigatorKey = GlobalKey<NavigatorState>();
    _warrantyNavigatorKey = GlobalKey<NavigatorState>();
    
    // Initial check on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSessionAndLogout();
    });
  }

  @override
  void dispose() {
    if (AppNavigation.currentState == this) {
      AppNavigation.currentState = null;
    }
    super.dispose();
  }

  bool get _hasDevice {
    final imei = AppPreference.instance.getSync(key: AppPreference.IMEI);
    return imei.isNotEmpty;
  }

  bool get _isWarrantyExpired {
    if (!_hasDevice) return false;
    return AppPreference.instance.getBoolSync(key: 'KEY_WARRANTY_EXPIRED', defaultValue: true);
  }

  bool get _isThreeTabMode => !_hasDevice || _isWarrantyExpired;

  GlobalKey<NavigatorState> _getNavigatorKey(int displayIndex) {
    if (!_isThreeTabMode) {
      return _navigatorKeys[displayIndex];
    } else {
      if (displayIndex == 0) return _navigatorKeys[0];
      if (displayIndex == 1) {
        return _isWarrantyExpired ? _warrantyNavigatorKey : _productNavigatorKey;
      }
      return _navigatorKeys[3]; // Profile is actual index 3
    }
  }

  void _refreshState() {
    setState(() {
      final bool currentlyThreeTabs = _isThreeTabMode;
      final bool previouslyThreeTabs = !_previousHasDevice || _previousIsWarrantyExpired;

      if (previouslyThreeTabs && !currentlyThreeTabs) {
        // Switched from 3 tabs to 4 tabs
        if (_currentIndex == 2) {
          _currentIndex = 3; // Profile moves from 2 to 3
        } else if (_currentIndex == 1) {
          _currentIndex = 0; // Middle tab falls back to Map
        }
      } else if (!previouslyThreeTabs && currentlyThreeTabs) {
        // Switched from 4 tabs to 3 tabs
        if (_currentIndex == 3) {
          _currentIndex = 2; // Profile moves from 3 to 2
        } else if (_currentIndex == 1 || _currentIndex == 2) {
          _currentIndex = 0; // Trips/Stats fall back to Map
        }
      } else if (previouslyThreeTabs && currentlyThreeTabs) {
        // Both layouts are 3 tabs, but maybe transitioned between Expired and Uninstalled states
        if (_previousIsWarrantyExpired != _isWarrantyExpired) {
          if (_currentIndex == 1) {
            _currentIndex = 0; // Reset middle tab to Map to be safe
          }
        }
      }
      _previousHasDevice = _hasDevice;
      _previousIsWarrantyExpired = _isWarrantyExpired;
    });
  }

  List<dynamic> get _currentIcons {
    if (!_isThreeTabMode) {
      return [
        AppImages.homeIcon,
        AppImages.tripsIcon,
        AppImages.statesIcon,
        AppImages.profileIcon,
      ];
    } else {
      return [
        AppImages.homeIcon,
        _isWarrantyExpired ? Icons.shield_outlined : Icons.inventory_2_outlined,
        AppImages.profileIcon,
      ];
    }
  }

  List<Widget> get _currentScreens {
    if (!_isThreeTabMode) {
      return [
        _buildNavigator(_navigatorKeys[0], const MapScreen()),
        _buildNavigator(_navigatorKeys[1], const TripScreen()),
        _buildNavigator(_navigatorKeys[2], const StatisticsScreen()),
        _buildNavigator(_navigatorKeys[3], const ProfileScreen()),
      ];
    } else {
      return [
        _buildNavigator(_navigatorKeys[0], const MapScreen()),
        _buildNavigator(
          _isWarrantyExpired ? _warrantyNavigatorKey : _productNavigatorKey,
          _isWarrantyExpired ? const WarrantyScreen() : const ProductOverviewScreen(),
        ),
        _buildNavigator(_navigatorKeys[3], const ProfileScreen()),
      ];
    }
  }

  void _onTabTap(int index) {
    final navKey = _getNavigatorKey(index);
    navKey.currentState?.popUntil((route) => route.isFirst);
    if (_currentIndex == index) {
      return;
    }
    setState(() {
      _currentIndex = index;
    });
    AppNavigation.currentTabNotifier.value = _getActualIndex(index);
    _checkSessionAndLogout();
  }

  Future<void> _checkSessionAndLogout() async {
    if (!mounted) return;
    final isExpired = await context.read<AppCubit>().isSessionExpired();
    if (isExpired && mounted) {
      await context.read<AppCubit>().logout();
      if (mounted) {
        context.read<ProfileCubit>().reset();
        context.read<MyProfileCubit>().reset();
        context.read<MapCubit>().reset();
        context.read<MyGarageCubit>().reset();
        context.read<ServiceLogsCubit>().reset();
        Navigator.of(
          context,
          rootNavigator: true,
        ).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const SignInScreen(),
          ),
          (Route<dynamic> route) => false,
        );
      }
    }
  }

  int _getActualIndex(int displayIndex) {
    if (!_isThreeTabMode) return displayIndex;
    // If 3-tab mode, displayIndex 0 -> actual 0 (Map)
    // displayIndex 1 -> actual 1 (Product or Warranty/Trips)
    // displayIndex 2 -> actual 3 (Profile)
    if (displayIndex == 2) return 3;
    return displayIndex;
  }

  Widget _buildNavigator(GlobalKey<NavigatorState> key, Widget child) {
    return Navigator(
      key: key,
      observers: [SessionRouteObserver()],
      onGenerateRoute: (settings) =>
          MaterialPageRoute(builder: (context) => child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = _currentScreens;
    if (_currentIndex >= screens.length) {
      _currentIndex = screens.length - 1;
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final navigator =
            _getNavigatorKey(_currentIndex).currentState;
        if (navigator != null && navigator.canPop()) {
          navigator.pop();
        } else {
          if (_currentIndex != 0) {
            _onTabTap(0);
          } else {
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        body: IndexedStack(index: _currentIndex, children: screens),
        bottomNavigationBar: Container(
          decoration: ShapeDecoration(
            color: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(26),
                topRight: Radius.circular(26),
              ),
              side: BorderSide(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                width: 0.8,
              ),
            ),
            shadows: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 
                  Theme.of(context).brightness == Brightness.dark ? 0.3 : 0.1,
                ),
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
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 20,
                              offset: const Offset(1, 0),
                            ),
                          ],
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Theme.of(
                                context,
                              ).colorScheme.primaryContainer.withValues(alpha: 0.02),
                              Theme.of(
                                context,
                              ).colorScheme.primaryContainer.withValues(alpha: 0.2),
                              Theme.of(
                                context,
                              ).colorScheme.primaryContainer.withValues(alpha: 0.4),
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
                        _currentIcons.length,
                        (index) => Expanded(
                          child: _RippleNavItem(
                            assetPath: _currentIcons[index],
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
      ),
    );
  }
}

class _RippleNavItem extends StatefulWidget {
  final dynamic assetPath;
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
        : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4);

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
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Transform.scale(
                    scale: _iconScale.value,
                    child: widget.assetPath is String
                        ? Image.asset(
                            widget.assetPath as String,
                            width: 24,
                            height: 24,
                            fit: BoxFit.contain,
                            color: iconColor,
                            colorBlendMode: BlendMode.srcIn,
                          )
                        : Icon(
                            widget.assetPath as IconData,
                            size: 26,
                            color: iconColor,
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
