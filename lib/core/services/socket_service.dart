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
  Duration _reconnectDelay = const Duration(seconds: 3);

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
    await _connectInternal();
  }

  Future<void> _connectInternal() async {
    if (_host == null || _port == null) return;
    if (_isConnecting) return;

    print('[SocketService] Attempting TCP connection to $_host:$_port');
    _isConnecting = true;

    try {
      // ✅ Using raw Socket.connect for TCP
      _socket = await Socket.connect(
        _host!,
        _port!,
        timeout: const Duration(seconds: 10),
      );

      _isConnected = true;
      _isConnecting = false;
      print('[SocketService] ✅ TCP Connected successfully to $_host:$_port');

      // Register device/handshake
      await _sendHandshake();

      _socketSubscription = _socket!.listen(
        (data) {
          try {
            final rawResponse = utf8.decode(data, allowMalformed: true);
            print(
              "[SocketService] 🔄 Received (Length: ${rawResponse.length}): $rawResponse",
            );

            // TCP streams can be noisy or contain multiple messages.
            // We find all substrings that look like JSON objects.
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
                    print("[SocketService] ✅ Decoded: $decoded");
                    _deviceDataController.add(decoded);
                  }
                } catch (e) {
                  print(
                    '[SocketService] ❌ JSON part decode error: $e | Part: $jsonPart',
                  );
                }
              }
            }

            if (matches.isEmpty) {
              print('[SocketService] ⚠️ No JSON found in chunk');
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
      String iMEI = _currentImei ?? await prefs.get(key: AppPreference.IMEI);
      print("Handshake IMEI: $iMEI");

      final handshake = {"type": "flutter", "imei": iMEI};
      _socket!.write(jsonEncode(handshake));
      print('[SocketService] 📤 Handshake sent: $handshake');
    }
  }

  // void send(Map<String, dynamic> data) {
  //   if (_socket != null && _isConnected) {
  //     _socket!.write(jsonEncode(data));
  //   } else {
  //     print('[SocketService] Cannot send — not connected');
  //   }
  // }

  void _handleDisconnect() {
    _isConnected = false;
    _isConnecting = false;
    _socketSubscription?.cancel();
    _socket?.destroy(); // destroy() is better for raw sockets than close()
    _socket = null;

    if (_shouldReconnect && _host != null) {
      print(
        '[SocketService] Disconnected. Reconnecting in ${_reconnectDelay.inSeconds}s...',
      );
      Future.delayed(_reconnectDelay, () => _connectInternal());
    }
  }

  void disconnect() {
    _shouldReconnect = false;
    _isConnected = false;
    _isConnecting = false;
    _socketSubscription?.cancel();
    _socket?.destroy();
    _socket = null;
    print('[SocketService] Disconnected manually.');
  }

  void dispose() {
    _shouldReconnect = false;
    _isConnected = false;
    _isConnecting = false;
    _socketSubscription?.cancel();
    _socket?.destroy();
    _deviceDataController.close();
  }
}
