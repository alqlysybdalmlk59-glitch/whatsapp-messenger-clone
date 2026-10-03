class User {
  final String id;
  final String phone;
  String? name;
  String? avatarUrl;
  User({required this.id, required this.phone, this.name, this.avatarUrl});
}

class Device {
  final String id;
  final String userId;
  final String pushToken;
  Device({required this.id, required this.userId, required this.pushToken});
}

class Message {
  final String id;
  final String conversationId;
  final String fromUserId;
  final String toUserId;
  final String text;
  final DateTime timestamp;
  String status; // sent/delivered/read
  Message({
    required this.id,
    required this.conversationId,
    required this.fromUserId,
    required this.toUserId,
    required this.text,
    required this.timestamp,
    this.status = 'sent',
  });
}
