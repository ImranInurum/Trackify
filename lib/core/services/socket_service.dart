import 'dart:async';
import 'dart:convert';
import 'dart:io';

class SocketService {
  static final SocketService _instance = SocketService._internal();

  factory SocketService() => _instance;

  SocketService._internal();

  WebSocket? _socket;
  StreamSubscription? _socketSubscription;
  final StreamController<Map<String, dynamic>> _deviceDataController =
  StreamController<Map<String, dynamic>>.broadcast();

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  String? _url;
  bool _shouldReconnect = false;
  Duration _reconnectDelay = const Duration(seconds: 3);

  Stream<Map<String, dynamic>> get deviceDataStream => _deviceDataController.stream;

  Future<void> connect(String url) async {
    _url = url;
    _shouldReconnect = true;

    await _connectInternal();
  }

  Future<void> _connectInternal() async {
    if (_url == null) return;

    print('[SocketService] Attempting connection to $_url');

    try {
      // ✅ Add timeout so we don’t hang forever
      _socket = await WebSocket.connect(_url!)
          .timeout(const Duration(seconds: 5));

      _isConnected = true;
      print('[SocketService] ✅ Connected successfully to $_url');

      _socketSubscription = _socket!.listen(
            (data) {
          print('[SocketService] 🔄 Received data: $data');

          try {
            final decoded = jsonDecode(data);
            if (decoded is Map<String, dynamic>) {
              _deviceDataController.add(decoded);
            } else {
              print('[SocketService] Warning: unexpected data type');
            }
          } catch (e) {
            print('[SocketService] ❌ JSON decode error: $e');
          }
        },
        onDone: () {
          print('[SocketService] ⚠️ Connection closed by server.');
          _handleDisconnect();
        },
        onError: (error) {
          print('[SocketService] ❌ Socket error: $error');
          _handleDisconnect();
        },
        cancelOnError: true,
      );
    } on TimeoutException {
      print('[SocketService] ⏰ Connection timeout while connecting to $_url');
      _handleDisconnect();
    } catch (e) {
      print('[SocketService] ❌ Connection failed: $e');
      _handleDisconnect();
    }
  }

  void send(Map<String, dynamic> data) {
    if (_socket != null && _isConnected) {
      final jsonString = jsonEncode(data);
      _socket!.add(jsonString);
    } else {
      print('[SocketService] Cannot send — not connected');
    }
  }

  void _handleDisconnect() {
    _isConnected = false;
    _socketSubscription?.cancel();
    _socket?.close();
    _socket = null;

    if (_shouldReconnect && _url != null) {
      print('[SocketService] Disconnected. Reconnecting in ${_reconnectDelay.inSeconds}s...');
      Future.delayed(_reconnectDelay, () => _connectInternal());
    }
  }

  void disconnect() {
    _shouldReconnect = false;
    _isConnected = false;
    _socketSubscription?.cancel();
    _socket?.close();
    _socket = null;
    print('[SocketService] Disconnected manually.');
  }

  void dispose() {
    _shouldReconnect = false;
    _isConnected = false;
    _socketSubscription?.cancel();
    _socket?.close();
    _deviceDataController.close();
  }
}
