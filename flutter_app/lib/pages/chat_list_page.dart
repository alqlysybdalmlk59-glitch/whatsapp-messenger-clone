import 'package:flutter/material.dart';
import 'chat_page.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});
  @override
  Widget build(BuildContext context) {
    final token = ModalRoute.of(context)!.settings.arguments as String?;
    return Scaffold(
      appBar: AppBar(title: const Text('الدردشات')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('محادثة مع userB'),
            subtitle: const Text('آخر رسالة: مرحبا'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChatPage(conversationId: 'userA-id:userB-id', token: token ?? 'userA-id', peerId: 'userB-id')));
            },
          )
        ],
      ),
    );
  }
}
