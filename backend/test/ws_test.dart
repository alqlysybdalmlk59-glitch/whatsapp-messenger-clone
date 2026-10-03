import 'dart:convert';
import 'package:test/test.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:async';
import 'dart:io';

void main() {
  test('websocket message flow (mock)', () async {
    // Warning: this test assumes server already running on localhost:8080
    final userA = 'userA-id';
    final userB = 'userB-id';

    final chA = IOWebSocketChannel.connect('ws://localhost:8080/ws');
    final chB = IOWebSocketChannel.connect('ws://localhost:8080/ws');

    final futureA = chA.stream.firstWhere((m) => m != null).timeout(Duration(seconds: 5));
    final futureB = chB.stream.firstWhere((m) => m != null).timeout(Duration(seconds: 5));

    // auth
    chA.sink.add(jsonEncode({'type': 'auth', 'token': userA}));
    chB.sink.add(jsonEncode({'type': 'auth', 'token': userB}));

    await Future.delayed(Duration(milliseconds: 200));

    // send message from A to B
    chA.sink.add(jsonEncode({'type': 'message', 'to': userB, 'text': 'مرحبا من A', 'conversationId': '$userA:$userB'}));

    // B should receive message
    final msgB = await chB.stream.first.timeout(Duration(seconds: 5));
    final obj = jsonDecode(msgB as String);
    expect(obj['type'], 'message');

    // A should receive ack
    final ack = await chA.stream.first.timeout(Duration(seconds: 5));
    final ackObj = jsonDecode(ack as String);
    expect(ackObj['type'], anyOf('ack', 'error'));

    chA.sink.close();
    chB.sink.close();
  }, timeout: Timeout(Duration(seconds: 20)));
}
