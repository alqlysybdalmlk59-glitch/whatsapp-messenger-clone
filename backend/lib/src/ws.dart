import 'dart:convert';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'store.dart';
import 'models.dart';

final Map<String, WebSocketChannel> connectionsByUser = {};

Handler webSocketHandler() {
  return webSocketHandlerWithChannel((WebSocketChannel webSocket) {
    String? userId;
    webSocket.stream.listen((message) {
      try {
        final data = jsonDecode(message as String) as Map<String, dynamic>;
        final type = data['type'] as String?;
        if (type == 'auth') {
          final token = data['token'] as String?;
          // For dev: token is userId in this mock
          if (token != null) {
            // In real: verify JWT and extract sub
            userId = token;
            connectionsByUser[userId!] = webSocket;
            store.presence[userId!] = true;
            // ack
            webSocket.sink.add(jsonEncode({'type': 'auth_ok', 'userId': userId}));
          }
        } else if (type == 'message') {
          final to = data['to'] as String;
          final text = data['text'] as String;
          final from = userId!;
          final conversationId = data['conversationId'] as String? ?? '$from:$to';
          final msg = store.saveMessage(conversationId, from, to, text);
          final payload = {
            'type': 'message',
            'message': {
              'id': msg.id,
              'conversationId': msg.conversationId,
              'from': msg.fromUserId,
              'to': msg.toUserId,
              'text': msg.text,
              'timestamp': msg.timestamp.toIso8601String(),
              'status': msg.status
            }
          };
          // send to recipient if connected
          final conn = connectionsByUser[to];
          if (conn != null) {
            conn.sink.add(jsonEncode(payload));
            // update status locally
            msg.status = 'delivered';
            // send ack back to sender
            webSocket.sink.add(jsonEncode({
              'type': 'ack',
              'messageId': msg.id,
              'status': 'delivered'
            }));
          } else {
            // offline: message stored, will be delivered when online
            webSocket.sink.add(jsonEncode({
              'type': 'ack',
              'messageId': msg.id,
              'status': 'stored'
            }));
          }
        } else if (type == 'typing') {
          final to = data['to'] as String;
          final conn = connectionsByUser[to];
          if (conn != null && userId != null) {
            conn.sink.add(jsonEncode({'type': 'typing', 'from': userId}));
          }
        }
      } catch (e) {
        webSocket.sink.add(jsonEncode({'type': 'error', 'message': e.toString()}));
      }
    }, onDone: () {
      if (userId != null) {
        connectionsByUser.remove(userId);
        store.presence[userId!] = false;
      }
    });
  });
}
