import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneCtl = TextEditingController();
  final _codeCtl = TextEditingController();
  String? _token;
  bool _otpRequested = false;

  Future<void> requestOtp() async {
    final api = dotenv.env['API_URL'] ?? 'http://localhost:8080';
    final res = await http.post(Uri.parse('$api/auth/request_otp'),
        body: jsonEncode({'phone': _phoneCtl.text}),
        headers: {'Content-Type': 'application/json'});
    final data = jsonDecode(res.body);
    if (data['ok'] == true) {
      setState(() {
        _otpRequested = true;
        _codeCtl.text = data['otp']; // in mock we show the OTP
      });
    }
  }

  Future<void> verifyOtp() async {
    final api = dotenv.env['API_URL'] ?? 'http://localhost:8080';
    final res = await http.post(Uri.parse('$api/auth/verify_otp'),
        body: jsonEncode({'phone': _phoneCtl.text, 'code': _codeCtl.text}),
        headers: {'Content-Type': 'application/json'});
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      _token = data['token'];
      // for this mock we store token in memory and navigate
      Navigator.of(context).pushReplacementNamed('/chats', arguments: _token);
    } else {
      final data = jsonDecode(res.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['message'] ?? 'خطأ')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل دخول')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(controller: _phoneCtl, decoration: const InputDecoration(labelText: 'رقم الهاتف')),
          const SizedBox(height: 8),
          if (_otpRequested) TextField(controller: _codeCtl, decoration: const InputDecoration(labelText: 'رمز التحقق')),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: _otpRequested ? verifyOtp : requestOtp, child: Text(_otpRequested ? 'تأكيد' : 'طلب رمز')),
        ]),
      ),
    );
  }
}
