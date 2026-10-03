# Messenger Flutter (Mock)

1. أنشئ ملف `.env` في مجلد flutter_app يحتوي:
   API_URL=http://localhost:8080

2. تشغيل التطبيق:
   flutter pub get
   flutter run

3. تسجيل الدخول:
   - أدخل أي رقم هاتف (مثلاً +966555000000)
   - اضغط "طلب رمز" ثم سترى الرمز 123456 يظهر تلقائياً (mock)
   - بعد التحقق سينقلك إلى قائمة الدردشات، ويمكنك فتح المحادثة التجريبية.

ملاحظة: WebSocket يتصل إلى ws://localhost:8080/ws
