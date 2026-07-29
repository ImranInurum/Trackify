import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:trackify/app/cubit/app_cubit.dart';
import 'package:trackify/app/cubit/app_state.dart';

import 'package:trackify/core/config/theme_manager.dart';
import 'package:trackify/feature/onboarding/presentation/pages/splash.dart';
import 'package:trackify/l10n/app_localizations.dart';
import 'package:trackify/main.dart';
import 'package:trackify/core/widgets/global_no_internet_screen.dart';
import 'package:trackify/app/session_route_observer.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
    _checkForUpdate();
  }

  Future<void> _checkForUpdate() async {
    try {
      final info = await InAppUpdate.checkForUpdate();
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        if (info.immediateUpdateAllowed) {
          await InAppUpdate.performImmediateUpdate();
        } else if (info.flexibleUpdateAllowed) {
          await InAppUpdate.startFlexibleUpdate();
          await InAppUpdate.completeFlexibleUpdate();
        }
      }
    } catch (e) {
      debugPrint('Error checking for update: $e');
    }
  }

  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();

    // Check initial link if app was in background and opened with a link
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      }
    } catch (e) {
      debugPrint('Failed to get initial uri: $e');
    }

    // Handle incoming links while app is open
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri);
    }, onError: (err) {
      debugPrint('Failed to get incoming uri: $err');
    });
  }

  void _handleDeepLink(Uri uri) {
    debugPrint('Received Deep Link: $uri');
    
    // Example: trackigy://device/880ff4276cf7c8268a438dc34a05ca45
    if (uri.scheme == 'trackigy') {
      final pathSegments = uri.pathSegments;
      if (pathSegments.isNotEmpty) {
        final token = pathSegments.last;
        final type = uri.host; // e.g. "device" or "ride"

        // Temporary placeholder: show a snackbar
        if (rootNavigatorKey.currentContext != null) {
          ScaffoldMessenger.of(rootNavigatorKey.currentContext!).showSnackBar(
            SnackBar(
              content: Text('Deep Link Received!\nType: $type\nToken: $token'),
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) => MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: rootNavigatorKey,
        themeMode: state.themeMode,
        theme: ThemeManager.getApplicationLightTheme(state.dynamicTheme),
        darkTheme: ThemeManager.getApplicationDarkTheme(state.dynamicTheme),
        locale: state.locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        navigatorObservers: [SessionRouteObserver()],
        home: const SplashScreen(),
        builder: (context, child) {
          return Stack(
            children: [
              if (child != null) child,
              if (!state.isConnected)
                const Positioned.fill(
                  child: GlobalNoInternetScreen(),
                ),
            ],
          );
        },
      ),
    );
  }
}
