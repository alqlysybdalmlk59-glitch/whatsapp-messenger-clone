# Project README

This repository contains a scaffold for a WhatsApp-like messenger:
- Backend: Dart (shelf) with in-memory store (mock)
- Client: Flutter app (multi-platform) connecting to backend via REST + WebSocket

To run backend:
  cd backend
  dart pub get
  dart run bin/server.dart

To run flutter client:
  cd flutter_app
  create .env with API_URL=http://localhost:8080
  flutter pub get
  flutter run

Next steps: replace in-memory store with Postgres/Redis/MinIO, integrate Twilio for OTP, implement JWT checks, add E2E Signal integration via native libs, and Coturn for WebRTC.
