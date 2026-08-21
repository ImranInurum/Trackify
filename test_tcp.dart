import 'dart:io';
import 'dart:convert';

void main() async {
  print('Connecting to TCP Socket...');
  try {
    var socket = await Socket.connect(
      'trackifybackend.inurum.com',
      4000,
      timeout: Duration(seconds: 5),
    );
    print('TCP Connected!');

    socket.listen(
      (data) {
        final rawResponse = utf8.decode(data, allowMalformed: true);
        print('TCP Received: $rawResponse');
      },
      onError: (e) {
        print('TCP Error: $e');
        exit(1);
      },
      onDone: () {
        print('Server ne connection close kar diya (TCP Done)');
        exit(0);
      },
    );

    // Handshake based on socket_service.dart
    final handshake = {
      "type": "flutter",
      "imei": "864662074414329",
    }; //864662074414329
    socket.write('${jsonEncode(handshake)}\n');
    print('Handshake sent: $handshake');
    print('Waiting indefinitely for server response or onDone event...');
  } catch (e) {
    print('Connection Error: $e');
  }
}
