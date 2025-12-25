import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class LoadingScreenOL {
  static final LoadingScreenOL _instance = LoadingScreenOL._internal();
  factory LoadingScreenOL() {
    return _instance;
  }
  LoadingScreenOL._internal();

  OverlayEntry? _overlayEntry;
  Timer? _timer;
  int _loadingCount = 0; // Reference counter
  show() {
    _loadingCount++;
    if (_loadingCount == 1 && _overlayEntry == null) {
      _overlayEntry = OverlayEntry(
        builder: (context) => const Material(
          color: Colors.transparent,
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 5,
                  child: LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB0B0DF)),
                    backgroundColor: Colors.black12,
                  ),
                ),
                Expanded(
                    child: Center(
                      child: CupertinoActivityIndicator(
                        animating: true,
                        color: Colors.white,
                      ),
                    ))
              ],
            ),
          ),
        ),
      );

      rootNavigatorKey.currentState?.overlay?.insert(_overlayEntry!);

    }
  }


  void hide() {
    if (_loadingCount > 0) {
      _loadingCount--;
    }

    if (_loadingCount == 0) {
      Future.delayed(const Duration(milliseconds: 300), () {
        // Delay the hide call to prevent flickering
        _timer?.cancel();
        _overlayEntry?.remove();
        _overlayEntry = null;
      });
    }
  }

  void reset() {
    _loadingCount = 0;
    hide();
  }
}