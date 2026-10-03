import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:dotenv/dotenv.dart' as dotenv;
import '../lib/src/routes.dart' as routes;

void main(List<String> args) async {
  dotenv.load();

  final ip = InternetAddress.anyIPv4;
  final portEnv = Platform.environment['PORT'] ?? '8080';
  final port = int.parse(portEnv);

  final router = Router();
  routes.registerRoutes(router);

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router);

  final server = await serve(handler, ip, port);
  print('Server running on http://${server.address.host}:${server.port}');
}
