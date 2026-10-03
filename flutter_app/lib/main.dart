import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pages/login_page.dart';
import 'pages/chat_list_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // create .env with API_URL=http://localhost:8080
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Messenger',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const LoginPage(),
      routes: {
        '/chats': (_) => const ChatListPage(),
      },
    );
  }
}
