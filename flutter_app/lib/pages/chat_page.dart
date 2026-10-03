import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';

class ChatPage extends StatefulWidget {
  final String conversationId;
  final String token;
  final String peerId;
  const ChatPage({super.key, required this.conversationId, required this.token, required this.peerId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late IOWebSocketChannel channel;
  final _textCtl = TextEditingController();
  List<Map<String,dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    channel = IOWebSocketChannel.connect('ws://localhost:8080/ws');
    channel.sink.add(jsonEncode({'type': 'auth', 'token': widget.token}));
    channel.stream.listen((msg) {
      final obj = jsonDecode(msg as String);
      final type = obj['type'];
      if (type == 'message') {
        setState(() {
          messages.add(obj['message'] as Map<String,dynamic>);
        });
      } else if (type == 'ack') {
        // update UI if needed
      }
    }, onError: (e) => print('ws error $e'));
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  void sendMessage() {
    final txt = _textCtl.text.trim();
    if (txt.isEmpty) return;
    final payload = {'type': 'message', 'to': widget.peerId, 'text': txt, 'conversationId': widget.conversationId};
    channel.sink.add(jsonEncode(payload));
    setState(() {
      messages.add({'id':'local-${DateTime.now().millisecondsSinceEpoch}','from':'me','to':widget.peerId,'text':txt,'timestamp':DateTime.now().toIso8601String(),'status':'sent'});
    });
    _textCtl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('دردشة مع ${widget.peerId}')),
      body: Column(children: [
        Expanded(
          child: ListView(
            children: messages.map((m) => ListTile(title: Text(m['text'] as String))).toList(),
          ),
        ),
        Row(children: [
          Expanded(child: TextField(controller: _textCtl, decoration: const InputDecoration(hintText: 'اكتب رسالة'))),
          IconButton(icon: const Icon(Icons.send), onPressed: sendMessage)
        ])
      ]),
    );
  }
}
