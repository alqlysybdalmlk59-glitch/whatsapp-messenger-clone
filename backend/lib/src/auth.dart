import 'dart:convert';
import 'package:jwt/jwt.dart';
import 'store.dart';
import 'models.dart';
import 'package:dotenv/dotenv.dart' as dotenv;

final store = InMemoryStore();
final jwtSecret = dotenv.env['JWT_SECRET'] ?? 'dev_secret_change_me';

String createJwt(User user) {
  final claims = {'sub': user.id, 'phone': user.phone, 'name': user.name ?? ''};
  final token = JsonWebTokenCodec(HmacKey(utf8.encode(jwtSecret))).encode(claims);
  return token;
}
