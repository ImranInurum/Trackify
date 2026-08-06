import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();

  factory ConnectivityService() => _instance;

  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectivityController =
  StreamController<bool>.broadcast();

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  Stream<bool> get connectivityStream => _connectivityController.stream;

  void initialize() {
    _subscription = _connectivity.onConnectivityChanged.listen((results) async {
      final isConnected = _hasConnection(results);
      _connectivityController.add(isConnected);
    });
  }

  Future<bool> checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    return _hasConnection(results);
  }

  void dispose() {
    _subscription?.cancel();
    _connectivityController.close();
  }

  bool _hasConnection(List<ConnectivityResult> results) {
    if (results.isEmpty) return false;
    return results.any((r) =>
    r == ConnectivityResult.mobile ||
        r == ConnectivityResult.wifi ||
        r == ConnectivityResult.ethernet ||
        r == ConnectivityResult.vpn);
  }
}
