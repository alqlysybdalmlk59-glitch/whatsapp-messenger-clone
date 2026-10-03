import 'models.dart';
import 'package:uuid/uuid.dart';

final _uuid = Uuid();

class InMemoryStore {
  // users by phone
  final Map<String, User> usersByPhone = {};
  // users by id
  final Map<String, User> usersById = {};
  // conversations: Map<conversationId, List<Message>>
  final Map<String, List<Message>> messages = {};
  // simple presence map userId -> isOnline
  final Map<String, bool> presence = {};
  // OTP store: phone -> code
  final Map<String, String> otps = {};

  User createOrGetUser(String phone) {
    if (usersByPhone.containsKey(phone)) {
      return usersByPhone[phone]!;
    }
    final id = _uuid.v4();
    final user = User(id: id, phone: phone, name: phone);
    usersByPhone[phone] = user;
    usersById[id] = user;
    return user;
  }

  String generateOtp(String phone) {
    final code = '123456'; // mocked OTP for dev
    otps[phone] = code;
    return code;
  }

  bool verifyOtp(String phone, String code) {
    final stored = otps[phone];
    if (stored == code) {
      otps.remove(phone);
      return true;
    }
    return false;
  }

  Message saveMessage(String conversationId, String from, String to, String text) {
    final id = _uuid.v4();
    final msg = Message(
      id: id,
      conversationId: conversationId,
      fromUserId: from,
      toUserId: to,
      text: text,
      timestamp: DateTime.now(),
    );
    messages.putIfAbsent(conversationId, () => []).add(msg);
    return msg;
  }

  List<Message> getMessages(String conversationId) => messages[conversationId] ?? [];
}
