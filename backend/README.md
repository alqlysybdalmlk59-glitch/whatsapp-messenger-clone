# Messenger Backend (Mock - In‑Memory)

تشغيل محلي (بدون Docker):
1. ثبت Dart SDK.
2. انتقل إلى مجلد backend:
   dart pub get
   dart run bin/server.dart
3. السيرفر يعمل على http://localhost:8080

نقاط مهمة:
- OTP هو ثابت '123456' في هذا الوضع التطويري.
- المصادقة عبر WebSocket تقبل token = userId (ببساطة للاختبار). لاحقاً استبدل بالتحقق من JWT.
- لتفعيل Postgres/Redis/MinIO لاحقاً قم بإزالة الin‑memory store واستبداله باتصال حقيقي.
