import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../utils/shared_preferences.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();

  factory SocketService() => _instance;

  SocketService._internal();

  Socket? _socket;
  StreamSubscription? _socketSubscription;
  final StreamController<Map<String, dynamic>> _deviceDataController =
      StreamController<Map<String, dynamic>>.broadcast();

  bool _isConnected = false;
  bool get isConnected => _isConnected;
  bool _isConnecting = false;
  bool get isConnecting => _isConnecting;
  final prefs = AppPreference.instance;

  String? _host;
  int? _port;
  bool _shouldReconnect = false;
  int _reconnectAttempts = 0;
  final int _maxReconnectAttempts = 10;
  final Duration _minReconnectDelay = const Duration(seconds: 2);
  final Duration _maxReconnectDelay = const Duration(minutes: 1);
  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;

  Stream<Map<String, dynamic>> get deviceDataStream =>
      _deviceDataController.stream;

  String? _currentImei;

  Future<void> connect(String url, {String? imei, bool force = false}) async {
    if (force) {
      disconnect();
    }
    
    if (_isConnected || _isConnecting) return;
    
    if (imei != null) {
      _currentImei = imei;
    } else {
      _currentImei = null;
    }

    try {
      final parts = url
          .replaceAll('ws://', '')
          .replaceAll('http://', '')
          .split(':');
      _host = parts[0];
      _port = parts.length > 1 ? int.tryParse(parts[1]) : 4000;
    } catch (e) {
      print('[SocketService] Error parsing URL: $e');
      _host = '139.59.1.109';
      _port = 4000;
    }

    _shouldReconnect = true;
    _reconnectAttempts = 0; // Reset attempts on manual connect
    await _connectInternal();
  }

  Future<void> _connectInternal() async {
    if (_host == null || _port == null) return;
    if (_isConnecting) return;

    print('[SocketService] Attempting TCP connection to $_host:$_port (Attempt: ${_reconnectAttempts + 1})');
    _isConnecting = true;

    try {
      _socket = await Socket.connect(
        _host!,
        _port!,
        timeout: const Duration(seconds: 10),
      );

      _isConnected = true;
      _isConnecting = false;
      _reconnectAttempts = 0; // Reset on successful connection
      print('[SocketService] ✅ TCP Connected successfully to $_host:$_port');

      _startHeartbeat();

      // Register device/handshake
      await _sendHandshake();

      _socketSubscription = _socket!.listen(
        (data) {
          try {
            final rawResponse = utf8.decode(data, allowMalformed: true);
            print(
              "[SocketService] 🔄 Received (Length: ${rawResponse.length}): $rawResponse",
            );

            final RegExp jsonRegExp = RegExp(r'\{.*?\}', dotAll: true);
            final Iterable<RegExpMatch> matches = jsonRegExp.allMatches(
              rawResponse,
            );

            for (final match in matches) {
              final jsonPart = match.group(0);
              if (jsonPart != null) {
                try {
                  final decoded = jsonDecode(jsonPart);
                  if (decoded is Map<String, dynamic>) {
                    _deviceDataController.add(decoded);
                  }
                } catch (e) {
                  print('[SocketService] ❌ JSON part decode error: $e');
                }
              }
            }
          } catch (e) {
            print('[SocketService] ❌ Raw data decode error: $e');
          }
        },
        onDone: () {
          print('[SocketService] ⚠️ TCP Connection closed.');
          _handleDisconnect();
        },
        onError: (error) {
          print('[SocketService] ❌ TCP Socket error: $error');
          _handleDisconnect();
        },
        cancelOnError: true,
      );
    } catch (e) {
      print('[SocketService] ❌ TCP Connection failed: $e');
      _isConnecting = false;
      _handleDisconnect();
    }
  }

  Future<void> _sendHandshake() async {
    if (_socket != null && _isConnected) {
      try {
        String iMEI = _currentImei ?? await prefs.get(key: AppPreference.IMEI);
        final handshake = {"type": "flutter", "imei": iMEI};
        _socket!.write('${jsonEncode(handshake)}\n');
        print('[SocketService] 📤 Handshake sent: $handshake');
      } catch (e) {
        print('[SocketService] ❌ Error sending handshake: $e');
        _handleDisconnect();
      }
    }
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_isConnected) {
        print('[SocketService] Socket still connected...');
      } else {
        timer.cancel();
      }
    });
  }

  void _handleDisconnect() {
    if (!_shouldReconnect && !_isConnected && !_isConnecting) return;
    
    _isConnected = false;
    _isConnecting = false;
    _heartbeatTimer?.cancel();
    _reconnectTimer?.cancel();
    _socketSubscription?.cancel();
    _socket?.destroy();
    _socket = null;

    if (_shouldReconnect && _host != null) {
      if (_reconnectAttempts < _maxReconnectAttempts) {
        _reconnectAttempts++;
      }
      
      // Exponential backoff
      int shift = _reconnectAttempts - 1;
      if (shift > 10) shift = 10; // Prevent overflow
      
      int delaySeconds = _minReconnectDelay.inSeconds * (1 << shift);
      if (delaySeconds > _maxReconnectDelay.inSeconds) {
        delaySeconds = _maxReconnectDelay.inSeconds;
      }
      
      final delay = Duration(seconds: delaySeconds);
      
       print(
        '[SocketService] Reconnecting in ${delay.inSeconds}s (Attempt $_reconnectAttempts)...',
      );
      
      _reconnectTimer = Timer(delay, () {
        if (_shouldReconnect && !_isConnected && !_isConnecting) {
          _connectInternal();
        }
      });
    }
  }

  void disconnect() {
    _shouldReconnect = false;
    _isConnected = false;
    _isConnecting = false;
    _heartbeatTimer?.cancel();
    _reconnectTimer?.cancel();
    _socketSubscription?.cancel();
    _socket?.destroy();
    _socket = null;
    print('[SocketService] Disconnected manually.');
  }

  void dispose() {
    _shouldReconnect = false;
    _isConnected = false;
    _isConnecting = false;
    _heartbeatTimer?.cancel();
    _reconnectTimer?.cancel();
    _socketSubscription?.cancel();
    _socket?.destroy();
    _deviceDataController.close();
  }
}
