import 'dart:convert';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'ws.dart';
import 'store.dart';
import 'auth.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';

final store = InMemoryStore();

void registerRoutes(Router router) {
  router.post('/auth/request_otp', (Request req) async {
    final body = jsonDecode(await req.readAsString()) as Map<String, dynamic>;
    final phone = body['phone'] as String;
    final code = store.generateOtp(phone);
    // In production: send SMS via Twilio. Here we return code (mock).
    return Response.ok(jsonEncode({'ok': true, 'otp': code}), headers: {'content-type': 'application/json'});
  });

  router.post('/auth/verify_otp', (Request req) async {
    final body = jsonDecode(await req.readAsString()) as Map<String, dynamic>;
    final phone = body['phone'] as String;
    final code = body['code'] as String;
    final ok = store.verifyOtp(phone, code);
    if (!ok) {
      return Response.forbidden(jsonEncode({'ok': false, 'message': 'Invalid code'}), headers: {'content-type': 'application/json'});
    }
    final user = store.createOrGetUser(phone);
    final token = createJwt(user); // in this mock token encodes claims
    // For simple WebSocket mock we will also allow using user.id directly as token
    return Response.ok(jsonEncode({'ok': true, 'token': user.id, 'jwt': token, 'user': {'id': user.id, 'phone': user.phone}}), headers: {'content-type': 'application/json'});
  });

  router.get('/ws', webSocketHandler()); // websocket endpoint

  router.get('/messages/<conversationId>', (Request req, String conversationId) {
    final msgs = store.getMessages(conversationId).map((m) => {
      'id': m.id,
      'from': m.fromUserId,
      'to': m.toUserId,
      'text': m.text,
      'timestamp': m.timestamp.toIso8601String(),
      'status': m.status
    }).toList();
    return Response.ok(jsonEncode({'messages': msgs}), headers: {'content-type': 'application/json'});
  });

  router.get('/health', (Request req) => Response.ok('OK'));
}
